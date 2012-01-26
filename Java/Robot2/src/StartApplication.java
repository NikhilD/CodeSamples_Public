// HW3_Spot ... changed code
package org.sunspotworld;


import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.sensorboard.peripheral.TriColorLED;
import com.sun.spot.sensorboard.peripheral.ITriColorLED;
import com.sun.spot.sensorboard.peripheral.LEDColor;
import com.sun.spot.sensorboard.io.PinDescriptor;
import com.sun.spot.sensorboard.peripheral.IAccelerometer3D;
import com.sun.spot.util.Utils;
import com.sun.spot.sensorboard.io.InputPin ;
import com.sun.spot.sensorboard.io.IOutputPin;
import com.sun.spot.sensorboard.peripheral.ISwitch;
import com.sun.spot.sensorboard.io.IInputPin;
import com.sun.spot.peripheral.*;
import com.sun.spot.util.Utils;
import java.io.IOException;
import java.lang.Object.*;
import com.sun.spot.peripheral.radio.IRadioPolicyManager;

import com.sun.spot.io.j2me.radiogram.*;
import com.sun.spot.util.*;


import java.io.*;
import javax.microedition.io.*;


import com.sun.spot.peripheral.Spot;
import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.peripheral.radio.IRadioPolicyManager;

import java.util.Random;
import java.util.Vector;
import javax.microedition.io.Connector;
import javax.microedition.io.Datagram;
import javax.microedition.io.DatagramConnection;

import org.sunspotworld.demo.utilities.RadioDataIOStream;   //handles the data packets
import org.sunspotworld.demo.utilities.StringTokenizer;     //separately stores each word seperated by a space in a string
//import com.sun.spot.peripheral.IAT91_TC;

import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;



public class StartApplication extends MIDlet { 
    
    public static final byte PID = 1;
    public static final byte TURN = 2;
    public static final byte FORWARD = 3;
    public static final byte REVERSE = 4;
    public static final byte RIGHT = 5;
    public static final byte LEFT = 6;
    public static final byte STOP = 7;
    public static final byte END_COMM = 8;
        
    ExecuteSend executeSend = new ExecuteSend();
    EstComm estComm = new EstComm();
    Control_Sense controlSense = new Control_Sense();
    
    public RadioDataIOStream IStream;                        //data packet
    ITriColorLED leds[] = EDemoBoard.getInstance().getLEDs();    
    
    
    public void init()throws IOException {
        controlSense.motorEnable.setLow(); // Disable the H-Bridge
        try{estComm.InitiateComm();} // Initiate the base discovery routine
        catch(IOException ex){/*ignore*/}
        IStream  = RadioDataIOStream.openInput(estComm.BASE_ID, 110); // open the inpout Stream to the base.
        controlSense.moveWheel(1,1); // Initialize the motors.        
        run();        
    }
 
      
     public void run() {
        System.out.println("connected...1");
        try{
            ExecuteLoop();
        }catch(IOException ex){}
     }
     
     public void ExecuteLoop() throws IOException{      
        
         String command;
         String[] parser;
         boolean thread_run = true;
         byte DirCmd;   
         controlSense.resetPIC();
        while(true){
            command = IStream.readUTF();  // receive Command from the radiostream...this is a halting function 
            System.out.println("Command Received: " + command); // and code does not procedd until new command is received!
            parser = StringTokenizer.parseStringAsArray(command, " "); // String parsing
            IStream.flush();
            DirCmd = Byte.parseByte(parser[0]); 
            if(DirCmd > 2 && DirCmd < 7) {
                executeSend.direction = Byte.parseByte(parser[0]);
                executeSend.arg1 = Double.parseDouble(parser[1]);
                executeSend.arg2 = Double.parseDouble(parser[2]);
                executeSend.newcommand = true;
                System.out.println("Moving...");
            }
            switch (DirCmd) {// If the Direction command is any of FORWARD, REVERSE, LEFT or RIGHT.
                case PID:
                    Control_Sense.kp = Double.parseDouble(parser[1]);
                    Control_Sense.kd = Double.parseDouble(parser[2]);
                    break;
                case TURN:// 'w'turn motion command
                    System.out.println("got a turn command");
                    executeSend.turnleft = Integer.parseInt(parser[1]);
                    executeSend.turnright = Integer.parseInt(parser[2]);
                    executeSend.newturn = true;
                    //controlSense.setSpeeds(Integer.parseInt(parser[1]), Integer.parseInt(parser[2]));
                    //controlSense.initVariables();
                    //this is w case
                    
                    break;
                case STOP:// 's'top motion command
                    controlSense.cmdFinish();
                    System.out.println("Stop Received...");                                
                    leds[4].setOff(); 
                    break;
                case END_COMM:// 'e'nd communication command
                    System.out.println("End Received...");                                
                    executeSend.reqStop();
                    leds[4].setOff();
                    IStream.close();
                    controlSense.initVariables();
                    try{init();}
                    catch(IOException ex){}
                    //System.exit(0);
                    break;
                default: break;
            }
            while(thread_run){ // This loop is executed only once on receiving any command from the Base-station
                if(DirCmd != 0){
                    executeSend.reqStart();
                    new Thread(executeSend).start(); // This line calls the run() method in the ExecuteSend.java thread.
                    thread_run = false;
                    leds[4].setRGB(60,40,0);            
                    leds[4].setOn();
                }
            }
            command = null;
        }                
     }  
     
     
     /**
      *
     * The rest is boiler plate code, for Java ME compliance
     *
     * startApp() is the MIDlet call that starts the application.
     */
    protected void startApp() throws MIDletStateChangeException {
        new BootloaderListener().start();   // monitor the USB (if connected) and recognize commands from host
        
        try {
            init(); // call the init() method written above!
        } catch (IOException ex) { //A problem in reading the sensors.
            ex.printStackTrace();
        }
    }
    
    /**
     * This will never be called by the Squawk VM.
     */
    protected void pauseApp() {
    }
    
    /**
     * Only called if startApp throws any exception other than MIDletStateChangeException.
     */
    protected void destroyApp(boolean arg0) throws MIDletStateChangeException {
    }
    
}
