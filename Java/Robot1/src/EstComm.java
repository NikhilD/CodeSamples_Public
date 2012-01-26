/*
 * EstComm.java
 *
 * Created on February 26, 2008, 3:07 PM
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
import com.sun.spot.peripheral.*;
import com.sun.spot.util.Utils;
import java.io.IOException;
import com.sun.spot.peripheral.ChannelBusyException;
import com.sun.spot.peripheral.NoAckException;
import com.sun.spot.peripheral.TimeoutException;
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

import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;

/**
 *
 * @author Nikhil
 */
public class EstComm {
    
    ExecuteSend executeSend;    
    
    public static final byte LOCATE_DISPLAY_SERVER_REQ  = 1;    // sent to display host (broadcast)
    public static final byte DISPLAY_SERVER_AVAIL_REPLY = 11;
    
    public long ourMacAddress;
    
    public static String BASE_ID = "0014.4F01.0000.0CDF";
    String BROADCAST_PORT = "42";
    public int PORT = 100;
   
    private Random random;
    
    /** Creates a new instance of EstComm */
    public EstComm() {
    }
    
    /******************************************************************
    /*This method initiates 'Base Discovery' routine for the TriSpot
    / It is called from StartApplication immediately upon reset.
     *
    / Input: null (uses global variables)
     *
    / Output: null (sets global variables)
     ******************************************************************/
    public void InitiateComm()throws IOException{
        
        ITriColorLED leds[] = EDemoBoard.getInstance().getLEDs();   
        ourMacAddress = new IEEEAddress(System.getProperty("IEEE_ADDRESS")).asLong();
        random = new Random(ourMacAddress);
        boolean connected = false;
        
        DatagramConnection txConn = null;
        RadiogramConnection rcvConn = null;
        
        leds[0].setRGB(50,0,0);     // Red = not active
        leds[0].setOn();
        txConn = (DatagramConnection)Connector.open("radiogram://broadcast:" + BROADCAST_PORT);
        Datagram xdg = txConn.newDatagram(txConn.getMaximumLength()); 
        rcvConn = (RadiogramConnection)Connector.open("radiogram://:" + BROADCAST_PORT);
        rcvConn.setTimeout(300);             // timeout in 300 msec
        Radiogram rdg = (Radiogram)rcvConn.newDatagram(rcvConn.getMaximumLength());

        while (true) {   // loop to locate a remote print server
            int tries = 0;
            boolean found = false;
            leds[1].setRGB(60,40,0);     // Yellow = looking for display server
            leds[1].setOn();
            do {
                found = locateDisplayServer(txConn, xdg, rcvConn, rdg);
                Utils.sleep(20);         // wait 20 msecs
                ++tries;
            } while (!found && tries < 5);
            leds[1].setOff();  // led off for server found!
            if (found) {
                connected = true;
                break;
            } else {
                Utils.sleep(5000);  // wait a while before looking again, 5 secs
            }
            System.out.println("still looking...");
        }
        System.out.println("done...");
        leds[0].setRGB(0,50,0);     // Green = active...found Base!
        if(connected){
            try {
                if (rcvConn != null) { 
                    rcvConn.close();
                }
                if (txConn != null) { 
                    txConn.close();
                }
            } catch (IOException ex) { /* ignore */ }
        }        
    }
    
    private boolean locateDisplayServer (DatagramConnection txConn, Datagram xdg,
                                         RadiogramConnection rcvConn, Datagram rdg) {
        String serverAddress = ""; 
        boolean result = false;                
        try {
            xdg.reset();
            xdg.writeByte(LOCATE_DISPLAY_SERVER_REQ);        // packet type
            int retry = 0;
            while (retry < 5) {
                try {
                    txConn.send(xdg);               // broadcast remote print request
                    break;
                } catch (ChannelBusyException ex) {
                    retry++;
                    Utils.sleep(random.nextInt(10) + 2);  // wait a random amount before retrying
                }
            }
            try {
                while (true) {                      // loop until we either get a good reply or timeout
                    rdg.reset();
                    rcvConn.receive(rdg);           // wait until we receive a request
                    if (rdg.readByte() == DISPLAY_SERVER_AVAIL_REPLY) { // type of packet
                        long replyAddress = rdg.readLong();
                        if (replyAddress == ourMacAddress) {
                            String addr = rdg.getAddress();
                            IEEEAddress ieeeAddr = new IEEEAddress(addr);                            
                            serverAddress = "" + ieeeAddr.asDottedHex();
                            if(serverAddress.equals(BASE_ID)){result = true;}
                        }
                    }
                }
            } catch (TimeoutException ex) { /* ignore - just return false */ }
        } catch (IOException ex)  { /* also ignore - just return false */ }

        return result;
    }
    
}
