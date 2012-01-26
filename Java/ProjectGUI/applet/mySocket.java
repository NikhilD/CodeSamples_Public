/*
 * mySocket.java
 *
 * This socket class is used for ECE 756 group 3 TriSPOT project
 *
 * This can be used to actively connect to an existing TCP socket server 
 *  OR it can wait for a TCP connection
 * It can also create a UDP 'connection' at the same time as a TCP connection
 *
 * The public UDPCommands flag is used to set the protocol used
 * in the genSend and genRead methods
 */

package my.gui.applet;

import java.io.*;
import java.net.Socket;
import java.net.*;
import java.net.InetAddress;
import java.net.InetAddress.*;
import java.net.DatagramSocket;
import java.net.DatagramPacket;

/**
 *
 * @author Bryan Klingenberg
 */
public class mySocket {
    public boolean UDPCommands = false;
    private DataInputStream input;
    private Socket serviceSocket;
    private ServerSocket MyService;
    private PrintStream output;
    private String imageData;
    public DatagramPacket packet = new DatagramPacket(new byte[512],512);
    public DatagramPacket sendPacket = new DatagramPacket(new byte[512],512);
    public DatagramSocket UDPSocket;
    public byte[] b = new byte[512];
    public int remoteUDPPort = 8000;
    public InetAddress remoteAddress;

    
        
/****************************************************************
/   TCP Methods
****************************************************************/   
    //Create a socket on the given port and wait for a remote machine to connect
    //create input and output streams to that remote machine
    //stopped with the stopServer method
    public void waitForClient(int port){

        try {
            MyService = new ServerSocket(port);
            serviceSocket = MyService.accept();
            System.out.println("Connected to: " + (serviceSocket.getInetAddress()).toString() + "::"+serviceSocket.getPort()+ " Using Local Port " + serviceSocket.getLocalPort());
            input = new DataInputStream(serviceSocket.getInputStream());
            output = new PrintStream(serviceSocket.getOutputStream());
        }
        catch (IOException e) {
            System.out.println(e);
        }
            
    }
    
    //Go out and connect to a machine at the given ip address and port
    //create input and output streams for the connection
    //stopped with the stopClient method
    public void connectToServer(String server, int port){

        try {
            //MyService = new Socket(server, port);
            serviceSocket = new Socket(server, port);
            System.out.println("Connected to: " + (serviceSocket.getInetAddress()).toString() + "::"+serviceSocket.getPort()+ " Using Local Port " + serviceSocket.getLocalPort());
            input = new DataInputStream(serviceSocket.getInputStream());
            output = new PrintStream(serviceSocket.getOutputStream());
        }
        catch (IOException e) {
            System.out.println(e);
        }
    }
    
    //Read a line on the input stream
    //this method is blocking
    public String readLine(){
        try {
            return (String)input.readLine();
        }
        catch (IOException e) {
            System.out.println(e);
            return null;
        }
    }

    //Send a string out to the output stream
    public void sendLine(String toSend){
        output.println(toSend);
    }
    
    //Stop the server (used with the waitForClient method)
    public void stopServer(){
         try {
             output.close();
             input.close();
             serviceSocket.close();
             MyService.close();
             System.out.println("Socket Closed");
             } 
        catch (IOException e) {
            System.out.println(e);
        }
    }
    
    //Stop the client (used with the connectToServer method)
    public void stopClient(){
         try {
             output.close();
             input.close();
             serviceSocket.close();
             System.out.println("Socket Closed");
             } 
        catch (IOException e) {
            System.out.println(e);
        }
    }
    
    //Gets the ip address of the remote computer on a TCP socket
    public String remoteAddr(){
        return serviceSocket.getInetAddress().toString();
    }
    
    
    
/****************************************************************
/   UDP Methods
****************************************************************/       
    //Creates a UDP listener on the given local port
    public void createUDPListener(int localport){
        try{
            UDPSocket = new DatagramSocket(localport);
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
    }
    
    //Sets the destination port of the UDP data
    public void setUDPDestPort(int remoteport){
        remoteUDPPort = remoteport;
    }
    
    //Sets the destination address of the UDP data
    public void setUDPDestAddr(String remoteAddr){
        try{
            remoteAddress = InetAddress.getByName(remoteAddr);
        }
        catch (UnknownHostException ex){
            ex.printStackTrace();
        }
    }

    //Sends a string to the destination UDP port and address
    public void sendUDP(String message){
        try{
            sendPacket = new DatagramPacket(message.getBytes(), message.getBytes().length, remoteAddress, remoteUDPPort);
        }
        catch(NullPointerException e){
            System.out.println("could not send this data of UDP: " + message);
        }
        try{
            UDPSocket.send(sendPacket);    
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
    }
    
    //Waits for a UDP message on the local port
    //This method is blocking
    public String readUDP(){
        try{
            UDPSocket.receive(packet);
            return new String(packet.getData(),0,packet.getLength());
        }
        catch(Exception ex){
            ex.printStackTrace();
            return "";
        }
    }
    
    //Closes the UDP socket
    public void closeUDP(){
        UDPSocket.close();
    }
    
    
/****************************************************************
/   General Methods
****************************************************************/       

    //GenSend will send either to TCP or UDP depending on the UDPCommands flag
    public void genSend(String toSend){
        //should maybe check if everyone is connected first...
        if(UDPCommands){
            sendUDP(toSend);
        }
        else{
            sendLine(toSend);
        }
    }
    
    //GenRead will read from either TCP or UDP depending on the UDPCommands flag
    //This method is blocking
    public String genRead(){
        //should maybe check if everyone is connected first...
        if(UDPCommands){
            return readUDP();
        }
        else{
            return readLine();
        }
    }
 
    
}
