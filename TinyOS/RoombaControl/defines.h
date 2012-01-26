#ifndef DEFINES_H
#define DEFINES_H

#include <AM.h>

/**
 *  Different register values for the power level and the associated 
 *  power in dBm.
 *
 *  31   0 
 *  27  -1 
 *  23  -3 
 *  19  -5 
 *  15  -7 
 *  11 -10 
 *  7  -15 
 *  3  -25 
 *
 **/

#define TXPOWER1 	31
#define TXPOWER2 	27
#define TXPOWER3 	11
#define TXPOWER4 	3

#define NETNODEPOWER 	7
#define DIRNODEPOWER 	3
 
#define BASE_ID				0
#define NET_BASE_ID			5
#define MAX_HC				250

#define NREADINGS		15					//Total Readings i.e. NREADINGS/NUM_CHNL readings per channel per log sample
#define NUM_CHNL		5

#define NET_MSG		1
#define PGNODE_MSG	2
#define BOT_MSG		3
#define BASE_MSG	4
#define NET_GP		1
#define BOT_GP		2

#define NUM_INDEX			(NREADINGS-(2*NUM_CHNL))
#define NETWORK_WAIT		500
#define BOT_WAIT 			50
#define START_WAIT			60
#define UART_WAIT			10
#define WEE_WAIT			10
#define	MLTFCTR				2

// The TMote IDs for the three antennas are the same as below!
#define BASEANT		0		// antenna for robot base mote!
#define FRONTANT	3		// antenna 3
#define RIGHTANT	2		// antenna 2
#define LEFTANT		1		// antenna 1

#define GAINFRONT	1		// antenna 3
#define GAINRIGHT	1		// antenna 2
#define GAINLEFT	1		// antenna 1

#define MAXRCVCNT		300
#define XMITCNT			100
#define TESTUARTSIZE	11
#define NEIGHSIZE		7
#define BOTSIZE			4		// 3 antennas + one base-station!
#define TOTRCVCNT		(XMITCNT*BOTSIZE)
#define UARTSIZE		XMITCNT

#define FLTVAL			145.657892
#define TURN_THRESH		0.2		// difference needed to initiate turn

#define START		1
#define STOP		2
#define ANNOUNCE	3
#define PGDIR		4
#define BOTDIR		5
#define GIVEPGNODE	6
#define GIVEBOTDIR	7

#define SENDNET		8
#define SENDUART	9
#define GUIDEBOT	10

#define MAX(x,y)		((x>y)?x:y)
#define MIN(x,y)		((x<y)?x:y)
#define ABS(a)	    	(((a) < 0) ? -(a) : (a))
#define BIGGEST(a,b,c)	((MAX(a,b) < c) ?  (c) : (MAX(a,b)))

#define OVA		0
#define RLA		1
#define LFA		2
#define FRA		3

#define CW		15
#define CCW		16

#define MINDBM		-95.0
#define MINSENSE	-72.0
#define MAXDBM		-5.0
#define MAXBOTDBM	-10.0


typedef nx_struct radio_msg {
	nx_uint8_t msgType;
	nx_am_id_t srcNode;
	nx_am_group_t srcGP;
	nx_am_id_t srcID;
	nx_am_id_t destID;
	nx_int16_t distance;
	nx_uint8_t hopCnt;	
	nx_uint32_t pgVal;
	nx_int8_t	dBmVal;
	nx_uint8_t	lQi;
	nx_uint8_t 	numMsgs;
} radio_msg_t;

enum {
  AM_RADIO_MSG = 9,
};

#endif
