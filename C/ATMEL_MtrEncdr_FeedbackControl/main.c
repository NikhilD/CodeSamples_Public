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

	double wait = 2750;	// gives about 1 sec!
	float wheelVelos[4], wheelTravels[2], setVelos[2]; 
	float wheelDists[2], integral[2], loopTime=0; 
	WORD wheelPWMs[2], leftEnc, rightEnc; 		
	uint8_t firstLoop=0, iter=0;
	
	initializeZero(wheelPWMs, setVelos, wheelDists, wheelTravels, wheelVelos);	
	integral[LEFTV] = 0.0;	integral[RIGHTV] = 0.0;

	while(fTrue){
	//for(int i=0;i<2;i++){
		if(dataFlags & (1 << RXFLAG)){
			dataFlags &= ~(1 << RXFLAG);
			executeSerial(setVelos, wheelDists);			
			wheelTravels[LEFTV]=0;	wheelTravels[RIGHTV]=0;			
			firstLoop = 1;
			if(serialData[0]=='S'){			
				initializeZero(wheelPWMs, setVelos, wheelDists, wheelTravels, wheelVelos);
				firstLoop = 0;
			}
		}
		if(firstLoop){
			loopTime = getEncoders(wheelVelos, wheelTravels, &leftEnc, &rightEnc);
			setPWM(wheelPWMs, setVelos, wheelVelos, loopTime, integral);
			
			if(iter==5){
				iter=0;
				usart_send_uint(wheelPWMs[LEFTV]); usart_send_uint(wheelPWMs[RIGHTV]);
		
				float wvL = wheelVelos[LEFTV];	float wvR = wheelVelos[RIGHTV];
				usart_send_float_char(&wvL, 2);	usart_send_float_char(&wvR, 2);

				float wtL = wheelTravels[LEFTV];	float wtR = wheelTravels[RIGHTV];
				usart_send_float_char(&wtL, 3);	usart_send_float_char(&wtR, 3);
			
				usart_send_uint(leftEnc);	usart_send_uint(rightEnc);

				usart_send_float_char(&loopTime, 4);
			}
			iter++;
		}
		if((wheelTravels[LEFTV] > wheelDists[LEFTV]) && (wheelTravels[RIGHTV] > wheelDists[RIGHTV])){
			initializeZero(wheelPWMs, setVelos, wheelDists, wheelTravels, wheelVelos);	
			firstLoop = 0;
		}
		//_delay_ms(wait);
	}	
	setDir('S');
	//cli();			//disable global interrupts.

}  //end main


void executeSerial(float *setVelos, float *wheelDists){

	uint8_t dir = serialData[0];
	uint16_t distInt = (serialData[2]<<8) + serialData[1];
	uint8_t distFrac = serialData[3];
	uint8_t leftVelInt = serialData[4]; uint8_t leftVelFrac = serialData[5]; 
	uint8_t rightVelInt = serialData[6]; uint8_t rightVelFrac = serialData[7]; 

	setDir(dir);
		
	// Set Distance for the wheels
	float dists = ((float)distInt) + (((float)distFrac)/100.0);
	wheelDists[LEFTV] = dists;
	wheelDists[RIGHTV] = dists;

	// Set Velocities...	
	setVelos[LEFTV] = ((float)leftVelInt) + (((float)leftVelFrac)/100.0);
	setVelos[RIGHTV] = ((float)rightVelInt) + (((float)rightVelFrac)/100.0);
	//float wtR = wheelDists[RIGHTV];	usart_send_float_char(&wtR, 2); usart_send_uchar(CR);
}


void setDir(uint8_t dir){
	
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
}


void initializeZero(WORD *wheelPWMs, float *setVelos, float *wheelDists, 
		float *wheelTravels, float *wheelVelos){

	setDir('S');
	wheelPWMs[LEFTV] = 0;	wheelPWMs[RIGHTV] = 0;		// initialize wheelPWMs
	setVelos[LEFTV] = 0.0;	setVelos[RIGHTV] = 0.0;		// in cm/sec
	wheelDists[LEFTV] = 0.0;	wheelDists[RIGHTV] = 0.0;
	wheelTravels[LEFTV]=0;	wheelTravels[RIGHTV]=0;
	wheelVelos[LEFTV]=0;	wheelVelos[RIGHTV]=0;
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










