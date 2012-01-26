#ifndef ALGO_FUNCS_H_
#define ALGO_FUNCS_H_

void followLeader(PlayerClient *, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *, int);
void leadFollower(PlayerClient *, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *, int);
void leadnfollow(PlayerClient *, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *);
void calcArcDist(double *, double *, double *);

#endif /*ALGO_FUNCS_H_*/
