// SunSpotHostApplication
package org.sunspotworld.demo;

import java.io.IOException; 
import com.sun.spot.peripheral.ChannelBusyException;
import com.sun.spot.peripheral.NoAckException;
import com.sun.spot.peripheral.TimeoutException;
import com.sun.spot.peripheral.*;
import com.sun.spot.peripheral.radio.*;
import com.sun.spot.io.j2me.radio.*;
import com.sun.spot.io.j2me.radiogram.*;
import com.sun.spot.util.IEEEAddress;

import com.sun.spot.peripheral.Spot;
import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.sensorboard.peripheral.ITriColorLED;
import com.sun.spot.peripheral.radio.IRadioPolicyManager;
import com.sun.spot.util.*;
import com.sun.spot.util.Utils;

import java.io.*;
import javax.microedition.io.*;
import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;

import com.sun.spot.peripheral.Spot;
//import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.peripheral.radio.IRadioPolicyManager;
//import com.sun.spot.io.j2me.radiostream.*;
import java.util.Random;
import java.util.Vector;
import javax.microedition.io.Connector;
import javax.microedition.io.Datagram;
import javax.microedition.io.DatagramConnection;
//import com.sun.spot.io.j2me.radiogram.RadiogramConnection;
import org.sunspotworld.demo.utilities.RadioDataIOStream;   //handles the data packets
import org.sunspotworld.demo.utilities.StringTokenizer;     //separately stores each word seperated by a space in a string
import com.sun.spot.peripheral.IAT91_TC;
import java.net.Socket;
import java.net.*;

/**
 * Sun SPOT host application
 */
public class SunSpotHostApplication {
    
    //Flags used for path tracking and recording
    public static boolean pathTracking = false;
    public static boolean pathTrackingAll = false;
    public static boolean pathFollowing = false;
    public static boolean tracker1Done = false;
    public static boolean tracker2Done = false;
    public static boolean pathRecording = false;
   
    //pathTrackingThread used to periodically send commands to image processing
  public Thread pathTrackingThread= new Thread() {

         public void run() {
            System.out.println("Path Tracking thread started...");
            while(true) {
                if(pathTracking  || pathRecording){  //Request a single image scan
                    cppTCPSocket.genSend("r");  
                    try {
                        pathTrackingThread.sleep(600 + DELAY);
                    }
                    catch(InterruptedException e){
                        System.out.println(e);
                    }
                }
                else if(pathTrackingAll || pathFollowing){  //Request an all scan
                    cppTCPSocket.genSend("a");
                    try {
                        pathTrackingThread.sleep(600 + DELAY);
                    }
                    catch(InterruptedException e){
                        System.out.println(e);
                    }
                    //used when tracking two paths to determine when both are done
                    if(tracker1Done && tracker2Done) pathTrackingAll = false;
                }
                else{
                    try {
                        pathTrackingThread.sleep(500);
                    }
                    catch(InterruptedException e){
                        System.out.println(e);
                    }
                }
            }
        }
    };
    
   
    public boolean UDPCommands = false;
    public boolean connected = false;
    public boolean cppTCPSocketConnected = false;
    public String[] ParseIt = {"","","","",""};
    public boolean found = false, found_TS2 = false, GuiSocketConnected = false;
    String input;
    public static String pcHost = "152.7.206.89";//ip address of the machine running c++
           
    public static mySocket GuiSocket = new mySocket();  //Comms to GUI
    public static mySocket cppTCPSocket = new mySocket();  //Comms to C++
    public CppThread cppUDPThread = new CppThread();  //Thread of Secondary Comms
    EstComm estComm = new EstComm();

    int i=0;
    public static boolean TS1_Conn = false, TS2_Conn = false, TS3_Conn = false;
    public static int DELAY = 0; //Delay for delay generator
    String[] forward = {"f","-1","0.01"};
    String[] endcmd = {"e","0","0"};
    
    //Three path trackers for tracking one or multiple robots
    public static QuadCurveTracker tracker = new QuadCurveTracker();
    public static QuadCurveTracker_1 tracker1 = new QuadCurveTracker_1();
    public static QuadCurveTracker_2 tracker2 = new QuadCurveTracker_2();
    
    
    //Main application
    //This is run on startup
    public void run() {       
        //Initialize the path trackers
        tracker.Init(tracker.TRISPOT);
        tracker1.Init(tracker1.TRISPOT);
        tracker2.Init(tracker2.TRISPOT);
        
        IEEEAddress ourAddr = new IEEEAddress(Spot.getInstance().getRadioPolicyManager().getIEEEAddress());
        System.out.println("Our radio address = " + ourAddr.asDottedHex());
        
        //This Runs forever
        while(true){
            // First need to connect to GUI with "base connect" command from GUI command line!
            if(!GuiSocketConnected){
                System.out.println("Waiting for connection from GUI");
                //Wait for the GUI
                GuiSocket.waitForClient(5500);  
                GuiSocket.UDPCommands = false;
                //Create UDP variant
                GuiSocket.createUDPListener(4005);  
                GuiSocket.setUDPDestAddr(GuiSocket.remoteAddr().substring(1));
                GuiSocket.setUDPDestPort(4006);
                GuiSocketConnected = true;
                System.out.println("Received a connection from GUI at: " + GuiSocket.remoteAddr());
            }
            System.out.println("Waiting for data....");    //Waiting for a command from the GUI                                    
            input = GuiSocket.genRead();  
            System.out.println("received this: " + input);
            if(input == null) { //If the socket is closed remotely the read above will return null
                GuiSocketConnected = false;
                System.out.println("Socket has been closed remotely");
                input = "";
            }
            System.out.println("received: " + input);
            if(!GuiSocketConnected){
                GuiSocket.stopServer();  //close the connection if it was remotely closed
                GuiSocketConnected = false;
            }
            if(GuiSocketConnected){
                //Parse the input string into an array
                ParseIt = StringTokenizer.parseStringAsArray(input, " ");
                
                if(ParseIt[0].equalsIgnoreCase("setID")){
                    estComm.setID(ParseIt);
                    GuiSocket.genSend("Spot Parameters Set");
                }
                
                //Case to connect to Image CPP over TCP and UDP as well as to TriSpot over Radio
                else if(ParseIt[0].equalsIgnoreCase("connect")){
                    if(ParseIt[1].equalsIgnoreCase("image")){
                        try{ //If the ip address is sent use it, otherwise use the default
                        if(ParseIt[2].length() > 7) pcHost = ParseIt[2];
                        }
                        catch(ArrayIndexOutOfBoundsException e){
                            pcHost = GuiSocket.remoteAddr();//this is the ip address that the GUI is running on
                            pcHost = pcHost.substring(1, pcHost.length());  //remove first char b/c is it s /
                        }
                        //start TCP Connection
                        while(!cppTCPSocketConnected){
                            System.out.println("Connecting to Image server at: " + pcHost + "::4003");
                            cppTCPSocket.connectToServer(pcHost,4003);
                            cppTCPSocketConnected = true;              
                            pathTrackingThread.start();
                        }
                        //start the UDP variant of the TCP command connection (not used by default)
                        cppTCPSocket.createUDPListener(9998);
                        cppTCPSocket.setUDPDestAddr(pcHost);
                        cppTCPSocket.setUDPDestPort(9999);
                        
                        //start the UDP listener for data
                        cppUDPThread.reqStart();
                        new Thread(cppUDPThread).start();
                    }
                    else if(ParseIt[1].equalsIgnoreCase("trispot")){
                        found = false;
                        estComm.newID(ParseIt[2], ParseIt[3], ParseIt[4]);
                        while(true){
                            found = estComm.waitForSpot(estComm.SPOT_ID, estComm.BROADCAST_PORT);
                            if(found){
                                GuiSocket.genSend("Tri-Spot "+ estComm.SPOT_ID +" Connected");
                                cppUDPThread.spotCmd.OpenRadioStream(estComm.SPOT_ID, estComm.PORT);
                                break;
                            }
                        }
                        if(ParseIt[2].equalsIgnoreCase(estComm.SPOT_ID1)){TS1_Conn = true;System.out.println(""+TS1_Conn);}
                        if(ParseIt[2].equalsIgnoreCase(estComm.SPOT_ID2)){TS2_Conn = true;System.out.println(""+TS2_Conn);}
                        if(ParseIt[2].equalsIgnoreCase(estComm.SPOT_ID3)){TS3_Conn = true;}
                    }     
                    else{GuiSocket.genSend("Bad Command");}
                }                
                else if(ParseIt[0].equalsIgnoreCase("spotselect")){
                    estComm.newID(ParseIt[1], ParseIt[2], ParseIt[3]);
                    if(ParseIt[1].equalsIgnoreCase(estComm.SPOT_ID1)){
                        GuiSocket.genSend("Tri-Spot 1 selected");TS1_Conn = true;TS2_Conn = false;}
                    if(ParseIt[1].equalsIgnoreCase(estComm.SPOT_ID2)){
                        GuiSocket.genSend("Tri-Spot 2 selected");TS2_Conn = true;TS1_Conn = false;}
                    if(ParseIt[1].equalsIgnoreCase(estComm.SPOT_ID3)){TS3_Conn = true;}
                    if(ParseIt[1].equalsIgnoreCase(estComm.ACCEL_SPOT)){GuiSocket.genSend("Accel-Spot selected");}
                }
                
                //Case to send command to TriSpot over Radio
                else if(ParseIt[0].equalsIgnoreCase("spotcommand")){
                    System.out.println("got a command");
                        cppUDPThread.spotCmd.SendSpot(estComm.SPOT_ID, ParseIt, 1);                        
                        System.out.println("command sent to " + estComm.SPOT_ID);
                }

                //Case to send command to Image CPP program and get data over TCP
                else if(ParseIt[0].equalsIgnoreCase("imagecommand")){
                    System.out.println("got an image command");
                    if(cppTCPSocketConnected){
                        if(ParseIt[1].equals("o")){
                            //request o data and forward directly to GUI
                            cppTCPSocket.genSend("o");
                            GuiSocket.genSend("object "+cppTCPSocket.genRead());
                        }
                        else if(ParseIt[1].equals("s")){
                            //Set safety regions of robot and obstacle
                            //NEEDS A SPACE AT END
                            String ImageSend = "s "+ParseIt[2]+" "+ParseIt[3]+" ";   //this is in format s robot obstacle with a space on the end
                            cppTCPSocket.genSend(ImageSend);
                        }
                        else if(ParseIt[1].equals("p")){  //path generation 
                            //NEEDS A SPACE AT END
                            String ImageSend = "p "+ParseIt[2]+" "+ParseIt[3]+" ";   //this is in format P X Y with a space on the end
                            cppTCPSocket.genSend(ImageSend);
                        }
                        else if(ParseIt[1].equals("r")){ //single camera update
                            cppTCPSocket.genSend("r");
                        }
                        else if(ParseIt[1].equals("g")){  //request for path data to GUI
                            //get the path by sending every path point
                            GuiSocket.genSend("path 999");  //tells GUI to erase old path
                            for(int i = 0; i<CppThread.pathLength;i++)
                            {
                                GuiSocket.genSend("path " + CppThread.path[i]);
                            }
                            GuiSocket.genSend("path 998");  //tells GUI path is complete
                            System.out.println("PathSent");
                        }                        
                        else if(ParseIt[1].equals("u")){  //primary socket comm protocol
                            if(ParseIt[2].equals("ON")){
                                cppTCPSocket.genSend("uON");
                                cppTCPSocket.UDPCommands = true;
                            }
                            else {
                                cppTCPSocket.genSend("uOFF");
                                cppTCPSocket.UDPCommands = false;
                            }
                        }
                        else if(ParseIt[1].equals("u2")){  //secondary socket comm protocol
                            if(ParseIt[2].equals("ON")){
                                cppTCPSocket.genSend("vON");
                                cppUDPThread.cppUDP.UDPCommands = true;
                            }
                            else {
                                cppTCPSocket.genSend("vOFF");
                                cppUDPThread.cppUDP.UDPCommands = false;
                            }
                        }
                        else{ //unknown or unparsed, send it to c++
                              cppTCPSocket.genSend(ParseIt[1]);
                        }
                    }
                    else{GuiSocket.genSend("Cpp TCP Socket not yet Connected"); System.out.println("Cpp TCP Socket not yet connected");}
                }

                //Case to disconnect connections
                else if(ParseIt[0].equalsIgnoreCase("disconnect")){                
                    if(ParseIt[1].equals("base") || ParseIt[1].equals("Base")){
                        //Disconnect the base station from GUI
                        if(GuiSocketConnected){
                            GuiSocket.stopServer();
                            GuiSocketConnected = false;
                        }
                    }
                    else if(ParseIt[1].equalsIgnoreCase("trispot")){
                       //Disconnect current trispot from base station
                       cppUDPThread.spotCmd.SendSpot(estComm.SPOT_ID,endcmd,0); 
                       for(i=0;i<20000;i++);
                       found = false;
                       TS1_Conn = false;
                       GuiSocket.genSend("Tri-Spot "+estComm.SPOT_ID+" Disconnected"); System.out.println("trispot disconnected");
                    }
                    else if(ParseIt[1].equalsIgnoreCase("image")){
                        //Disconnect image software from base station
                        if(cppUDPThread.CppSocketConnected){
                           cppUDPThread.reqStop();
                           cppUDPThread.CppSocketConnected = false;
                           GuiSocket.genSend("Image UDP Disconnected"); System.out.println("Image UDP disconnected");
                        }
                        if(cppTCPSocketConnected){
                           cppTCPSocket.stopServer();
                           cppTCPSocketConnected = false;
                           GuiSocket.genSend("Image TCP Disconnected"); System.out.println("Image TCP disconnected");
                        }
                        else{GuiSocket.genSend("Image software not yet Connected"); System.out.println("Image software not yet connected");}
                    }
                    else{GuiSocket.genSend("Bad Command");}  
                }
                 else if(ParseIt[0].equals("GSM")){  //Turn GSM ON
                    if(ParseIt[1].equals("true")) {
                        System.out.println("got a GSM true");
                        CppThread.GSM = true;
                    }
                    else {  //Turn GSM OFF
                        CppThread.GSM = false;
                        CppThread.manualGain = false;
                        System.out.println("got a GSM false");
                    }
                 }
                 else if(ParseIt[0].equalsIgnoreCase("gain")){ //Set a manual gain value, GSM Must be on
                    CppThread.manualGain = true;
                    CppThread.manualGainValue = Double.parseDouble(ParseIt[1]);
                 }
                 else if (ParseIt[0].equals("DELAY")) {  //Set delay in seconds for delay gen
                    DELAY = (int) (1000 * Double.parseDouble(ParseIt[1]));
                    System.out.println("Delay"+DELAY);
                 }
                //Path Tracking Commands
                 else if (ParseIt[0].equals("track")) {
                    if(ParseIt[1].equals("start")){  //start tracking a path
                        cppTCPSocket.genSend("r");  //send an r to start receiving data
                        tracker.Init(tracker.TRISPOT);  //init tracker
                        cppUDPThread.spotCmd.SendSpot(estComm.SPOT_ID, forward, 0);
                        pathTracking = true;  
                        CppThread.firsttime = true;
                    }
                    else if(ParseIt[1].equals("all")) {  //start tracking two paths
                        cppTCPSocket.genSend("a");  //send an a to start receiving data
                        tracker1.Init(tracker1.TRISPOT); 
                        tracker2.Init(tracker2.TRISPOT);
                        cppUDPThread.spotCmd.SendSpot(estComm.SPOT_ID1, forward, 0);
                        cppUDPThread.spotCmd.SendSpot(estComm.SPOT_ID2, forward, 0);
                        CppThread.firsttime1 = true;
                        CppThread.firsttime2 = true;
                        pathTrackingAll = true;
                        tracker1Done = false;
                        tracker2Done = false;
                    }
                    else if(ParseIt[1].equals("follow")) {  //follow a moving robot
                        cppTCPSocket.genSend("a");
                        tracker1.Init(tracker1.TRISPOT);
                        CppThread.firsttime1 = true;
                        pathFollowing = true;
                    }
                    else if(ParseIt[1].equals("stop")) {  //stop following a robot
                        pathTracking = false;
                        pathTrackingAll = false;
                        pathFollowing = false;
                        pathRecording = false;
                        //CppThread.camrefreshon = false;
                    }
                 }
                
                 else if (ParseIt[0].equals("follow")) {//path recording
                    if(ParseIt[1].equals("start")){ //start recording
                        System.out.println("Follow");
                        pathRecording=true;
                        CppThread.pathLength = 0;
                        
                    }
                    if(ParseIt[1].equals("stop")) { //stop recording
                        pathRecording=false;
                    }
                 }
                //This is used to tune the smax paramater for tracker
                 else if (ParseIt[0].equals("smax")) {
                    QuadCurveTracker.Smax = Double.parseDouble(ParseIt[1]);
                    GuiSocket.genSend("Smax is: " + QuadCurveTracker.Smax);
                 }
                //This is used to tune the rho paramater for tracker
                 else if (ParseIt[0].equals("rho")) {
                    QuadCurveTracker.rho = Double.parseDouble(ParseIt[1]);
                    GuiSocket.genSend("rho is: " + QuadCurveTracker.rho);
                 }
                //This is used to tune the turnscale paramater for tracker
                 else if (ParseIt[0].equals("turnscale")) {
                    QuadCurveTracker.turnScale = Double.parseDouble(ParseIt[1]);
                    GuiSocket.genSend("turnscale is: " + QuadCurveTracker.turnScale);
                 }
                //This is used to tune the speedscale paramater for tracker
                 else if (ParseIt[0].equals("speedscale")) {
                    CppThread.speedscale = Double.parseDouble(ParseIt[1]);
                    GuiSocket.genSend("speedscale is: " + CppThread.speedscale);
                 }
                 //Request for UDP mode between GUI and Base
                 else if (ParseIt[0].equals("UDP")) {
                    GuiSocket.genSend("UDP");  //tell the GUI to listen for UDP
                    GuiSocket.UDPCommands = true;
                    System.out.println("Base station is now operating in UDP Mode");
                 }
                 //Request for TCP mode between GUI and Base
                 else if (ParseIt[0].equals("TCP")) {
                    GuiSocket.genSend("TCP");  //tell the GUI to listen for TCP
                    GuiSocket.UDPCommands = false;
                    System.out.println("Base station is now operating in TCP Mode");
                 }
    // Case where the command received is not any of the cases already considered...            
                else{GuiSocket.genSend("Bad Command");}  
            } //end of the if(GuiSocketConnected)
        }
    }
    
    /**
     * Start up the host application.
     *
     * @param args any command line arguments
     */
    public static void main(String[] args) throws Exception {
        SunSpotHostApplication app = new SunSpotHostApplication();
        new BootloaderListener().start();   // monitor the USB (if connected) and recognize commands from host
        app.run();                
    }

}
