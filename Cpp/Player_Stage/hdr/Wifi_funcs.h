#ifndef WIFI_FUNCS_H_
#define WIFI_FUNCS_H_

void wifiColl(WiFiProxy &wp, int *, wifi_link *);
void wifiChkIP(WiFiProxy &wp, int *, wifi_link *);
void wifiChkMAC(WiFiProxy &wp, int *, wifi_link *, char *);
void getDistID(SimulationProxy &simp, wifi_link *, double *, double *);
void getName(char *MAC, char *name);
int parseMAC(int , wifi_link *);
int parseMAC_tmp(int , wifi_link *);

#endif /*WIFI_FUNCS_H_*/
