/*
 * Control_Sense.java
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
public class Control_Sense {
    public static final byte TURN = 2;
    public static final byte FORWARD = 3;
    public static final byte REVERSE = 4;
    public static final byte RIGHT = 5;
    public static final byte LEFT = 6;
    public static final byte STOP = 7;
    public static final byte END_COMM = 8;
    
    IAccelerometer3D acc = EDemoBoard.getInstance().getAccelerometer();
    public static int oldleftcount=0, oldrightcount=0, temp = 0, oldlpulse = 0, oldrpulse = 0;
    public static double lefttravel = 0, righttravel = 0, pulseperm = 1002.55; //pulses per meter
    public static double T1, leftAngularV = 0, rightAngularV = 0, piby90 = 0.03490658, kp = 3.0, kd = 0.3;
    public static double p = 0.028575, W = 0.112, thetaV = 0, linearV = 0, theta = 0, wL = 0, wR = 0, xDot = 0;
    public double degConvFactor = 3.14159*W/720;
    public static double yDot = 0, x = 0, y = 0, xDotPrev = 0, yDotPrev = 0, xAccelEnc = 0, yAccelEnc = 0;
    public static double leftvelocity = 0, rightvelocity = 0, oldleftvelocity = 0, oldrightvelocity = 0;
    public static double leftEncoderAccel = 0, rightEncoderAccel = 0;
    public static double setLeftPosition = 0, setRightPosition = 0;
    public static int setVelocity = 1;
    public static int lpulse = 0, rpulse = 0, wheelCircum = 18;
    public static int leftPWM = 100, rightPWM = 100;
    public static byte DirCmd;
    public EDemoBoard demoBoard = EDemoBoard.getInstance();    
    //public IOutputPin motorEnable = (IOutputPin)demoBoard.bindOutputPin(EDemoBoard.D4);  //our robot
    public IOutputPin motorEnable = (IOutputPin)demoBoard.bindOutputPin(EDemoBoard.D3);   //xiaofeng
    public IOutputPin leftPulse = (IOutputPin)demoBoard.bindOutputPin(EDemoBoard.D0);
    public IOutputPin rightPulse = (IOutputPin)demoBoard.bindOutputPin(EDemoBoard.D3);
    
    IAT91_TC timer1 = Spot.getInstance().getAT91_TC(1);
    public String message;
    public static int leftTurnFactor = 0;
    public static int rightTurnFactor = 0;
    public static int leftSetVelocity = 0;
    public static int rightSetVelocity = 0;
    public static double setwr = 0.0;
    public static double setwl = 0.0;
    public byte UART_send = 50;
    public static byte getLeft = 50;
    public static byte getRight = 51;
    public static byte resetPIC = 49;
    public static int resultL =0;
    public static int UARTdataL = 0;
    public static int delta_dataL = 0;
    public static int pre_UARTdataL = 0;
    public static int resultR =0;
    public static int UARTdataR = 0;
    public static int delta_dataR = 0;
    public static int pre_delta_dataR = 0;
    public static int pre_delta_dataL = 0;
    public static int delta_diffR=0;
    public static int delta_diffRL=0;
    public static int pre_UARTdataR = 0;
    //accelerometer variables
    public double ax = 0.0, ay = 0.0, az = 0.0, accelRawX = 0.0, accelRawY = 0.0, accelRawZ = 0.0;
    public static double pi = 3.14159;
    
    ExecuteSend executeSend;
    EstComm estComm;
    
    /**
     * Creates a new instance of Control_Sense
     */
    public Control_Sense() {        
    }
    
    /******************************************************************
    /*This method sets the Left & Right wheel Velocity for the TriSpot
    / It is called from ExecuteSend on receiving a new turn command
     *
    / Input: left wheel velocity, right wheel velocity (cm/s)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void setSpeeds(int left, int right){
        leftSetVelocity = left;
        rightSetVelocity = right;
        System.out.println("***************************************new set velocities: " + leftSetVelocity + " " + rightSetVelocity);
    }
    
     /******************************************************************
    /*This method sets the Direction, Position and Velocity for the TriSpot
    / It is called from ExecuteSend on receiving a new direction command
     *
    / Input: Dir, Pos (Distance to be travelled), Vel
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void setDirPosVel(byte Dir, double DistCmd, double VelCmd){
         
        DirCmd = Dir;
         setVelocity = (int)(100*VelCmd);
         //setVelocity = VelCmd;
         leftSetVelocity = setVelocity;
         rightSetVelocity = setVelocity;
         //System.out.println("Setvelo: " + setVelocity + " velcmd " + VelCmd);
         if(DistCmd < 0){setLeftPosition = 100000;setRightPosition = 100000;}
         else {
             DistCmd = (int)(100*DistCmd); //convert distance from meters to centimeters
             if(DirCmd == FORWARD || DirCmd == REVERSE){setLeftPosition = DistCmd;setRightPosition = DistCmd;}
             if(DirCmd == RIGHT){setLeftPosition = (degConvFactor * DistCmd); setRightPosition = (degConvFactor * DistCmd);}
             if(DirCmd == LEFT){setLeftPosition = (degConvFactor * DistCmd); setRightPosition = (degConvFactor * DistCmd);}     
         }
    }
    
    /******************************************************************
    /*This method sets the Left & Right pulse widths for the TriSpot
    / It is called from ExecuteSend 
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void setPWM(){
        //System.out.println("setvel: " + setVelocity);
        //System.out.println("leftvelo: " + leftvelocity + " rightvelo: " + rightvelocity + " leftset: " + leftSetVelocity + " rightset: " + rightSetVelocity);
        if(leftPWM < 0) leftPWM = (-1)*(leftPWM);
        if(rightPWM < 0) rightPWM = (-1)*(rightPWM);
        leftPWM += (int)(leftSetVelocity - leftvelocity)*kp;
        leftPWM += (int)((oldleftvelocity - leftvelocity)/T1)*kd;
        System.out.println("leftPWM " + leftPWM);
        if(leftPWM > 255) leftPWM = 255;
        rightPWM += (int)(rightSetVelocity - rightvelocity)*kp;
        rightPWM += (int)((oldrightvelocity - rightvelocity)/T1)*kd;
        System.out.println("                    rightPWM " + rightPWM);
        if(rightPWM > 255) rightPWM = 255; 

        //Xiaofeng
        if(DirCmd == LEFT) {rightPWM = (-1)*rightPWM;}
        if(DirCmd == RIGHT) {leftPWM = (-1)*leftPWM;}
        if(DirCmd == FORWARD) {leftPWM = (-1)*leftPWM; rightPWM = (-1)*rightPWM;}
    }    
     //   Xiaofeng moveWheel
    /******************************************************************
    /*This method sets the pulse widths to the output pinson the SunSpot
    / It is called from ExecuteSend after the setPWM method
     *
    / Input: leftPWM and rightPWM
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void moveWheel(int pulseWidth1, int pulseWidth2 ) {
        //System.out.println(pulseWidth1 + "---" + pulseWidth2);
        if(pulseWidth1 >= 0) demoBoard.setPWM(EDemoBoard.H0,pulseWidth1);
        else demoBoard.setPWM(EDemoBoard.H0,1);
        if(pulseWidth1 < 0) demoBoard.setPWM(EDemoBoard.H1,pulseWidth1*(-1));
        else demoBoard.setPWM(EDemoBoard.H1,1);
        if(pulseWidth2 >= 0) demoBoard.setPWM(EDemoBoard.H2,pulseWidth2);
        else demoBoard.setPWM(EDemoBoard.H2,1);
        if(pulseWidth2 < 0) demoBoard.setPWM(EDemoBoard.H3,pulseWidth2*(-1));
        else demoBoard.setPWM(EDemoBoard.H3,1);
        
    }

    /******************************************************************
    /*This method issues the command to stop the TriSpot motion
    / It is called from ExecuteSend after the TriSpot has traversed its 
     * required distance or from StartApplication after receiving a 
     * Stop command
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void cmdFinish(){
        
        leftPWM = 0;
        rightPWM = 0;
        moveWheel(leftPWM, rightPWM);
        motorEnable.setLow();
        initVariables();
    }
    
    /******************************************************************
    /*This method sets the feedback parameters for the TriSpot
    / It is called from ExecuteSend after the motion commands have been
     * issued
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void getEncValues(){
        
        //if(lpulse > 1 && lpulse < 101) lpulse = oldlpulse;
        //if(lpulse > 0) wL = (double)((0.915*17453)/lpulse);  //deg/uSec
        if(lpulse > 0) wL = (double)(lpulse)*(pi/90)/T1;  //rad/s
        else wL = 0;
        //System.out.println("oldlpulse: " + lpulse+" newlpulse: " + (double)(lpulse)*(pi/90)/T1);
        
        //if(rpulse > 1 && rpulse < 101) rpulse = oldrpulse;
        //if(rpulse > 0) wR = (double)((0.89*17453)/rpulse);
        if(rpulse > 0) wR = (double)(rpulse)*(pi/90)/T1;
        else wR = 0;
        //System.out.println("oldrpulse: "+rpulse+"newrpulse: " + (double)(rpulse)*(pi/90)/T1);
        if(DirCmd == FORWARD){
            wL = wL * (-1);
            wR = wR * (-1);
        }
        if(DirCmd == RIGHT) wR = wR*(-1);
        if(DirCmd == LEFT) wL = wL*(-1);
        
        linearV = (double)(p/2)*(wL + wR);
        thetaV = (double)(p/W)*(wR - wL);
        setwr = ((linearV/p) + ((W*thetaV)/(2*p)));
        setwl = ((linearV/p) - ((W*thetaV)/(2*p)));
        //System.out.println("wr: " +wR+ " wl: "+wL+ "thetaV: " + thetaV + " linearV: " + linearV + " wr: " + setwr + " wl: " + setwl);
        theta += (double)thetaV*T1;
        xDotPrev = xDot;
        xDot = linearV*(Math.cos(theta));
        yDotPrev = yDot;
        yDot = linearV*(Math.sin(theta));
        xAccelEnc = (xDot - xDotPrev)/T1;
        yAccelEnc = (yDot - yDotPrev)/T1;
        x += xDot*T1;
        y += yDot*T1;
        
        thetaV = (int)(thetaV*1000);thetaV = (double)(thetaV/1000);
        
        x = (int)(x*1000);x = (double)(x/1000);
        y = (int)(y*1000);y = (double)(y/1000);
        

        xDot = (int)(xDot*1000);xDot = (double)(xDot/1000);
        yDot = (int)(yDot*1000);yDot = (double)(yDot/1000);

        xAccelEnc=(int)(xAccelEnc*1000);xAccelEnc=(double)(xAccelEnc/1000);
        yAccelEnc=(int)(yAccelEnc*1000);yAccelEnc=(double)(yAccelEnc/1000);

        T1=(int)(T1*100000);T1=(double)(T1/100000);
    }
    
    /******************************************************************
    /*This method sets the Left & Right wheel travel for the TriSpot
    / It is called from ExecuteSend for determing the distance travelled 
     * by the TriSpot.
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
     public void getEncTravel(){
         
         T1 = ((double)(timer1.counter()*30.5176))/1000000;
         timer1.enableAndReset();
         oldlpulse = lpulse;
         oldrpulse = rpulse;          
         encoder_reading();
         
         oldleftvelocity = leftvelocity;
         leftvelocity = (((((double)lpulse)*(piby90*p))/T1)*100);                     
         leftEncoderAccel = (leftvelocity - oldleftvelocity)/T1;
         lefttravel += (double)((leftvelocity + oldleftvelocity)*T1/2);
         
         oldrightvelocity = rightvelocity;         
         rightvelocity = (((((double)rpulse)*(piby90*p))/T1)*100);
         rightEncoderAccel = (rightvelocity - oldrightvelocity)/T1;
         righttravel += (double)((rightvelocity + oldrightvelocity)*T1/2);
         
     }
     
      /******************************************************************
    /*This method sets the Left & Right wheel travel for the TriSpot
    / It is called from getEncTravel() for determing the wheel velocities
     * from the encoder readings.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
     public void encoder_reading() {
         UART_send = 50;
         demoBoard.sendUART(UART_send);
         Utils.sleep(5);
         try {UARTdataL = demoBoard.receiveUART();}
         catch (IOException ex){};
         if(UARTdataL < pre_UARTdataL) delta_dataL = UARTdataL + 256 - pre_UARTdataL; 
         else delta_dataL = UARTdataL - pre_UARTdataL; 
         pre_UARTdataL = UARTdataL;
         lpulse = delta_dataL;
         UART_send = 51;
         demoBoard.sendUART(UART_send);
         Utils.sleep(5);
         try {UARTdataR = demoBoard.receiveUART();}
         catch (IOException ex){};
         if(UARTdataR < pre_UARTdataR) delta_dataR = UARTdataR + 256 - pre_UARTdataR; 
         else delta_dataR = UARTdataR - pre_UARTdataR; 
         pre_UARTdataR = UARTdataR;
         rpulse = delta_dataR;
     }
    
      /******************************************************************
    /*This method exists in order to reset the encoder data coming from 
      * the PIC
    / It is rarely used and is put in for flexibility.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void resetPIC(){
        UART_send = 49;
        demoBoard.sendUART(UART_send);
    }
    
     /******************************************************************
    /*This method resets all the used parameters for the TriSpot
    / It is called from cmdFinish() or from StartApplication when it 
     * receives a Disconnect (END_COMM) command.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void initVariables(){
         
         timer1.configure(TimerCounterBits.TC_CAPT | TimerCounterBits.TC_CLKS_SLCK);
         timer1.enableAndReset();
         leftPWM = 40;
         rightPWM = 40;
         lefttravel = 0;
         righttravel = 0;
         theta = 0;
         lpulse = 0;
         rpulse = 0;
         oldleftvelocity = 0;
         leftvelocity = 0;
         oldrightvelocity = 0;
         rightvelocity = 0;
         leftEncoderAccel = 0;
         rightEncoderAccel = 0;
         leftSetVelocity = 0;
         rightSetVelocity = 0;
     }
    
    /******************************************************************
    /*This method sets the feedback parameters for the TriSpot using 
     * the Accelerometer
    / It is called from ExecuteSend after the motion commands have been
     * issued
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/          
     public void getAccel(){
    
         try {
             accelRawX = acc.getAccelX();
             accelRawY = acc.getAccelY();
             accelRawZ = acc.getAccelZ();
         } 
         catch (IOException ex) { //A problem in reading the sensors.
                ex.printStackTrace();
         }
         ax=accelRawX*9.80665; ay=accelRawY*9.80665; az=accelRawZ*9.80665;
         
         accelRawX = (int)(accelRawX*1000);accelRawX = (double)(accelRawX/1000);
         accelRawY = (int)(accelRawY*1000);accelRawY = (double)(accelRawY/1000);
         accelRawZ = (int)(accelRawZ*1000);accelRawZ = (double)(accelRawZ/1000);

         ax = (int)(ax*1000);ax = (double)(ax/1000);
         ay = (int)(ay*1000);ay = (double)(ay/1000);
         az = (int)(az*1000);az = (double)(az/1000);
     } 
    
      /******************************************************************
    /*This method forms the feedback message of the TriSpot to be conveyed 
      * to the Base-station
    / It is called from ExecuteSend before transmitting data back to the 
     * base.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
     public String getData(){
         
         message = T1+" "+ax+" "+ay+" "+lpulse+" "+rpulse+" "+xDot+" "+yDot+" "+x+" "+y+" "+xAccelEnc+" "+yAccelEnc + " "+thetaV;
         return message;
     }
}
