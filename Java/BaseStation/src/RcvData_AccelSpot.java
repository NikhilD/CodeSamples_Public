/*
 * RcvData_AccelSpot.java
 *
 * Created on February 20, 2008, 5:46 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.sunspotworld.demo;

import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.sensorboard.peripheral.TriColorLED;
import com.sun.spot.sensorboard.peripheral.ITriColorLED;
import com.sun.spot.sensorboard.peripheral.LEDColor;
import com.sun.spot.sensorboard.io.PinDescriptor;
import com.sun.spot.sensorboard.peripheral.IAccelerometer3D;
import com.sun.spot.util.Utils;
import com.sun.spot.sensorboard.io.InputPin ;
import com.sun.spot.sensorboard.peripheral.ISwitch;
import com.sun.spot.sensorboard.io.IInputPin;
import com.sun.spot.peripheral.*;
import com.sun.spot.util.Utils;
import java.io.IOException;
import java.lang.Object.*;
import com.sun.spot.peripheral.radio.IRadioPolicyManager;
//import com.sun.spot.io.j2me.radio.*;
//import com.sun.spot.io.j2me.radiogram.*;
import com.sun.spot.util.*;
import java.lang.Thread;
import java.io.*;
import javax.microedition.io.*;


import com.sun.spot.peripheral.Spot;
import com.sun.spot.sensorboard.EDemoBoard;
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
//import com.sun.spot.peripheral.IAT91_TC;

import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;
/**
 *
 * @author Nikhil
 */
public class RcvData_AccelSpot implements Runnable{
    
    CppThread CppThread;
    EstComm estComm;    
    private Thread runThread;    
    public boolean stop;
    public static RadioDataIOStream IStream;
    public String[] accelCmd = {"","","",""};
    
    
    //Constructor
    public RcvData_AccelSpot() {        
    }
    
    //Start running this thread and calling receive and print
    public void run() {
        runThread = Thread.currentThread();        
        while (!stop) {
            ReceiveAndPrint();
        }        
    }
    
    //Request that the loop stop and close the input stream
    public void reqStop() {        
        stop = true;     
        if (runThread != null) {            
            runThread.interrupt();            
        }
        System.out.println("thread stopped");
        IStream.InputClose();
    }
    
    //Request that this thread start
    //creat input stream for data from spot
    public void reqStart(String ID, int PORT){
        stop = false;        
        IStream  = RadioDataIOStream.openInput(ID, PORT);        
    }
    
    //Main functions
    public void ReceiveAndPrint(){        
        String message="";
        try{
            message = IStream.readUTF();
            IStream.flush();            
            if(message == null){
                System.out.println("null message");
                message = "";
            }
            System.out.println("message3 is: " + message);
            //Get the motion command sent by the accel spot
            accelCmd = StringTokenizer.parseStringAsArray(message, " ");
            //Send the motion command to the spot
            CppThread.spotCmd.SendSpot(estComm.SPOT_ID2,accelCmd,0);
        }
        catch(IOException ex){}             
    }
}
