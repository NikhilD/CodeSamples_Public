#include "../hdr/common.h"
#include "../hdr/Motion_funcs.h"
#include "../hdr/Wifi_funcs.h"
#include "../hdr/Algo_funcs.h"

extern int gInd, oldRSSI[4], status;
extern char LEADMAC[32], FOLLOWMAC[32];
extern bool print;

void followLeader(PlayerClient *robot, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *wifi, int FL_ITER){
	cout << "following" << endl;
	double dummy_dist, dummy_angle, travel; 
	double newspeed, newturnrate, nspeed, ntrate, angle;	
	int links=0, i=0, iters, g=0;
	robot_pos rself, rlink, point;	
	
	for(g=0; g<FL_ITER; g++){
		robot->Read();			
//		for(unsigned int j=0; j<5000; j++){
			wifiChkMAC(wp, &links, wifi, &LEADMAC[0]);				//uses LEADMAC to get data from the Leader
//			for(unsigned int h=0; h<5000; h++){}
//		}		
		if((wifi->RSS==0) || (links==0)){
			cout << "f0" << endl;
			print = false;
			break;
		}
		getName(wifi->MAC, wifi->robotLink);
		simp.GetPose2d((wifi->robotLink), rlink.x, rlink.y, rlink.yaw);
		simp.GetPose2d((wifi->robotSelf), rself.x, rself.y, rself.yaw);
		
		closestPoint(&point, &rlink, &rself, &dummy_dist, &angle, 12);
		if(chkTravel(simp, &point, (wifi->robotSelf), 0.0009))return;
//		chgOrient(robot, lp, pp, &point, &rself);
//		simp.GetPose2d((wifi->robotSelf), rself.x, rself.y, rself.yaw);
		
		dummy_angle = (angle - rself.yaw);
		
		calcArcDist(&dummy_angle, &dummy_dist, &travel);
		if(dummy_angle>PI)dummy_angle = dummy_angle - (2*PI);
		if(dummy_angle<(-PI))dummy_angle = (2*PI) - dummy_angle;
		
		newspeed = dummy_dist*SPEEDFACTOR;	
		newturnrate = dtor((rtod(dummy_angle))/(TURNFACTOR/3));
		
//		if(pointLineTest(&point, &rself)==RIGHT)newturnrate = -newturnrate;
		motionLimits(&newspeed, &newturnrate);
		iters = MOVE_ITER/3;
//		if(chkTravel(simp, &rlink, (wifi->robotLink), 0.009))iters = 0;		
		
		// Use when moving robot by following an arc!
		/*		 
		calcArcDist(&dummy_angle, &dummy_dist, &travel);		
		newspeed = travel*SPEEDFACTOR;	
		newturnrate = dtor((2*(rtod(dummy_angle)))/TURNFACTOR);
		motionLimits(&newspeed, &newturnrate);		
		for(i=0; i<iters; i++){
			robot->Read();
			moveRobot(lp, pp, &newspeed, &newturnrate);
			if(chkTravel(simp, &point, (wifi->robotSelf), 0.009))iters = iters-3;
			if(!chkTravel(simp, &rlink, (wifi->robotLink), 0.05)){
//				cout << "broken by moving leader " << i << endl;
				break;
			}
		}
		*/
		
		// the robot turns to the desired angle and then travels the desired distance. 
		nspeed = 0;
		ntrate = newturnrate;		
		for(i=0; i<iters; i++){
			robot->Read();				
			moveRobot(lp, pp, &nspeed, &ntrate);
			if(!chkTravel(simp, &rlink, (wifi->robotLink), 0.05)){
//				cout << "broken by moving leader " << i << endl;
				break;
			}
		}
		iters = MOVE_ITER;
		nspeed = newspeed;
		ntrate = 0;
		for(i=0; i<iters; i++){
			robot->Read();				
			moveRobot(lp, pp, &nspeed, &ntrate);
			if(chkTravel(simp, &point, (wifi->robotSelf), 0.009))iters = iters-3;
			if(!chkTravel(simp, &rlink, (wifi->robotLink), 0.05)){
//				cout << "broken by moving leader " << i << endl;
				break;
			}
		}
		
		newspeed = 0;
		newturnrate = 0;
		moveRobot(lp, pp, &newspeed, &newturnrate);
		
	}	
	
	return;
}

void leadFollower(PlayerClient *robot, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *wifi, int LD_ITER){
	cout << "leading" << endl;
	
	double newspeed=0, newturnrate=0;
	int links=0, k=0, iter = 0, g=0;
	
	for(g=0; g<LD_ITER; g++){
		robot->Read();
//		iter = 1;
//		for(unsigned int i=0; i<5000; i++){
			wifiChkMAC(wp, &links, wifi, &FOLLOWMAC[0]);				//uses FOLLOWMAC to get data from the Follower
//			for(unsigned int h=0; h<5000; h++){}
//		}
		if((wifi->RSS==0) || (links==0)){
			cout << "l0" << endl;
			print = false;
			break;
		}		
		if((wifi->RSS>=(DSRD_RSS-1)) && (iter==1) && (status==LEADER)){			
			Wander(&newspeed, &newturnrate, STRAIGHT);
			iter = 30;			
		}
		else {
			newspeed = 0;
			newturnrate = 0;
			iter = 1;
		}
		
		for(k=0; k<iter; k++){
			robot->Read();				
			moveRobot(lp, pp, &newspeed, &newturnrate);
		}		
	}
	return;	
}

void leadnfollow(PlayerClient *robot, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *wifi){
	cout << "leadnfollow" << endl;
	followLeader(robot, wp, lp, pp, simp, wifi, 1);
	leadFollower(robot, wp, lp, pp, simp, wifi, 20);
	return;
}

void calcArcDist(double *angle, double *distance, double *arclength){
	double int_angle, radius, dummy;
	
//	if((*angle)>90)int_angle = 180-(*angle);
//	else 
	int_angle = rtod(*angle);
	
	radius = (*distance)/(2*(cos(dtor(90-int_angle))));
	dummy = radius*(2*dtor(int_angle));
	
	if((*angle)>90)(*arclength) = (2*PI*radius)-dummy;
	else (*arclength) = dummy;
	
	return;
}
