/*
 * RcvData_TS2.java
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

import java.io.FileReader;
import java.io.FileWriter;
import java.io.BufferedReader;
import java.io.PrintWriter;

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
public class RcvData_TS2 implements Runnable{
    
    EstComm estComm;
    public PrintWriter outputStream = null;
    private Thread runThread;    
    public boolean stop;
    public static RadioDataIOStream IStream;
    
    public void reqStop() {        
        stop = true;     
        if (runThread != null) {            
            runThread.interrupt();            
        }
        System.out.println("thread stopped");
        IStream.InputClose();
    }
    
    /**
     * Creates a new instance of RcvData
     */    
    public RcvData_TS2() {        
    }
    
    public void run() {
        runThread = Thread.currentThread();        
        while (!stop) {
            ReceiveAndPrint();
        }        
    }
    
//    public void reqStart(){
//        stop = false;        
//        IStream  = RadioDataIOStream.openInput(estComm.SPOT_ID2, 110);  
//        try {
//            outputStream = new PrintWriter(new FileWriter("meas_log_TS2.txt", true));                  
//            outputStream.println("Time          ax          ay          lpulse          rpulse          xDot          yDot          x          y          xAccelEnc          yAccelEnc");
//        }
//        catch(IOException ex){}
//        
//    }
    
    public void reqStart(String ID, int PORT){
        stop = false;        
        IStream  = RadioDataIOStream.openInput(ID, PORT);  
        try {
            outputStream = new PrintWriter(new FileWriter("meas_log_TS2.txt", true));                  
            outputStream.println("Time          ax          ay          lpulse          rpulse          xDot          yDot          x          y          xAccelEnc          yAccelEnc");
        }
        catch(IOException ex){}
        
    }
    
    public void ReceiveAndPrint(){        
        String message="";
        try{
            message = IStream.readUTF();
            IStream.flush();
            writefile(message);
            if(message == null){
                System.out.println("null message");
                message = "";
            }
           // System.out.println("message2 is: " + message);
            
            try {
                Thread.currentThread().sleep(1);               
            }
            catch (InterruptedException e) {
               System.out.println("Delay generator generated an exceptio");
            }
            if((!SunSpotHostApplication.TS1_Conn) && SunSpotHostApplication.TS2_Conn){
               // System.out.println("Tx message 2");
                SunSpotHostApplication.GuiSocket.genSend("data "+message);
            }
        }
        catch(IOException ex){}             
    }
    
    public void writefile (String theData) throws IOException{                    
        outputStream.println(theData);        
    }
    
}
