/*
 * Dirantenna_comms_server.cpp
 *
 *  Created on: Jan 22, 2012
 *      Author: crim
 */

#include "dirantenna_communication_actionserver/Dirantenna_comms_server.h"

Dirantenna_comms_server::Dirantenna_comms_server(std::string name):
   as_(nh_, name, boost::bind(&Dirantenna_comms_server::executeCB, this, _1), false),
   action_name_(name)
{
   // Start the actionserver once the TMote communication is configured!
   as_.start();
}


void Dirantenna_comms_server::initSerialPorts(std::string serialPorts, int numMotes) {
   std::cout << "--- configuring TMOTE device ---" << " \n";

   std::vector<std::string> portNums(numMotes);

   std::string initPart = "/dev/";
   threeAntn << 0, 1, 2, 3;    twoAntn << 0, 3, 4;
   VectorXi useAntn;
   if(numMotes==4) useAntn = threeAntn;
   else useAntn = twoAntn;

   OneTmoteConfig OneTmoteConf;

   formSerialId(serialPorts, portNums, numMotes);

   for (int i=0; i<numMotes; i++) {
      OneTmoteConf.strTmoteSerial = initPart + portNums[i];
      OneTmoteConf.strTmoteId = dirantn_cmd::Tmotes[useAntn(i)];
      ROS_INFO("Serial Port : %s; Antenna : %s", OneTmoteConf.strTmoteSerial.c_str(),
               OneTmoteConf.strTmoteId.c_str());
      OneTmoteConf.sp = new SerialPort(OneTmoteConf.strTmoteSerial);
      OneTmoteConf.sp->Open(SerialPort::BAUD_115200, SerialPort::CHAR_SIZE_8,
                            SerialPort::PARITY_NONE, SerialPort::STOP_BITS_1,
                            SerialPort::FLOW_CONTROL_NONE);
      OneTmoteConf.bConfigured = true;
      TMote_list.push_back(OneTmoteConf);
   }

   ROS_INFO("Starting action server for nav client ...");
}


void Dirantenna_comms_server::formSerialId(std::string dataStr, std::vector<std::string> &val, int numMotes)
{
   int len = numMotes - 1;
   std::string s = ",";

   if(len!=0) {
      size_t value[numMotes], found=0;
      for (int i=0; i<len; i++) {
         found = dataStr.find(s, found);
         if(found != std::string::npos) {
            value[i] = found;
            found++;
         }
      }
      value[numMotes] = dataStr.length();
      found = 0;
      for (int i=0; i<numMotes; i++) {
         val[i] = dataStr.substr(found, (value[i]-found));
         found = value[i] + 1;
      }
   }
   else {
      val[0] = dataStr;
   }
}


Dirantenna_comms_server::~Dirantenna_comms_server() {
   OneTmoteConfig  OneTmoteConf;
   while( !TMote_list.empty() ) {
      OneTmoteConf = TMote_list.back();
      OneTmoteConf.sp->Close();
      TMote_list.pop_back();
   }
}


void Dirantenna_comms_server::GetDirAntennas() {

   OneTmoteMeas    tMeas;
   unsigned char writeOut = 97;     // byte to start reception from TMotes
   std::list<OneTmoteConfig>::iterator iterat1, iterat;
   bool success = true;

   //verify that a subdevice is connected
   if( 1 > (int)TMote_list.size() ) {
      ROS_WARN_STREAM ("No SubDevice connected OR access rights to USB not given");
      ROS_INFO("%s: Aborted", action_name_.c_str());
      // set the action state to succeeded
      as_.setAborted();
      result_.success = false;
      return;
   }

   //Trace tmote list
   iterat1 = TMote_list.begin();   iterat1++;
   for ( iterat = iterat1; iterat != TMote_list.end(); iterat++ ) {
      if (as_.isPreemptRequested() || !ros::ok()) {
         ROS_INFO("%s: Preempted", action_name_.c_str());
         // set the action state to preempted
         as_.setPreempted();
         success = false;
         break;
      }
      //verify if the tmote device is configured (which should be the case as only configured tmotes are pushed on list)
      else if( iterat->bConfigured == true ) {
         iterat->sp->WriteByte(writeOut);
         iterat->sp->Read(tMeas.rawRSSI, iNum_Readings, (iNum_Readings*iIntrPkt_Wait));
         convertRSSI(tMeas.rawRSSI, tMeas.iRSSI, iNum_Readings);
         feedback_.rssCount_Mote.push_back(iNum_Readings);
         tMeas.dtomeas        = ros::Time::now();
         tMeas.bMeasAvailable = true;
         tMeas.strID      = iterat->strTmoteId;
         feedback_.strId_Mote.push_back(tMeas.strID);
         for (size_t i=0; i<(tMeas.iRSSI.size()); i++) {
            if (as_.isPreemptRequested() || !ros::ok()) {
               ROS_INFO("%s: Preempted", action_name_.c_str());
               // set the action state to preempted
               as_.setPreempted();
               success = false;
               break;
            }
            if(success) feedback_.rssVals.push_back(tMeas.iRSSI.at(i));
         }
         // Publish the measurement as feedback!
         if (success) as_.publishFeedback(feedback_);
         else break;
      }
   }
   if (success) {
      result_.rssCount_Mote = feedback_.rssCount_Mote;
      result_.strId_Mote = feedback_.strId_Mote;
      result_.rssVals = feedback_.rssVals;
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


bool Dirantenna_comms_server::GetBase(uint8_t startByte) {

   bool success = true;
   OneTmoteMeas    tMeas;
   std::list<OneTmoteConfig>::iterator iterat;
   unsigned char val;   int count=0;

   //verify that a subdevice is connected
   if( 1 > (int)TMote_list.size() ) {
      ROS_WARN_STREAM ("No SubDevice connected OR access rights to USB not given");
      ROS_INFO("%s: Aborted", action_name_.c_str());
      // set the action state to succeeded
      as_.setAborted();
      result_.success = false;
      return false;
   }

   feedback_.rssCount_Mote.clear();
   feedback_.strId_Mote.clear();
   feedback_.rssVals.clear();

   iterat = TMote_list.begin();

   //verify if the tmote device is configured (which should be the case as only configured tmotes are pushed on list)
   if( iterat->bConfigured == true ) {
      iterat->sp->WriteByte(startByte);
      while (true) {
         if (as_.isPreemptRequested() || !ros::ok()) {
            ROS_INFO("%s: Preempted", action_name_.c_str());
            // set the action state to preempted
            as_.setPreempted();
            success = false;
            break;
         }
         if(iterat->sp->IsDataAvailable()) {
            val = iterat->sp->ReadByte(iIntrPkt_Wait);
            tMeas.rawRSSI.push_back(val);
            count++;
         }
         if(val==69) break;
      }
      if (success) {
         convertRSSI(tMeas.rawRSSI, tMeas.iRSSI, count);
         feedback_.rssCount_Mote.push_back(count);
         tMeas.dtomeas        = ros::Time::now();
         tMeas.bMeasAvailable = true;
         tMeas.strID      = iterat->strTmoteId;
         feedback_.strId_Mote.push_back(tMeas.strID);
         for (size_t i=0; i<(tMeas.iRSSI.size()); i++) {
            if (as_.isPreemptRequested() || !ros::ok()) {
               ROS_INFO("%s: Preempted", action_name_.c_str());
               // set the action state to preempted
               as_.setPreempted();
               success = false;
               break;
            }
            if(success) feedback_.rssVals.push_back(tMeas.iRSSI.at(i));
         }

         // Publish the measurement as feedback!
         if (success) {
            as_.publishFeedback(feedback_);
            if((int)TMote_list.size() > 1) return true;
            else {
               result_.rssCount_Mote = feedback_.rssCount_Mote;
               result_.strId_Mote = feedback_.strId_Mote;
               result_.rssVals = feedback_.rssVals;
               result_.success = true;
               ROS_INFO("%s: Succeeded - All", action_name_.c_str());
               // set the action state to succeeded
               as_.setSucceeded(result_);
               return false;
            }
         }
         else {
            ROS_INFO("%s: Aborted", action_name_.c_str());
            // set the action state to succeeded
            as_.setAborted();
            result_.success = false;
            return false;
         }
      }
      else {
         ROS_INFO("%s: Aborted", action_name_.c_str());
         // set the action state to succeeded
         as_.setAborted();
         result_.success = false;
         return false;
      }
   }
   else {
      ROS_INFO("%s: Aborted", action_name_.c_str());
      // set the action state to succeeded
      as_.setAborted();
      result_.success = false;
      return false;
   }
}


void Dirantenna_comms_server::convertRSSI(ReadBuffer &rawVal, std::vector<double> &val, int numReadings)
{
   int dat=0;
   for (int i=0; i<numReadings; i++) {
      dat = int(rawVal.at(i));
      if(dat<128) {
         dat = dat-45;
      }
      else {
         dat = dat-256-45;
      }
      val.push_back(dat);
   }
}


void Dirantenna_comms_server::getReading_Waiting(uint8_t startByte) {
   int pktWait_part = (startByte & 0x0F), numReadings_part = (startByte >> 4);

   switch (numReadings_part) {
      case 1:
         iNum_Readings = 25;
         break;
      case 2:
         iNum_Readings = 50;
         break;
      case 3:
         iNum_Readings = 100;
         break;
      case 4:
         iNum_Readings = 150;
         break;
      case 5:
         iNum_Readings = 200;
         break;
      default:
         iNum_Readings = dirantn_cmd::DEFAULT_NUM_READINGS;
         break;
   }
   switch (pktWait_part) {
      case 1:
         iIntrPkt_Wait = 50;
         break;
      case 2:
         iIntrPkt_Wait = 100;
         break;
      case 3:
         iIntrPkt_Wait = 200;
         break;
      case 4:
         iIntrPkt_Wait = 400;
         break;
      case 5:
         iIntrPkt_Wait = 500;
         break;
      default:
         iIntrPkt_Wait = dirantn_cmd::DEFAULT_INTRPKT_WAIT;
         break;
   }
}


void Dirantenna_comms_server::executeCB(const dirantenna_communication_actionserver::
                                        dirantenna_communicationGoalConstPtr &goal)
{
   bool readIt = false;   uint8_t startByte;

   startByte = goal->startByte;
   // get the number of readings and inter-packet wait interval from the startByte
   getReading_Waiting(startByte);

   // publish info to the console for the user
   ROS_INFO("%s: Collecting RSS values for %d readings, every %d msec - for each position", action_name_.c_str(), iNum_Readings, iIntrPkt_Wait);

   readIt = GetBase(startByte);
   if(readIt) GetDirAntennas();     // execute only if more than one TMote connected!
}


int main(int argc, char** argv) {

   ros::init(argc, argv, "dirantenna_comms");
   ros::NodeHandle nh;

   if( nh.getParam("/dirantenna_communication_actionserver/serialPorts", sSerial_Ports ) == false ) {
      sSerial_Ports = dirantn_cmd::DEFAULT_SERIAL_PORTS;
   };
   if( nh.getParam("/dirantenna_communication_actionserver/numMotes", iNum_Motes ) == false ) {
      iNum_Motes = dirantn_cmd::DEFAULT_NUM_MOTES;
   };
   iNum_Readings = dirantn_cmd::DEFAULT_NUM_READINGS;
   iIntrPkt_Wait = dirantn_cmd::DEFAULT_INTRPKT_WAIT;
   Dirantenna_comms_server dirantenna_commServer(ros::this_node::getName());
   dirantenna_commServer.initSerialPorts(sSerial_Ports, iNum_Motes);
   std::cout << "Name: " << ros::this_node::getName() << std::endl;

   ros::spin();

   return 0;
}
