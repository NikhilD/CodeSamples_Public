#include "../hdr/common.h"
#include "../hdr/Motion_funcs.h"

void Wander(double *newspeed, double *newturnrate, int dirn){
	double maxSpeed = 0.3;
	int maxTurn = 45;
	double fspeed, tspeed;
	
	//fspeed is between 0 and 10
	fspeed = rand()%11;

	//(fspeed/10) is between 0 and maxSpeed
	fspeed = (fspeed/10)*maxSpeed;

	tspeed = rand()%(2*maxTurn);
	tspeed = tspeed-maxTurn;
	*newspeed = fspeed;
	if(dirn==STRAIGHT)
		*newturnrate = 0;
	else
		*newturnrate = dtor(tspeed);
		
	return;
}

void moveRobot(LaserProxy &lp, Position2dProxy &pp, double *newspeed, double *newturnrate){
	laserAvoid(lp, newspeed, newturnrate);
  	pp.SetSpeed(*newspeed, *newturnrate);	    
}

void laserAvoid(LaserProxy &lp, double *newspeed, double *newturnrate){
	double trate = 0, l = 0, r = 0;
	
	double minR = lp.GetMinRight();
   	double minL = lp.GetMinLeft();
   
   	if((minR < 0.7) || (minL < 0.7)){
   		l = (1e5*minR)/500-100;
	   	r = (1e5*minL)/500-100;
	   	
	   	if (l > 100)l = 100;
	   	if (r > 100) r = 100;

	   	*newspeed = (r+l)/1e3;

 	 	trate = (r-l);
	   	trate = limit(trate, -40.0, 40.0);
   		*newturnrate = dtor(trate);   		
   	}   	
   	return;
}

void motionLimits(double *newspeed, double *newturnrate){
	if(*newspeed<lospeed)		(*newspeed) = lospeed;//(*newspeed) = -(*newspeed);
	if(*newspeed>hispeed)		(*newspeed) = hispeed;
	if(*newturnrate<loturnrate)	(*newturnrate)=loturnrate;
	if(*newturnrate>hiturnrate)	(*newturnrate)=hiturnrate;
}

bool chkTravel(SimulationProxy &simp, robot_pos *point, char *ID, double buffer){
	bool dummy;
	char robotID[10];
	robot_pos robot;
	
	for(int j=0; j<10; j++){
		robotID[j] = ID[j]; 
	}	
	 
	simp.GetPose2d(robotID, robot.x, robot.y, robot.yaw);
	if ((robot.x>((point->x)-buffer)) && (robot.x<((point->x)+buffer)))
		dummy = true;
	else if ((robot.y>((point->y)-buffer)) && (robot.y<((point->y)+buffer)))
		dummy = true;
	else
		dummy = false;
			
	return dummy;
}

void chgOrient(PlayerClient *robotc, LaserProxy &lp, Position2dProxy &pp, robot_pos *point, robot_pos *robot){
	unsigned char orientn, directn;
	double newspeed, newturnrate;
	int iters=0;
	
	if ((robot->yaw >= 0) && (robot->yaw <= dtor(90)))				orientn=1;
	else if ((robot->yaw > dtor(90)) && (robot->yaw <= dtor(180)))	orientn=2;
	else if ((robot->yaw < 0) && (robot->yaw >= -dtor(90)))			orientn=3;
	else															orientn=4;
	
	if ((robot->x >= point->x) && (robot->y >= point->y))			directn=1;
	else if ((robot->x <= point->x) && (robot->y >= point->y))		directn=2;
	else if ((robot->x >= point->x) && (robot->y <= point->y))		directn=3;
	else															directn=4;
	
	newspeed = 0;	
	iters = MOVE_ITER;
		
	if((directn==1) && (orientn==1))		newturnrate = dtor((180)/TURNFACTOR);		
	else if ((directn==2) && (orientn==2))	newturnrate = dtor((180)/TURNFACTOR);
	else if ((directn==3) && (orientn==3))	newturnrate = dtor((180)/TURNFACTOR);
	else if ((directn==4) && (orientn==4))	newturnrate = dtor((180)/TURNFACTOR);
	else iters = 0;
	
	for(int i=0; i<iters; i++){
		robotc->Read();
		moveRobot(lp, pp, &newspeed, &newturnrate);
	}
}

