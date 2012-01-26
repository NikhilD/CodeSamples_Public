/************************************************************************/
/*																		*/
/*	motorControl.h	--	declarations that correspond to motorControl.c	*/
/*																		*/
/************************************************************************/

/* ------------------------------------------------------------ */
/*					Miscellaneous Declarations					*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*					General Type Declarations					*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Object Class Declarations					*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Variable Declarations						*/
/* ------------------------------------------------------------ */


#define TIMER1A_PWM _BV(COM1A1)	| _BV(WGM11) | _BV(WGM10)
#define TIMER1B_SRC _BV(ICES1) |_BV(CS11) /* use 1/8 prescaler */
#define TIMER5A_PWM _BV(COM5A1) | _BV(WGM51) | _BV(WGM50)
#define TIMER5B_SRC _BV(ICES5) | _BV(CS51) /* use 1/8 prescaler */

#define DUTYMAX		1023		// fixed value... based on 10-bit timer!
#define FAST		1000
#define NORMAL		650		
#define SLOW		300		

#define RIGHTPWMREG		OCR1A
#define LEFTPWMREG		OCR5A

#define RIGHT_DIRPORT	prtJE1
#define RIGHT_DIRREG	ddrJE1
#define RIGHT_DIRPIN	bnJE1
#define RIGHT_ENBPORT	prtJE2
#define RIGHT_ENBREG	ddrJE2			
#define	RIGHT_ENBPIN	bnJE2

#define LEFT_DIRPORT	prtJF1
#define LEFT_DIRREG		ddrJF1
#define LEFT_DIRPIN		bnJF1
#define LEFT_ENBPORT	prtJF2
#define LEFT_ENBREG		ddrJF2			
#define	LEFT_ENBPIN		bnJF2

#define KP	2.0
#define KI 	0.2
#define KD	0.15


typedef enum directions{
	FORWARD,
	REVERSE,
	TURNLEFT,
	TURNRIGHT,
	STOP
} Directions;

typedef enum speeds{
	GOFAST,
	GONORMAL,
	GOSLOW
} Speeds;

/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

void InitRightMotor(void);
void InitLeftMotor(void);
void SetConstMotorSpeeds(Speeds, Speeds);
void SetVariMotorSpeeds(WORD, WORD);
void SetRobotDir(Directions);
void StopMotors(void);
void RunMotors(void);
void setPWM(WORD *, float *, float *, float, float *);
