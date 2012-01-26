/************************************************************************/
/*																		*/
/*	EncoderControl.c	--	Encoder program file for project			*/
/*																		*/
/************************************************************************/
/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include	"commonIncls.h"
#include	"encoderControl.h"
#include	"USARTControl.h"

volatile WORD countR=0, countL=0, countLoop=0;
extern volatile uint8_t dataFlags;

/* ------------------------------------------------------------ */
/*				Interrupt Service Routines						*/
/* ------------------------------------------------------------ */

ISR (TIMER5_CAPT_vect){			// Left Encoder Pulse Capture
	cli();
	countL++;
	sei();
}


ISR (TIMER1_CAPT_vect){			// Right Encoder Pulse Capture	
	cli();
	countR++;
	sei();
}

ISR (TIMER3_COMPA_vect){
	dataFlags |= (1 << ENCFLAG);
}

ISR (TIMER4_OVF_vect){
	countLoop++;
	dataFlags |= (1 << LOPFLAG);
}

/* ------------------------------------------------------------ */
/***	InitEncoderTimer
**	Description:
**		Initializes the Timer for Encoder Count
**		
*/
void encoderTimer_init(){
	
	TCCR3A = TIMER3A_PWM;
	TCCR3B |= TIMER3B_SRC;
	TCCR3C = 0;
	
	OCR3A = TIMERMAX;

	TIMSK3 |= (1 << OCIE3A) | (1 << TOIE3);

	TCNT3 = 0;
}

/* ------------------------------------------------------------ */
/***	InitLoopTimer
**	Description:
**		Initializes the Timer for the PID loop
**		
*/
void loopTimer_init(){
	
	TCCR4A = TIMER4A_PWM;
	TCCR4B |= TIMER4B_SRC;
	TCCR4C = 0;
	
	TIMSK4 |= (1 << TOIE4);

	TCNT4 = 0;
}

void getLoopTime(float *loopTime, uint32_t *timerVal){

	uint32_t tval=0;
	if(dataFlags & (1 << LOPFLAG)){
		dataFlags &= ~(1 << LOPFLAG);
		tval = 65536*countLoop;
		countLoop=0;
	}
	*timerVal = TCNT4 + tval;		// get the count Value from timer.	
	*loopTime = ((float)*timerVal)/(F_CPU/8.0); // based on pre-scaler used...
	TCNT4 = 0;						// reset timer to start timing again
}

//-------------------------------------------------------------

/* ------------------------------------------------------------ */
/***	Get Encoder Readings
**
**	Synopsis:
**		getEncoders()
**
**	Parameters:
**		wheel velocities and distances traversed
**
**	Return Values:
**		double "loopTime" for PID and other calculations (seconds)
**
**	Errors:
**		none
**
**	Description:
**		Get the encoder readings for both motors
*/

float getEncoders(float *wheelVelos, float *wheelTravels, WORD *leftEnc, WORD *rightEnc){
	float leftV, rightV, loopTime;
	uint32_t timerVal;
	 
	getLoopTime(&loopTime, &timerVal);			// get the loop time in seconds	

	wheelVelos[OLDLV] = wheelVelos[LEFTV]; // update leftvelocity to old
	WORD lpulse = getLeftEncoder();		*leftEnc = lpulse;
	// convert pulse/sec to cm/sec
	leftV = (((float)lpulse)*PulseToCM)/loopTime;
    wheelTravels[LEFTV] += (float)((leftV + wheelVelos[OLDLV])*loopTime/2);
	wheelVelos[LEFTV] = leftV;

	wheelVelos[OLDRV] = wheelVelos[RIGHTV]; // update rightvelocity to old
	WORD rpulse = getRightEncoder();	*rightEnc = rpulse;
	// convert pulse/sec to cm/sec
    rightV = (((float)rpulse)*PulseToCM)/loopTime;
    wheelTravels[RIGHTV] += (float)((rightV + wheelVelos[OLDRV])*loopTime/2);
	wheelVelos[RIGHTV] = rightV;

	return loopTime;
}

WORD getLeftEncoder(){
	WORD value=0;
	TIMSK5 |= (1 << ICIE5);		// enable the encoder interrupt
	TCNT3=0;
	dataFlags &= ~(1 << ENCFLAG);
	while(fTrue){
		if(dataFlags & (1 << ENCFLAG)){
			dataFlags &= ~(1 << ENCFLAG);		
			TIMSK5 &= ~(1 << ICIE5);  // disable the encoder interrupt at pin
			value = countL;
			countL = 0;			
			break;	
		}
	}
	return value;
}

WORD getRightEncoder(){
	WORD value = 0;
	TIMSK1 |= (1 << ICIE1);		// enable the encoder interrupt at pin
	TCNT3=0;
	dataFlags &= ~(1 << ENCFLAG);
	while(fTrue){
		if(dataFlags & (1 << ENCFLAG)){
			dataFlags &= ~(1 << ENCFLAG);		
			TIMSK1 &= ~(1 << ICIE1);  // disable the encoder interrupt at pin
			value = countR;
			countR = 0;			
			break;	
		}
	}
	return value;
}

//--------------------------------------------------------------------


