// HW6_AccelSpot ... changed code
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
    
    public static final byte END_COMM = 8;
    public static byte oldcommand=0;
    EstComm estComm = new EstComm();
    Accel_Sense Accel_Sense = new Accel_Sense();
    String message;
    public RadioDataIOStream IStream, OStream;                        //data packet
    ITriColorLED leds[] = EDemoBoard.getInstance().getLEDs();    
    public ISwitch sw1 = EDemoBoard.getInstance().getSwitches()[0];
    public ISwitch sw2 = EDemoBoard.getInstance().getSwitches()[0];

    
    public void init()throws IOException {        
        try{estComm.InitiateComm();} // Initiate the base discovery routine
        catch(IOException ex){/*ignore*/}
        OStream  = RadioDataIOStream.openOutput(estComm.BASE_ID, 120);   // open the inpout Stream to the base.       
        leds[3].setRGB(60,60,60);            
        leds[3].setOff();
        run();        
    }
 
      
     public void run() {
        System.out.println("connected...1");
        try{
            ExecuteLoop();
        }catch(IOException ex){}
     }
     
     public void ExecuteLoop() throws IOException{      
        
         while(true){
             
            Accel_Sense.getAccel();
            if(Accel_Sense.sendcommand != oldcommand){ // check if the command to be sent is a new command
                System.out.println("new: " + Accel_Sense.sendcommand + "        old: "+ oldcommand); 
                oldcommand = Accel_Sense.sendcommand;
                try{            
                        message = Accel_Sense.getData();
                        OStream.writeUTF(message); // transmit the message
                        OStream.flush();            
                    //blink a light
                    if(leds[3].isOn()) leds[3].setOff();
                    else leds[3].setOn();
                }   
                catch(IOException ex){}
            }                         
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
