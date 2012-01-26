/*
 * Dirantenna_movebase_server.h
 *
 *  Created on: Jan 22, 2012
 *      Author: crim
 */

#ifndef DIRANTENNA_MOVEBASE_SERVER_H_
#define DIRANTENNA_MOVEBASE_SERVER_H_

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <list>
#include <map>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <boost/thread.hpp>

// Eigen headers
#include <Eigen/Eigen>
#include <Eigen/Core>
#include <Eigen/Dense>
#include <Eigen/Geometry>
#include <Eigen/LU>

// ROS headers
#include "ros/ros.h"
#include "ros/time.h"
#include <actionlib/server/simple_action_server.h>
#include <geometry_msgs/Twist.h>
#include "geometry_msgs/PoseWithCovarianceStamped.h"
#include <tf/transform_listener.h>

#include "dirantenna_movebase_actionserver/dirantenna_movebaseAction.h"

using namespace Eigen;

namespace dirantn_mb_cmd {
    const double         DEFAULT_TRAVEL = 0.5;
    const double         DEFAULT_TWIST = 15;
}

typedef boost::shared_ptr<geometry_msgs::PoseWithCovarianceStamped const> robot_pose_ekf_ConstPtr;

class Dirantenna_movebase_server {

   protected:
      ros::NodeHandle nh_;
      std::string action_name_;
      actionlib::SimpleActionServer<dirantenna_movebase_actionserver::dirantenna_movebaseAction> as_;

      // create messages that are used to published feedback/result
      dirantenna_movebase_actionserver::dirantenna_movebaseFeedback feedback_;
      dirantenna_movebase_actionserver::dirantenna_movebaseResult result_;

   public:
      Dirantenna_movebase_server(std::string , ros::NodeHandle &nh);
      virtual ~Dirantenna_movebase_server();

      //! Turn a specified angle based on odometry information
      //! Drive a specified distance based on odometry information
      bool twistTravel_Odom(bool, double , double );

      void robot_pose_ekf_callback(const robot_pose_ekf_ConstPtr& ro_po_ekf);

      void pose_callbackThread( void );

      /// actionserver callback to move the crimbot - distance and angle
      void executeCB(const dirantenna_movebase_actionserver::dirantenna_movebaseGoalConstPtr &goal );

   private:
      //! We will be publishing to the "cmd_vel" topic to issue commands
      ros::Publisher cmd_vel_pub_;
      //! We will be listening to TF transforms as well
      tf::TransformListener listener_;

      double oldx, oldy, ekf_TurnedAngle;
};

#endif /* DIRANTENNA_MOVEBASE_SERVER_H_ */
