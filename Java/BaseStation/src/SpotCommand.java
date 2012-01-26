/*
 * SpotCommand.java
 *
 * Created on March 20, 2008, 4:02 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.sunspotworld.demo;

import java.io.IOException; 
import org.sunspotworld.demo.utilities.RadioDataIOStream;   //handles the data packets
/**
 *
 * @author Nikhil
 */
public class SpotCommand {
    public static final byte PID = 1;
    public static final byte TURN = 2;
    public static final byte FORWARD = 3;
    public static final byte REVERSE = 4;
    public static final byte RIGHT = 5;
    public static final byte LEFT = 6;
    public static final byte STOP = 7;
    public static final byte END_COMM = 8;
    
    public static byte DirCmd = REVERSE;
    
    boolean thread_run;
    public RadioDataIOStream Stream_ID1, Stream_ID2, Stream_ID3, Stream_Accel;
    public RadioDataIOStream OStream;
    EstComm estComm;
    RcvData Rcv = new RcvData();
    RcvData_AccelSpot rcvAccel = new RcvData_AccelSpot();
    RcvData_TS2 Rcv_TS2 = new RcvData_TS2();
    /** Creates a new instance of SpotCommand */
    public SpotCommand() {
    }
    
    /******************************************************************
    /*This method opens three separate Output radioStreams to the TriSpots
    / It is called from SunSpotHostApplication after the communication link 
     * has been established with the specified TriSpot.
     *
    / Input: ID and Comm Port for the desired TriSpot
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void OpenRadioStream(String ID, int PORT){
        System.out.println("" + PORT);
        if(ID.equals(estComm.SPOT_ID1)){            
            Stream_ID1  = RadioDataIOStream.openOutput(ID, PORT);            
            Rcv.reqStart(ID, PORT);
            new Thread(Rcv).start(); 
        }
        if(ID.equals(estComm.SPOT_ID2)){
            Stream_ID2  = RadioDataIOStream.openOutput(ID, PORT);            
            Rcv_TS2.reqStart(ID, PORT);
            new Thread(Rcv_TS2).start(); 
        }
        if(ID.equals(estComm.SPOT_ID3)){
            Stream_ID3  = RadioDataIOStream.openOutput(ID, PORT);     
        }
        if(ID.equals(estComm.ACCEL_SPOT)){
            Stream_Accel  = RadioDataIOStream.openOutput(ID, PORT);            
            rcvAccel.reqStart(ID, PORT);
            new Thread(rcvAccel).start(); 
        }
    }
    
    /******************************************************************
    /*This method closes the three separate Output radioStreams to the TriSpots
    / It is called from SunSpotHostApplication when the Base receives the 
     * 'Disconnect triSpot' command.
     *
    / Input: ID for the desired TriSpot
     *
    / Output: null (sets global variables)
     ******************************************************************/    
    public void CloseRadioStream(String ID){
        
        if(ID.equals(estComm.SPOT_ID1)){            
            //Stream_ID1.OutputClose();
            Rcv.reqStop(); 
        }
        if(ID.equals(estComm.SPOT_ID2)){
            //Stream_ID2.OutputClose();
            Rcv_TS2.reqStop(); 
        }
        if(ID.equals(estComm.SPOT_ID3)){
            //Stream_ID3.OutputClose();            
        }
        if(ID.equals(estComm.ACCEL_SPOT)){
            //Stream_ID3.OutputClose();
            rcvAccel.reqStop(); 
        }        
    }
    
    
    /******************************************************************
    /*This method sends the commands in the desired format to the TriSpots
    / It is called from SunSpotHostApplication (with the 'spotcommand' command)
     * , or from the Path Tracking program.
     *
    / Input: ID, command string array and index in the array where the command begins
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void SendSpot(String ID, String args[], int i){ 
            //System.out.println("ok sending it...");
            if(ID.equals(estComm.SPOT_ID1)){OStream = Stream_ID1;System.out.println("Stream1: "+OStream);}
            else if(ID.equals(estComm.SPOT_ID2)){OStream = Stream_ID2;System.out.println("Stream2: "+OStream);}
            else if(ID.equals(estComm.SPOT_ID3)){OStream = Stream_ID3;}
            else if(ID.equals(estComm.ACCEL_SPOT)){OStream = Stream_Accel;}  
            
            if(args[i].equalsIgnoreCase("p")){
                try{                    
                    OStream.writeUTF(PID+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("PID Sent...");                    
                }
                catch(IOException ex){}
            }
            if(args[i].equalsIgnoreCase("w")){
                try{                    
                    OStream.writeUTF(TURN+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    //System.out.println("turn Sent...");                    
                }
                catch(IOException ex){}
            }
                                                            
            if(args[i].equalsIgnoreCase("f")){
                try{                    
                    OStream.writeUTF(REVERSE+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("forward Sent...");  
                    DirCmd = REVERSE;
                }
                catch(IOException ex){}
            }
            if(args[i].equalsIgnoreCase("b")){
                try{                    
                    OStream.writeUTF(FORWARD+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("reverse Sent...");   
                    DirCmd = FORWARD;
                }
                catch(IOException ex){}
            }
            if(args[i].equalsIgnoreCase("r")){
                try{                    
                    OStream.writeUTF(LEFT+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("right Sent..."); 
                    DirCmd = LEFT;
                }
                catch(IOException ex){}
            }
            if(args[i].equalsIgnoreCase("l")){
                try{                    
                    OStream.writeUTF(RIGHT+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("left Sent...");  
                    DirCmd = RIGHT;
                }
                catch(IOException ex){}
            }
            if(args[i].equalsIgnoreCase("s")){
                try{                    
                    OStream.writeUTF(STOP+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("Stop Sent...");           
                }
                catch(IOException ex){}
            }
            if(args[i].equalsIgnoreCase("e")){
                try{                    
                    OStream.writeUTF(END_COMM+" "+args[i+1]+" "+args[i+2]);
                    OStream.flush();
                    System.out.println("end Sent...");                    
                    OStream.OutputClose();
                    CloseRadioStream(ID);
                }
                catch(IOException ex){}
            }                    
    }
}
