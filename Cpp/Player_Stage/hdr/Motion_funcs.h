#ifndef MOTION_FUNCS_H_
#define MOTION_FUNCS_H_

void laserAvoid(LaserProxy &lp, double *newspeed, double *newturnrate);
void Wander(double *newspeed, double *newturnrate, int );
void moveRobot(LaserProxy &lp, Position2dProxy &pp, double *, double *);
void motionLimits(double *, double *);
bool chkTravel(SimulationProxy &simp, robot_pos *, char *, double );
void chgOrient(PlayerClient *robot, LaserProxy &lp, Position2dProxy &pp, robot_pos *, robot_pos *);
#endif /*MOTION_FUNCS_H_*/
