/*
 * Accel_Sense.java
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

//import org.sunspotworld.demo.utilities.RadioDataIOStream;   //handles the data packets
//import org.sunspotworld.demo.utilities.StringTokenizer;     //separately stores each word seperated by a space in a string
//import com.sun.spot.peripheral.IAT91_TC;

import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;

/**
 *
 * @author Nikhil
 */
public class Accel_Sense {
//    
    IAccelerometer3D acc = EDemoBoard.getInstance().getAccelerometer();
    public ISwitch sw1 = EDemoBoard.getInstance().getSwitches()[0];
    public ISwitch sw2 = EDemoBoard.getInstance().getSwitches()[1];

    
    
    IAT91_TC timer1 = Spot.getInstance().getAT91_TC(1);
    public String message;
    public static int setwl=0, setwr=0;
    
    //accelerometer variables
    public double ax = 0.0, ay = 0.0, az = 0.0, accelRawX = 0.0, accelRawY = 0.0, accelRawZ = 0.0;
    public static double pi = 3.14159, moveSpeed = 0.0;
    public static byte sendcommand=0;  
    public static boolean flagsw1=false;
    public static boolean flagsw2=false;
    EstComm estComm;
    
    /**
     * Creates a new instance of Accel_Sense
     */
    public Accel_Sense() {        
    }
    
    public void getAccel(){
    
         try {
             accelRawX = acc.getAccelX();
             accelRawY = acc.getAccelY();
             accelRawZ = acc.getAccelZ();
         } 
         catch (IOException ex) { //A problem in reading the sensors.
                ex.printStackTrace();
         }
         
         if(accelRawX <= 0.15 && accelRawX >= (-0.15))
         {
             accelRawX=0.0;
         }
         if(accelRawY <= 0.15 && accelRawY >= (-0.15))
         {
             accelRawY=0.0;
         }
         if(!sw1.isClosed() && !sw2.isClosed() ) 
         {
            System.out.println("Stop");
            message = "s 0 0";
            sendcommand = 0;   
            flagsw1 = false;
            flagsw2 = false;
         }
         if(sw1.isClosed()){
             System.out.println("flagsw1 "+flagsw1);
             if(!flagsw1)//entered first time
             {
                 System.out.println("Switch S1");
                  moveSpeed = 0.15;
                  sendcommand = 1;
                  message = "b -1 0.01";//move forward(only direction)
             }
             
             else if(flagsw1)
             {
                if(accelRawY ==0.0) //move forward
                {
                    setwl = 20; setwr = 20;
                    sendcommand = 2;
                    message = "w " + setwl + " " + setwr;
                    System.out.println("Move forward");
                }
                else if(accelRawY > 0.15)
                {
                    setwl = 20; setwr = 11;//move right
                    sendcommand = 3;
                    message = "w " + setwl + " " + setwr;
                    System.out.println("Move forward and right");
                }
                else if(accelRawY < -0.15)
                {
                    setwl = 11; setwr = 20;//move left
                    sendcommand = 4;
                    message = "w " + setwl + " " + setwr;
                    System.out.println("Move forward and left");
                }
             }
             flagsw1=true;
             

         }
         else if(sw2.isClosed())
         {
             System.out.println("flagsw2" +flagsw2);
             if(!flagsw2)//entered first time
             {    
                  System.out.println("Switch S2 closed");
                  moveSpeed = 0.15;
                  sendcommand = 5;
                  message = "f -1 0.01";//move reverse(direction only)
             }
             
             else if(flagsw2)
             {
                if(accelRawY ==0.0) //move reverse
                {
                    setwl = 20; setwr = 20;
                    sendcommand = 2;
                    message = "w " + setwl + " " + setwr;
                    System.out.println("Reverse");
                }
                else if(accelRawY > 0.15)
                {
                    setwl = 20; setwr = 11;//move right
                    sendcommand = 3;
                    message = "w " + setwl + " " + setwr;
                    System.out.println("Reverse and right");
                }
                else if(accelRawY < -0.15)
                {
                    setwl = 11; setwr = 20;//move left
                    sendcommand = 4;
                    message = "w " + setwl + " " + setwr;
                    System.out.println("Reverse and left");
                }
             }
             flagsw2=true;
             

         }
         
         System.out.println("ACC in Xaxis"+accelRawX);
         System.out.println("ACC in Yaxis"+accelRawY);
        
     } 
     
     public String getData(){         
         
         return message;
     }
}
