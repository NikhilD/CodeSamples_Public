#ifndef COMMON_H_
#define COMMON_H_

#include <libplayerc++/playerc++.h>
#include <iostream>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

using namespace PlayerCc;
using namespace std;

#define ROBOT "robot%d%d"
#define DUMMYMAC "08:00:20:ae:fd:%d%d"
#define make_name(a,b,c) sprintf(a,ROBOT,b,c)
#define make_MAC(a,b,c) sprintf(a,DUMMYMAC,b,c)

#define LEADER 		2
#define FOLLOWER 	1
#define LEADFOLLOW 	3 

#define STRAIGHT 	1
#define RANDOM		0

#define RIGHT	2
#define LEFT	1
#define ONIT	0

#define hispeed		0.5
#define lospeed		-0.5
#define hiturnrate 	1.5707
#define loturnrate -1.5707

#define PLC 80.0
#define POWER_DBM 4.77
#define PI 3.14159
#define DSRD_RSS -55.0

// inverting raytrace model to get distance from RSS.
#define EXP_TERM ((-DSRD_RSS + POWER_DBM + 28 - (20*(log10(2450.0)))) / PLC)
#define DSRD_DIST pow(10, EXP_TERM)

#define MOVE_ITER 90
#define TURNFACTOR ((4.0*MOVE_ITER)/42.0)
#define SPEEDFACTOR ((0.3*36.0)/MOVE_ITER)


#define IP0 "192.168.0.2"
#define dummy_MAC "08:00:20:ae:ae:ae"
#define dummy_IP "192.168.200.200"

typedef struct{
	char IP[32];
	char MAC[32];
	double FRQ;
	int RSS;
	char robotLink[10];
	char robotSelf[10];
} wifi_link;

typedef struct{
	double x;
	double y;
	double yaw;
} robot_pos;

int pointLineTest(robot_pos *, robot_pos *);
void closestPoint(robot_pos *, robot_pos *, robot_pos *, double *, double *, int);

#endif /*COMMON_H_*/
