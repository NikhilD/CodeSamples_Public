/*
 * Dirantenna_movebase_server.cpp
 *
 *  Created on: Jan 22, 2012
 *      Author: crim
 */

#include "../include/dirantenna_movebase_actionserver/Dirantenna_movebase_server.h"

Dirantenna_movebase_server::Dirantenna_movebase_server(std::string name, ros::NodeHandle &nh):
   as_(nh_, name, boost::bind(&Dirantenna_movebase_server::executeCB, this, _1), false),
   action_name_(name),
   oldx(0),
   oldy(0),
   ekf_TurnedAngle(0)
{
   nh_ = nh;
   //set up the publisher for the cmd_vel topic
   cmd_vel_pub_ = nh_.advertise<geometry_msgs::Twist>("cmd_vel", 1);

   as_.start();
}


Dirantenna_movebase_server::~Dirantenna_movebase_server() {
   // TODO Auto-generated destructor stub
}


bool Dirantenna_movebase_server::twistTravel_Odom(bool clockwise, double angle, double distance) {

   bool turnDone = false, travelDone = false, done = false, success = true;
   double radians = angle*(M_PI/180.0);
   while(radians < 0) radians += 2*M_PI;
   while(radians > 2*M_PI) radians -= 2*M_PI;

   //wait for the listener to get the first message
   listener_.waitForTransform("base_footprint", "odom", ros::Time(0), ros::Duration(1.0));

   //we will record transforms here
   tf::StampedTransform start_transform;
   tf::StampedTransform current_transform;

   //record the starting transform from the odometry to the base frame
   listener_.lookupTransform("base_footprint", "odom", ros::Time(0), start_transform);

   //we will be sending commands of type "twist"
   //the command will be to travel at 0.175 m/s and/or turn at 0.175 rad/sec
   geometry_msgs::Twist base_cmd;

   base_cmd.linear.x = base_cmd.angular.y = base_cmd.angular.z = 0;

   //the axis we want to be rotating by
   tf::Vector3 desired_turn_axis(0,0,1);
   if (!clockwise) desired_turn_axis = -desired_turn_axis;

   ros::Rate rate(100.0);
   travelDone = true;      // ensuring 'turn-before-travel' !

   while (!done && nh_.ok()) {

      // Ensure that action is not pre-empted!
      if (as_.isPreemptRequested() || !nh_.ok()) {
         ROS_INFO("%s: Preempted", action_name_.c_str());
         // set the action state to preempted
         as_.setPreempted();
         success = done = false;
         break;
      }

      if((angle > -0.01) && (angle < 0.01)) turnDone = true;
      if((distance > -0.075) && (distance < 0.075)) travelDone = true;

      // Calculate the drive/turn command - always 'turn-before-travel'!
      if(!turnDone) {
         base_cmd.angular.x = base_cmd.angular.y = 0;
         base_cmd.angular.z = 0.175;
         if (clockwise) base_cmd.angular.z = -base_cmd.angular.z;
      }
      if(!travelDone) {
         base_cmd.angular.y = base_cmd.angular.z = 0;
         if(distance<0) base_cmd.linear.x = -0.175;
         else base_cmd.linear.x = 0.175;
      }
      if(turnDone && travelDone) {
         done = true;
         break;
      }

      //send the drive command
      cmd_vel_pub_.publish(base_cmd);
      rate.sleep();

      //get the current transform
      try {
         listener_.lookupTransform("base_footprint", "odom", ros::Time(0), current_transform);
      }
      catch (tf::TransformException ex) {
         ROS_ERROR("%s",ex.what());
         break;
      }
      //see how far we've traveled
      tf::Transform relative_transform = start_transform.inverse() * current_transform;
      double dist_moved = relative_transform.getOrigin().length();

      tf::Vector3 actual_turn_axis = relative_transform.getRotation().getAxis();
      double angle_turned = relative_transform.getRotation().getAngle();

      if ( fabs(angle_turned) < 1.0e-2) continue;
      if ( actual_turn_axis.dot( desired_turn_axis ) < 0 )
         angle_turned = 2 * M_PI - angle_turned;

      // Publish feedback
      feedback_.distance = dist_moved;
      feedback_.angle = angle_turned;
      as_.publishFeedback(feedback_);

      if(dist_moved > fabs(distance)) {
         ROS_INFO("Travelled Distance: %lf", dist_moved);
         travelDone = true;      done = true;
      }
      if (angle_turned > radians) {
         ROS_INFO("Turned Angle - TF: %lf", (angle_turned*180/M_PI));
         travelDone = false;     turnDone = true;
      }
   }
   if (done) return true;
   else if (success) return true;
   else return false;
}


void Dirantenna_movebase_server::executeCB(const dirantenna_movebase_actionserver::
                                        dirantenna_movebaseGoalConstPtr &goal)
{
   bool clockwise = false;   double travelDist, turnAngle;

   travelDist = goal->twistTravel.at(0);
   turnAngle = goal->twistTravel.at(1);
   if(turnAngle < 0) {
      turnAngle = -turnAngle;
      clockwise = true;
   }
   feedback_.distance = feedback_.angle = 0;

   if(twistTravel_Odom(clockwise, turnAngle, travelDist)) {
      result_.distance = feedback_.distance;
      result_.angle = feedback_.angle;
      result_.success = true;
      ROS_INFO("%s: Succeeded - All", action_name_.c_str());
      // set the action state to succeeded
      as_.setSucceeded(result_);
   }
   else {
      ROS_INFO("%s: Aborted", action_name_.c_str());
      // set the action state to succeeded
      as_.setAborted();
      result_.success = false;
   }
}


void Dirantenna_movebase_server::robot_pose_ekf_callback(const robot_pose_ekf_ConstPtr& ro_po_ekf) {

   double x = ro_po_ekf->pose.pose.position.x, y = ro_po_ekf->pose.pose.position.y;
   double distance = sqrt(pow((x - oldx),2) + pow((y - oldy),2));
   oldx = x; oldy = y;
//   std::cout << "Pose --> X: " << x << " Y: " << y << " Dist. Covered: " << distance << std::endl;
//   std::cout << "Orientation W: " << ro_po_ekf->pose.pose.orientation.w << std::endl;
   ekf_TurnedAngle = 2*acos(ro_po_ekf->pose.pose.orientation.w);
   if(ro_po_ekf->pose.pose.orientation.z < 0) ekf_TurnedAngle = (2*M_PI) - ekf_TurnedAngle;

   double angle = ekf_TurnedAngle*(180.0/M_PI);
   std::cout << "Orientation Theta: " << angle << std::endl;
}


void Dirantenna_movebase_server::pose_callbackThread() {

   ros::Subscriber ekf_sub = nh_.subscribe("/robot_pose_ekf/odom", 100, &Dirantenna_movebase_server::robot_pose_ekf_callback, this);
   ros::spin();
}


int main(int argc, char** argv) {

   //init the ROS node
   ros::init(argc, argv, "dirantenna_movebase");
   ros::NodeHandle nh;

   Dirantenna_movebase_server dirantenna_mbServer(ros::this_node::getName(), nh);
   std::cout << "Name: " << ros::this_node::getName() << std::endl;

   ros::spin();
//   boost::thread my_thread(boost::bind(&Dirantenna_movebase_server::pose_callbackThread, &dirantenna_mbServer));
//
//   ros::shutdown();
//   my_thread.interrupt();
//   my_thread.join();

   return 0;
}

