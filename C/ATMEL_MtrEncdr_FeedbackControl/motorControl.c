/************************************************************************/
/*																		*/
/*	motorControl.c	--	Motor program file for project					*/
/*																		*/
/************************************************************************/
/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include	"commonIncls.h"
#include	"motorControl.h"
#include	"USARTControl.h"

/* ------------------------------------------------------------ */
/*				Interrupt Service Routines						*/
/* ------------------------------------------------------------ */

ISR (TIMER5_OVF_vect){
	LEFT_ENBPORT &= ~(1 << LEFT_ENBPIN);	// set output LOW
}

ISR (TIMER1_OVF_vect){
	RIGHT_ENBPORT &= ~(1 << RIGHT_ENBPIN);	// set output LOW	
}

/* ------------------------------------------------------------ */
/*				Functions										*/
/* ------------------------------------------------------------ */
/* ------------------------------------------------------------ */
/***	InitRightMotor
**
**	Synopsis:
**		InitRightMotor()
**
**	Parameters:
**		none
**
**	Return Values:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initializes the registers and ports for the left motor
**		Connector JE (TOP) - PORT D, PORT B
*/
void InitRightMotor(){
	
	RIGHT_DIRREG |= (1 << RIGHT_DIRPIN);			// set pin to output
	RIGHT_ENBREG |= (1 << RIGHT_ENBPIN);			// set pin to output

	RIGHT_DIRPORT &= ~(1 << RIGHT_DIRPIN);		// set output low
	RIGHT_ENBPORT &= ~(1 << RIGHT_ENBPIN);		// set output low

	RIGHTPWMREG = 0;
	
	TCCR1A = TIMER1A_PWM;
	TCCR1B |= TIMER1B_SRC;
	TCCR1C = 0;

	TIMSK1 |= (1 << TOIE1);
	TCNT1 = 0;		// start counting from 0
}



/* ------------------------------------------------------------ */
/***	InitLeftMotor
**
**	Synopsis:
**		InitLeftMotor()
**
**	Parameters:
**		none
**
**	Return Values:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initializes the registers and ports for the left motor
**		Connector JF (TOP) - PORT L
*/

void InitLeftMotor(){

	LEFT_DIRREG |= (1 << LEFT_DIRPIN);		// set pin to output
	LEFT_ENBREG |= (1 << LEFT_ENBPIN);		// set pin to output

	LEFT_DIRPORT &= ~(1 << LEFT_DIRPIN);		// set output low
	LEFT_ENBPORT &= ~(1 << LEFT_ENBPIN);		// set output low

	LEFTPWMREG = 0;	

	TCCR5A = TIMER5A_PWM;
	TCCR5B |= TIMER5B_SRC;
	TCCR5C = 0;

	TIMSK5 |= (1 << TOIE5);
	TCNT5 = 0;			// start counting from 0
}



/* ------------------------------------------------------------ */
/***	SetMotorSpeeds
**
**	Synopsis:
**		SetMotorSpeeds()
**
**	Parameters:
**		Duty Cycle for Left and Right Motors
**
**	Return Values:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initializes the PWM registers the motors
*/
void SetConstMotorSpeeds(Speeds leftVal, Speeds rightVal){	
	
	switch(leftVal){
		case GOFAST:
			LEFTPWMREG = FAST;
			break;
		case GONORMAL:
			LEFTPWMREG = NORMAL;
			break;
		case GOSLOW:
			LEFTPWMREG = SLOW;
			break;
	}
	switch(rightVal){
		case GOFAST:
			RIGHTPWMREG = FAST;
			break;
		case GONORMAL:
			RIGHTPWMREG = NORMAL;
			break;
		case GOSLOW:
			RIGHTPWMREG = SLOW;
			break;
	}
}

void SetVariMotorSpeeds(WORD leftVal, WORD rightVal){
	LEFTPWMREG = leftVal;
	RIGHTPWMREG = rightVal;

}

/* ------------------------------------------------------------ */
/***	Set Robot Directions
**
**	Synopsis:
**		SetRobotDir()
**
**	Parameters:
**		directions for the robot
**
**	Return Values:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initializes the registers and ports for the motors
*/
void SetRobotDir(Directions Value){
	uint8_t chkStop=0;	
	StopMotors();
	switch(Value){
		case FORWARD:
			LEFT_DIRPORT |= (1 << LEFT_DIRPIN);
			RIGHT_DIRPORT &= ~(1 << RIGHT_DIRPIN);
			break;
		case REVERSE:
			LEFT_DIRPORT &= ~(1 << LEFT_DIRPIN);
			RIGHT_DIRPORT |= (1 << RIGHT_DIRPIN);
			break;
		case TURNLEFT:
			LEFT_DIRPORT &= ~(1 << LEFT_DIRPIN);
			RIGHT_DIRPORT &= ~(1 << RIGHT_DIRPIN);
			break;
		case TURNRIGHT:
			LEFT_DIRPORT |= (1 << LEFT_DIRPIN);
			RIGHT_DIRPORT |= (1 << RIGHT_DIRPIN);
			break;
		case STOP:
			chkStop=1;
			break;		
	}
	if(!chkStop) RunMotors();
}


/* ------------------------------------------------------------ */
/***	Stop The Robot
**
**	Synopsis:
**		StopMotors()
**
**	Parameters:
**		none
**
**	Return Values:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Stops the motors by making the enable pins low
*/
void StopMotors(){
	LEFT_ENBPORT &= ~(1 << LEFT_ENBPIN);
	RIGHT_ENBPORT &= ~(1 << RIGHT_ENBPIN);

	LEFT_ENBREG &= ~(1 << LEFT_ENBPIN);
	RIGHT_ENBREG &= ~(1 << RIGHT_ENBPIN);

	RIGHTPWMREG = 0;
	LEFTPWMREG = 0;
}

/* ------------------------------------------------------------ */
/***	Move The Robot
**
**	Synopsis:
**		RunMotors()
**
**	Parameters:
**		none
**
**	Return Values:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Runs the motors by making the enable pins high
*/
void RunMotors(){
	LEFT_ENBREG |= (1 << LEFT_ENBPIN);
	RIGHT_ENBREG |= (1 << RIGHT_ENBPIN);

	LEFT_ENBPORT |= (1 << LEFT_ENBPIN);
	RIGHT_ENBPORT |= (1 << RIGHT_ENBPIN);
}


/******************************************************************
/ This method sets the Left & Right pulse widths for the Robot
 *
/ Input: leftPWM, rightPWM, actualVelocities, setVelocities
 *
/ Output: null (sets global variables)
 ******************************************************************/
void setPWM(WORD *wheelPWMs, float *setVelos, float *wheelVelos, float loopTime, float *integral){
	float error=0;

	error = (setVelos[LEFTV] - wheelVelos[LEFTV]);	
	integral[LEFTV] += error*loopTime;
	
	wheelPWMs[LEFTV] += (WORD)(error*KP);
    wheelPWMs[LEFTV] += (WORD)(((wheelVelos[OLDLV] - wheelVelos[LEFTV])/loopTime)*KD);
	wheelPWMs[LEFTV] += (WORD)(integral[LEFTV]*KI);
    if(wheelPWMs[LEFTV] > DUTYMAX) wheelPWMs[LEFTV] = DUTYMAX;
	if(wheelPWMs[LEFTV] < 0) wheelPWMs[LEFTV] = 0;
    
	error = (setVelos[RIGHTV] - wheelVelos[RIGHTV]);
	integral[RIGHTV] += + error*loopTime;

	wheelPWMs[RIGHTV] += (WORD)(error*KP);
    wheelPWMs[RIGHTV] += (WORD)(((wheelVelos[OLDRV] - wheelVelos[RIGHTV])/loopTime)*KD);
	wheelPWMs[RIGHTV] += (WORD)(integral[RIGHTV]*KI);
    if(wheelPWMs[RIGHTV] > DUTYMAX) wheelPWMs[RIGHTV] = DUTYMAX; 
	if(wheelPWMs[RIGHTV] < 0) wheelPWMs[RIGHTV] = 0;

	SetVariMotorSpeeds(wheelPWMs[LEFTV], wheelPWMs[RIGHTV]);
}
