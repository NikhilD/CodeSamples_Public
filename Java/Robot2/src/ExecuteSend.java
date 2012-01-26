/*
 * ExecuteSend.java
 *
 * Created on February 26, 2008, 3:05 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.sunspotworld;

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
import com.sun.spot.sensorboard.io.IOutputPin;
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
import com.sun.spot.peripheral.IAT91_TC;

import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;
import com.sun.spot.sensorboard.peripheral.LEDColor;

/**
 *
 * @author Nikhil
 */
public class ExecuteSend implements Runnable{
    
    EstComm estComm;
    Control_Sense controlSense = new Control_Sense();
    ITriColorLED leds[] = EDemoBoard.getInstance().getLEDs();   
    
    byte DirCmd;
    String received;
    private Thread runThread;    
    private boolean running = false;
    RadioDataIOStream OStream;
    public String message;
    public static boolean newcommand = false, newturn = false;
    public static byte direction;
    public static double arg1, arg2;
    public static int turnleft, turnright;
    
    public ExecuteSend() {        
    }
    
    /******************************************************************
    /*This method opens the Output radioStream to the Base-station
    / It is called from StartApplication when it receives any command.
     *It also initializes the UART for communication with PIC
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void reqStart () {     
        System.out.println("started...");
        OStream  = RadioDataIOStream.openOutput(estComm.BASE_ID, 110);
        controlSense.demoBoard.initUART(9600, false);
        running = true;
        leds[3].setRGB(60,60,60);            
        leds[3].setOff();
    }
    
    /******************************************************************
    /*This method closes the radioStream for the TriSpot and stops 
     * execution of the Thread.
    / It is called from StartApplication when it receives a Disconnect 
     * (END_COMM) command.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void reqStop () {
        running = false;
        leds[3].setOff();
        if (runThread != null) {            
            runThread.interrupt();            
        }
        OStream.OutputClose();
        System.out.println("thread stopped"); 
    }
    
    /** On executing Thread.start(), the runnable interface 
     * calls this method.
     * Start executing command and sending data to host.
     */
    public void run() {    
        runThread = Thread.currentThread();
        while (running) {
            ExecuteAndSend();
        }
    }
    
    /******************************************************************
    /*This main program loop, calls all the relevant functions from the
     * Control_Sense.java file    / 
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void ExecuteAndSend(){
        
        
        if(newcommand){
            controlSense.setDirPosVel(direction, arg1, arg2);
            controlSense.leftPWM = (int)((4.27*arg2*100) + 91);
            controlSense.rightPWM = (int)((5.36*arg2*100) + 52);
            controlSense.motorEnable.setHigh();
            newcommand = false;
        }
        if(newturn){
            controlSense.setSpeeds(turnleft, turnright);
            controlSense.leftPWM = (int)((4.27*turnleft) + 91);
            controlSense.rightPWM = (int)((5.36*turnright) + 52);
            newturn = false;
        }
        controlSense.getEncTravel();
        controlSense.setPWM(); 
        controlSense.moveWheel(controlSense.leftPWM, controlSense.rightPWM);
        controlSense.getEncValues(); 
        controlSense.getAccel();
        
        try{
            message = controlSense.getData();
            OStream.writeUTF(message);
            OStream.flush();
            
            //blink a light
            if(leds[3].isOn()) leds[3].setOff();
            else leds[3].setOn();
        }   
        catch(IOException ex){}
        try {
            Thread.sleep(1);
        }catch (InterruptedException x) {
         // re-assert interrupt
            Thread.currentThread().interrupt();
        }        
        
        if(controlSense.lefttravel > controlSense.setLeftPosition && controlSense.righttravel > controlSense.setRightPosition){
            controlSense.cmdFinish();        
        }
    }       
    
}
