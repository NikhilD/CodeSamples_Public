/*
 * Dirantenna_2dnav_client.cpp
 *
 *  Created on: Jan 22, 2012
 *      Author: crim
 */

#include "../include/dirantenna_navigation_actionclient/Dirantenna_2dnav_client.h"

Dirantenna_2dnav_client::Dirantenna_2dnav_client() {
   // TODO Auto-generated constructor stub

}

Dirantenna_2dnav_client::~Dirantenna_2dnav_client() {
   // TODO Auto-generated destructor stub
}


int main (int argc, char **argv) {

   ros::init(argc, argv, "dirantenna_2dnav");
   ros::NodeHandle nh;
   Dirantenna_2dnav_client da_nav;

   // create the action client
   // true causes the client to spin its own thread
   actionlib::SimpleActionClient<dirantenna_communication_actionserver::
                                 dirantenna_communicationAction>
      da_Acomms("dirantenna_communication_actionserver", true);

   actionlib::SimpleActionClient<dirantenna_movebase_actionserver::
                                 dirantenna_movebaseAction>
      da_Amovebase("dirantenna_movebase_actionserver", true);

   ROS_INFO("Waiting for action server to start.");
   // wait for the action server to start
   da_Acomms.waitForServer(); //will wait for infinite time
   da_Amovebase.waitForServer(); //will wait for infinite time

   ROS_INFO("Action server started, sending goal...");

   // send a goal to the action
   dirantenna_communication_actionserver::dirantenna_communicationGoal goal_comms;
   goal_comms.startByte = 97;
   da_Acomms.sendGoal(goal_comms);

   //wait for the action to return
   bool finished_before_timeout_comms = da_Acomms.waitForResult(ros::Duration(5000.0));

   if (finished_before_timeout_comms) {
      actionlib::SimpleClientGoalState state = da_Acomms.getState();
      ROS_INFO("Action dirantenna_communication_actionserver finished: %s", state.toString().c_str());
   }
   else ROS_INFO("Action dirantenna_communication_actionserver did not finish before the time out.");

   // send a goal to the action
   dirantenna_movebase_actionserver::dirantenna_movebaseGoal goal_movebase;
   goal_movebase.twistTravel.push_back(0.3);
   goal_movebase.twistTravel.push_back(20);
   da_Amovebase.sendGoal(goal_movebase);

   //wait for the action to return
   bool finished_before_timeout_movebase = da_Amovebase.waitForResult(ros::Duration(5000.0));

   if (finished_before_timeout_movebase) {
      actionlib::SimpleClientGoalState state = da_Amovebase.getState();
      ROS_INFO("Action dirantenna_movebase_actionserver finished: %s", state.toString().c_str());
   }
   else ROS_INFO("Action dirantenna_movebase_actionserver did not finish before the time out.");

   //exit
   return 0;
}
