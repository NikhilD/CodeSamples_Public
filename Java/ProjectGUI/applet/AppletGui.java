/* 
 * AppletGui.java
 *
 * Created on February 18, 2008, 6:05 PM
 */

package my.gui.applet;

import java.awt.image.BufferedImage;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.*; 
import java.applet.*; 
import java.awt.event.*; 
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container.*;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
//import java.awt.peer.FramePeer;
import java.io.*;
import java.net.*;
import java.net.URL;
import java.awt.Image;
import javax.imageio.*;
import javax.swing.BorderFactory;
import javax.swing.JApplet;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JScrollPane;
import javax.swing.border.EtchedBorder;
import javax.swing.*;
import java.awt.event.*; 
import java.awt.*;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Toolkit;
import javax.swing.table.TableColumn;
import java.awt.BorderLayout;
import java.awt.*;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.JComponent;
import java.awt.*;
import javax.swing.*;
import my.gui.applet.StringTokenizer;
import java.lang.Math;
import java.beans.PropertyVetoException;
import java.util.Arrays;
//Jimmy's change
import java.awt.font.*;
import java.awt.geom.*;
import java.util.zip.DataFormatException;
import java.util.Vector;
// ends of Jimmy's change

/**
 *
 * @author  Nikhil, Jimmy
 */
public class AppletGui extends java.applet.Applet{
   
    public boolean validRobotData = false;
    public boolean validCommand0 = false;
    public boolean validCommand1 = false;
     public int pathPoints = 0;
    public String[] path = new String[512];
    public int historyPathPoints = 0;
    public String[] historyPath = new String[1024];
    public String objectString = "";
    public int points = 0;
    public int TrackCount = 0;
   
    public int[] path_DataX= new int[1500];
    public int[] path_DataY= new int[1500];
    public int[] path_CamX= new int[1500];
    public int[] path_CamY= new int[1500];
    public int pathCamLength = 0;
    //public int[] path_DataPreX= new int[1000];
    //public int[] path_DataPreY= new int[1000];
    public int pathLength = 0;
    public int x_shift=200, y_shift=200;
    public int SAFETY_REGION=15;
        
    public byte RED = 1;
    public byte GREEN = 2;
    public byte BLUE = 3;
    public double pi = 3.14159;
    public String command;
    //public String baseServer = "152.7.206.82";
    
    
    public String baseServer = "152.7.206.28";    
    public String imageServer = "";
    mySocket baseSocket = new mySocket();
    //mySocket baseSocketUDP = new mySocket();
    private int PORT_UDP_SEND = 4005;
    private int PORT_UDP_RECV = 4006;
    private int PORT_NUM_BASE = 5500;
    
   // public String cppServer = "152.14.96.61";
    public int selectedCam = 1;
    private String imageData;

    public String cData;
    public boolean dataSocketConnected;
    public String consoleCommand;
    public String[] ParseIt;
    public TableColumn column;
    public String[] baseData;
    public String objectData;
    public boolean baseDataSocketConnected = false;
    public boolean disconnectBaseDataThread = false;
    public int oldRobotX = 0, oldRobotY = 0, robotX = 0, robotY = 0;
    public double oldRobotO[] = new double[3];
    public String[] robotData;
    public int numberInHistory = 0;
    public boolean robotInit = true;
    boolean firsttime=true;
    private static final int width = 340;
    private static final int height = 320;
    private double XRef = 210.0;
    private double YRef = 160.0;
    private BufferedImage Field = new BufferedImage(width+40, height+30, BufferedImage.TYPE_INT_ARGB);
    //Graphics graphicsView = Field.getGraphics();
    private int drawingSize = 10;
    private int drawingSize2 = 12;
    Font font = new Font("Dialog", Font.PLAIN, 12);
    private double X[] = new double[3];
    private double Y[] = new double[3];
    //camNewX[] are predefined in prepare()
    private int camNewX[] = new int[3];
    private int camNewY[] = new int[3];
    private int cam[] = new int[3];
    public URL url1, url2, url3, url4; 
    public BufferedImage image1, image2, image3, image4;
    public BufferedImage image = new BufferedImage(370, 270, BufferedImage.TYPE_INT_ARGB);
    Graphics graphics = image.getGraphics();
    public BufferedImage imageAll = new BufferedImage(370, 270, BufferedImage.TYPE_INT_ARGB);
    Graphics graphicsAll = imageAll.getGraphics();
    private short cameraImage = 0;
    private boolean gridOn = false;
    private boolean curveGridOn = false;
    final static float dash1[] = {1.0f};
    private static BasicStroke dashed = new BasicStroke(1.0f, 
                                          BasicStroke.CAP_BUTT, 
                                          BasicStroke.JOIN_MITER, 
                                          10.0f, dash1, 0.0f);
    private static BasicStroke dashed1 = new BasicStroke(1.0f, 
                                          BasicStroke.CAP_BUTT, 
                                          BasicStroke.JOIN_MITER, 
                                          10.0f, dash1, 0.0f);
    private static BasicStroke dashed2 = new BasicStroke(1.9f, 
                                          BasicStroke.CAP_BUTT, 
                                          BasicStroke.JOIN_MITER, 
                                          10.0f, dash1, 0.0f);
    final static BasicStroke normalStroke = new BasicStroke(2.0f);
    final static BasicStroke thinStroke = new BasicStroke(1.0f);
    private int destinationX = 0;
    private int destinationY = 0;
    private boolean coordinatesLabel = true;
    private double safetyRegion = 0.15;
    private int PathPlanning = 0;
    
    private int abNetwork = 0;
    private int bcNetwork = 0;
    private boolean toBaseUsingTCP = true;
    private boolean toCPPUsingTCP = true;
    
    private boolean GSMOn = false;
    private String ManualInput = "";
    private String[] obstacles;// = {"5","1", "-72","75",
                                     // "2", "-50","-14",
                                     // "3", "27","-27",
                                     // "2","-46","-123",
                                     // "3","134","60"};
    private String[] obstaclesEX;
    private boolean getCoordinate = false;
    private boolean firstDestination = true;
    private boolean firstPath = true;
    private boolean fvGrid = false;
    private boolean getPath = false;
    private boolean showPlanPath = false;
    private double delay = 0.0;
    private int columnOfDelay = 10;
    private int rowOfCurvature = 20;
    private double maxOfDelay = 5;
    private double maxOfCurvature = 9999;
    private double GSMGain[][] = new double[columnOfDelay][rowOfCurvature];
    double kappa=0.0;
    private double gain = 1;
    private int currentRobot = 1; // 0 is red, 1 is green, 2 is blue
    private boolean RefreshOn = false;
    private int currentCam = 1;
    //private int keysPressed = 0;
    
    public static String BROADCAST_PORT1 = "42";
    public static int PORT1 = 100;
    public static String BROADCAST_PORT2 = "45";
    public static int PORT2 = 110;
    public static String BROADCAST_PORT3 = "48";
    public static int PORT3 = 120;    
    public static String SPOT_ID1 = "0014.4F01.0000.049F";            //the Spot's IEEE address  
    public static String SPOT_ID2 = "0014.4F01.0000.06F0";            //the Spot's IEEE address  
    public static String SPOT_ID3 = "0014.4F01.0000.0499";            //the Spot's IEEE address    
     
    /****Second Thread for running the socket for the image processing****/
    public Thread robotSocketThread= new Thread() {

         public void run() {
           System.out.println("Robot Loop Started");
            pathCamLength = 0;
         }
    };
    
    
    //This thread manages the automatic update functionality
     public Thread camRefreshThread= new Thread() {

         public void run() {
           System.out.println("Cam Refresh Thread Started");
            while(true) {
               if (RefreshOn) {
                   double refreshTime = Double.parseDouble(RefreshRateInputField.getText());
                   realTimeRefreshCamera(cameraImage);
                   try {
                        camRefreshThread.sleep((int)refreshTime);
                    }
                    catch(InterruptedException e){
                        System.out.println(e);
                    } 
               }
               else {
                   try {
                        camRefreshThread.sleep(100);
                    }
                    catch(InterruptedException e){
                        System.out.println(e);
                    }                
               }    
            }    
        
         }
   
    };
    
    
    
    public Thread baseDataThread= new Thread() {

        String objectString="";
         public void run() {
            System.out.println("Thread baseDataThread started...");
            while(true){ 
                if (baseDataSocketConnected){
                      //System.out.println("Inside while loop : baseDataThread");
                    try {
                        baseDataThread.sleep(10);
                    }
                    catch(InterruptedException e){
                        System.out.println(e);
                    }                
                    String baseInfo = "";

                    baseInfo = baseSocket.genRead();//if this returns null the socket has been closed
                    System.out.println(baseInfo);

                    
                    if (baseInfo.length() > 0){
                        baseData = StringTokenizer.parseStringAsArray(baseInfo, " ");                
                        if (baseData[0] == null){
                            System.out.println("NULL received");
                        }else if(baseData[0].equalsIgnoreCase("Exit")){//disconnect and exit the thread    
                            baseSocket.stopClient();
                            baseDataSocketConnected = false;
                            disconnectBaseDataThread = true;                            
                        }
                        else if(baseData[0].equalsIgnoreCase("data")){//Update the table                
                            updateTableBase(baseData);
                        }
                        else if(baseData[0].equalsIgnoreCase("object")){
                            commandHistory.setText(commandHistory.getText() + "\n" + "Object Data: " + baseInfo + "\n" + "--------------\n");
                            getCoordinate = true;
                            System.out.println("Obstacle data received");
                            objectString = baseInfo.substring(6);
                            //showObstacles(objectString);
                            getObstaclesCoordinates(baseInfo.substring(6));
                            getCoordinate = true;
                            //System.out.println("Obstacle data received "+baseInfo.substring(6));
                            DrawFieldView();
                            updateTableObjects(baseInfo.substring(6));

                        }else if(baseData[0].equalsIgnoreCase("robot")){
                            // getting the controlled robot data (only one robot) in a formate of: "robot # x y o"
                            cData = baseInfo.substring(7);
                            robotData = StringTokenizer.parseStringAsArray(cData, " ");
                            try{
                                Y[currentRobot] = Double.parseDouble(robotData[1]);//try reading array to see if its valid
                                validRobotData = true;
                            }
                            catch (NumberFormatException ex){
                                validRobotData = false;
                            }
                            if(validRobotData) {
                                System.out.println("robot data: " + cData);
                                X[currentRobot] = Double.parseDouble(robotData[0]);
                                Y[currentRobot] = Double.parseDouble(robotData[1]);
                                camNewX[currentRobot] = (int)TranslateX(Double.parseDouble(robotData[0]));
                                camNewY[currentRobot] = (int)TranslateY(Double.parseDouble(robotData[1]));
                                if( camNewX[currentRobot]>40 && camNewX[currentRobot]<width+40 && camNewY[currentRobot]>0 && camNewY[currentRobot]<height){
                                    Graphics graphicsView = Field.getGraphics();
                                    graphics.setColor(Color.BLACK);
                                    oldRobotO[currentRobot] = Double.parseDouble(robotData[2]);
                                    path_CamX[pathCamLength] = camNewX[currentRobot];
                                    path_CamY[pathCamLength] = camNewY[currentRobot];
                                    pathCamLength++;
                                    DrawFieldView();
                                    updateTableRobot();
                                }
                            }
                            else System.out.println("robot data was not valid");
                        }else if(baseData[0].equalsIgnoreCase("robots")){
                            //robot data for all trispots in format of "robots robot# x y o robot# x y o robot# x y o..."
                            //the incoming data can have two sets of data for one robot, the getRobotCoordinates function will overwrite the first one
                            cData = baseInfo.substring(6);
                            getRobotCoordinates(cData);
                            updateTableRobot();
                            DrawFieldView();

                        }
                        else if(baseData[0].equalsIgnoreCase("Robot_Selected")){
                            commandHistory.setText(commandHistory.getText() + "Current TriSpot:"+baseData[1]+ "\n");
                            updateTableRobot();
                        }
                        else if(baseData[0].equalsIgnoreCase("path")){
                            System.out.println("path received: " + baseInfo);
                            if(Integer.parseInt(baseData[1]) == 999) pathPoints = 0;
                            else if(Integer.parseInt(baseData[1]) == 997) {
                                //pathLength = pathPoints;
                                //System.out.println("path generated with " + pathLength + " points");
                                commandtoBase("imagecommand g"); //get the path
                            }
                            else if (Integer.parseInt(baseData[1]) == 998){   
                                //
                                pathLength = pathPoints;
                                if(pathLength > 0) {
                                    System.out.println("path generated with " + pathLength + " points");
                                    DrawFieldView();
                                    commandHistory.setText(commandHistory.getText() + "\n" + "Path Generation Successful!");
                                }
                                else commandHistory.setText(commandHistory.getText() + "\n" + "Path Generation Failed!");
                            }
                            else{
                                // getting world frame coordinates for path points 
                                        path_DataX[pathPoints] = (int)Double.parseDouble(baseData[1])-x_shift;
                                        path_DataY[pathPoints] = (int)Double.parseDouble(baseData[2])-y_shift;
                                        System.out.println("wX: "+path_DataX[pathPoints]+" wY: "+path_DataY[pathPoints]);
                                // convert path points to  field view coordinates       
                                        path_DataX[pathPoints]=(TranslateX(path_DataX[pathPoints]));
                                        path_DataY[pathPoints]=(TranslateY(path_DataY[pathPoints]));
                                        System.out.println("X: "+path_DataX[pathPoints]+" Y: "+path_DataY[pathPoints]);
                                        pathPoints++;
                            }
                                    
                            firstPath = false;
                            showPlanPath =  true;
                            //DrawFieldView(); 
                            //UNNATI THE ARRAY OF PATH POINTS IS SAVED HERE
                                    //path[pathPoints] = baseData[1] + " " + baseData[2];
                                    //pathPoints++;
                               
                          
                        }

                        //GSM
                        else if(baseData[0].equalsIgnoreCase("gain")){
                         commandHistory.setText(commandHistory.getText() + "\n" + "Gain =" + Double.parseDouble(baseData[1]));   
                        }
                        else if(baseData[0].equalsIgnoreCase("TCP")){
                         commandHistory.setText(commandHistory.getText() + "\n" + "Going to TCP Mode");   
                         baseSocket.UDPCommands = false;
                        }
                        else if(baseData[0].equalsIgnoreCase("UDP")){
                         commandHistory.setText(commandHistory.getText() + "\n" + "Going to UDP Mode"); 
                         baseSocket.UDPCommands = true;
                        }
                        else {
                         commandHistory.setText(commandHistory.getText() + "\n" + "Base Message: " +baseInfo+ "\n" + "--------------\n");
                        }
                    }

                    SwingUtilities.invokeLater(new Runnable() {
                        public void run() {
                            JScrollBar scrollBar = jScrollPane1.getVerticalScrollBar();
                            scrollBar.setValue(scrollBar.getMaximum());
                        }
                    });
                }
                if (disconnectBaseDataThread){
                    break;
                }
            }
        }
    };
    
    
   
    
    
    
    /** Initializes the applet AppletGui */
    public void init() {
        
             
        try {
            java.awt.EventQueue.invokeAndWait(new Runnable() {
                public void run() {
                    setSize(1035,710);                    
                    prepare();

                    setGSMGainTable();
                    System.out.println("Starting Socket Thread");
                    robotSocketThread.start();
                    camRefreshThread.start();
                    System.out.println("base Thread Started. Initializing Components");
                    System.out.println("Socket Thread Started. Initializing Components");
                    initComponents();
                    drawFieldViewRuler();
                    appletbaseCombo.setEnabled(false);
                    basecppnetwork.setEnabled(false);
                    System.out.println("Components Initialized");
                }
            });
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
     /** Handle the key typed event from the text field. */
    public void keyTyped(KeyEvent evt) {
        System.out.println("Key Code " + (int)evt.getKeyChar());
	if ((int)evt.getKeyChar() == 27) {
            EmergencyStop();
        }
            
    }
     
    
    /** This method is called from within the init() method to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        camLabel = new javax.swing.JLabel();
        CamViewLabel = new javax.swing.JLabel();
        Cam1Button = new javax.swing.JButton();
        Cam2Button = new javax.swing.JButton();
        Cam4Button = new javax.swing.JButton();
        Cam3Button = new javax.swing.JButton();
        allCamButton = new javax.swing.JButton();
        refreshButton = new javax.swing.JButton();
        gridButton = new javax.swing.JButton();
        curveGrid = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        RefreshRateInputField = new javax.swing.JTextField();
        RefreshDelayOn = new javax.swing.JRadioButton();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        SafetyRegionLabel = new javax.swing.JLabel();
        SafetyRegionTextField = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        PathPlanningCombo = new javax.swing.JComboBox();
        GSMLabel = new javax.swing.JLabel();
        GSMCombo = new javax.swing.JComboBox();
        DelayGemLabel = new javax.swing.JLabel();
        DelayGenTextField = new javax.swing.JTextField();
        MoreButton = new javax.swing.JButton();
        appletbaseCombo = new javax.swing.JComboBox();
        jLabel4 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        basecppnetwork = new javax.swing.JComboBox();
        FieldViewPanel = new javax.swing.JPanel();
        FieldViewLabel = new javax.swing.JLabel();
        clearButton = new javax.swing.JButton();
        CoordinateLabelButton = new javax.swing.JButton();
        GridOnOffButton = new javax.swing.JButton();
        GetPathButton = new javax.swing.JButton();
        RobotControlPanel = new javax.swing.JPanel();
        ManualInputWindow = new javax.swing.JInternalFrame();
        ManualInputTextField = new javax.swing.JTextField();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        ManualInputButton = new javax.swing.JButton();
        ControlPanel = new javax.swing.JLabel();
        RunButton = new javax.swing.JButton();
        Trispot0Button = new javax.swing.JButton();
        Trispot2Button = new javax.swing.JButton();
        Trispot1Button = new javax.swing.JButton();
        Trispot3Button = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        commandHistory = new javax.swing.JTextPane();
        commandEntry = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        TablePanel = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        TableData = new javax.swing.JTable();

        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                formMouseClicked(evt);
            }
        });
        addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                formPropertyChange(evt);
            }
        });
        setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("Camera View"));
        jPanel1.setName("Camera View"); // NOI18N

        camLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        camLabel.setText("Camera");

        CamViewLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        CamViewLabel.setVerticalAlignment(javax.swing.SwingConstants.TOP);
        CamViewLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                CamViewLabelMouseClicked(evt);
            }
        });

        Cam1Button.setText("Camera1");
        Cam1Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Cam1ButtonActionPerformed(evt);
            }
        });

        Cam2Button.setText("Camera2");
        Cam2Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Cam2ButtonActionPerformed(evt);
            }
        });

        Cam4Button.setText("Camera4");
        Cam4Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Cam4ButtonActionPerformed(evt);
            }
        });

        Cam3Button.setText("Camera3");
        Cam3Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Cam3ButtonActionPerformed(evt);
            }
        });

        allCamButton.setText("All Cam");
        allCamButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                allCamButtonActionPerformed(evt);
            }
        });

        refreshButton.setText("Refresh");
        refreshButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                refreshButtonActionPerformed(evt);
            }
        });

        gridButton.setText("Grid On/Off");
        gridButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                gridButtonActionPerformed(evt);
            }
        });

        curveGrid.setText("AccurateGrid");
        curveGrid.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                curveGridActionPerformed(evt);
            }
        });

        jLabel1.setText("Image Refresh Time (ms):");

        RefreshRateInputField.setText("1000");

        RefreshDelayOn.setText("Refresh Delay On");
        RefreshDelayOn.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        RefreshDelayOn.setMargin(new java.awt.Insets(0, 0, 0, 0));
        RefreshDelayOn.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                RefreshDelayOnMousePressed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(141, 141, 141)
                        .addComponent(camLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 113, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(CamViewLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 370, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addGap(6, 6, 6)
                                .addComponent(RefreshRateInputField, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(Cam2Button, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(Cam1Button, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(Cam3Button, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(Cam4Button, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(allCamButton, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(refreshButton, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(RefreshDelayOn, javax.swing.GroupLayout.PREFERRED_SIZE, 126, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(gridButton, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(curveGrid, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(camLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(CamViewLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 270, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(16, 16, 16)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(Cam1Button)
                    .addComponent(Cam4Button)
                    .addComponent(allCamButton)
                    .addComponent(gridButton))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(Cam2Button)
                    .addComponent(Cam3Button)
                    .addComponent(refreshButton)
                    .addComponent(curveGrid))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(RefreshRateInputField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(RefreshDelayOn))
                .addContainerGap())
        );

        add(jPanel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(410, 0, 410, 440));

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Parameter Setting"));

        SafetyRegionLabel.setText("Safety Region");

        SafetyRegionTextField.setText("0.15");
        SafetyRegionTextField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SafetyRegionTextFieldActionPerformed(evt);
            }
        });

        jLabel3.setText("Path Planning");

        PathPlanningCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "FM", "OUM", "QPF" }));
        PathPlanningCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                PathPlanningComboActionPerformed(evt);
            }
        });

        GSMLabel.setText("GSM");

        GSMCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "GSM On", "GSM Off" }));
        GSMCombo.setSelectedIndex(1);
        GSMCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                GSMComboActionPerformed(evt);
            }
        });

        DelayGemLabel.setText("Delay Gen");

        DelayGenTextField.setText("0.0");
        DelayGenTextField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                DelayGenTextFieldActionPerformed(evt);
            }
        });

        MoreButton.setText("More");
        MoreButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MoreButtonActionPerformed(evt);
            }
        });

        appletbaseCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "TCP", "UDP" }));
        appletbaseCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                appletbaseComboActionPerformed(evt);
            }
        });

        jLabel4.setText("Applet-Base Network");

        jLabel6.setText("Base-Server Network");

        basecppnetwork.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Hybrid", "TCP", "UDP" }));
        basecppnetwork.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                basecppnetworkActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addComponent(SafetyRegionLabel)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 42, Short.MAX_VALUE)
                        .addComponent(SafetyRegionTextField, javax.swing.GroupLayout.PREFERRED_SIZE, 67, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 63, Short.MAX_VALUE)
                        .addComponent(PathPlanningCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(GSMLabel)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 90, Short.MAX_VALUE)
                        .addComponent(GSMCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(11, 11, 11))
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(11, 11, 11)
                .addComponent(DelayGemLabel)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(DelayGenTextField, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(MoreButton, javax.swing.GroupLayout.DEFAULT_SIZE, 76, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel6)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 19, Short.MAX_VALUE)
                        .addComponent(basecppnetwork, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 31, Short.MAX_VALUE)
                        .addComponent(appletbaseCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(SafetyRegionLabel)
                    .addComponent(SafetyRegionTextField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(PathPlanningCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(GSMLabel)
                    .addComponent(GSMCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel4)
                    .addComponent(appletbaseCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(basecppnetwork, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(DelayGemLabel))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(MoreButton)
                            .addComponent(DelayGenTextField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        add(jPanel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(820, 0, 220, 190));

        FieldViewPanel.setBorder(javax.swing.BorderFactory.createTitledBorder("Field View"));
        FieldViewPanel.setName("Field View"); // NOI18N
        FieldViewPanel.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        FieldViewLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        FieldViewLabel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                FieldViewLabelMouseClicked(evt);
            }
        });
        FieldViewPanel.add(FieldViewLabel, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 20, 390, 350));

        clearButton.setText("Clear");
        clearButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                clearButtonMouseClicked(evt);
            }
        });
        FieldViewPanel.add(clearButton, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 390, 70, -1));

        CoordinateLabelButton.setLabel("Label On/Off");
        CoordinateLabelButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                CoordinateLabelButtonMouseClicked(evt);
            }
        });
        FieldViewPanel.add(CoordinateLabelButton, new org.netbeans.lib.awtextra.AbsoluteConstraints(180, 390, 110, -1));

        GridOnOffButton.setText("Grid On/Off");
        GridOnOffButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                GridOnOffButtonMouseClicked(evt);
            }
        });
        FieldViewPanel.add(GridOnOffButton, new org.netbeans.lib.awtextra.AbsoluteConstraints(80, 390, 100, -1));

        GetPathButton.setText("Get Path");
        GetPathButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                GetPathButtonActionPerformed(evt);
            }
        });
        FieldViewPanel.add(GetPathButton, new org.netbeans.lib.awtextra.AbsoluteConstraints(290, 390, -1, -1));

        add(FieldViewPanel, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 410, 440));

        RobotControlPanel.setBorder(javax.swing.BorderFactory.createTitledBorder("Robot Control\n"));
        RobotControlPanel.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        ManualInputWindow.setClosable(true);
        ManualInputWindow.setTitle("Manual Input");
        ManualInputWindow.setNormalBounds(new java.awt.Rectangle(0, 0, 180, 180));
        ManualInputWindow.setVerifyInputWhenFocusTarget(false);

        ManualInputTextField.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ManualInputTextFieldActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout ManualInputWindowLayout = new javax.swing.GroupLayout(ManualInputWindow.getContentPane());
        ManualInputWindow.getContentPane().setLayout(ManualInputWindowLayout);
        ManualInputWindowLayout.setHorizontalGroup(
            ManualInputWindowLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ManualInputWindowLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(ManualInputTextField, javax.swing.GroupLayout.DEFAULT_SIZE, 184, Short.MAX_VALUE)
                .addContainerGap())
        );
        ManualInputWindowLayout.setVerticalGroup(
            ManualInputWindowLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ManualInputWindowLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(ManualInputTextField, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(56, Short.MAX_VALUE))
        );

        RobotControlPanel.add(ManualInputWindow, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 90, 210, 130));

        jLabel10.setFont(new java.awt.Font("Tahoma", 3, 14));
        jLabel10.setText("L");
        RobotControlPanel.add(jLabel10, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 120, -1, -1));

        jLabel11.setFont(new java.awt.Font("Tahoma", 3, 14));
        jLabel11.setText("B");
        RobotControlPanel.add(jLabel11, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 200, -1, -1));

        jLabel12.setFont(new java.awt.Font("Tahoma", 3, 14));
        jLabel12.setText("R");
        RobotControlPanel.add(jLabel12, new org.netbeans.lib.awtextra.AbsoluteConstraints(160, 120, 10, -1));

        jLabel9.setFont(new java.awt.Font("Tahoma", 3, 14));
        jLabel9.setText("F");
        RobotControlPanel.add(jLabel9, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 80, 10, -1));

        ManualInputButton.setText("Manual Input");
        ManualInputButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ManualInputButtonActionPerformed(evt);
            }
        });
        RobotControlPanel.add(ManualInputButton, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 220, -1, -1));

        ControlPanel.setIcon(new javax.swing.ImageIcon(getClass().getResource("/my/gui/applet/Control_Panel.GIF"))); // NOI18N
        ControlPanel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                ControlPanelMouseClicked(evt);
            }
        });
        RobotControlPanel.add(ControlPanel, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 80, -1, -1));

        RunButton.setText("Run");
        RunButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                RunButtonMousePressed(evt);
            }
        });
        RobotControlPanel.add(RunButton, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 220, -1, -1));

        Trispot0Button.setText("Trispot0");
        Trispot0Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Trispot0ButtonActionPerformed(evt);
            }
        });
        RobotControlPanel.add(Trispot0Button, new org.netbeans.lib.awtextra.AbsoluteConstraints(30, 20, -1, -1));

        Trispot2Button.setText("Trispot2");
        Trispot2Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Trispot2ButtonActionPerformed(evt);
            }
        });
        RobotControlPanel.add(Trispot2Button, new org.netbeans.lib.awtextra.AbsoluteConstraints(30, 50, -1, -1));

        Trispot1Button.setText("Trispot1");
        Trispot1Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Trispot1ButtonActionPerformed(evt);
            }
        });
        RobotControlPanel.add(Trispot1Button, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 20, -1, -1));

        Trispot3Button.setText("Trispot3");
        Trispot3Button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Trispot3ButtonActionPerformed(evt);
            }
        });
        RobotControlPanel.add(Trispot3Button, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 50, -1, -1));

        add(RobotControlPanel, new org.netbeans.lib.awtextra.AbsoluteConstraints(820, 190, 220, 250));

        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder("Message Console"));
        jPanel5.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        commandHistory.addCaretListener(new javax.swing.event.CaretListener() {
            public void caretUpdate(javax.swing.event.CaretEvent evt) {
                commandHistoryCaretUpdate(evt);
            }
        });
        jScrollPane1.setViewportView(commandHistory);

        jPanel5.add(jScrollPane1, new org.netbeans.lib.awtextra.AbsoluteConstraints(70, 20, 270, 210));

        commandEntry.setCursor(Cursor.getDefaultCursor());
        commandEntry.setName(""); // NOI18N
        commandEntry.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                commandEntryActionPerformed(evt);
            }
        });
        jPanel5.add(commandEntry, new org.netbeans.lib.awtextra.AbsoluteConstraints(70, 240, 160, 20));

        jLabel2.setText("Message");
        jPanel5.add(jLabel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(16, 46, -1, -1));

        jLabel5.setText("History");
        jPanel5.add(jLabel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(16, 60, -1, -1));

        jLabel7.setText("Command");
        jPanel5.add(jLabel7, new org.netbeans.lib.awtextra.AbsoluteConstraints(8, 233, -1, -1));

        jLabel8.setText("Line");
        jPanel5.add(jLabel8, new org.netbeans.lib.awtextra.AbsoluteConstraints(36, 247, -1, -1));

        jLabel13.setIcon(new javax.swing.ImageIcon(getClass().getResource("/my/gui/applet/halt.GIF"))); // NOI18N
        jLabel13.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel13MouseClicked(evt);
            }
        });
        jPanel5.add(jLabel13, new org.netbeans.lib.awtextra.AbsoluteConstraints(240, 230, 100, 30));

        add(jPanel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(690, 440, 350, 270));

        TablePanel.setBorder(javax.swing.BorderFactory.createTitledBorder("Data Viewer"));

        TableData.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"Tri-Spot 1", null, null, null},
                {"       Encoder   (mL, mR)", "", "", null},
                {"              Position           (m)", null, null, null},
                {"              Velocity         (m/s)", null, null, null},
                {"              Acceleration    (m/s^2)", null, null, null},
                {"      Accelerometer     (m/s^2)", null, null, null},
                {"      Cameras              (cm)", null, null, null},
                {null, null, null, null},
                {"", "", "", null},
                {null, null, "", null},
                {null, null, "", null},
                {null, null, "", null},
                {null, null, "", null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Object Type", "               X", "               Y", "Orientation (rads)"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class
            };
            boolean[] canEdit = new boolean [] {
                false, false, false, false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jScrollPane2.setViewportView(TableData);

        javax.swing.GroupLayout TablePanelLayout = new javax.swing.GroupLayout(TablePanel);
        TablePanel.setLayout(TablePanelLayout);
        TablePanelLayout.setHorizontalGroup(
            TablePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(TablePanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 658, Short.MAX_VALUE)
                .addContainerGap())
        );
        TablePanelLayout.setVerticalGroup(
            TablePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 244, Short.MAX_VALUE)
        );

        add(TablePanel, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 440, 690, 270));
    }// </editor-fold>//GEN-END:initComponents

//Starts the currently selected UV tracking the generated path
    private void RunButtonMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_RunButtonMousePressed
// TODO add your handling code here:
        commandtoBase("track start");
    }//GEN-LAST:event_RunButtonMousePressed

    
 //Activates the emergency stop when the user hits the escape key (in theory) provided the applet has keyboard focus
 //This does not seem to work when the UVs are actually connected and running
    //When pressed stops the movement of all UVs
    //This is the emergency stop button
    private void jLabel13MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel13MouseClicked
// TODO add your handling code here:
        EmergencyStop();
    }//GEN-LAST:event_jLabel13MouseClicked

//Toggles the automatic Camera View refresh function on and off
    private void RefreshDelayOnMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_RefreshDelayOnMousePressed
// TODO add your handling code here:
        RefreshOn = !RefreshDelayOn.isSelected();
        if(!RefreshOn){camRefreshThread.interrupt();}    
    }//GEN-LAST:event_RefreshDelayOnMousePressed

    //Increases the daly inserted by the delay generator by .05 seconds
    private void MoreButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MoreButtonActionPerformed
// TODO add your handling code here:
        commandtoBase("DELAY" + " " + (Double.parseDouble(DelayGenTextField.getText()) + 0.05));
        double get = (Double.parseDouble(DelayGenTextField.getText()) + 0.05);
        get = (int)(get*100); get = (double)(get/100);
        String set = "" + get;
        DelayGenTextField.setText(set);
    }//GEN-LAST:event_MoreButtonActionPerformed

    //Sets the currently controlled UV to UV 3
    private void Trispot3ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Trispot3ButtonActionPerformed
// TODO add your handling code here:

        String send = "connect trispot 0014.4F01.0000.0498 48 120";
        commandtoBase(send);
        Trispot3Button.setEnabled(false);        
        
        commandHistory.setText(commandHistory.getText() + "\n" + "Action: "+ send);
    }//GEN-LAST:event_Trispot3ButtonActionPerformed

    private void commandHistoryCaretUpdate(javax.swing.event.CaretEvent evt) {//GEN-FIRST:event_commandHistoryCaretUpdate
// TODO add your handling code here:

    }//GEN-LAST:event_commandHistoryCaretUpdate

//Sets the applet-base communication protocol to be used
    private void appletbaseComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_appletbaseComboActionPerformed
// TODO add your handling code here:
        JComboBox cb = (JComboBox)evt.getSource();
        abNetwork = cb.getSelectedIndex();
        if (abNetwork == 0) commandtoBase("TCP");  //TCP
        else commandtoBase("UDP");  //UDP
    }//GEN-LAST:event_appletbaseComboActionPerformed

//Selects the base-server communication protocol to be used
    private void basecppnetworkActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_basecppnetworkActionPerformed
// TODO add your handling code here:
        JComboBox cb = (JComboBox)evt.getSource();
        bcNetwork = cb.getSelectedIndex();
        if (bcNetwork == 0) {
            commandtoBase("imagecommand u OFF");  //Hybrid: TCP for commands, UDP for data
            try {Thread.sleep(250);}
            catch(InterruptedException e) {System.out.println(e);}
            commandtoBase("imagecommand u2 ON");
        }
        else if (bcNetwork == 1) {
            commandtoBase("imagecommand u OFF");  //All TCP
            try {Thread.sleep(250);}
            catch(InterruptedException e) {System.out.println(e);}
            commandtoBase("imagecommand u2 OFF");
        }
        else{
            commandtoBase("imagecommand u ON");  //All UDP
            try {Thread.sleep(250);}
            catch(InterruptedException e) {System.out.println(e);}
            commandtoBase("imagecommand u2 ON");
        }
    }//GEN-LAST:event_basecppnetworkActionPerformed

    private void formPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_formPropertyChange
// TODO add your handling code here:
    }//GEN-LAST:event_formPropertyChange

//Sets the currently controlled UV to UV 2
    private void Trispot2ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Trispot2ButtonActionPerformed
        if(currentRobot !=2){
            currentRobot = 2;// TODO add your handling code here:
            pathCamLength = 0;
            pathLength = 0;
            DrawFieldView();
            commandtoBase("imagecommand 2");
         //commandHistory.setText(commandHistory.getText() + "Current TriSpot:"+baseSocket.readLine()+ "\n");
            String send = "spotselect "+SPOT_ID3+" "+BROADCAST_PORT3+" "+PORT3;
            commandtoBase(send);
            commandHistory.setText(commandHistory.getText() + "\n" + "Action: "+ send);
        }
    }//GEN-LAST:event_Trispot2ButtonActionPerformed

//Sets the currently controlled Uv to UV 1
    private void Trispot1ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Trispot1ButtonActionPerformed
        if(currentRobot !=1){
            currentRobot = 1;// TODO add your handling code here:
            pathCamLength = 0;
            pathLength = 0;
            DrawFieldView();
            commandtoBase("imagecommand 1");
            String send = "spotselect "+SPOT_ID2+" "+BROADCAST_PORT2+" "+PORT2;
            commandtoBase(send);
            commandHistory.setText(commandHistory.getText() + "\n" + "Action: "+ send);
        } //commandHistory.setText(commandHistory.getText()+ "Current TriSpot:" +baseSocket.readLine()+ "\n");
    }//GEN-LAST:event_Trispot1ButtonActionPerformed

//Sets the currently controlled UV to UV 0
    private void Trispot0ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Trispot0ButtonActionPerformed
        if(currentRobot !=0){
            currentRobot = 0;// TODO add your handling code here:
            pathCamLength = 0;
            pathLength = 0;
            DrawFieldView();
            commandtoBase("imagecommand 0");
            String send = "spotselect "+SPOT_ID1+" "+BROADCAST_PORT1+" "+PORT1;
            commandtoBase(send);
            commandHistory.setText(commandHistory.getText() + "\n" + "Action: "+ send);
        }//commandHistory.setText(commandHistory.getText() + "Current TriSpot:"+baseSocket.readLine()+ "\n");
    }//GEN-LAST:event_Trispot0ButtonActionPerformed

//Gets the delay from the delay input field
//input in seconds
    private void DelayGenTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_DelayGenTextFieldActionPerformed
        delay = Double.parseDouble(DelayGenTextField.getText());
        commandtoBase( "DELAY" + " " + DelayGenTextField.getText());
    }//GEN-LAST:event_DelayGenTextFieldActionPerformed

//Gets the value input in the safety region field
    private void SafetyRegionTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SafetyRegionTextFieldActionPerformed
        SAFETY_REGION = (int)((Double.parseDouble(SafetyRegionTextField.getText()))*100);
        safetyRegion = Double.parseDouble(SafetyRegionTextField.getText());
        SafetyRegionTextField.setText("0.0");
        SafetyRegionTextField.setText(Double.toString(safetyRegion));
        commandtoBase("imagecommand s " + SAFETY_REGION + " " + SAFETY_REGION + " ");
        
    }//GEN-LAST:event_SafetyRegionTextFieldActionPerformed

//Sets the selected path planning method
    private void PathPlanningComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_PathPlanningComboActionPerformed
        JComboBox cb = (JComboBox)evt.getSource();
        PathPlanning = cb.getSelectedIndex();
    }//GEN-LAST:event_PathPlanningComboActionPerformed

//Toggles the GSM on or off
    private void GSMComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_GSMComboActionPerformed
        int index = 0;
        JComboBox cb = (JComboBox)evt.getSource();
        index = cb.getSelectedIndex();
        if(index == 0){
            GSMOn = true;
            commandtoBase("GSM true");
        } else{
            commandtoBase("GSM false");
            GSMOn = false;
        }
    }//GEN-LAST:event_GSMComboActionPerformed

//Draws the planned path for the UV on the field view
    private void GetPathButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_GetPathButtonActionPerformed
        ParseIt[1] = "";
        getPath = true;
        commandtoBase("imagecommand p " + destinationX + " " + destinationY);
        getPath = false;
    }//GEN-LAST:event_GetPathButtonActionPerformed

//Toggles the field view grid on and off when the GridOnOff button is pressed
    private void GridOnOffButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_GridOnOffButtonMouseClicked
        if(!fvGrid){
            fvGrid = true;
        }
        else{
            fvGrid = false;
        }
        DrawFieldView();
    }//GEN-LAST:event_GridOnOffButtonMouseClicked

//Toggles the coordinate label of objects off and on when the LabelOn/Off button is pressed
    private void CoordinateLabelButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_CoordinateLabelButtonMouseClicked
        if(coordinatesLabel){
            coordinatesLabel = false;
        }
        else{
            coordinatesLabel =  true;
        }
        DrawFieldView();
    }//GEN-LAST:event_CoordinateLabelButtonMouseClicked

    //Gets the text from the pop up text field that pops up when the user clicks on the Manual Input button
    private void ManualInputTextFieldActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ManualInputTextFieldActionPerformed
        ManualInput = ManualInputTextField.getText();
        //destinationPreX = destinationX;
        //destinationPreY = destinationY;
        destinationX = (int)(Double.parseDouble(StringTokenizer.getX(ManualInput))*100);
        destinationY = (int)(Double.parseDouble(StringTokenizer.getY(ManualInput))*100);
        if(destinationX<180 && destinationX>-180 && destinationY<150 && destinationY>-150){ 
            showPlanPath = false;
            firstDestination = false;
            DrawFieldView();
        }
        
        String trispotNumber = StringTokenizer.getTriNumber(ManualInput);
        ManualInputTextField.setText("");
        commandHistory.setText(commandHistory.getText() + "\n" + 
                                " Move Trispot" + trispotNumber + " to (" + destinationX + "," + destinationY + ")");
         try{ManualInputWindow.setClosed(true);}
        catch(PropertyVetoException ex){System.out.println("closing not possible"+ex);}
    }//GEN-LAST:event_ManualInputTextFieldActionPerformed

//Pops up a text field in a panel allowing the user to manually input movement commands to the currently controlled UV
    private void ManualInputButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ManualInputButtonActionPerformed
        //ManualInputWindow.show();
        ManualInputWindow.setVisible(true);
        try{ManualInputWindow.setClosed(false);}
        catch(PropertyVetoException ex){System.out.println("closing not possible"+ex);}
        ManualInputWindow.moveToFront();
    }//GEN-LAST:event_ManualInputButtonActionPerformed

    private void CamViewLabelMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_CamViewLabelMouseClicked
        if (evt.getSource() == CamViewLabel){
             int x = evt.getX();
             int y = evt.getY();
             switch(cameraImage){
                case 1:
                    if(x>40 && x<=360 && y>0 && y<=240){
                         x=x - 40;
                         calCam1X(x);
                         calCam1Y(y);
                    }
                    break;
                case 2:
                    if(x>40 && x<=360 && y>0 && y<=240){
                         x=x - 40-3;
                         y=y-2;
                         calCam2X(x);
                         calCam2Y(y);
                    }
                    break;
                case 3:
                    if(x>40 && x<=360 && y>0 && y<=240){
                         x=x - 40;
                         y=y+3;
                         calCam3X(x);
                         calCam3Y(y);
                    }
                    break;
                case 4:
                    if(x>40 && x<=360 && y>0 && y<=240){
                         x=x - 40;
                         calCam4X(x);
                         calCam4Y(y);
                    }
                    break;
                case 5:
                    //destinationPreX = destinationX;    
                    //destinationPreY = destinationY;
                    destinationX = (int)( ((double)(x-200))*100/75.0 );
                    destinationY = (int)( ((double)(120-y))*100/72.0 );
                    System.out.println("destinationx: " + destinationX);
                    break;
            }
            if(destinationX<180 && destinationX>-180 && destinationY<150 && destinationY>-150){ 
                showPlanPath = false;
                firstDestination = false;
                DrawFieldView();
            }
         }
    }//GEN-LAST:event_CamViewLabelMouseClicked

//Toggles the more accurate grid on the Camera View on and off
    private void curveGridActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_curveGridActionPerformed
        if(curveGridOn){
            curveGridOn = false;
        }
        else{
            curveGridOn = true;
        }
        switch(cameraImage){
                case 1:
                    getCam1Image();
                    break;
                case 2:
                    getCam2Image();
                    break;
                case 3:
                    getCam3Image();
                    break;
                case 4:
                    getCam4Image();
                    break;
                case 5:
                    getAllImage1();
                    break;
            } 
    }//GEN-LAST:event_curveGridActionPerformed

//Toggles the straight lined grid on the Camera View on and off
    private void gridButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_gridButtonActionPerformed
        if(gridOn){
            gridOn = false;
        }
        else{
            gridOn = true;
        }
        switch(cameraImage){
                case 1:
                    getCam1Image();
                    break;
                case 2:
                    getCam2Image();
                    break;
                case 3:
                    getCam3Image();
                    break;
                case 4:
                    getCam4Image();
                    break;
                case 5:
                    getAllImage1();
                    break;
            } 
    }//GEN-LAST:event_gridButtonActionPerformed

    private void refreshButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_refreshButtonActionPerformed
        switch(cameraImage){
            case 1:
                getCam1Image();
                break;
            case 2:
                getCam2Image();
                break;
            case 3:
                getCam3Image();
                break;
            case 4:
                getCam4Image();
                break;
            case 5:
                getAllImage1();
                break;
        }
        //commandtoBase("imagecommand r");  //need to check if image server connected
    }//GEN-LAST:event_refreshButtonActionPerformed

    //This function is called in a thread to provide real time refreshing of the current camera view
    private void realTimeRefreshCamera(int camera) {
        switch(cameraImage){
            case 1:
                getCam1Image();
                break;
            case 2:
                getCam2Image();
                break;
            case 3:
                getCam3Image();
                break;
            case 4:
                getCam4Image();
                break;
            case 5:
                getAllImage1();
                break;
        }
        
    }
    
    
    private void allCamButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_allCamButtonActionPerformed
        cameraImage = 5;
        camLabel.setText("All 4 Camera View");
        getAllImage1();
    }//GEN-LAST:event_allCamButtonActionPerformed

//Sets the current camera view to camera four
    private void Cam4ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Cam4ButtonActionPerformed
        cameraImage = 4;
        camLabel.setText("Camera 4 View");
        getCam4Image();
    }//GEN-LAST:event_Cam4ButtonActionPerformed

//Sets the current camera view to camera three
    private void Cam3ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Cam3ButtonActionPerformed
        cameraImage = 3;
        camLabel.setText("Camera 3 View");
        getCam3Image();
    }//GEN-LAST:event_Cam3ButtonActionPerformed

//Sets the current camera view to camera two
    private void Cam2ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Cam2ButtonActionPerformed
        cameraImage = 2;
        camLabel.setText("Camera 2 View");
        getCam2Image();
    }//GEN-LAST:event_Cam2ButtonActionPerformed

//Sets the current camera view to camera one
    private void Cam1ButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Cam1ButtonActionPerformed
        cameraImage = 1;
        camLabel.setText("Camera 1 View");
        getCam1Image();
    }//GEN-LAST:event_Cam1ButtonActionPerformed

    //reacts to a user entering a manual command in the command line text field
    private void commandEntryActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_commandEntryActionPerformed
// TODO add your handling code here:
        consoleCommand = commandEntry.getText();
        commandEntry.setText("");
        ParseIt = StringTokenizer.parseStringAsArray(consoleCommand, " ");
        if(ParseIt[0].equalsIgnoreCase("set")){
            if(ParseIt[1].equalsIgnoreCase("baseip")) baseServer = ParseIt[2];
            if(ParseIt[1].equalsIgnoreCase("imageip")) imageServer = ParseIt[2];
        }
        else if(ParseIt[0].equalsIgnoreCase("init")){
            ClearFieldView();
            cameraImage = 5;
            camLabel.setText("All 4 Camera View");
            getAllImage1();
            commandtoBase("base connect");
            try {Thread.sleep(250);}
            catch(InterruptedException e) {System.out.println(e);}
            commandtoBase("image connect");
            try {Thread.sleep(250);}
            catch(InterruptedException e) {System.out.println(e);}
            commandtoBase("imagecommand s " + SAFETY_REGION + " " + SAFETY_REGION + " ");
            try {Thread.sleep(250);}
            catch(InterruptedException e) {System.out.println(e);}
            // scan all the camera, get all the trispots' coordinates, and set the current controlled trispot to trispot1
            commandtoBase("imagecommand 0");
            try {Thread.sleep(1000);}
            catch(InterruptedException e) {System.out.println(e);}
            //scan one camera where the current controlled trispot is at and get back the coordinate
            commandtoBase("imagecommand o");
            try {Thread.sleep(1000);}
            catch(InterruptedException e) {System.out.println(e);}
            //scan for all the robots
            commandtoBase("imagecommand a");
            try {Thread.sleep(1000);}
            catch(InterruptedException e) {System.out.println(e);}
            commandtoBase("imagecommand r");
            try {Thread.sleep(200);}
            catch(InterruptedException e) {System.out.println(e);}
            //commandtoBase("trispot connect");
            commandtoBase("setID "+SPOT_ID1+" "+BROADCAST_PORT1+" "+PORT1+" "+SPOT_ID2+" "+BROADCAST_PORT2+" "+PORT2+" "+SPOT_ID3+" "+BROADCAST_PORT3+" "+PORT3);
            try {Thread.sleep(1000);}
            catch(InterruptedException e) {System.out.println(e);}
            connectSpots();
        }
        else if(ParseIt[0].equalsIgnoreCase("mimic")){
            destinationX = (int)(X[1]);
            destinationY = (int)(Y[1]);
            if(destinationX<180 && destinationX>-180 && destinationY<150 && destinationY>-150){ 
                showPlanPath = false;
                firstDestination = false;
                DrawFieldView();
            }
            commandtoBase("imagecommand g");
        }
        else{
            commandHistory.setText(commandHistory.getText() + "\n" + "Base Station Information: " + consoleCommand);
            commandtoBase(consoleCommand);  /*send Data to base*/
        }
        SwingUtilities.invokeLater(new Runnable() {
	public void run() {
		JScrollBar scrollBar = jScrollPane1.getVerticalScrollBar();
		scrollBar.setValue(scrollBar.getMaximum());
	}
});
                                                

    }//GEN-LAST:event_commandEntryActionPerformed
    
    public void connectSpots(){
        String send = "";
        send = "connect trispot "+SPOT_ID1+" "+BROADCAST_PORT1+" "+PORT1;
        commandtoBase(send);
        commandHistory.setText(commandHistory.getText() + "\n" + "Action: "+ send);
        try {Thread.sleep(2000);}
        catch(InterruptedException e) {System.out.println(e);}
        
        
        send = "connect trispot "+SPOT_ID2+" "+BROADCAST_PORT2+" "+PORT2;
        commandtoBase(send);
        commandHistory.setText(commandHistory.getText() + "\n" + "Action: "+ send);

    }
    
    private void formMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseClicked
// TODO add your handling code here:
    }//GEN-LAST:event_formMouseClicked

    private void FieldViewLabelMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_FieldViewLabelMouseClicked
    if (evt.getSource() == FieldViewLabel){
            System.out.println(evt.getPoint().toString());
        }
    }//GEN-LAST:event_FieldViewLabelMouseClicked

    //Clears the field view and redraws the obstacles, UV position, and destination when the clear button is pressed
    private void clearButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_clearButtonMouseClicked
        ClearFieldView();
        //should check if image server is connect
        //commandtoBase("imagecommand r");
        DrawFieldView();
    }//GEN-LAST:event_clearButtonMouseClicked

//When clicked gets the coordinate of the mousclick, and generates the appropriate command to the currently selected UV
    private void ControlPanelMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_ControlPanelMouseClicked
        if (evt.getSource() == ControlPanel) {
            System.out.println(evt.getPoint().toString());
            
            //This is a string of text commands to be sent to the UV.  This way only the index of the command has to be assigned
            String commands[] = {"f -1 0.08", "f -1 0.15", "f -1 0.22", "f -1 .3", "b -1 0.08","b -1 0.15", "b -1 0.22", "b -1 .3", "r -1 0.08","r -1 0.15", "r -1 0.22", "r -1 .3","l -1 0.08","l -1 0.15", "l -1 0.22", "l -1 .3", "s 0 0"};
            int commandIndex = -1;
            int X = evt.getX();
            int Y = evt.getY();
                                 
            //Forward Control
            if(((X > 47)&&(X < 86))&&((Y > 28)&&(Y < 36))) commandIndex = 0;
            if((X > 52&&X<81)&&(Y>21&&Y<27)) commandIndex = 1;
            if((X > 56&&X<76)&&(Y>11&&Y<19)) commandIndex = 2;
            if((X >61&&X<72)&&(Y>5&&Y<10)) commandIndex = 3;
            
            //Backward Control
            if((X >48&&X<86)&&(Y>97&&Y<105)) commandIndex = 4;
            if((X >55&&X<81)&&(Y>107&&Y<113)) commandIndex = 5;
            if((X >58&&X<78)&&(Y>115&&Y<122)) commandIndex = 6;
            if((X >63&&X<73)&&(Y>124&&Y<131)) commandIndex = 7;
            //Right Control
            if((X >97&&X<105)&&(Y>46&&Y<85)) commandIndex = 8;
            if((X >107&&X<113)&&(Y>52&&Y<80)) commandIndex = 9;
            if((X >115&&X<122)&&(Y>57&&Y<75)) commandIndex = 10;
            if((X >124&&X<132)&&(Y>62&&Y<71)) commandIndex = 11;
            //Left Control
            if((X >29&&X<36)&&(Y>49&&Y<87)) commandIndex = 12;
            if((X >21&&X<27)&&(Y>54&&Y<82)) commandIndex = 13;
            if((X >11&&X<19)&&(Y>58&&Y<77)) commandIndex = 14;
            if((X >1&&X<10)&&(Y>63&&Y<73)) commandIndex = 15;
            //Stop Button
            if((X >39&&X<95)&&(Y>40&&Y<95)) commandIndex = 16;
            
            if(commandIndex > -1){
                if(baseDataSocketConnected){
                    baseSocket.genSend("spotcommand "+commands[commandIndex]);
                    if(commandIndex == 16){
                        baseSocket.genSend("track stop");
                        commandHistory.setText(commandHistory.getText() + "\n" + "Track STOP");
                    }
                }
                else System.out.println("Base Socket is not connected!");
                System.out.println("command is: " + commands[commandIndex]);
                commandHistory.setText(commandHistory.getText() + "\n" + "Motion Command: " + commands[commandIndex] + "\n" +  "--------------\n");
            }
        }
    }//GEN-LAST:event_ControlPanelMouseClicked

    // Calculate the Destinatioin world frame X in cm when click anyone point on Camera 1 view
    public void calCam1X(int x){
        //destinationPreX = destinationX;
        destinationX = (int)(6.0*30.38*((float)x-268.5)/223.5);
    }
    
    // Calculate the Destinatioin world frame Y in cm when click anyone point on Camera 1 view
    public void calCam1Y(int y){
        //destinationPreY = destinationY;
        destinationY = (int)(5.0*30.38*(213.5-(float)y)/187.5);
    }
    
    // Calculate the Destinatioin world frame X in cm when click anyone point on Camera 2 view
    public void calCam2X(int x){
        //destinationPreX = destinationX;
        destinationX = (int)(6.0*30.38*((float)x-276.5)/222.0);
    }
    
    // Calculate the Destinatioin world frame Y in cm when click anyone point on Camera 2 view
    public void calCam2Y(int y){
        //destinationPreY = destinationY;
        destinationY = (int)(5.0*30.38*(40.0-(float)y)/182.0);
    }
    
    // Calculate the Destinatioin world frame X in cm when click anyone point on Camera 3 view
    public void calCam3X(int x){
        //destinationPreX = destinationX;
        destinationX = (int)(6.0*30.38*((float)x-42.0)/222.0);
    }
    
    // Calculate the Destinatioin world frame Y in cm when click anyone point on Camera 3 view
    public void calCam3Y(int y){
        //destinationPreY = destinationY;
        destinationY = (int)(5.0*30.38*(15.0-(float)y)/183.0);
    }
    
    // Calculate the Destinatioin world frame X in cm when click anyone point on Camera 4 view
    public void calCam4X(int x){
        //destinationPreX = destinationX;
        destinationX = (int)(6.0*30.38*((float)x-43.0)/223.0);
    }
    
    // Calculate the Destinatioin world frame Y in cm when click anyone point on Camera 4 view
    public void calCam4Y(int y){
        //destinationPreY = destinationY;
        destinationY = (int)(5.0*30.38*(206.5-(float)y)/186.0);
    } 
    
    // Clear all the graphics on Field View
    public void ClearFieldView() {
        DrawIt();
    }
    
    // Connect to Base station through socket program
    
    private void commandtoBase(String command){
        ParseIt = StringTokenizer.parseStringAsArray(command, " ");

        try{  //check if the 0 command is valid
            if(ParseIt[0].equals(""));
            validCommand0 = true;
        }
        catch( ArrayIndexOutOfBoundsException ex){
            validCommand0 = false;
        }
        if(validCommand0)
        {
            if (ParseIt[0].equalsIgnoreCase("exit")){
                  baseSocket.genSend("exit");
                  baseDataSocketConnected = false;
                  disconnectBaseDataThread = true;

                  baseSocket.stopClient();
            }
            try{
                if(ParseIt[1].equals(""));
                validCommand1 = true;
            }
            catch( ArrayIndexOutOfBoundsException ex){
                validCommand1 = false;
            }
            if(validCommand1){
                if(ParseIt[1].equalsIgnoreCase("Connect")){
                     if (ParseIt[0].equalsIgnoreCase("base")){
                            try{
                            if(ParseIt[2].length() > 7) baseServer = ParseIt[2];
                            }
                            catch(ArrayIndexOutOfBoundsException e){
                                baseServer = baseServer;
                            }
                            System.out.println("base server; "  + baseServer);
                            baseSocket.connectToServer(baseServer, PORT_NUM_BASE);
                            baseSocket.createUDPListener(PORT_UDP_RECV);
                            baseSocket.setUDPDestAddr(baseServer);
                            baseSocket.setUDPDestPort(PORT_UDP_SEND);
                            baseSocket.UDPCommands = false;
                            appletbaseCombo.setEnabled(true);
                            baseDataSocketConnected = true;
                            disconnectBaseDataThread = false;
                            new Thread(baseDataThread).start();
                            commandHistory.setText(commandHistory.getText()  + "Connected to Base !\n");
                            commandHistory.setText(commandHistory.getText()  + "TCP Connection to: " + baseServer + "::" + PORT_NUM_BASE + "\n");
                            commandHistory.setText(commandHistory.getText()  + "UDP Listener on Port: " + PORT_UDP_RECV + "\n");
                            commandHistory.setText(commandHistory.getText()  + "UDP Sender to: " + baseServer + "::" + PORT_UDP_SEND + "\n");

                     }else if(ParseIt[0].equalsIgnoreCase("image")){
                         if(imageServer.length() > 7) baseSocket.genSend("connect image " + imageServer);
                         else baseSocket.genSend("connect image");
                         basecppnetwork.setEnabled(true);
                         commandHistory.setText(commandHistory.getText()  + "Connected to ImageProcessing Server !" + "\n" + "--------------\n");
                     }else if(ParseIt[0].equalsIgnoreCase("trispot")){

                         baseSocket.genSend("connect trispot");
                         commandHistory.setText(commandHistory.getText()  + "\nConnecting to trispot");
                     }
  
                }else if(ParseIt[1].equalsIgnoreCase("Disconnect")){
                    if (ParseIt[0].equalsIgnoreCase("base")){
                        baseSocket.genSend("disconnect base");
                        /*baseDataSocketConnected = false;
                        disconnectBaseDataThread = true;
                        baseSocket.stopClient();
                        baseSocketUDP.closeUDP();*/
                        appletbaseCombo.setEnabled(false);
                        commandHistory.setText(commandHistory.getText() + "\n" + "Disconnected from Base !" + "\n" + "--------------\n");
                    }else if(ParseIt[0].equalsIgnoreCase("image")){
                        basecppnetwork.setEnabled(false);
                        baseSocket.genSend("disconnect image");
                        commandHistory.setText(commandHistory.getText() + "\n" + "Disconnected from imageProcessing Server !" + "\n" + "--------------\n");
                    }                     
                }else if(ParseIt[0].equalsIgnoreCase("imagecommand")){
                    if (ParseIt[1].equals("0")) currentRobot = 0;
                    else if (ParseIt[1].equals("1")) currentRobot = 1;
                    else if (ParseIt[1].equals("2")) currentRobot = 2;                    }
                    else if(ParseIt[1].equalsIgnoreCase("o")) commandHistory.setText(commandHistory.getText() + "\n" + "Request for Obstacle sent !" + "\n" + "--------------\n");
                    else if(ParseIt[1].equalsIgnoreCase("a")) commandHistory.setText(commandHistory.getText() + "\n" + "Request for all trispots sent !" + "\n" + "--------------\n");
                    baseSocket.genSend(command);
                }
                else{
                    baseSocket.genSend(command);
                    //commandHistory.setText(commandHistory.getText() + "\n" + "Received Data: " + baseSocket.readLine() + "\n" + "--------------\n");
                }
            }
            else{
                    baseSocket.genSend(command);
                    //commandHistory.setText(commandHistory.getText() + "\n" + "Received Data: " + baseSocket.readLine() + "\n" + "--------------\n");
                }

        //}
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                        JScrollBar scrollBar = jScrollPane1.getVerticalScrollBar();
                        scrollBar.setValue(scrollBar.getMaximum());
	}
    });
    }
    
    
    
    // Draw destination on Field View with input of world frame X and Y
    public void DrawDestination(int x, int y) {
        Graphics graphicsView = Field.getGraphics();
        //if(!firstDestination){
            //System.out.println("erase");
            //double x1=(double)destinationPreX;
            //double y1=(double)destinationPreY;
            //graphicsView.setColor(new Color(234,236,248));
            //Polygon oct = GenerateOctagon((int)TranslateX(x1), (int)TranslateY(y1));
            //graphicsView.drawPolygon(oct);
            //String string1 = "Destination";
            //String string2 = "(" + destinationPreX + "," + destinationPreY + ")";
            //drawLabel(string1, string2, (int)TranslateX(x1), (int)TranslateY(y1)-drawingSize,new Color(234,236,248) );
        //}
        double x1=(double)x;
        double y1=(double)y;
        graphicsView.setColor(Color.MAGENTA);
        Polygon oct = GenerateOctagon((int)TranslateX(x1), (int)TranslateY(y1));
        graphicsView.drawPolygon(oct);
        String string1 = "Destination";
        String string2 = "(" + x + "," + y + ")";
        drawLabel(string1, string2, (int)TranslateX(x1), (int)TranslateY(y1)-drawingSize, Color.MAGENTA);
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
        firstDestination = false;
    }
    
    // Draw ruler on Field View
    public void drawFieldViewRuler(){
        Graphics graphicsView = Field.getGraphics();
        graphicsView.setColor(Color.BLACK);
        Graphics2D g3 = (Graphics2D) graphicsView;
        g3.setColor(Color.BLACK);
        g3.setStroke(normalStroke);
        g3.drawRect(40,0,340,320);
        //y axis and label
        g3.drawString(" 1.5", 0,14);
        g3.drawLine(36,10,40,10);
        g3.drawString(" 1.0", 0,64);
        g3.drawLine(36,60,40,60);
        g3.drawString(" 0.5", 0,114);
        g3.drawLine(36,110,40,110);
        g3.drawString(" 0.0", 0,164);
        g3.drawLine(36,160,40,160);
        g3.drawString("-0.5", 0,214);
        g3.drawLine(36,210,40,210);
        g3.drawString("-1.0", 0,264);
        g3.drawLine(36,260,40,260);
        g3.drawString("-1.5", 0,314);
        g3.drawLine(36,310,40,310);
        //x axis and label
        g3.drawString(" 1.8", 350,350);
        g3.drawLine(363,320,363,324);
        g3.drawString(" 1.5", 324,350);
        g3.drawLine(337,320,337,324);
        g3.drawString(" 1.0", 282,350);
        g3.drawLine(295,320,295,324);
        g3.drawString(" 0.5", 239,350);
        g3.drawLine(252,320,252,324);
        g3.drawString(" 0.0", 197,350);
        g3.drawLine(210,320,210,324);
        g3.drawString("-0.5", 154,350);
        g3.drawLine(167,320,167,324);
        g3.drawString("-1.0", 112,350);
        g3.drawLine(125,320,125,324);
        g3.drawString("-1.5", 69,350);
        g3.drawLine(82,320,82,324);
        g3.drawString("-1.8", 44,350);
        g3.drawLine(57,320,57,324);
        g3.setStroke(thinStroke);
        g3.dispose();
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
    }
    
    // Fill a rectangler with background color to cover the Field View
    public void DrawIt() {
        Graphics graphicsView = Field.getGraphics();
        //System.out.println(FieldViewLabel.getWidth());
        //System.out.println(FieldViewLabel.getHeight());
        graphicsView.setColor(new Color(234,236,248));
        graphicsView.fillRect(41,0,379,319);
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
        pathCamLength = 0;
        fvGrid = false;
        firstDestination = true;
    }
    
    // Draw all the components on Field View
    public void DrawFieldView(){
        Graphics graphicsView = Field.getGraphics();
        String string1, string2;
        // Cover old Field View Image
        graphicsView.setColor(new Color(234,236,248));
        graphicsView.fillRect(41,0,379,319);
        
        // Draw Origin
        graphicsView.setColor(Color.YELLOW);
        graphicsView.fillOval((int)(XRef - 3), (int)(YRef - 3),6,6);
        
        // Draw grid if grid is on
        if(fvGrid){
            Graphics2D g3 = (Graphics2D) graphicsView;
            g3.setColor(Color.YELLOW);
            g3.setStroke(dashed);
            g3.drawLine(380,10,40,10);
            g3.drawLine(380,60,40,60);
            g3.drawLine(380,110,40,110);
            g3.drawLine(380,160,40,160);
            g3.drawLine(380,210,40,210);
            g3.drawLine(380,260,40,260);
            g3.drawLine(380,310,40,310);
            //x axis and label
            g3.drawLine(363,320,363,0);
            g3.drawLine(337,320,337,0);
            g3.drawLine(295,320,295,0);
            g3.drawLine(252,320,252,0);
            g3.drawLine(210,320,210,0);
            g3.drawLine(167,320,167,0);
            g3.drawLine(125,320,125,0);
            g3.drawLine(82,320,82,0);
            g3.drawLine(57,320,57,0);
            g3.setStroke(thinStroke);
        }
        
        //Draw Obstacles
        if(getCoordinate){
            graphicsView.setColor(Color.BLACK);
            for(int i = 1; i<(Integer.parseInt(obstacles[0])*3);){
                int x = (int)Double.parseDouble(obstacles[i]);
                i++;
                int y = (int)Double.parseDouble(obstacles[i]);
                i++;
                i++;
                graphicsView.drawOval((TranslateX(x)-10), (TranslateY(y)-10), 20, 20);
            }
            if(coordinatesLabel){
                int i = 1;
                while(i<(3*Integer.parseInt(obstacles[0]))){
                    int x = (int)Double.parseDouble(obstacles[i]);
                    i++;
                    int y = (int)Double.parseDouble(obstacles[i]);
                    i++;
                    String z = (obstacles[i]);
                    i++;
                    string1 = "Obstacle " + z;
                    string2 = "(" + x + "," + y + ")";
                    drawLabel(string1, string2, TranslateX(x), TranslateY(y)-drawingSize,Color.BLACK );
                }
            }
        }
        
        //Draw Trispot
        if(!robotInit){
            int i = 0;
            while(i < 3){
                Color mycolor = Color.BLACK;
                if(i == 0){mycolor = (Color.RED);}
                if(i == 1){mycolor = (Color.GREEN);}
                if(i == 2){mycolor = (Color.BLUE);}
                graphicsView.setColor(mycolor);
                drawTrispot(camNewX[i], camNewY[i],oldRobotO[i], mycolor);
                graphicsView.drawString(Integer.toString(i),camNewX[i]-2,camNewY[i]+3);
                //System.out.println("drawing trispot here.................look at it");
                if(coordinatesLabel){
                    graphicsView.setColor(Color.BLACK);
                    string1 = "Trispot"+i;
                    string2 = "(" + roundTwoDecimal(getRealX(camNewX[i])) + ", " 
                                    + roundTwoDecimal(getRealY(camNewY[i]))+ ", " 
                                    + roundTwoDecimal(Math.toDegrees(oldRobotO[i])) + ")";
                    drawLabel(string1, string2, camNewX[i], camNewY[i] - drawingSize,mycolor);
                }
                i++;
            }
            graphicsView.setColor(Color.BLACK);
            graphicsView.drawPolyline(path_CamX,path_CamY,pathCamLength);
        }
        
        //Draw Destination and planning path
        if(!firstDestination){
            graphicsView.setColor(Color.MAGENTA);
            Polygon oct = GenerateOctagon((int)TranslateX(destinationX), (int)TranslateY(destinationY));
            graphicsView.drawPolygon(oct);
            if(showPlanPath){
                graphicsView.drawPolyline(path_DataX,path_DataY,pathLength);
            }
            if(coordinatesLabel){
                string1 = "Destination";
                string2 = "(" + destinationX + "," + destinationY + ")";
                drawLabel(string1, string2, (int)TranslateX(destinationX), (int)TranslateY(destinationY)-drawingSize,Color.MAGENTA );
            }
        }
        
        //Draw path
        
        //Draw encoder path
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
        //System.out.println("HAHA..................................333333333333333");
    }
    
    // Draw labels for obstacles and trispots on the Field View with input of two label strings and Field View coordinates of the objects.
    public void drawLabel(String s1, String s2, double x, double y, Color c){
        Graphics graphicsView = Field.getGraphics();
        graphicsView.setColor(c);
        FontRenderContext frc = ((Graphics2D)graphicsView).getFontRenderContext();
        Rectangle2D bounds1 = font.getStringBounds(s1, frc);
        Rectangle2D bounds2 = font.getStringBounds(s2, frc);
        int xText1 =(int)x - (int)bounds1.getWidth()/2;
        int yText1 =(int)y - (int)bounds2.getHeight()-(int)bounds1.getHeight()-(int)bounds1.getY();
        int xText2 = (int)x - (int)bounds2.getWidth()/2;
        int yText2 = (int)y - (int)bounds2.getHeight()-(int)bounds2.getY();
        if ( (xText1 + (int)bounds1.getWidth())>(width+30)){
            xText1 = (int)width+30 - (int)bounds1.getWidth()-drawingSize;
            if(x > 500){
                xText1 = (int)x;
            }
        }
        if ( (yText1 - (int)bounds1.getHeight())<10){
            yText1 =  (int)y + 2*drawingSize +(int)bounds1.getHeight();
            yText2 = yText1 + (int)bounds1.getHeight();
        }
        if ( (xText2 + (int)bounds2.getWidth())>(width+30)){
            xText2 = (int)width+30 - (int)bounds2.getWidth()-drawingSize;
            if(x > 500){
                xText2 = (int)x;
            }
        }
        if (xText1 < 40){
            xText1 = 40+drawingSize;
        }
        if (xText2 < 40){
            xText2 = 40+drawingSize;
        }
        graphicsView.drawString(s1, xText1, yText1);
        graphicsView.drawString(s2, xText2, yText2);
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
    }
    
    // Draw the obstacle on the Field View with input of Field View coordinates of the objects and objects' number
    public void DrawObstacle (int x, int y, int z) {
        Graphics graphicsView = Field.getGraphics();
        graphicsView.setColor(Color.red);
        graphicsView.drawOval((TranslateX(x)-10), (TranslateY(y)-10), 20, 20);
        String string1 = "Obstacle " + z;
        String string2 = "(" + x + "," + y + ")";
        drawLabel(string1, string2, TranslateX(x), TranslateY(y)-drawingSize, Color.BLACK);
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
    }
    
    // Draw the trispot on the Field View with input of Field View coordinates and orientation of the trispot
    public void drawTrispot(int x, int y, double a, Color color){
        Graphics graphicsView = Field.getGraphics();
        graphicsView.setColor(color);
        int[] X = {(int)(x + drawingSize2*Math.cos(a)), 
                (int)(x + drawingSize2*Math.cos(Math.toRadians(150) - a)), 
                (int)(x-drawingSize2*Math.cos(a - Math.toRadians(30)))};
        int[] Y = {(int)(y - drawingSize2*Math.sin(a)), 
                (int)(y + drawingSize2*Math.sin(Math.toRadians(150) - a)), 
                (int)(y + drawingSize2*Math.sin(a - Math.toRadians(30)))}; 
        graphicsView.drawPolygon(X, Y, 3);
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
    }
    
    // Generate an octagon for the destination of the trispot with input of Field View coordinates
    public Polygon GenerateOctagon(int x, int y) {
        int[] X = {x-10,x-4,x+4,x+10,x+10,x+4,x-4,x-10};
        int[] Y = {y-4,y-10,y-10,y-4,y+4,y+10,y+10,y+4};
        Polygon oct = new Polygon(X, Y, 8);
        return oct;
    }
    
    // Get 4 camera images, combine them, and put it on Camera View with gird/noGrid, boundaries, and rulers.
    public void getAllImage1(){
        //dashed = dashed2;
        //graphicsAll.setColor(new Color(240,240,240));
        //graphicsAll.fillRect(0,0,40,240);
        //graphicsAll.fillRect(0,240,370,270);
        Graphics2D g2 = (Graphics2D) graphicsAll;
        //g2.setColor(Color.BLACK);
        //g2.setStroke(normalStroke);
        //g2.drawLine(39,0,39,242);
        //g2.drawLine(38,241,360,241);
        getCam4Image();
        if(graphicsAll.drawImage(image,200,0,360, 120, 42+40, 0, 320+40, 205, null)){
            getCam3Image();
            if(graphicsAll.drawImage(image,200,120,360, 240, 40+40,10, 310+40, 220, null)){
                getCam2Image();
                if(graphicsAll.drawImage(image,40,120,200, 240, 19+40,38, 280+40, 240, null)){
                    getCam1Image();
                    if(graphicsAll.drawImage(image,40,0,200,120, 0+40,5, 270+40, 215, null)){
                        g2.setStroke(thinStroke);
                        g2.setColor(Color.GREEN);
                        g2.drawRect(59,8,282,224);
                        
                        dashed = dashed2;
                        graphicsAll.setColor(new Color(240,240,240));
                        graphicsAll.fillRect(0,0,40,240);
                        graphicsAll.fillRect(0,240,370,270);
                        g2.setColor(Color.BLACK);
                        g2.setStroke(normalStroke);
                        g2.drawLine(39,0,39,242);
                        g2.drawLine(38,241,360,241);
                        graphicsAll.setColor(Color.BLACK);
                        graphicsAll.drawString("(0,0)", 203, 117);
                        graphicsAll.drawLine(200,0, 200,242);
                        graphicsAll.drawLine(40,120,360,120);
                        //y labels
                        g2.drawString("  1.5m",0,13 );
                        g2.drawLine(36,27, 40, 27);
                        g2.drawString("  1.0m",0,52 );
                        g2.drawLine(36,65, 40, 65);
                        g2.drawString("  0.5m",0,88 );
                        g2.drawLine(36,102, 40, 102);
                        g2.drawString("  0.0m",0,124 );
                        g2.drawLine(36,137, 40, 137);
                        g2.drawString(" -0.5m",0,159 );
                        g2.drawLine(36,174, 40, 174);
                        g2.drawString(" -1.0m",0,198 );
                        g2.drawLine(36,212, 40, 212);
                        g2.drawString(" -1.5m",0,235 );
                        //x labels
                        g2.drawString("-2.0m", 32,260);
                        g2.drawLine(68,240, 68, 244);
                        g2.drawString("-1.5m", 69,260);
                        g2.drawLine(106,240, 106, 244);
                        g2.drawString("-1.0m", 107,260);
                        g2.drawLine(144,240, 144, 244);
                        g2.drawString("-0.5m", 145,260);
                        g2.drawLine(181,240, 181, 244);
                        g2.drawString(" 0.0m", 182,260);
                        g2.drawLine(217,240, 217, 244);
                        g2.drawString(" 0.5m", 217,260);
                        g2.drawLine(254,240, 254, 244);
                        g2.drawString(" 1.0m", 255,260);
                        g2.drawLine(291,240, 291, 244);
                        g2.drawString(" 1.5m", 292,260);
                        g2.drawLine(326,240, 326, 244);
                        g2.drawString(" 2.0m", 324,260);
                        g2.drawLine(360,240, 360, 244);

                        g2.setStroke(normalStroke);
                        g2.drawLine(36,9, 40, 9);
                        g2.drawLine(36,46, 40, 46);
                        g2.drawLine(36,84, 40, 84);
                        g2.drawLine(36,120, 40, 120);
                        g2.drawLine(36,155, 40, 155);
                        g2.drawLine(36,194, 40, 194);
                        g2.drawLine(36,231, 40, 231);
                        g2.drawLine(50,240, 50, 244);
                        g2.drawLine(87,240, 87, 244);
                        g2.drawLine(125,240, 125, 244);
                        g2.drawLine(163,240, 163, 244);
                        g2.drawLine(200,240, 200, 244);
                        g2.drawLine(235,240, 235, 244);
                        g2.drawLine(273,240, 273, 244);
                        g2.drawLine(310,240, 310, 244);
                        g2.drawLine(342,240, 342, 244);
                        if(gridOn){
                            dashed = dashed1;
                            g2.setColor(Color.YELLOW);
                            g2.setStroke(dashed);
                            g2.drawLine(342,0, 342, 242);
                            g2.drawLine(310,0, 310, 242);
                            g2.drawLine(273,0, 273, 242);
                            g2.drawLine(235,0, 235, 242);
                            g2.drawLine(163,0, 163, 242);
                            g2.drawLine(125,0, 125, 242);
                            g2.drawLine(87,0, 87, 242);
                            g2.drawLine(50,0, 50, 242);
                            //x direction grid
                            g2.drawLine(40,9, 360, 9);
                            g2.drawLine(40,46, 360, 46);
                            g2.drawLine(40,84, 360, 84);
                            g2.drawLine(40,155, 360, 155);
                            g2.drawLine(40,194, 360, 194);
                            g2.drawLine(40,231, 360, 231);
                        }
                        CamViewLabel.setIcon(new ImageIcon(imageAll));
                    }
                }
            }
        }
        dashed = dashed1;
    }
    
    // Get camera 1 images, put it on Camera View with grid/noGrid, boundaries, and rulers.
    public void getCam1Image(){
        try{ 
                image1 = ImageIO.read(url1);
                Graphics2D g2 = (Graphics2D) graphics;
                if(graphics.drawImage(image1,40,0,360, 240, 0,0, 320, 240, null)){
                    // Boundry of the field 
                    if(cameraImage==1){
                            g2.setColor(Color.GREEN);
                            g2.drawLine(80,23,360,23);
                            g2.drawLine(80,240,80,23);
                    }
                    if(gridOn && (cameraImage!= 5)){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        // Y direction grid
                        g2.drawLine(358,0, 358, 242);
                        g2.drawLine(335,0, 335, 242);
                        g2.drawLine(309,0, 309, 242);
                        g2.drawLine(279,0, 279, 242);
                        g2.drawLine(249,0, 249, 242);
                        g2.drawLine(216,0, 216, 242);
                        g2.drawLine(184,0, 184, 242);
                        g2.drawLine(154,0, 154, 242);
                        g2.drawLine(121,0, 121, 242);
                        g2.drawLine(90,0, 90, 242);
                        g2.drawLine(59,0, 59, 242);
                        //x direction grid
                        g2.drawLine(40,27, 360, 27);
                        g2.drawLine(40,57, 360, 57);
                        g2.drawLine(40,89, 360, 89);
                        g2.drawLine(40,121, 360, 121);
                        g2.drawLine(40,151, 360, 151);
                        g2.drawLine(40,182, 360, 182);
                        g2.drawLine(40,212, 360, 212);
                    }
                    if(curveGridOn){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        // Y direction grid
                        QuadCurve2D q = new QuadCurve2D.Float();
                        q.setCurve(354,0, 366, 220,348, 242);
                        g2.draw(q);
                        q.setCurve(330,0, 346, 150, 326, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(307,0, 315, 220, 302, 242);
                        g2.draw(q);
                        q.setCurve(279,0, 283, 220, 274, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(249,0, 253, 220, 245, 242);
                        g2.draw(q);
                        q.setCurve(217,0, 223, 180, 213, 241);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(186,0, 187, 220, 183, 242);
                        g2.draw(q);
                        if(cameraImage !=5)g2.drawLine(154,0, 154, 242);
                        q.setCurve(125,0, 111, 220, 123, 242);
                        g2.draw(q);
                        q.setCurve(95,0, 78, 180, 94, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(66,0, 45, 160, 65, 242);
                        g2.draw(q);
                        //x direction grid
                        q.setCurve(40,25, 190, 16, 360, 36);
                        g2.draw(q);
                        q.setCurve(40,57, 190, 48, 360, 63);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,87, 190, 81, 360, 93);
                        g2.draw(q);
                        q.setCurve(40,119, 190, 121, 360, 121);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,148, 190, 158, 360, 148);
                        g2.draw(q);
                        q.setCurve(40,178, 200, 189, 360, 178);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,210, 220, 225, 360, 204);
                        g2.draw(q);
                    }
                    
                    if(cameraImage ==5){
                        g2.setStroke(normalStroke);
                    }
                    else{
                        g2.setStroke(thinStroke);
                    }
                    if(getCoordinate){
                        int i = 0;
                        while(i<(Integer.parseInt(obstacles[0])*3)){
                            int x1=0, y1=0;
                            //if(Integer.parseInt(obstacles[i+1])==1){
                                double x = Double.parseDouble(obstacles[i+1]);
                                double y = Double.parseDouble(obstacles[i+2]);
                                x1 = getSR1X(x)+40;
                                y1 = getSR1Y(y);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                int srx = (int)(safetyRegion*75);
                                //System.out.println("sr " + srx );
                                //int sry = safetyRegion*72;
                                if(srx !=0){
                                    g2.setColor(Color.GREEN);
                                    g2.drawOval(x1-25-srx,y1-25-srx,50+2*srx,50+2*srx);
                                }
                            //}
                            i=i+3;
                        }
                    }
                    if(!robotInit){
                        //if(cam[0]==1){
                            int i =0;
                            while(i<3){
                                int x1=0, y1=0;
                                x1 = getSR1X(X[i])+40;
                                y1 = getSR1Y(Y[i]);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                i++;
                            }
                        //}
                    }
                }
                
                graphics.setColor(new Color(240,240,240));
                graphics.fillRect(0,0,40,240);
                graphics.fillRect(0,240,370,270);
                g2.setColor(Color.BLACK);
                g2.setStroke(normalStroke);
                g2.drawLine(39,0,39,242);
                g2.drawLine(38,241,360,241);
                g2.setColor(Color.BLACK);
                if(gridOn){
                    //y labels
                    g2.drawString("  1.5m",0,31 );
                    g2.drawLine(36,27, 40, 27);
                    g2.drawLine(36,57, 40, 57);
                    g2.drawString("  1.0m",0,93 );
                    g2.drawLine(36,89, 40, 89);
                    g2.drawLine(36,121, 40, 121);
                    g2.drawString("  0.5m",0,155 );
                    g2.drawLine(36,151, 40, 151);
                    g2.drawLine(36,182, 40, 182);
                    g2.drawString("  0.0m",0,216 );
                    g2.drawLine(36,212, 40, 212);
                    g2.drawLine(36,236, 40, 236);
                    //x labels
                    g2.drawString("-2.0m", 41,260);
                    g2.drawLine(59,240, 59, 244);
                    g2.drawLine(90,240, 90, 244);
                    g2.drawString("-1.5m", 103,260);
                    g2.drawLine(121,240, 121, 244);
                    g2.drawLine(154,240, 154, 244);
                    g2.drawString("-1.0m", 166,260);
                    g2.drawLine(184,240, 184, 244);
                    g2.drawLine(216,240, 216, 244);
                    g2.drawString("-0.5m", 231,260);
                    g2.drawLine(249,240, 249, 244);
                    g2.drawLine(279,240, 279, 244);
                    g2.drawString(" 0.0m", 291,260);
                    g2.drawLine(309,240, 309, 244);
                    g2.drawLine(335,240, 335, 244);
                    g2.drawString(" 0.5m", 340,260);
                    g2.drawLine(358,240, 358, 244);
                }
                else{
                    //y labels
                    g2.drawString("  1.5m",0,29 );
                    g2.drawLine(36,25, 40, 25);
                    g2.drawLine(36,57, 40, 57);
                    g2.drawString("  1.0m",0,91 );
                    g2.drawLine(36,87, 40, 87);
                    g2.drawLine(36,119, 40, 119);
                    g2.drawString("  0.5m",0,152 );
                    g2.drawLine(36,148, 40, 148);
                    g2.drawLine(36,178, 40, 178);
                    g2.drawString("  0.0m",0,214 );
                    g2.drawLine(36,210, 40, 210);
                    g2.drawLine(36,238, 40, 238);
                    //x labels
                    g2.drawString("-2.0m", 47,260);
                    g2.drawLine(65,240, 65, 244);
                    g2.drawLine(94,240, 94, 244);
                    g2.drawString("-1.5m", 105,260);
                    g2.drawLine(123,240, 123, 244);
                    g2.drawLine(154,240, 154, 244);
                    g2.drawString("-1.0m", 165,260);
                    g2.drawLine(183,240, 183, 244);
                    g2.drawLine(213,240, 213, 244);
                    g2.drawString("-0.5m", 227,260);
                    g2.drawLine(245,240, 245, 244);
                    g2.drawLine(274,240, 274, 244);
                    g2.drawString(" 0.0m", 284,260);
                    g2.drawLine(302,240, 302, 244);
                    g2.drawLine(326,240, 326, 244);
                    g2.drawString(" 0.5m", 332,260);
                    g2.drawLine(348,240, 348, 244);
                }
                if (cameraImage !=5)
                CamViewLabel.setIcon(new ImageIcon(image));
            }
            catch (IOException error){
                System.out.println("Did you pitch an exception?");
                System.out.println(error.toString());
            }
    }
    
    // Get camera 2 images, put it on Camera View with grid/noGrid, boundaries, and rulers.
    public void getCam2Image(){
        try{ 
                image2 = ImageIO.read(url2);
                Graphics2D g2 = (Graphics2D) graphics;
                if(graphics.drawImage(image2,40,0,360, 240, 0,0, 320, 240, null)){
                    if(cameraImage==2){
                            g2.setColor(Color.GREEN);
                            g2.drawLine(62,227,360,227);
                            g2.drawLine(62,0,62,227);
                    }
                    if(gridOn&& (cameraImage!= 5)){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        g2.drawLine(345,0, 345, 242);
                        g2.drawLine(320,0, 320, 242);
                        g2.drawLine(292,0, 292, 242);
                        g2.drawLine(262,0, 262, 242);
                        g2.drawLine(231,0, 231, 242);
                        g2.drawLine(199,0, 199, 242);
                        g2.drawLine(168,0, 168, 242);
                        g2.drawLine(137,0, 137, 242);
                        g2.drawLine(107,0, 107, 242);
                        g2.drawLine(78,0, 78, 242);
                        g2.drawLine(47,0, 47, 242);
                        //x direction grid
                        g2.drawLine(40,12, 360, 12);
                        g2.drawLine(40,42, 360, 42);
                        g2.drawLine(40,67, 360, 67);
                        g2.drawLine(40,96, 360, 96);
                        g2.drawLine(40,129, 360, 129);
                        g2.drawLine(40,160, 360, 160);
                        g2.drawLine(40,191, 360, 191);
                        g2.drawLine(40,223, 360, 223);
                    }
                    if(curveGridOn){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        QuadCurve2D q = new QuadCurve2D.Float();
                        q.setCurve(331,0, 355, 50,342, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(309,0, 328, 60,319, 242);
                        g2.draw(q);
                        q.setCurve(286,0, 296, 60,295, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(257,0, 268, 60,264, 242);
                        g2.draw(q);
                        q.setCurve(228,0, 235, 60,229, 242);
                        if(cameraImage !=5)g2.draw(q);
                        g2.drawLine(200,0, 200, 242);
                        q.setCurve(171,0, 167, 60,168, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(143,0, 131, 60,137, 242);
                        g2.draw(q);
                        q.setCurve(113,0, 103, 60,107, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(88,0, 70, 60,78, 242);
                        g2.draw(q);
                        q.setCurve(55,0, 38, 60,47, 242);
                        if(cameraImage !=5)g2.draw(q);
                        //x direction grid
                        q.setCurve(40,20, 200, 3,360, 20);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,45, 200, 24,360, 48);
                        g2.draw(q);
                        q.setCurve(40,70, 200, 57,360, 71);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,99, 200, 90,360, 99);
                        g2.draw(q);
                        q.setCurve(40,132, 200, 127,360, 130);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,157, 200, 161,360, 157);
                        g2.draw(q);
                        q.setCurve(40,187, 200, 197,360, 187);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,220, 200, 236,360, 218);
                        g2.draw(q);
                    }
                    if(cameraImage ==5){
                        g2.setStroke(normalStroke);
                    }
                    else{
                        g2.setStroke(thinStroke);
                    }
                    if(getCoordinate){
                    
                        int i = 0;
                        while(i<(Integer.parseInt(obstacles[0])*3)){
                            int x1=0, y1=0;
                            //if(Integer.parseInt(obstacles[i+1])==2){
                                double x = Double.parseDouble(obstacles[i+1]);
                                double y = Double.parseDouble(obstacles[i+2]);
                                x1 = getSR2X(x)+40;
                                y1 = getSR2Y(y);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                int srx = (int)(safetyRegion*75);
                                //int sry = safetyRegion*72;
                                if(srx!=0){
                                    g2.setColor(Color.GREEN);
                                    g2.drawOval(x1-25-srx,y1-25-srx,50+2*srx,50+2*srx);
                                }
                            //}
                            i=i+3;
                        }
                    }
                    
                    if(!robotInit){
                        //if(cam[0]==2){
                            int i =0;
                            while(i<3){
                                int x1=0, y1=0;
                                x1 = getSR2X(X[i])+40;
                                y1 = getSR2Y(Y[i]);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                i++;
                            }
                        //}
                    }
                }
                graphics.setColor(new Color(240,240,240));
                graphics.fillRect(0,0,40,240);
                graphics.fillRect(0,240,370,270);
                g2.setColor(Color.BLACK);
                g2.setStroke(normalStroke);
                g2.drawLine(39,0,39,242);
                g2.drawLine(38,241,360,241);
                g2.setColor(Color.BLACK);
                if(gridOn){
                    //y labels
                    g2.drawString("  0.0m",0,46 );
                    g2.drawLine(36,12, 40, 12);
                    g2.drawLine(36,42, 40, 42);
                    g2.drawLine(36,67, 40, 67);
                    g2.drawString(" -0.5m",0,100 );
                    g2.drawLine(36,96, 40, 96);
                    g2.drawLine(36,129, 40, 129);
                    g2.drawString(" -1.0m",0,164 );
                    g2.drawLine(36,160, 40, 160);
                    g2.drawLine(36,191, 40, 191);
                    g2.drawString(" -1.5m",0,227 );
                    g2.drawLine(36,223, 40, 223);
                    //x labels
                    g2.drawString("-2.0m", 60,260);
                    g2.drawLine(47,240, 47, 244);
                    g2.drawLine(78,240, 78, 244);
                    g2.drawLine(107,240, 107, 244);
                    g2.drawString("-1.5m", 119,260);
                    g2.drawLine(137,240, 137, 244);
                    g2.drawLine(168,240, 168, 244);
                    g2.drawString("-1.0m", 181,260);
                    g2.drawLine(199,240, 199, 244);
                    g2.drawLine(231,240, 231, 244);
                    g2.drawString("-0.5m", 244,260);
                    g2.drawLine(262,240, 262, 244);
                    g2.drawLine(292,240, 292, 244);
                    g2.drawString(" 0.0m", 302,260);
                    g2.drawLine(320,240, 320, 244);
                    g2.drawLine(345,240, 345, 244);
                }
                else{
                //y labels
                    g2.drawString("  0.0m",0,49 );
                    g2.drawLine(36,20, 40, 20);
                    g2.drawLine(36,45, 40, 45);
                    g2.drawLine(36,70, 40, 70);
                    g2.drawString(" -0.5m",0,104 );
                    g2.drawLine(36,99, 40, 99);
                    g2.drawLine(36,132, 40, 132);
                    g2.drawString(" -1.0m",0,161 );
                    g2.drawLine(36,157, 40, 157);
                    g2.drawLine(36,187, 40, 187);
                    g2.drawString(" -1.5m",0,224 );
                    g2.drawLine(36,220, 40, 220);
                    //x labels
                    g2.drawString("-2.0m", 60,260);
                    g2.drawLine(47,240, 47, 244);
                    g2.drawLine(78,240, 78, 244);
                    g2.drawLine(107,240, 107, 244);
                    g2.drawString("-1.5m", 119,260);
                    g2.drawLine(137,240, 137, 244);
                    g2.drawLine(168,240, 168, 244);
                    g2.drawString("-1.0m", 182,260);
                    g2.drawLine(200,240, 200, 244);
                    g2.drawLine(229,240, 229, 244);
                    g2.drawString("-0.5m", 246,260);
                    g2.drawLine(264,240, 264, 244);
                    g2.drawLine(295,240, 295, 244);
                    g2.drawString(" 0.0m", 301,260);
                    g2.drawLine(319,240, 319, 244);
                    g2.drawLine(342,240, 342, 244);
                }
                if (cameraImage !=5)
                CamViewLabel.setIcon(new ImageIcon(image));
            }
            catch (IOException error){
                System.out.println("Did you pitch an exception?");
                System.out.println(error.toString());
            }
    }
    
    // Get camera 3 images, put it on Camera View with grid/noGrid, boundaries, and rulers.
    public void getCam3Image(){
        try{ 
                image3 = ImageIO.read(url3);
                Graphics2D g2 = (Graphics2D) graphics;
                if(graphics.drawImage(image3,40,0,360, 240, 0,0, 320, 240, null)){
                    if(cameraImage==3){
                        g2.setColor(Color.GREEN);
                        g2.drawLine(316,0,316,200);
                        g2.drawLine(40,200,316,200);
                    }
                    if(gridOn&& (cameraImage!= 5)){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        g2.drawLine(345,0, 345, 242);
                        g2.drawLine(321,0, 321, 242);
                        g2.drawLine(293,0, 293, 242);
                        g2.drawLine(265,0, 265, 242);
                        g2.drawLine(234,0, 234, 242);
                        g2.drawLine(204,0, 204, 242);
                        g2.drawLine(173,0, 173, 242);
                        g2.drawLine(140,0, 140, 242);
                        g2.drawLine(110,0, 110, 242);
                        g2.drawLine(80,0, 80, 242);
                        g2.drawLine(52,0, 52, 242);
                        //x direction grid
                        g2.drawLine(40,11, 360, 11);
                        g2.drawLine(40,38, 360, 38);
                        g2.drawLine(40,68, 360, 68);
                        g2.drawLine(40,101, 360, 101);
                        g2.drawLine(40,133, 360, 133);
                        g2.drawLine(40,167, 360, 167);
                        g2.drawLine(40,198, 360, 198);
                        g2.drawLine(40,230, 360, 230);
                    }
                    if(curveGridOn){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        QuadCurve2D q = new QuadCurve2D.Float();
                        q.setCurve(335,0, 355, 50,355, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(315,0, 329, 60,330, 242);
                        g2.draw(q);
                        q.setCurve(288,0, 301, 50,303, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(261,0, 271, 50,272, 242);
                        g2.draw(q);
                        q.setCurve(232,0, 241, 50,241, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(202,0, 208, 50,208, 242);
                        g2.draw(q);
                        q.setCurve(172,0, 174, 50,174, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(142,0, 140, 50,140, 242);
                        g2.draw(q);
                        q.setCurve(113,0, 109, 50,110, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(85,0, 76, 50,80, 242);
                        g2.draw(q);
                        q.setCurve(59,0, 50, 50,52, 242);
                        if(cameraImage !=5)g2.draw(q);
                        //x direction grid
                        q.setCurve(40,17, 200, 0,360, 17);
                        g2.draw(q);
                        q.setCurve(40,43, 200, 30,360, 44);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,75, 200, 60,360, 70);
                        g2.draw(q);
                        q.setCurve(40,104, 200, 99,360, 100);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,136, 200, 130,360, 129);
                        g2.draw(q);
                        q.setCurve(40,165, 200, 174,360, 156);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,196, 200, 205,360, 185);
                        g2.draw(q);
                        q.setCurve(40,221, 200, 245,360, 210);
                        if(cameraImage !=5)g2.draw(q);
                    }
                    g2.setColor(Color.orange);
                    if(cameraImage ==5){
                        g2.setStroke(normalStroke);
                    }
                    else{
                        g2.setStroke(thinStroke);
                    }
                    if(getCoordinate){
                        int i = 0;
                        while(i<(Integer.parseInt(obstacles[0])*3)){
                            int x1=0, y1=0;
                            //if(Integer.parseInt(obstacles[i+1])==3){
                                double x = Double.parseDouble(obstacles[i+1]);
                                double y = Double.parseDouble(obstacles[i+2]);
                                x1 = getSR3X(x)+40;
                                y1 = getSR3Y(y);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                int srx = (int)(safetyRegion*75);
                                //int sry = safetyRegion*72;
                                if(srx!=0){
                                    g2.setColor(Color.GREEN);
                                    g2.drawOval(x1-25-srx,y1-25-srx,50+2*srx,50+2*srx);
                                }
                            //}
                            i=i+3;
                        }
                        //if(camX[0]>210 && camY[0]>160){
                            
                        //}
                    }
                    if(!robotInit){
                        //if(cam[0]==3){
                            int i = 0;
                            while(i<3){
                                int x1=0, y1=0;
                                x1 = getSR3X(X[i])+40;
                                y1 = getSR3Y(Y[i]);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                i++;
                            }
                        //}
                    }
                }
                graphics.setColor(new Color(240,240,240));
                graphics.fillRect(0,0,40,240);
                graphics.fillRect(0,240,370,270);
                g2.setColor(Color.BLACK);
                g2.setStroke(normalStroke);
                g2.drawLine(39,0,39,242);
                g2.drawLine(38,241,360,241);
                if(gridOn){
                    //y labels
                    g2.drawString("  0.0m",0,15 );
                    g2.drawLine(36,11, 40, 11);
                    g2.drawLine(36,38, 40, 38);
                    g2.drawString(" -0.5m",0,72 );
                    g2.drawLine(36,68, 40, 68);
                    g2.drawLine(36,101, 40, 101);
                    g2.drawString(" -1.0m",0,137 );
                    g2.drawLine(36,133, 40, 133);
                    g2.drawLine(36,167, 40, 167);
                    g2.drawString(" -1.5m",0,202 );
                    g2.drawLine(36,198, 40, 198);
                    g2.drawLine(36,230, 40, 230);
                    //x labels
                    g2.drawString(" 0.0m", 62,260);
                    g2.drawLine(52,240, 52, 244);
                    g2.drawLine(80,240, 80, 244);
                    g2.drawLine(110,240, 110, 244);
                    g2.drawString(" 0.5m", 122,260);
                    g2.drawLine(140,240, 140, 244);
                    g2.drawLine(173,240, 173, 244);
                    g2.drawString(" 1.0m", 186,260);
                    g2.drawLine(204,240, 204, 244);
                    g2.drawLine(234,240, 234, 244);
                    g2.drawString(" 1.5m", 247,260);
                    g2.drawLine(265,240, 265, 244);
                    g2.drawLine(293,240, 293, 244);
                    g2.drawString(" 2.0m", 303,260);
                    g2.drawLine(321,240, 321, 244);
                    g2.drawLine(345,240, 345, 244);
                }
                else{
                    //y labels
                    g2.drawString("  0.0m",0,21 );
                    g2.drawLine(36,17, 40, 17);
                    g2.drawLine(36,43, 40, 43);
                    g2.drawLine(36,75, 40, 75);
                    g2.drawString(" -0.5m",0,79 );
                    g2.drawLine(36,104, 40, 104);
                    g2.drawLine(36,136, 40, 136);
                    g2.drawString(" -1.0m",0,140 );
                    g2.drawLine(36,165, 40, 165);
                    g2.drawLine(36,196, 40, 196);
                    g2.drawString(" -1.5m",0,200 );
                    g2.drawLine(36,221, 40, 221);
                    //x labels
                    g2.drawString(" 0.0m", 62,260);
                    g2.drawLine(52,240, 52, 244);
                    g2.drawLine(80,240, 80, 244);
                    g2.drawLine(110,240, 110, 244);
                    g2.drawString(" 0.5m", 122,260);
                    g2.drawLine(140,240, 140, 244);
                    g2.drawLine(174,240, 174, 244);
                    g2.drawString(" 1.0m", 190,260);
                    g2.drawLine(208,240, 208, 244);
                    g2.drawLine(241,240, 241, 244);
                    g2.drawString(" 1.5m", 254,260);
                    g2.drawLine(272,240, 272, 244);
                    g2.drawLine(303,240, 303, 244);
                    g2.drawString(" 2.0m", 312,260);
                    g2.drawLine(330,240, 330, 244);
                    g2.drawLine(355,240, 355, 244);
                }
                if (cameraImage !=5)
                CamViewLabel.setIcon(new ImageIcon(image));
            }
            catch (IOException error){
                System.out.println("Did you pitch an exception?");
                System.out.println(error.toString());
            }
    }
    
    // Get camera 4 images, put it on Camera View with grid/noGrid, boundaries, and rulers.
    public void getCam4Image(){
        try{ 
                image4 = ImageIO.read(url4);
                Graphics2D g2 = (Graphics2D) graphics;
                if(graphics.drawImage(image4,40,0,360, 240, 0, 0, 320, 240, null)){
                    if(cameraImage==4){
                        g2.setColor(Color.GREEN);
                        g2.drawLine(40,21,335,21);
                        g2.drawLine(335,21,335,240);
                    }
                    if(gridOn&& (cameraImage!= 5)){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        g2.drawLine(355,0, 355, 242);
                        g2.drawLine(330,0, 330, 242);
                        g2.drawLine(302,0, 302, 242);
                        g2.drawLine(272,0, 272, 242);
                        g2.drawLine(244,0, 244, 242);
                        g2.drawLine(211,0, 211, 242);
                        g2.drawLine(177,0, 177, 242);
                        g2.drawLine(145,0, 145, 242);
                        g2.drawLine(113,0, 113, 242);
                        g2.drawLine(83,0, 83, 242);
                        g2.drawLine(55,0, 55, 242);
                        //x direction grid
                        g2.drawLine(40,19, 360, 19);
                        g2.drawLine(40,47, 360, 47);
                        g2.drawLine(40,80, 360, 80);
                        g2.drawLine(40,110, 360, 110);
                        g2.drawLine(40,145, 360, 145);
                        g2.drawLine(40,175, 360, 175);
                        g2.drawLine(40,206, 360, 206);
                        g2.drawLine(40,236, 360, 236);
                    }
                    if(curveGridOn){
                        g2.setColor(Color.YELLOW);
                        g2.setStroke(dashed);
                        QuadCurve2D q = new QuadCurve2D.Float();
                        q.setCurve(352,0, 369, 50,347, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(328,0, 340, 100,324, 242);
                        g2.draw(q);
                        q.setCurve(300,0, 313, 100,296, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(272,0, 280, 100,270, 242);
                        g2.draw(q);
                        q.setCurve(244,0, 250, 100,241, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(211,0, 214, 100,211, 242);
                        g2.draw(q);
                        q.setCurve(180,0, 176, 100,179, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(148,0, 144, 100,149, 242);
                        g2.draw(q);
                        q.setCurve(117,0, 108, 100,118, 242);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(88,0, 80, 100,89, 242);
                        g2.draw(q);
                        q.setCurve(62,0, 49, 100,61, 242);
                        if(cameraImage !=5)g2.draw(q);
                        //g2.drawLine(55,0, 55, 242);
                        //x direction grid
                        q.setCurve(40,25, 200, 0,360, 28);
                        g2.draw(q);
                        q.setCurve(40,50, 200, 35,360, 55);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,80, 200, 71,360, 83);
                        g2.draw(q);
                        q.setCurve(40,110, 200, 110,360, 114);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,142, 200, 147,360, 141);
                        g2.draw(q);
                        q.setCurve(40,173, 200, 183,360, 170);
                        if(cameraImage !=5)g2.draw(q);
                        q.setCurve(40,202, 200, 211,360, 201);
                        g2.draw(q);
                        q.setCurve(40,229, 200, 245,360, 226);
                        if(cameraImage !=5)g2.draw(q);
                    }
                    if(cameraImage ==5){
                        g2.setStroke(normalStroke);
                    }
                    else{
                        g2.setStroke(thinStroke);
                    }
                    if(getCoordinate){
                        int i = 0;
                        while(i<(Integer.parseInt(obstacles[0])*3)){
                            int x1=0, y1=0;
                            //if(Integer.parseInt(obstacles[i+1])==4){
                                double x = Double.parseDouble(obstacles[i+1]);
                                double y = Double.parseDouble(obstacles[i+2]);
                                x1 = getSR4X(x)+40;
                                y1 = getSR4Y(y);
                                g2.setColor(Color.orange);
                                g2.drawOval(x1-25,y1-25,50,50);
                                int srx = (int)(safetyRegion*75);
                                //int sry = safetyRegion*72;
                                if(srx!=0){
                                    g2.setColor(Color.GREEN);
                                    g2.drawOval(x1-25-srx,y1-25-srx,50+2*srx,50+2*srx);
                                }
                            //}
                            i=i+3;
                        }
                    }
                    if(!robotInit){
                        //if(cam[0]==4){
                        int i =0;
                        while(i<3){
                            int x1=0, y1=0;
                            x1 = getSR4X(X[i])+40;
                            y1 = getSR4Y(Y[i]);
                            g2.setColor(Color.orange);
                            g2.drawOval(x1-25,y1-25,50,50);
                            i++;
                        }
                        //}
                    }
                }
                graphics.setColor(new Color(240,240,240));
                graphics.fillRect(0,0,40,240);
                graphics.fillRect(0,240,370,270);
                g2.setColor(Color.BLACK);
                g2.setStroke(normalStroke);
                g2.drawLine(39,0,39,242);
                g2.drawLine(38,241,360,241);
                if(gridOn){
                    //y labels
                    g2.drawString("  1.5m",0,23 );
                    g2.drawLine(36,19, 40, 19);
                    g2.drawLine(36,47, 40, 47);
                    g2.drawString("  1.0m",0,84 );
                    g2.drawLine(36,80, 40, 80);
                    g2.drawLine(36,110, 40, 110);
                    g2.drawString("  0.5m",0,149 );
                    g2.drawLine(36,145, 40, 145);
                    g2.drawLine(36,175, 40, 175);
                    g2.drawString("  0.0m",0,210 );
                    g2.drawLine(36,206, 40, 206);
                    g2.drawLine(36,236, 40, 236);
                    //x labels
                    g2.drawString("-0.5m", 37,260);
                    g2.drawLine(55,240, 55, 244);
                    g2.drawLine(83,240, 83, 244);
                    g2.drawString("-0.0m", 95,260);
                    g2.drawLine(113,240, 113, 244);
                    g2.drawLine(145,240, 145, 244);
                    g2.drawString(" 0.5m", 159,260);
                    g2.drawLine(177,240, 177, 244);
                    g2.drawLine(211,240, 211, 244);
                    g2.drawString(" 1.0m", 226,260);
                    g2.drawLine(244,240, 244, 244);
                    g2.drawLine(272,240, 272, 244);
                    g2.drawString(" 1.5m", 284,260);
                    g2.drawLine(302,240, 302, 244);
                    g2.drawLine(330,240, 330, 244);
                    g2.drawString(" 2.0m", 337,260);
                    g2.drawLine(355,240, 355, 244);
                }
                else{
                    //y labels
                    g2.drawString("  1.5m",0,29 );
                    g2.drawLine(36,25, 40, 25);
                    g2.drawLine(36,50, 40, 50);
                    g2.drawString("  1.0m",0,84 );
                    g2.drawLine(36,80, 40, 80);
                    g2.drawLine(36,110, 40, 110);
                    g2.drawString("  0.5m",0,146 );
                    g2.drawLine(36,142, 40, 142);
                    g2.drawLine(36,173, 40, 173);
                    g2.drawString("  0.0m",0,206 );
                    g2.drawLine(36,202, 40, 202);
                    g2.drawLine(36,229, 40, 229);
                    //x labels
                    g2.drawString("-0.5m", 43,260);
                    g2.drawLine(61,240, 61, 244);
                    g2.drawLine(89,240, 89, 244);
                    g2.drawString(" 0.0m", 100,260);
                    g2.drawLine(118,240, 118, 244);
                    g2.drawLine(149,240, 149, 244);
                    g2.drawString(" 0.5m", 161,260);
                    g2.drawLine(179,240, 179, 244);
                    g2.drawLine(211,240, 211, 244);
                    g2.drawString(" 1.0m", 225,260);
                    g2.drawLine(243,240, 243, 244);
                    g2.drawLine(270,240, 270, 244);
                    g2.drawString(" 1.5m", 278,260);
                    g2.drawLine(296,240, 296, 244);
                    g2.drawLine(324,240, 324, 244);
                    g2.drawString(" 2.0m", 329,260);
                    g2.drawLine(347,240, 347, 244);
                }
                if (cameraImage !=5)
                CamViewLabel.setIcon(new ImageIcon(image));
            }
            catch (IOException error){
                System.out.println("Did you pitch an exception?");
                System.out.println(error.toString());
            }
    }
    
    // Calculate and reture GSM gain based on delay and curvature inputs
    public double getGSMGain(double dela, double curv){
        int c = (int)Math.round( ((double)columnOfDelay - 1.0) * dela / maxOfDelay) + 1;
        int r = (int)Math.round( ((double)rowOfCurvature - 1.0) * curv / maxOfCurvature) + 1;
        commandHistory.setText(commandHistory.getText() + "\n" + "New Gain is: " + GSMGain[c][r]
                                + ", with delay: "+ dela + " and curvature: " + curv + "\n" + "--------------\n");
         commandHistory.setText(commandHistory.getText() + "C: " + c + ", R: "+ r + "\n" + "--------------\n");
        return GSMGain[c][r];
    }
    
    // Get obstacles' world frame coordinates with input string data from base station and store them to an array with formate of: 
    // [0] = number of obstacles, [1] or [4]..[1+3*i] = world frame X of the obstacles, 
    // [2] or [5]..[2+3*i] = world frame Y of the obstacles 
    // [3] or [6]..[3+3*i]= obstacle number
    public void getObstaclesCoordinates(String obstacleData){
        obstacles = new String[16];
        obstacles = StringTokenizer.parseStringAsArray(obstacleData, " ");
        int count = Integer.parseInt(obstacles[0]);
        //int x = 0;
        //int y = 0;
        //int z = 0;
        //for(int i = 1; i<(count*3);){
            
            //x = (int)Double.parseDouble(obstacles[i]);
            //i++;
            //y = (int)Double.parseDouble(obstacles[i]);
            //i++;
            //if(x<=0 && y>=0){
                //obstacles[i-3]="1";
            //}
            //if(x<=0 && y<0){
                //obstacles[i-3]="2";
            //}
            //if(x>0 && y<0){
                //obstacles[i-3]="3";
            //}
            //if(x>0 && y>0){
                //obstacles[i-3]="4";
            //}
        //}
    }
    
    // Get trispot' world frame coordinates with input string data from base station and store them to an array with formate of: 
    // [0] or [4]..[0+4*i] = world frame # of the trispot 
    // [1] or [5]..[1+4*i] = world frame X of the trispot 
    // [2] or [6]..[2+4*i] = world frame Y of the trispot 
    // [3] or [7]..[3+4*i] = world frame angle of the trispot
    public void getRobotCoordinates(String data){
        String robotsData[] = new String[24];
        robotsData = StringTokenizer.parseStringAsArray(data, " ");
        int i = 0;
        while(i < robotsData.length){
            X[Integer.parseInt(robotsData[i])] = Double.parseDouble(robotsData[i+1]);
            Y[Integer.parseInt(robotsData[i])] = Double.parseDouble(robotsData[i+2]);
            camNewX[Integer.parseInt(robotsData[i])] = (int)TranslateX(Double.parseDouble(robotsData[i+1]));
            camNewY[Integer.parseInt(robotsData[i])] = (int)TranslateY(Double.parseDouble(robotsData[i+2]));
            oldRobotO[Integer.parseInt(robotsData[i])] = (Double.parseDouble(robotsData[i+3]));
            System.out.println("robot" + i + "x " + robotsData[i+1] + " y " + robotsData[i+2] + " o " + robotsData[i+3]);
            i = i+4;
        }
        robotInit = false;
    }
    
    // Get the Camera View X coordinate for camera 1 view with input of world frame X coordinate in cm
    public int getSR1X (double x){
        return (int)(x*223.5/6.0/30.38+268.5); 
    }
    
    // Get the Camera View Y coordinate for camera 1 view with input of world frame Y coordinate in cm
    public int getSR1Y (double y){
        return (int)(213.5 - y*187.5/5.0/30.38); 
    }
    
    // Get the Camera View X coordinate for camera 2 view with input of world frame X coordinate in cm
    public int getSR2X (double x){
        return (int)(x*222.0/6.0/30.38+276.5); 
    }
    
    // Get the Camera View Y coordinate for camera 2 view with input of world frame Y coordinate in cm
    public int getSR2Y (double y){
        return (int)(40 - y*183.0/5.0/30.38); 
    }
    
    // Get the Camera View X coordinate for camera 3 view with input of world frame X coordinate in cm
    public int getSR3X (double x){
        return (int)(x*222.0/6.0/30.38+42.0); 
    }
    
    // Get the Camera View Y coordinate for camera 3 view with input of world frame Y coordinate in cm
    public int getSR3Y (double y){
        return (int)(15.0 - y*183.0/5.0/30.38); 
    }
    
    // Get the Camera View X coordinate for camera 4 view with input of world frame X coordinate in cm
    public int getSR4X (double x){
        return (int)(x*223.0/6.0/30.38+43.0); 
    }
    
    // Get the Camera View Y coordinate for camera 4 view with input of world frame Y coordinate in cm
    public int getSR4Y (double y){
        return (int)(206.5 - y*186.0/5.0/30.38); 
    }
    
    // Get the world frame X in cm coordinate for Field View labels with input of Field View X coordinate
    public double getRealX(double x){
        double realX = (x-XRef)*400/(double)width;
        return realX;
    }
    
    // Get the world frame Y in cm coordinate for Field View labels with input of Field View Y coordinate
    public double getRealY(double y){
        double realY = ((double)YRef-y)*320/(double)height;
        return realY;
    }
    
    // Initialize all the url addresses
    public void prepare(){
           try 
        {
            url1 = new URL("http://152.14.97.66:8001/axis-cgi/jpg/image.cgi?resolution=320x240");
            //url2 = new URL("http://152.14.97.66:8002/axis-cgi/jpg/image.cgi?resolution=320x240");  
            url3 = new URL("http://152.14.97.66:8003/axis-cgi/jpg/image.cgi?resolution=320x240");
            url4 = new URL("http://152.14.97.66:8004/axis-cgi/jpg/image.cgi?resolution=320x240");  
            url2 = new URL("http://152.14.97.66:8001/axis-cgi/jpg/image.cgi?resolution=320x240");  
        }
        catch(MalformedURLException e)
        {
            System.out.println(e.toString());
        } 
        
        camNewX[0]=1000;
        camNewX[1]=1000;
        camNewX[2]=1000;
        
  }
    
    // Draw obstacles with its labels on Field View with input of string data from C++
    public void showObstacles(String obstacleData){
        Graphics graphicsView = Field.getGraphics();
        graphicsView.setColor(Color.YELLOW);
        graphicsView.fillOval((int)(XRef - 3), (int)(YRef - 3),6,6);
        obstaclesEX = new String[15];
        obstaclesEX = StringTokenizer.parseStringAsArray(obstacleData, " ");
        int count = Integer.parseInt(obstaclesEX[0]);
        int x = 0;
        int y = 0;
        int z = 0;
        for(int i = 1; i<(count*3);){
            z = Integer.parseInt(obstaclesEX[i]);
            i++;
            x = (int)Double.parseDouble(obstaclesEX[i]);
            i++;
            y = (int)Double.parseDouble(obstaclesEX[i]);
            i++;
            //System.out.println("xyz " + x + " " + y + " " + z);
            DrawObstacle(x,y,z);
        }
        graphicsView.dispose();
        FieldViewLabel.setIcon(new ImageIcon(Field));
    }
    
    // Set the values for GSM gain table
    public void setGSMGainTable(){
        int c = 0; int r = 0;
        while(c<columnOfDelay){
            while(r<rowOfCurvature){
                GSMGain[c][r] = 1;
                //System.out.println("GSMGain[" + c + "][" + r + "]=" + GSMGain[c][r]);
                r++;
            }
            c++;
            r=0;
        }
    }
    // Calculate the world frame X in cm to Field View X coordinate (int input, int output)
    public int TranslateX (int x) {
        return (int)((double)XRef + (double)x*((double)width/400.0));
        }
    
    // Calculate the world frame Y in cm to Field View Y coordinate (int input, int output)
    public int TranslateY (int y) {
        return (int)((double)YRef - (double)y*((double)height/320.0));
    }
    
    // Calculate the world frame X in cm to Field View X coordinate (double input, double output)
    public double TranslateX (double x) {
        return (double)XRef + x*((double)width/400.0);
    }
    
    // Calculate the world frame Y in cm to Field View Y coordinate (double input, double output)
    public double TranslateY (double y) {
        return (double)YRef - y*((double)height/320.0);
    }
    
    // Round all the double value with two decimal points
    public double roundTwoDecimal(double value){
        int intValue = (int)(value*100);
        return ((double)intValue)/100;
        
    }
    
    // Update table objects information from C++
    public void updateTableObjects(String info) {
        int k = 1;
        String[] objects = StringTokenizer.parseStringAsArray(info, " ");
        int i = Integer.parseInt(objects[0]);
        for(int j=1;j<i*3;j=j+3){            
            TableData.setValueAt("Object " + objects[j+2], k+7,0);
            TableData.setValueAt(objects[j], k+7,1);
            TableData.setValueAt(objects[j+1], k+7,2);
            k++;
        }
    }
    
    // Update table with information from Base station
public void updateTableBase(String[] info) {
        TableData.setValueAt(info[2], 5,1);
        TableData.setValueAt(info[3], 5,2);
        TableData.setValueAt(info[4], 1,1);
        TableData.setValueAt(info[5], 1,2);
        TableData.setValueAt(info[6], 3,1);
        TableData.setValueAt(info[7], 3,2);
        TableData.setValueAt(info[8], 2,1);
        TableData.setValueAt(info[9], 2,2);
        TableData.setValueAt(info[10], 4,1);
        TableData.setValueAt(info[11], 4,2);
        TableData.setValueAt(info[12], 0,3);
    }
    
    // Update table trispot informatioin from C++
    public void updateTableRobot() {
        System.out.println("update table for robot");
        TableData.setValueAt("Tri-spot" + currentRobot, 0,0);
        TableData.setValueAt(camNewX[currentRobot], 6,1);
        TableData.setValueAt(camNewY[currentRobot], 6,2);
        TableData.setValueAt(oldRobotO[currentRobot], 6,3);        
    }
   
    //This function performs an emergency stop on all UVs
    private void EmergencyStop() {
        //Code here to stop the vehicles
        System.out.println("Emergency Stop Performed");
        
        String send = "spotselect "+SPOT_ID1+" "+BROADCAST_PORT2+" "+PORT2;
        commandtoBase(send);
        try {Thread.sleep(100);}
        catch(InterruptedException e) {System.out.println(e);}
        commandtoBase("spotcommand s 0 0");
        try {Thread.sleep(100);}
        catch(InterruptedException e) {System.out.println(e);}
        send = "spotselect "+SPOT_ID2+" "+BROADCAST_PORT2+" "+PORT2;
        commandtoBase(send);
        try {Thread.sleep(100);}
        catch(InterruptedException e) {System.out.println(e);}
        commandtoBase("spotcommand s 0 0");
    }

 
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton Cam1Button;
    private javax.swing.JButton Cam2Button;
    private javax.swing.JButton Cam3Button;
    private javax.swing.JButton Cam4Button;
    private javax.swing.JLabel CamViewLabel;
    private javax.swing.JLabel ControlPanel;
    private javax.swing.JButton CoordinateLabelButton;
    private javax.swing.JLabel DelayGemLabel;
    private javax.swing.JTextField DelayGenTextField;
    private javax.swing.JLabel FieldViewLabel;
    private javax.swing.JPanel FieldViewPanel;
    private javax.swing.JComboBox GSMCombo;
    private javax.swing.JLabel GSMLabel;
    private javax.swing.JButton GetPathButton;
    private javax.swing.JButton GridOnOffButton;
    private javax.swing.JButton ManualInputButton;
    private javax.swing.JTextField ManualInputTextField;
    private javax.swing.JInternalFrame ManualInputWindow;
    private javax.swing.JButton MoreButton;
    private javax.swing.JComboBox PathPlanningCombo;
    private javax.swing.JRadioButton RefreshDelayOn;
    private javax.swing.JTextField RefreshRateInputField;
    private javax.swing.JPanel RobotControlPanel;
    private javax.swing.JButton RunButton;
    private javax.swing.JLabel SafetyRegionLabel;
    private javax.swing.JTextField SafetyRegionTextField;
    private javax.swing.JTable TableData;
    private javax.swing.JPanel TablePanel;
    private javax.swing.JButton Trispot0Button;
    private javax.swing.JButton Trispot1Button;
    private javax.swing.JButton Trispot2Button;
    private javax.swing.JButton Trispot3Button;
    private javax.swing.JButton allCamButton;
    private javax.swing.JComboBox appletbaseCombo;
    private javax.swing.JComboBox basecppnetwork;
    private javax.swing.JLabel camLabel;
    private javax.swing.JButton clearButton;
    private javax.swing.JTextField commandEntry;
    private javax.swing.JTextPane commandHistory;
    private javax.swing.JButton curveGrid;
    private javax.swing.JButton gridButton;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JButton refreshButton;
    // End of variables declaration//GEN-END:variables
     
}
   
		
		
		


