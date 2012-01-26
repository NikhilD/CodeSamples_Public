/************************************************************************/
/*																		*/
/*	encoderControl.h --	declarations corresponding to encoderControl.c	*/
/*																		*/
/************************************************************************/

/* ------------------------------------------------------------ */
/*					Miscellaneous Declarations					*/
/* ------------------------------------------------------------ */
#define TIMER3A_PWM 	0x00
#define TIMER3B_SRC 	_BV(WGM32) | _BV(CS31) /* use 1/8 prescaler */

#define TIMER4A_PWM 	0x00
#define TIMER4B_SRC 	_BV(CS41) /* use 1/8 prescaler */

#define TIMERMAX	50000

/* ------------------------------------------------------------ */
/*					General Type Declarations					*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Object Class Declarations					*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Variable Declarations						*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

void encoderTimer_init(void);
void loopTimer_init(void);
WORD getRightEncoder(void);
WORD getLeftEncoder(void);
float getEncoders(float *, float *, WORD *, WORD *);
void getLoopTime(float *, uint32_t *);
