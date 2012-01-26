#ifndef FOLLOW_MAIN_H
#define FOLLOW_MAIN_H

#define RAYS 32

bool print = false;
int gInd, oldRSSI[4], status;
char FOLLOWMAC[32], LEADMAC[32];

int main(int argc, char **argv);
void robots(PlayerClient *robot, WiFiProxy &wp, LaserProxy &lp, Position2dProxy &pp, SimulationProxy &simp, wifi_link *);

#endif
