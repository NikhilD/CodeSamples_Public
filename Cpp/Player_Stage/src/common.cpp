#include "../hdr/common.h"

int pointLineTest(robot_pos *point, robot_pos *robot){
	double test;
	int dummy;
	robot_pos origin;
	
	origin.x = 0;
	origin.y = 0;
	
	test = ((point->y - 0)*(origin.x - robot->x)) - ((point->x - 0)*(origin.y - robot->y));
	
	if(test<0)dummy=RIGHT;
	else if(test>0)dummy=LEFT;
	else dummy=ONIT;
	
	return dummy;
}

void closestPoint(robot_pos *dest_pt, robot_pos *rlink, robot_pos *rself, double *dist, double *angle, int num_points){
	double tmpx[num_points], tmpy[num_points], dista[num_points];
	robot_pos point[num_points];
	double temp=1000, int_angle;
	int index=0; 
		
	for(int i=0; i<num_points; i++){		
		point[i].x = DSRD_DIST*(cos(dtor(30*i))) + rlink->x;
		point[i].y = DSRD_DIST*(sin(dtor(30*i))) + rlink->y;
		tmpx[i] = point[i].x - rself->x;
		tmpy[i] = point[i].y - rself->y;
		dista[i] = (tmpx[i]*tmpx[i]) + (tmpy[i]*tmpy[i]);
		dista[i] = sqrt(dista[i]);
		if(dista[i] < temp){
			temp = dista[i];
			index = i;
		}
	}
	int_angle = atan2(tmpy[index], tmpx[index]);
	*angle = int_angle;
	
	dest_pt->x = point[index].x;
	dest_pt->y = point[index].y;
	
	*dist = dista[index];
	
	return;
}
