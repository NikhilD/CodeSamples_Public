/*
 * EstComm.java
 *
 * Created on February 26, 2008, 4:04 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.sunspotworld.demo;

import java.io.IOException; 
import com.sun.spot.peripheral.ChannelBusyException;
import com.sun.spot.peripheral.NoAckException;
import com.sun.spot.peripheral.TimeoutException;
import com.sun.spot.peripheral.*;
import com.sun.spot.peripheral.radio.*;
import com.sun.spot.io.j2me.radio.*;
import com.sun.spot.io.j2me.radiogram.*;
import com.sun.spot.util.IEEEAddress;

import com.sun.spot.peripheral.Spot;
import com.sun.spot.sensorboard.EDemoBoard;
import com.sun.spot.sensorboard.peripheral.ITriColorLED;
import com.sun.spot.peripheral.radio.IRadioPolicyManager;
import com.sun.spot.util.*;
import com.sun.spot.util.Utils;

import java.io.*;
import javax.microedition.io.*;
import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;

import com.sun.spot.peripheral.Spot;
//import com.sun.spot.sensorboard.EDemoBoard;
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
import com.sun.spot.peripheral.IAT91_TC;

/**
 *
 * @author Nikhil
 */
public class EstComm {
    
    public static final byte LOCATE_DISPLAY_SERVER_REQ  = 1;    // sent to display host (broadcast)
    public static final byte DISPLAY_SERVER_AVAIL_REPLY = 11;
    
    public static String BROADCAST_PORT = "42";
    public static int PORT = 100;
    public static String BROADCAST_PORT1 = "42";
    public static int PORT1 = 100;
    public static String BROADCAST_PORT2 = "45";
    public static int PORT2 = 110;
    public static String BROADCAST_PORT3 = "48";
    public static int PORT3 = 120;
    public static String BROADCAST_ACCEL = "48";
    public static int PORT_ACCEL = 120;
    public static String SPOT_ID = "0014.4F01.0000.049F";            //the Spot's IEEE address  
    public static String SPOT_ID1 = "0014.4F01.0000.049F";            //the Spot's IEEE address  
    public static String SPOT_ID2 = "0014.4F01.0000.06F0";            //the Spot's IEEE address  
    public static String SPOT_ID3 = "0014.4F01.0000.0499";            //the Spot's IEEE address  
    public static String ACCEL_SPOT = "0014.4F01.0000.0498";            //the Spot's IEEE address  
    public boolean execute;
        
    private RadiogramConnection conn = null;
    private Radiogram xdg = null;
    
    /** Creates a new instance of EstComm */
    public EstComm() {
    }
    
    /******************************************************************
    /*This method sets the SPOT_ID, the broadcast port and comm 
     * port for the latest SPOT to be used for communication
    / It is called from SunSpotHostApplication upon receiving a connect command.
     *
    / Input: ID, Broadcast port, Comm Port
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void newID(String ID, String BROADCAST, String PORT_NUM){
        SPOT_ID = ID;
        BROADCAST_PORT = BROADCAST;
        PORT = Integer.parseInt(PORT_NUM);
    }
    
    /******************************************************************
    /*This method sets the Three SPOT_IDs, their broadcast ports and comm 
     * ports
    / It is called from SunSpotHostApplication upon receiving a setID command.
     *
    / Input: ID, Broadcast port, Comm Port for three different SunSPOTs
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void setID(String args[]){
        SPOT_ID1 = args[1];
        BROADCAST_PORT1 = args[2];
        PORT1 = Integer.parseInt(args[3]);
        
        SPOT_ID2 = args[4];
        BROADCAST_PORT2 = args[5];
        PORT2 = Integer.parseInt(args[6]);
        
        SPOT_ID3 = args[7];
        BROADCAST_PORT3 = args[8];
        PORT3 = Integer.parseInt(args[9]);
    }
    
    /******************************************************************
    /*This method initiates wait for Spot routine for the Base-station
    / It is called from SunSpotHostApplication immediately upon receiving 
     * the 'connect trispot' command.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public boolean waitForSpot (String ID, String BROADCAST) {
        boolean result = false;
        RadiogramConnection rcvConn = null;
        DatagramConnection txConn = null;
        execute = true;
        try {
            rcvConn = (RadiogramConnection)Connector.open("radiogram://:" + BROADCAST);
            rcvConn.setTimeout(20000);             // timeout in 20 seconds
            Datagram dg = rcvConn.newDatagram(rcvConn.getMaximumLength());            
            while (execute) {
                try {
                    dg.reset();
                    rcvConn.receive(dg);            // wait until we receive a request
                    if (dg.readByte() == LOCATE_DISPLAY_SERVER_REQ) {       // type of packet
                        String addr = dg.getAddress();
                        IEEEAddress ieeeAddr = new IEEEAddress(addr);
                        long macAddress = ieeeAddr.asLong();
                        System.out.println("Received request from: " + ieeeAddr.asDottedHex());
                        String spotAddr = "" + ieeeAddr.asDottedHex();
                        if(spotAddr.equals(ID)){ // check if received spot message is from desired SPOT.
                            Datagram xdg = rcvConn.newDatagram(rcvConn.getMaximumLength());                                
                            dg.reset();
                            xdg.reset();
                            xdg.setAddress(dg);
                            xdg.writeByte(DISPLAY_SERVER_AVAIL_REPLY);        // packet type
                            xdg.writeLong(macAddress);                        // requestor's ID
                            rcvConn.send(xdg);
                            result = true;
                            execute = false;
                            break;
                        }
                    }
                } catch (TimeoutException ex) {
                    System.out.println("Error waiting for remote Spot");
                }
            }
        } catch (Exception ex) {
            System.out.println("Error waiting for remote Spot: " + ex.toString());
            result = false;
            ex.printStackTrace();
        } finally {
            try {
                if (rcvConn != null) { 
                    rcvConn.close();
                }
                if (txConn != null) { 
                    txConn.close();
                }
            } catch (IOException ex) { /* ignore */ }
        }
        return result;
    }
}
