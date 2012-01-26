/*
 * RcvData.java
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
import java.util.Random;
import java.util.Vector;
import javax.microedition.io.Connector;
import javax.microedition.io.Datagram;
import javax.microedition.io.DatagramConnection;
import org.sunspotworld.demo.utilities.RadioDataIOStream;   //handles the data packets
import org.sunspotworld.demo.utilities.StringTokenizer;     //separately stores each word seperated by a space in a string

import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;
/**
 *
 * @author Nikhil
 */
public class RcvData implements Runnable{
    
    EstComm estComm;
            
    public PrintWriter outputStream = null;
    private Thread runThread;
    public static boolean write=true;    
    public boolean stop;
    public static RadioDataIOStream IStream;
    
    
    //Constructor
    public RcvData() {        
    } 
    
    //Request for this thread to start, open input stream from Spot
    public void reqStart(String ID, int PORT){
        stop = false;        
        IStream  = RadioDataIOStream.openInput(ID, PORT);    
        try{
            //Create a file for storing the data received from the spot and insert a file header
            outputStream = new PrintWriter(new FileWriter("meas_log_TS1.txt", true));                  
            outputStream.println("Time          ax          ay          lpulse          rpulse          xDot          yDot          x          y          xAccelEnc          yAccelEnc");            
        }
        catch(IOException ex){}
    }
    
    //Request for this thread to stop and to cloes comms with the Spot
    public void reqStop() {        
        stop = true;     
        if (runThread != null) {            
            runThread.interrupt();            
        }
        System.out.println("thread stopped");
        IStream.InputClose();
    }

    //Main function, implements a loop that calls ReceiveAndPrint
    public void run() {
        runThread = Thread.currentThread();        
        while (!stop) {
            ReceiveAndPrint();
        }        
    }
    
    //Write the contents of string to the data file
    public void writefile (String theData) throws IOException{        
        outputStream.println(theData);        
    }
    
/**********************************************************************
 * ReceiveAndPrint()
 * Waits for messages from Spot using Istream
 *
 * writes message to file and forwards to the GUI for display
 *
 * All path tracking calls are made from this function, if enabled
 *********************************************************************/
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
            if(SunSpotHostApplication.TS1_Conn){//If connected send the data to GUI
                SunSpotHostApplication.GuiSocket.genSend("data "+message);
            }
        }
        catch(IOException ex){}               
    } 
}
