/*
 * Dirantenna_comms_server.h
 *
 *  Created on: Jan 22, 2012
 *      Author: crim
 */

#ifndef DIRANTENNA_COMMS_SERVER_H_
#define DIRANTENNA_COMMS_SERVER_H_

#include "SerialStream.h"
#include "SerialPort.h"

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
#include <actionlib/server/simple_action_server.h>

#include "dirantenna_communication_actionserver/dirantenna_communicationAction.h"

using namespace LibSerial;
using namespace Eigen;

namespace dirantn_cmd {
    const unsigned short MAX_TMOTES = 5;        // maximum number of tmotes that are used!
    const std::string    Tmotes[] = {"base", "left", "right", "front", "back"};
    const double         DEFAULT_RATE_Hz = 1;
    const int            DEFAULT_NUM_MOTES = 4;
    const std::string    DEFAULT_SERIAL_PORTS = "basestn,leftstn,rightstn,frontstn";
    const unsigned short DEFAULT_NUM_READINGS = 12;    // number of readings at each location
    const unsigned short DEFAULT_INTRPKT_WAIT = 500;    // ms inter-packet wait time for serial reception.
}

typedef std::vector<unsigned char> ReadBuffer;

struct OneTmoteMeas {
    bool                bMeasAvailable; //indicates true if a valid measurement is available
    ReadBuffer          rawRSSI;
    std::vector<double> iRSSI;
    ros::Time           dtomeas; //time tag measurement immediately in case of other delays
    std::string         strID;
};

std::string         sSerial_Ports;
int                 iNum_Motes;
int                 iNum_Readings, iIntrPkt_Wait;

class Dirantenna_comms_server {

   protected:
      ros::NodeHandle nh_;
      std::string action_name_;
      actionlib::SimpleActionServer<dirantenna_communication_actionserver::dirantenna_communicationAction> as_;

      // create messages that are used to published feedback/result
      dirantenna_communication_actionserver::dirantenna_communicationFeedback feedback_;
      dirantenna_communication_actionserver::dirantenna_communicationResult result_;

   public:
      Dirantenna_comms_server(std::string );
      virtual ~Dirantenna_comms_server();

      void initSerialPorts(std::string, int );

      ///! Polls one set of measurements from desired TMotes defined in std::list<OneTmoteMeas>&
      /*!
      * Iterates through all detected directional antenna Tmotes and collects the RSSI measurements from
      * respective Tmotes.
      *
      */
      void GetDirAntennas( void );

      ///! Polls one set of measurements from the base TMote defined in std::list<OneTmoteMeas>&
      bool GetBase( uint8_t startByte );

      /// Convert raw RSSI values into usable dBm values
      void convertRSSI( ReadBuffer &, std::vector<double> &, int );

      /// actionserver callback to get the readings from the motes and respond!
      void executeCB(const dirantenna_communication_actionserver::dirantenna_communicationGoalConstPtr &goal );

   private:
      // structure for one Tmote serial comm. configuration
      struct OneTmoteConfig {
        SerialPort      *sp;
        std::string     strTmoteId;
        std::string     strTmoteSerial;
        bool            bConfigured;
      };
      std::list<OneTmoteConfig> TMote_list;

      Vector4i threeAntn;
      Vector3i twoAntn;

      /// form the individual serial port IDs from the received serial ports string!
      void formSerialId( std::string, std::vector<std::string> &, int );

      // populate the iNum_Readings and iIntrPkt_Wait variables
      void getReading_Waiting( uint8_t );
};

#endif /* DIRANTENNA_COMMS_SERVER_H_ */
