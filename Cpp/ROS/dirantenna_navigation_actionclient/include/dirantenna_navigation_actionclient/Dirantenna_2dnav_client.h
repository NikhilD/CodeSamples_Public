/*
 * Dirantenna_2dnav_client.h
 *
 *  Created on: Jan 22, 2012
 *      Author: crim
 */

#ifndef DIRANTENNA_2DNAV_CLIENT_H_
#define DIRANTENNA_2DNAV_CLIENT_H_

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

// Eigen headers
#include <Eigen/Eigen>
#include <Eigen/Core>
#include <Eigen/Dense>
#include <Eigen/Geometry>
#include <Eigen/LU>

// ROS headers
#include "ros/ros.h"
#include "ros/time.h"
#include "geometry_msgs/PoseWithCovarianceStamped.h"
#include <actionlib/client/simple_action_client.h>
#include <actionlib/client/terminal_state.h>
#include "dirantenna_communication_actionserver/dirantenna_communicationAction.h"
#include "dirantenna_movebase_actionserver/dirantenna_movebaseAction.h"

using namespace Eigen;

class Dirantenna_2dnav_client {
   public:
      Dirantenna_2dnav_client();
      virtual ~Dirantenna_2dnav_client();
};

#endif /* DIRANTENNA_2DNAV_CLIENT_H_ */
