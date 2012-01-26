#include "../hdr/common.h"
#include "../hdr/Wifi_funcs.h"

extern bool print;
extern int gInd, oldRSSI[4];
extern char LEADMAC[32], FOLLOWMAC[32];

void wifiColl(WiFiProxy &wp, int *links, wifi_link *wifi){
	*links = wp.GetLinkCount();
	for(int i=0; i<(*links); i++){		
		wifi[i].RSS = wp.GetLinkQuality(i);
		wifi[i].FRQ = wp.GetLinkFreq(i);
		strncpy(wifi[i].IP, wp.GetLinkIP(i), 32);
		strncpy(wifi[i].MAC, wp.GetLinkMAC(i), 32);
	}
   	return;   
}


void wifiChkMAC(WiFiProxy &wp, int *links, wifi_link *wifi, char *MACID){
	char MAC[32];
	for(int j=0; j<32; j++){
		MAC[j] = MACID[j]; 
	}
	*links = wp.GetLinkCount();
	for(int i=0; i<(*links); i++){
		if(strncmp(wp.GetLinkMAC(i), MAC, 17)==0){
			wifi->RSS = wp.GetLinkQuality(i);
			wifi->FRQ = wp.GetLinkFreq(i);
			strncpy(wifi->IP, wp.GetLinkIP(i), 32);
			strncpy(wifi->MAC, wp.GetLinkMAC(i), 32);
			break;
		}
		else{
			wifi->RSS = 0;
			wifi->FRQ = 0;
			strncpy(wifi->IP, dummy_IP, 32);
			strncpy(wifi->MAC, dummy_MAC, 32);
		}
	}
   	return;   
}

void wifiChkIP(WiFiProxy &wp, int *links, wifi_link *wifi){
	*links = wp.GetLinkCount();
	for(int i=0; i<(*links); i++){
		if(strncmp(wp.GetLinkIP(i), IP0, 32)==0){
			wifi->RSS = wp.GetLinkQuality(i);
			wifi->FRQ = wp.GetLinkFreq(i);
			strncpy(wifi->IP, wp.GetLinkIP(i), 32);
			strncpy(wifi->MAC, wp.GetLinkMAC(i), 32);
			break;
		}
		else{
			wifi->RSS = 0;
			wifi->FRQ = 0;
			strncpy(wifi->IP, dummy_IP, 32);
			strncpy(wifi->MAC, dummy_MAC, 32);
		}
	}
   	return;   
}


void getName(char *MAC, char *name){
	char robot[10] = "robot";
	robot[5] = MAC[15];
	robot[6] = MAC[16];
	strcpy(name, robot);
	return;
}

void getDistID(SimulationProxy &simp, wifi_link *wifi, double *sim_dist, double *wifi_dist){

	double sx, sy, lx, ly, x, y, dummy, plc = 80, power_dbm = 4.77; // power_dbm = 10*log10(stg_model->power)
	simp.GetPose2d((wifi->robotSelf), sx, sy, dummy);
	simp.GetPose2d((wifi->robotLink), lx, ly, dummy);
	
	x = sx - lx;
	y = sy - ly;
	
	dummy = (x*x) + (y*y);
	*sim_dist = sqrt(dummy);
	
	dummy = (-(wifi->RSS) + power_dbm + 28 - (20*(log10(wifi->FRQ)))) / plc;		// inverting raytrace model to get distance from RSS. 
//	dummy = (-(wifi->RSS) + power_dbm - 32.44177 + (20*(log10(wifi->FRQ))))/20;			// inverting friis model to get distance from RSS.
	sx = pow(10, dummy);
	*wifi_dist = sx;//*1000;
	
	return;	
}

int parseMAC(int links, wifi_link *wifi){
	int tens[links], units[links], ID[links], folldone=0, leaddone=0;
	int dummy[2] = {0, 0};
	for (int i=0; i<links; i++){
		tens[i] = wifi[i].MAC[15] - '0';		// converting char/string to int
		units[i] = wifi[i].MAC[16] - '0';		// converting char/string to int
		ID[i] = tens[i]*10 + units[i];
		if((ID[i] > gInd) && folldone==0){
			make_MAC(LEADMAC, tens[i], units[i]);		// MAC of the robot that 'I' follow
			oldRSSI[LEADER] = wifi[i].RSS;
			folldone = 1;
			dummy[0] = FOLLOWER;
		}
		else if((ID[i] < gInd) && leaddone==0){
			make_MAC(FOLLOWMAC, tens[i], units[i]);		// MAC of the robot that follows 'me'
			oldRSSI[FOLLOWER] = wifi[i].RSS;
			leaddone = 1;
			dummy[1] = LEADER;
		}
	}
	return (dummy[0] + dummy[1]);
}

int parseMAC_tmp(int links, wifi_link *wifi){
	int dummy[2] = {0, 0};
	for (int i=0; i<links; i++){
		if(strncmp(wifi[i].MAC, LEADMAC, 17)==0){			
			oldRSSI[LEADER] = wifi[i].RSS;			
			dummy[0] = FOLLOWER;
		}
		else if(strncmp(wifi[i].MAC, FOLLOWMAC, 17)==0){			
			oldRSSI[FOLLOWER] = wifi[i].RSS;
			dummy[1] = LEADER;
		}
	}
	return (dummy[0] + dummy[1]);
}
