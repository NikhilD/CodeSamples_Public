#include "../hdr/common.h"
#include "../hdr/Motion_funcs.h"
#include "../hdr/Algo_funcs.h"
#include "../hdr/Wifi_funcs.h"
#include "../hdr/Follow_main.h"
#include "../hdr/args.h"



int main(int argc, char **argv){
	parse_args(argc,argv);
	
  	// we throw exceptions on creation if we fail
  	try{
  		robot_pos rself;
  		PlayerClient robot(gHostname, gPort);  		
    	Position2dProxy pp(&robot, gIndex);
    	LaserProxy lp(&robot, gIndex);
	 	WiFiProxy wp(&robot, gIndex);
	 	SimulationProxy simp(&robot, 0);
	 	gInd = gIndex;
	 	
	 	srand(time(NULL));
	 	
	 	wifi_link wifi[20];
	 				
    	pp.SetMotorEnable (true);
    	
    	for(int i=0; i<5; i++){
    		make_name(wifi[i].robotSelf, (gInd/10), (gInd%10));
    	}
    	
		switch(gIndex){
			case 0:
				make_MAC(LEADMAC, 0, 1);				
				break;
			case 1:
				make_MAC(FOLLOWMAC, 0, 0);
				make_MAC(LEADMAC, 0, 2);		
				break;				
			case 2:
				make_MAC(FOLLOWMAC, 0, 1);
				break;
			default: break;
		}
    	robots(&robot, wp, lp, pp, simp, &wifi[0]);		
  	}
  	catch (PlayerCc::PlayerError e){
  		cerr << e << endl;
    	return -1;
  	}
}

void robots(PlayerClient *robot, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *wifi){
	
	int links=0, i=0, j=0; 	 
	double newspeed, newturnrate, rateRSS;
		
	while(true){
		robot->Read();
		wifiColl(wp, &links, wifi);
		if(links>=1){
//			status = parseMAC(links, wifi);
			status = parseMAC_tmp(links, wifi);
//			cout << status << endl;
			newspeed = 0;
			newturnrate = 0;
			moveRobot(lp, pp, &newspeed, &newturnrate);
		}
		switch(status){
			case FOLLOWER:
				followLeader(robot, wp, lp, pp, simp, wifi, 20);
				cout << "flout" << endl;
				newspeed = 0;
				newturnrate = 0;
				break;
			case LEADER:
				leadFollower(robot, wp, lp, pp, simp, wifi, 20);
				cout << "lfout" << endl;
				newspeed = 0;
				newturnrate = 0;
				break;
			case LEADFOLLOW:
			  	leadnfollow(robot, wp, lp, pp, simp, wifi);
			  	cout << "lnfout" << endl;
			  	newspeed = 0;
				newturnrate = 0;
			  	break;
			default:
//				cout << "no relevant links..." << endl;
				Wander(&newspeed, &newturnrate, RANDOM);
				break;  				  	
		}
		status = 0;
		moveRobot(lp, pp, &newspeed, &newturnrate);
	}	
	return;	   		
}




