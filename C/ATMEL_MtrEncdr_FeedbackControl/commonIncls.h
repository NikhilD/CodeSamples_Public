/************************************************************************/
/*																		*/
/*	commonIncls.h	--	files and variables common to all *.c files		*/
/*																		*/
/************************************************************************/
#define F_CPU 8000000UL  // 8 MHz

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include	"../AVR_Common/stdtypes.h"
#include	"../AVR_Common/Cerebot_Plus.h"

#define	RXFLAG	0	
#define	TXFLAG	1
#define ENCFLAG 2
#define LOPFLAG 3

#define RX_BUFFER	8

#define PI	3.14159

#define wheelPPR	60.0		// pulses per revolution of encoder
#define radius		3.35		// wheel radius in cm
#define width		15.5	// distance between wheels in cm
#define PulseToCM	((2*PI*radius)/wheelPPR)

#define LEFTV	0
#define RIGHTV	1
#define OLDLV	2
#define OLDRV	3
