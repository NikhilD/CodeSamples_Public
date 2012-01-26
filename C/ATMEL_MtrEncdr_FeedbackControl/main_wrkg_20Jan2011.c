/************************************************************************/
/*																		*/
/*	main.c	--	Primary program file for project						*/
/*																		*/
/************************************************************************/
/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include	"commonIncls.h"
#include	"main.h"
#include	"motorControl.h"
#include	"USARTControl.h"
#include	"encoderControl.h"
#include 	<stdio.h>
#include 	<string.h>
#include 	<stdlib.h>


extern volatile uint8_t dataFlags;
extern uint8_t serialData[RX_BUFFER];
/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */

/***	main
**
**	Synopsis:
**		st = main()
**
**	Parameters:
**		none
**
**	Return Values:
**		does not return
**
**	Errors:
**		none
**
**	Description:
**		Main program module. Performs basic board initialization
**		and then enters the main program loop.
**
*/
/* ------------------------------------------------------------ */
int main(void) {

	DeviceInit();
	AppInit();

	double wait = 275;	// gives about 1 sec!
	Directions robotDir = FORWARD;
	float wheelVelos[4], wheelTravels[2], setVelos[2]; 
	float wheelDists[2], integral[2], loopTime=0; 
	WORD wheelPWMs[2], leftEnc, rightEnc; 	
	char lpwm[10], rpwm[10], lenc[10], renc[10];

	wheelPWMs[LEFTV] = 300;	wheelPWMs[RIGHTV] = 300;		// initialize wheelPWMs
	setVelos[LEFTV] = 35.0;	setVelos[RIGHTV] = 35.0;		// in cm/sec
	wheelDists[LEFTV] = 1000.0;	wheelDists[RIGHTV] = 1000.0;
	integral[LEFTV] = 0.0;	integral[RIGHTV] = 0.0;

	SetRobotDir(robotDir);

	while(fTrue){
		if(dataFlags & (1 << RXFLAG)){
			dataFlags &= ~(1 << RXFLAG);
			uint8_t dir = serialData[0];
			uint8_t dist = serialData[1];
			uint16_t leftVel = (serialData[3]<<8) + serialData[2];
			uint16_t rightVel = (serialData[5]<<8) + serialData[4];
			setDirDistVel(dir, dist, leftVel, rightVel, setVelos, wheelDists);
		}
									
		loopTime = getEncoders(wheelVelos, wheelTravels, &leftEnc, &rightEnc);
		setPWM(wheelPWMs, setVelos, wheelVelos, loopTime, integral);
		
		utoa(wheelPWMs[LEFTV], lpwm, 10);	utoa(wheelPWMs[RIGHTV], rpwm, 10);	
		utoa(leftEnc, lenc, 10);	utoa(rightEnc, renc, 10);			
		
		strcat(lpwm, " ");	strcat(rpwm, " ");	strcat(lenc, " ");
		strcat(renc, " ");	

		usart_send_float(&loopTime); usart_send_string(" ");
		usart_send_string(lenc);	usart_send_string(renc);
		usart_send_string(lpwm);	usart_send_string(rpwm);
			
		float wvL = wheelVelos[LEFTV];	float wvR = wheelVelos[RIGHTV];
		usart_send_float(&wvL);		usart_send_float(&wvR);

		float wtL = wheelTravels[LEFTV];	float wtR = wheelTravels[RIGHTV];
		usart_send_float(&wtL);		usart_send_float(&wtR);

		if((wheelTravels[LEFTV] > wheelDists[LEFTV]) && (wheelTravels[RIGHTV] > wheelDists[RIGHTV])){
			wheelTravels[LEFTV]=0;	wheelTravels[RIGHTV]=0;
			setDirDistVel(5,0,0,0, setVelos, wheelDists);			
		}
	}	
	//cli();			//disable global interrupts.

}  //end main


void setDirDistVel(uint8_t dir, uint8_t dist, uint16_t leftVel, uint16_t rightVel, float *setVelos, float *wheelDists){
	
	// Set Direction on motor
	// Unless the command is for turn-in-place, cases 3-4 are not used!
	Directions robotDir = FORWARD;
	switch(dir){
		case 'F':			
			robotDir = FORWARD;
			break;
		case 'V':
			robotDir = REVERSE;
			break;
		case 'L':
			robotDir = TURNLEFT;
			break;
		case 'R':
			robotDir = TURNRIGHT;
			break;
		case 'S':
			robotDir = STOP;
			break;
	}
	SetRobotDir(robotDir);
	
	// Set Distance for the wheels
	wheelDists[LEFTV] = (float)dist;
	wheelDists[RIGHTV] = (float)dist;

	// Set Velocities...
	setVelos[LEFTV] = ((float)leftVel)/10.0;
	setVelos[RIGHTV] = ((float)rightVel)/10.0;
	
}

/* ------------------------------------------------------------ */
/***	DeviceInit
**
**	Synopsis:
**		DeviceInit()
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
**		Initializes on chip peripheral devices to the default
**		state.
*/

void DeviceInit() {
	/* Default all i/o ports to input with pull-ups enabled
	Also, takes care of pins for encoder inputs!!
	*/
	DDRA = 0;
	DDRB = 0;
	DDRC = 0;
	DDRD = 0;
	DDRE = 0;
	DDRF = 0;
	DDRG = 0;
	DDRH = 0;
	DDRJ = 0;
	DDRK = 0;
	DDRL = 0;

	PORTA = 0xFF;
	PORTB = 0xFF;
	PORTC = 0xFF;
	PORTD = 0xFF;
	PORTE = 0xFF;
	PORTF = 0xFF;
	PORTG = 0xFF;
	PORTH = 0xFF;
	PORTJ = 0xFF;
	PORTK = 0xFF;
	PORTL = 0xFF;

	/*The above statements sets all ports as inputs (DDRx = 0) and enables the internal
	  pull-up resistors on those pins (PORTx = 0xFF).  This includes the data direction
	  register and pull-up that handles the User Input Jumper JP5. */
	  	
	//Set the data direction register of the LEDs as output
	ddrLed0 |= (1 << bnLed0);
	ddrLed1 |= (1 << bnLed1);
	ddrLed2 |= (1 << bnLed2);
	ddrLed3 |= (1 << bnLed3);

	//Set the LEDs pins low (off) initially
	prtLed0 &= ~(1 << bnLed0);
	prtLed1 &= ~(1 << bnLed1);
	prtLed2 &= ~(1 << bnLed2);
	prtLed3 &= ~(1 << bnLed3);
}

/* ------------------------------------------------------------ */
/***	AppInit
**
**	Synopsis:
**		AppInit()
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
**		Performs application specific initialization. Sets devices
**		and global variables for application.
*/

void AppInit(){
	/* Initialization of global variables, such as flags, would go in this 
	  function */
	InitLeftMotor();
	InitRightMotor();
	usart_init();	
	encoderTimer_init();
	loopTimer_init();

	sei();  //enable global interrupts.
}










