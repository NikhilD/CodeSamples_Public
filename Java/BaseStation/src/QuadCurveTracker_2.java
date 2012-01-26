/*
 * QuadCurveTracker.java
 *
 * Created on April 10, 2008, 1:30 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.sunspotworld.demo;


import java.lang.Math;
/**
 *
 * @author Unnati, BK, Nikhil
 */
public class QuadCurveTracker_2 {
    public static final int MAXPOINTS=512;
    public static final byte JOHNNY6=1;
    public static final byte ANA=2;
    public static final byte TRISPOT=3;
    public static final byte ROBOTOFF=4;   
   
    public static int[][] path=new int[MAXPOINTS][2];
    public static int number_of_points;
   
    double robotX, robotY, robotO;
    public static double Smax;        // Maximum lookahead distance
    public static double rho;             // coefficient for curvature
    double alpha;           // roughly the max speed
    public static double Kappa;           // roughly path curvature
    int findRefPoint;       // index of current reference point
    double speed;           // linear speed of UV, in cm/sec
    double turnRate;        // turn rate of UV, in rad/sec
    public static double turnScale = 5;  //this value was 2 in Yixin's code
    double endRadius;    // the circle to check whether UV is at destination
    double refTheta;
   
   
    /** Creates a new instance of QuadCurveTracker */
    public QuadCurveTracker_2() {
    }

// Constructor, set algorithm parameters and take path input
public void Init(byte ROBOT_TYPE)
{
    switch(ROBOT_TYPE)
    {
    case JOHNNY6:
        Smax = 0.775;   
        rho = 0.005;       
        alpha = 0.36;
        break;
    case ANA:
        Smax = 0.2;
        rho = 0.5;
        alpha = 5.0;
        break;
    case TRISPOT:
        Smax = 0.2;//0.2
        rho  = 1.5;
        alpha = 0.3;
        break;
    case ROBOTOFF:
        Smax = 0.775;   
        rho = 0.005;
        alpha = .36;       
    }

    endRadius   = 20;
    findRefPoint = 0;
    Kappa       = 0;
}

public void printPath()
{
    for(int i = 0; i< number_of_points;i++)
        System.out.println(" pathx: "+path[i][0]+" pathy: "+path[i][1]);
}

// Find nearest point on the path and return the index
private int FindNearPoint(double x, double y)
{
    double dist_to_path = 1e6;
    double temp;
    int findNearPoint = 0;

    // Search toward the starting point and choose the one closest to current position
    for(int i=findRefPoint; i>=0; i--)
    {
        //System.out.println("x: "+x+" y: "+y+" pathx: "+path[i][0]+" pathy: "+path[i][1]);
        temp = Distance(x, y, path[i][0],path[i][1]);
        //System.out.println("robotx: " + x + " temp: " + temp);
        if( temp < dist_to_path )
        {
            findNearPoint = i;
            dist_to_path = temp;
        }
    }
    return findNearPoint;
}

// Find the next reference point based on look ahead distance
private void FindRefPoint(double x, double y)
{
    System.out.println("**************************************************************************kappa: " + Kappa);
    double dist_ahead = Smax/(1+(rho*(Kappa/100)));    // look ahead distance
    //System.out.println("distahead; " + dist_ahead);
    dist_ahead = dist_ahead;  //meters
    int i = 0;
    int cur = FindNearPoint(x,y);
    //System.out.println("lookahead distance: " + dist_ahead + " near point: " + cur);
   
    while( (Distance(x,y, path[cur+i][0], path[cur+i][1]))/100 < dist_ahead ) {
        i++;
        if(i >= number_of_points) break;
    }
    //findRefPoint = cur+i>indRefPoint ? (cur+i>path->number_of_point-1 ? path->number_of_point-1 : cur+i) : indRefPoint;
        if ((cur+i)>findRefPoint){
            if((cur+i)>number_of_points) findRefPoint = number_of_points-1;
            else findRefPoint = cur+i;                            
        }else findRefPoint = findRefPoint;
   
        //System.out.println("index of refpoint: " + i + " potential refpoint: " + (cur+i) + " actual refpoint: "  + findRefPoint);
    //return findRefPoint;
}

// Calculate control command
public void Exec(double inrobotX, double inrobotY, double inrobotO)
{
    robotX = inrobotX;
    robotY = inrobotY;
    robotO = inrobotO;
    //System.out.println("robotx: " + robotX+ "roboty: "+robotY+" theta: "+robotO);
    double delta_x,delta_y;
    double e_x,e_y;
    double cosTmp,sinTmp;
    double A,K;

    if( number_of_points!=0 )               
    {
        // if UV is within small distance to destination, STOP
        //System.out.println("distance to end: "+Distance(path[number_of_points-1][0],path[number_of_points-1][1], robotX,robotY));
        if( Distance(path[number_of_points-1][0],path[number_of_points-1][1], robotX,robotY) < endRadius )
        {
            speed    = 0;
            turnRate = 0;
        }
        else                   
        {
            FindRefPoint(robotX, robotY);
            System.out.println("refpoint is: "+path[findRefPoint][0]+" "+path[findRefPoint][1]);
            delta_x = (double)(path[findRefPoint][0] - robotX);    //in cm
            delta_y = (double)(path[findRefPoint][1] - robotY);    //in cm
            //System.out.println("deltax: " + delta_x + " deltay: " + delta_y);
            cosTmp  = Math.cos(robotO);
            sinTmp  = Math.sin(robotO);
            //System.out.println("costemp: " + cosTmp + " sintemp: " + sinTmp);
            e_x =  cosTmp*delta_x + sinTmp*delta_y;
            e_y = -sinTmp*delta_x + cosTmp*delta_y;
           // System.out.println("ex: " + e_x + " ey: "+e_y);
           /* Delta cal*/
            
            
            if (e_x > 0)                       
            {
                A = e_y/(e_x*e_x);
                K = alpha/(0.01+Math.abs(A));
            }
            else
            if (e_x < 0)
            {
                A = -e_y/(e_x*e_x);
                K = -alpha/(0.01+Math.abs(A));
            }
            else
            {
                A = 0;
                K = 0;
            }

                        Kappa = Math.abs(A);
            speed = K;  //centimeters/s
            turnRate = turnScale*A*K;               
            //speed = 15;
            //refTheta = Math.atan(delta_y/delta_x);
           // if(delta_x < 0 && delta_y < 0) refTheta = refTheta*(-1);
            //turnRate=0.5*(refTheta-robotO);
        }
    }
    else
    {
        speed = 0;
        turnRate = 0;
    }
}
/*
Coordinate GetRefPoint()
{
    return path->point[indRefPoint];
}
*/

public double getSpeed(){
    return speed;
}

public double getturnRate(){
    return turnRate;
}

private double Distance(double x1, double y1, double x2, double y2)
{
    return Math.sqrt((double)((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)));
}
   
   
   
}