/*
 * CppThread.java
 *
 * Created on March 20, 2008, 3:00 PM
 *
 * CppThread class is used to listen to data coming from image processing software
 */

package org.sunspotworld.demo;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.sunspotworld.demo.utilities.StringTokenizer;     //separately stores each word seperated by a space in a string
/**
 *
 * @author Nikhil
 */
public class CppThread implements Runnable {
    
    public static boolean manualGain = false;
    public static double manualGainValue = 1;
    public static boolean GSM = false;
    public static String[] path = new String[512];
    public static int pathLength;
    public boolean CppSocketConnected = false;
    private Thread runThread;
    boolean stop;
    public static int X=0, Y=1, Or=2, Rd=3, Obj=0, i=0, tempObj = 0;
    public static String[][] Robot = new String[3][4];
    String[][] Obstacle;
    String[] ParseIt, GSM_Val, robotsData;
    String input;
    public static double gain = 1;
    public int maxDelay = 10;
    public int delay = 0;
    public int kappaScaled = 0;
    public double kappaMax = 0.001;
    public static double speedscale = 0.5;
    public static double timeSinceUpdate = 0;
    public static boolean firsttime = false;
    public static boolean firsttime1 = false;
    public static boolean firsttime2 = false;
    public static boolean pathtracking = false;
    public static double camX = 0, camY = 0;
    public int setwr = 0, setwl = 0;
    public double linearV = 0, thetaV = 0, oldlinearV = 0;
    public double linearV1 = 0, thetaV1 = 0, oldlinearV1 = 0;
    public double linearV2 = 0, thetaV2 = 0, oldlinearV2 = 0;
    public double dublinearV = 0, dubthetaV = 0, dubwr = 0, dubwl = 0, duboldlinearV = 0, dubKappa =0, theta = 0, x = 0, y = 0;
    String[] forward = {"f","-1","0.01"};
    String[] backward = {"b","-1","0.01"};
    String[] stopcmd = {"s","0","0"};
    String[] turncmd = {"w","1","1"};
    public static double p = 0.028575, W = 0.095;
    
    //GSM file reading stuff
    public int m=20,n=10;
    File file = new File("GSM.txt");
    FileInputStream fis = null;
    BufferedInputStream bis = null;
    DataInputStream dis = null;
    double GSM_arr[][] = new double[m][n];
    // GSM over
   
    public static int Co_x,Co_y;
    public int APathPoints = 0;
    public String[]AccelPath=new String[1024];
    
    public static mySocket cppUDP = new mySocket();  //socket for secondary comms
    public static SpotCommand spotCmd = new SpotCommand();
    EstComm estComm;
    
    //Constructor
    public CppThread() {
    }

    //Connect socket and prepare for the run method
    public void reqStart(){
        while(!CppSocketConnected){
            System.out.println("Creating UDP listener");
            cppUDP.createUDPListener(8998);
            System.out.println("UDP Listener Created");
            CppSocketConnected = true;
            stop = false;
            //also connect the TCP variant here
            cppUDP.UDPCommands = true;
            System.out.println("connecting to TCP option");
            cppUDP.connectToServer(SunSpotHostApplication.pcHost, 4004);
            System.out.println("TCP option connected");
        }
    }
    
    //stop this thread and disconnect sockets
    public void reqStop() {        
        stop = true;     
        CppSocketConnected = false;
        cppUDP.closeUDP();
        cppUDP.stopClient();
        
        if (runThread != null) {            
            runThread.interrupt();            
        }
        System.out.println("thread stopped");        
    }
     
    //Main thread function, loads gain table and runs execute loop
    public void run() {
        runThread = Thread.currentThread();   
        System.out.println("cp thread starting");
        readGSM();
        System.out.println("Gain Table Created...");
        while (!stop) {
            ReceiveAndExecute();
        }
    }

/**********************************************************************
 * ReceiveAndExecute()
 * Waits for messages on secondary socket from C++, default protocol is UDP
 *
 * Accepts Path, robot and robots data.  q and o are deprecated
 *
 * All path tracking calls are made from this function, if enabled
 *********************************************************************/
    public void ReceiveAndExecute(){

        if(cppUDP.UDPCommands) System.out.println("UDP is listening....");
        else System.out.println("TCP is listening....");
        input = cppUDP.genRead();  
        if(cppUDP.UDPCommands) System.out.println("I got this from UDP: " + input);
        else System.out.println("I got this from TCP: " + input);
        
        ParseIt = StringTokenizer.parseStringAsArray(input, " ");
        if(ParseIt[0].equals("p")){///path data
            if(ParseIt[1].equals("999")) {  //Prepare for new path
                pathLength = 0;
                SunSpotHostApplication.tracker.number_of_points = 0;
                System.out.println("Path Initialized");
            }
            else if(ParseIt[1].equals("997")) {  //Path generation has completed
                SunSpotHostApplication.GuiSocket.genSend("path 997");  //Tell the GUI path is completed
                System.out.println("Path Complete");
                SunSpotHostApplication.tracker.printPath();
            }
            else{  //This is a new path point
                if(SunSpotHostApplication.TS1_Conn){  
                    //If robot 0 is currently selected put the path into tracker and tracker1
                    //tracker is used for normal path tracking, tracker1 is used for track all
                    path[pathLength] = ParseIt[1] + " " + ParseIt[2];
                    SunSpotHostApplication.tracker.path[pathLength][0] = Integer.parseInt(ParseIt[1]) - 200;
                    SunSpotHostApplication.tracker.path[pathLength][1] = Integer.parseInt(ParseIt[2]) - 200;
                    SunSpotHostApplication.tracker.number_of_points = pathLength;
                    SunSpotHostApplication.tracker1.path[pathLength][0] = Integer.parseInt(ParseIt[1]) - 200;
                    SunSpotHostApplication.tracker1.path[pathLength][1] = Integer.parseInt(ParseIt[2]) - 200;
                    SunSpotHostApplication.tracker1.number_of_points = pathLength;
                    System.out.println("putting path data in tracker 1");
                    pathLength++;
                }
                if(SunSpotHostApplication.TS2_Conn){
                    //If robot 1 is currently selected put the path data into tracker2, this is used for track all
                    path[pathLength] = ParseIt[1] + " " + ParseIt[2];
                    SunSpotHostApplication.tracker2.path[pathLength][0] = Integer.parseInt(ParseIt[1]) - 200;
                    SunSpotHostApplication.tracker2.path[pathLength][1] = Integer.parseInt(ParseIt[2]) - 200;
                    SunSpotHostApplication.tracker2.number_of_points = pathLength;
                    System.out.println("putting path data in tracker 2");
                    pathLength++;
                }
            }
            
        }
        else if(ParseIt[0].equals("r")){//Single robot data
            //command received is in the form r ID x y Or radius
            i=1;
            Obj = Integer.parseInt(ParseIt[i]);i++; 
            Robot[Obj][X] = ParseIt[i];i++;            
            Robot[Obj][Y] = ParseIt[i];i++;
            Robot[Obj][Or] = ParseIt[i];i++;
            Robot[Obj][Rd] = ParseIt[i];i++;
            System.out.println("robot "+Robot[Obj][X] + " " + Robot[Obj][Y] + " " + Robot[Obj][Or]);
            SunSpotHostApplication.GuiSocket.genSend("robot "+ Obj + " " 
                    +Robot[Obj][X] + " " + Robot[Obj][Y] + " " + Robot[Obj][Or]);  //reformat for sending to GUI
            camX = Double.parseDouble(Robot[Obj][X]);
            camY = Double.parseDouble(Robot[Obj][Y]);
            
            //do Normal path tracking here if its on
            if(SunSpotHostApplication.pathTracking){
                setwr = 0;
                setwl = 0;
                trackPath();
            }
            //Record the robot positions to a path if pathrecording is on
            if(SunSpotHostApplication.pathRecording){
                Co_x=(int)camX;
                Co_y=(int)camY;
                path[pathLength] = Integer.toString(Co_x + 200)+" "+Integer.toString(Co_y + 200);
                SunSpotHostApplication.tracker.path[pathLength][0]=Co_x;
                SunSpotHostApplication.tracker.path[pathLength][1]=Co_y;
                SunSpotHostApplication.tracker.number_of_points=pathLength;
                pathLength++;
            }
        }
        else if(ParseIt[0].equalsIgnoreCase("robots")){//multiple robots data
            robotsData = StringTokenizer.parseStringAsArray(input.substring(6), " ");
            int i = 0;
            while(i < robotsData.length){  //loop through all the robots
                tempObj = Integer.parseInt(robotsData[i]);
                Robot[tempObj][X] = robotsData[i+1];         
                Robot[tempObj][Y] = robotsData[i+2];
                Robot[tempObj][Or] = robotsData[i+3];
                Robot[tempObj][Rd] = "10";
                //If path following is on execute this code for robot 1 only
                //this will record the position of robot1 to a path in tracker1
                if(tempObj == 1 && SunSpotHostApplication.pathFollowing){
                    Co_x= (int)Double.parseDouble(Robot[tempObj][X]);
                    Co_y= (int)Double.parseDouble(Robot[tempObj][Y]);
                    path[pathLength] = Integer.toString(Co_x + 200)+" "+Integer.toString(Co_y + 200);
                    SunSpotHostApplication.tracker1.path[pathLength][0]=Co_x;
                    SunSpotHostApplication.tracker1.path[pathLength][1]=Co_y;
                    SunSpotHostApplication.tracker1.number_of_points=pathLength;
                    pathLength++;
                    //After the robot has a head start start tracking thepath with robot 0
                    if(pathLength >= 20){
                        if(pathLength == 20) spotCmd.SendSpot(estComm.SPOT_ID1, forward,0);
                        Obj = 0;
                        setwr = 0;
                        setwl = 0;
                        trackPath1();
                    }
                }
                i = i+4;
            }
            //If track all is enabled do path tracking for robot 0 
            //using tracker1 and robot 1 using tracker2
            if(SunSpotHostApplication.pathTrackingAll){
                Obj = 0; //select robot 0
                setwr = 0;
                setwl = 0;
                trackPath1();
                Obj = 1; //selecr robot 1
                setwr = 0;
                setwl = 0;
                trackPath2();
            }
            SunSpotHostApplication.GuiSocket.genSend(input);
        }
        else if(ParseIt[0].equals("q")){
            //command received is in the form r ID x y Or radius  THESE are from the second C++
            i=1;
            Obj = Integer.parseInt(ParseIt[i]);i++; 
            Robot[Obj][X] = ParseIt[i];i++;            
            Robot[Obj][Y] = ParseIt[i];i++;
            Robot[Obj][Or] = ParseIt[i];i++;
            Robot[Obj][Rd] = ParseIt[i];i++;
            //need to send robot x y o
            System.out.println("robot "+Robot[Obj][X] + " " + Robot[Obj][Y] + " " + Robot[Obj][Or]);
        }
        else if(ParseIt[0].equals("o")){ //obstacle data
            i=1;
            Obj = Integer.parseInt(ParseIt[i]);i++;            
            Obstacle[Obj][X] = ParseIt[i];i++;            
            Obstacle[Obj][Y] = ParseIt[i];i++;
        }
        else if(ParseIt[0].equals("TCP")){
            //Go to using TCP for this
            cppUDP.UDPCommands = false;
        }
        else if(ParseIt[0].equals("UDP")){
            //Go to using UDP for this
            cppUDP.UDPCommands = true;
        }
        else System.out.println("unsupported command: " + input);
    } 
    
    //open and load the GSM data from the GSM file
     public void readGSM(){
        try {
            fis = new FileInputStream(file);            
            bis = new BufferedInputStream(fis);
            dis = new DataInputStream(bis);
            String strLine;            
            while ((strLine = dis.readLine()) != null){              
                GSM_Val = StringTokenizer.parseStringAsArray(strLine, ",");
                System.out.println(GSM_Val.length);
                for(int i=0;i<m;i++){
                    for(int j=0;j<n;j++){
                        GSM_arr[i][j]= Double.parseDouble(GSM_Val[(j+(i*n))]);
                        System.out.println(GSM_arr[i][j]);
                    }
                }                 
            }
            // dispose all the resources after using them.
            fis.close();
            bis.close();
            dis.close();
        }
        catch (FileNotFoundException ex) {ex.printStackTrace();}
        catch (IOException e) {e.printStackTrace();}
    }
    
    //path tracking call for tracker
    public void trackPath(){
        //Get the robot data
        x = Double.parseDouble(Robot[Obj][X]);
        y = Double.parseDouble(Robot[Obj][Y]);
        theta = Double.parseDouble(Robot[Obj][Or]);
        oldlinearV = linearV;
        //Call Path tracking and get the speed and turnrate
        SunSpotHostApplication.tracker.Exec(x,y,theta);
        linearV = SunSpotHostApplication.tracker.getSpeed();
        thetaV = SunSpotHostApplication.tracker.getturnRate();
        System.out.println("************************************************path tracking linearV: "+linearV+" path tracking thetaV: "+thetaV);
        if(firsttime) {
            linearV=10;
            firsttime = false;
        }  //this is first run

        //If the set speed is 0 then the end of the path has been reached
        if(linearV == 0) {
            spotCmd.SendSpot(estComm.SPOT_ID,stopcmd,0);
            SunSpotHostApplication.pathTracking = false;
        }

        linearV = linearV/100;  //meters per second

        //If the linearV sign changes then need to 
        //send the opposite direction command to robot
        if((linearV < 0)&&(oldlinearV > 0) || (linearV > 0)&&(oldlinearV < 0)){
            //this is true if the sign has changed
            System.out.println("********************************************sign changed..." + linearV);
            if(linearV < 0) spotCmd.SendSpot(estComm.SPOT_ID, backward,0);
            if(linearV > 0) spotCmd.SendSpot(estComm.SPOT_ID, forward,0);
        }
        if(linearV < 0) linearV = -0.2;
        else linearV = 0.2;
        
        //Use the kinematics of the robot and the desired 
        //linearV and thetaV to find wheel set speeds in cm/s
        //in rad/s but then multiplied by p*100 to get cm/s
        setwr = Math.abs((int)(((linearV/p) + ((W*thetaV)/(2*p)))*p*100));
        //in rad/s but then multiplied by p*100 to get cm/s
        setwl = Math.abs((int)(((linearV/p) - ((W*thetaV)/(2*p)))*p*100));

        //scale the wheel speeds using the speedscale parameter
        setwr = (int)(setwr*speedscale);
        setwl = (int)(setwl*speedscale);

        //if GSM is on modify the gain value
        if(GSM){
            //Scale the delay so that is it in the range [0-19]
            delay=(int)(((double)(SunSpotHostApplication.DELAY * 19/1000))/((double)(maxDelay)));
            //Get Kappa and scale it to be an integer ing [0-9]
            dubKappa = SunSpotHostApplication.tracker.Kappa;
            if(dubKappa > kappaMax) dubKappa = kappaMax;
            kappaScaled =(int)(dubKappa * 9/kappaMax);
            gain = GSM_arr[delay][kappaScaled];
            //if manual gain is on override the GSM table value
            if(manualGain) gain = manualGainValue;
            //Send the gain to the GUI for display to user
            SunSpotHostApplication.GuiSocket.genSend("gain " + gain);
        }
        else gain = 1;
        
        //Scale the wheel speed by the GSM gain
        setwr = (int)(setwr*gain);
        setwl = (int)(setwl*gain);

        //If wheelspeed is too small bump it up to a value that will actually move the wheel
        if((setwr > 0) && (setwr < 5)) setwr = 5;
        if((setwl > 0) && (setwl < 5)) setwl = 5;

        System.out.println("path tracking linearV: "+linearV+" path tracking thetaV: "+thetaV+" setwr: " + setwr + " setwl: " + setwl);
        
        //Set the turn commands and send them to the TriSPOT
        turncmd[1] = ("" + setwl);
        turncmd[2] = ("" + setwr);
        spotCmd.SendSpot(estComm.SPOT_ID, turncmd,0);
    }
    
    //Path tracking call for tracker1
    public void trackPath1(){
        //Get the robot data
        x = Double.parseDouble(Robot[Obj][X]);
        y = Double.parseDouble(Robot[Obj][Y]);
        theta = Double.parseDouble(Robot[Obj][Or]);
        oldlinearV1 = linearV1;
        //Call Path tracking and get the speed and turnrate
        SunSpotHostApplication.tracker.Exec(x,y,theta);
        linearV1 = SunSpotHostApplication.tracker1.getSpeed();
        thetaV1 = SunSpotHostApplication.tracker1.getturnRate();
        System.out.println("************************************************path tracking linearV1: "+linearV1+" path tracking thetaV1: "+thetaV1);
        if(firsttime1) {
            linearV1=10;
            firsttime1 = false;
        }  //this is first run

        //If the set speed is 0 then the end of the path has been reached
        if(linearV1 == 0) {
            spotCmd.SendSpot(estComm.SPOT_ID1,stopcmd,0);
            SunSpotHostApplication.tracker1Done = true;
            System.out.println("tracker 1 reached end");
        }

        linearV1 = linearV1/100;  //meters per second

        //If the linearV sign changes then need to send the opposite direction command to robot
        if((linearV1 < 0)&&(oldlinearV1 > 0) || (linearV1 > 0)&&(oldlinearV1 < 0)){
            //this is true of the sign has changed
            System.out.println("********************************************sign changed..." + linearV1);
            if(linearV1 < 0) spotCmd.SendSpot(estComm.SPOT_ID1, backward,0);
            if(linearV1 > 0) spotCmd.SendSpot(estComm.SPOT_ID1, forward,0);
        }
        if(linearV1 < 0) linearV1 = -0.2;
        else linearV1 = 0.2;
        
        //Use the kinematics of the robot and the desired linearV and thetaV to find wheel set speeds in cm/s
        setwr = Math.abs((int)(((linearV1/p) + ((W*thetaV1)/(2*p)))*p*100));//in rad/s but then multiplied by p*100 to get cm/s
        setwl = Math.abs((int)(((linearV1/p) - ((W*thetaV1)/(2*p)))*p*100));//in rad/s but then multiplied by p*100 to get cm/s

        //scale the wheel speeds using the speedscale parameter
        setwr = (int)(setwr*speedscale);
        setwl = (int)(setwl*speedscale);

        //if GSM is on modify the gain value
        if(GSM){
            //Scale the delay so that is it in the range [0-19]
            delay=(int)(((double)(SunSpotHostApplication.DELAY * 19/1000))/((double)(maxDelay)));
            //Get Kappa and scale it to be an integer ing [0-9]
            dubKappa = SunSpotHostApplication.tracker.Kappa;
            if(dubKappa > kappaMax) dubKappa = kappaMax;
            kappaScaled =(int)(dubKappa * 9/kappaMax);
            gain = GSM_arr[delay][kappaScaled];
            //if manual gain is on override the GSM table value
            if(manualGain) gain = manualGainValue;
            //Send the gain to the GUI for display to user
            SunSpotHostApplication.GuiSocket.genSend("gain " + gain);
        }
        else gain = 1;
        
        //Scale the wheel speed by the GSM gain
        setwr = (int)(setwr*gain);
        setwl = (int)(setwl*gain);

        //If wheelspeed is too small bump it up to a value that will actually move the wheel
        if((setwr > 0) && (setwr < 5)) setwr = 5;
        if((setwl > 0) && (setwl < 5)) setwl = 5;

        System.out.println("path tracking linearV: "+linearV+" path tracking thetaV: "+thetaV+" setwr: " + setwr + " setwl: " + setwl);
        
        //Set the turn commands and send them to the TriSPOT
        turncmd[1] = ("" + setwl);
        turncmd[2] = ("" + setwr);
        spotCmd.SendSpot(estComm.SPOT_ID1, turncmd,0);
       // }
    }
        
    //Path tracking call for tracker2
    public void trackPath2(){
        //Get the robot data
        x = Double.parseDouble(Robot[Obj][X]);
        y = Double.parseDouble(Robot[Obj][Y]);
        theta = Double.parseDouble(Robot[Obj][Or]);
        oldlinearV2 = linearV2;
        //Call Path tracking and get the speed and turnrate
        SunSpotHostApplication.tracker.Exec(x,y,theta);
        linearV2 = SunSpotHostApplication.tracker2.getSpeed();
        thetaV2 = SunSpotHostApplication.tracker2.getturnRate();
        System.out.println("************************************************path tracking linearV2: "+linearV2+" path tracking thetaV2: "+thetaV2);
        if(firsttime2) {
            linearV2=10;
            firsttime2 = false;
        }  //this is first run

        //If the set speed is 0 then the end of the path has been reached
        if(linearV2 == 0) {
            spotCmd.SendSpot(estComm.SPOT_ID2,stopcmd,0);
            SunSpotHostApplication.tracker2Done = true;
            System.out.println("tracker 2 reached end");
        }

        linearV2 = linearV2/100;  //meters per second

        //If the linearV sign changes then need to send the opposite direction command to robot
        if((linearV2 < 0)&&(oldlinearV2 > 0) || (linearV2 > 0)&&(oldlinearV2 < 0)){
            //this is true of the sign has changed
            System.out.println("********************************************sign changed..." + linearV2);
            if(linearV2 < 0) spotCmd.SendSpot(estComm.SPOT_ID2, backward,0);
            if(linearV2 > 0) spotCmd.SendSpot(estComm.SPOT_ID2, forward,0);
        }
        if(linearV2 < 0) linearV2 = -0.2;
        else linearV2 = 0.2;
        
        //Use the kinematics of the robot and the desired linearV and thetaV to find wheel set speeds in cm/s
        setwr = Math.abs((int)(((linearV2/p) + ((W*thetaV2)/(2*p)))*p*100));//in rad/s but then multiplied by p*100 to get cm/s
        setwl = Math.abs((int)(((linearV2/p) - ((W*thetaV2)/(2*p)))*p*100));//in rad/s but then multiplied by p*100 to get cm/s

        //scale the wheel speeds using the speedscale parameter
        setwr = (int)(setwr*speedscale);
        setwl = (int)(setwl*speedscale);

        //if GSM is on modify the gain value
        if(GSM){
            //Scale the delay so that is it in the range [0-19]
            delay=(int)(((double)(SunSpotHostApplication.DELAY * 19/1000))/((double)(maxDelay)));
            //Get Kappa and scale it to be an integer ing [0-9]
            dubKappa = SunSpotHostApplication.tracker.Kappa;
            if(dubKappa > kappaMax) dubKappa = kappaMax;
            kappaScaled =(int)(dubKappa * 9/kappaMax);
            gain = GSM_arr[delay][kappaScaled];
            //if manual gain is on override the GSM table value
            if(manualGain) gain = manualGainValue;
            //Send the gain to the GUI for display to user
            SunSpotHostApplication.GuiSocket.genSend("gain " + gain);
        }
        else gain = 1;
        
        //Scale the wheel speed by the GSM gain
        setwr = (int)(setwr*gain);
        setwl = (int)(setwl*gain);

        //If wheelspeed is too small bump it up to a value that will actually move the wheel
        if((setwr > 0) && (setwr < 5)) setwr = 5;
        if((setwl > 0) && (setwl < 5)) setwl = 5;

        System.out.println("path tracking linearV: "+linearV+" path tracking thetaV: "+thetaV+" setwr: " + setwr + " setwl: " + setwl);
        
        //Set the turn commands and send them to the TriSPOT
        turncmd[1] = ("" + setwl);
        turncmd[2] = ("" + setwr);
        spotCmd.SendSpot(estComm.SPOT_ID2, turncmd,0);
    }
}
