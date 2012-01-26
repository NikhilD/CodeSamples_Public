/************************************************************************/
/*																		*/
/*	USARTControl.c	--	Motor program file for project						*/
/*																		*/
/************************************************************************/
/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include	"commonIncls.h"
#include	"USARTControl.h"
#include	<math.h>

/* ------------------------------------------------------------ */
/*				Extern Variable Definitions						*/
/* ------------------------------------------------------------ */
volatile uint8_t dataFlags=0x00;
uint8_t serialData[RX_BUFFER], rxn=0;


/* ------------------------------------------------------------ */
/*				Interrupt Service Routines						*/
/* ------------------------------------------------------------ */

// USART Receive Interrupt
ISR (USART1_RX_vect){	
	while(!(UCSR1A & (1<<RXC1)));	// Wait for empty receive buffer
	if (rxn==RX_BUFFER){ // if RX_BUFFER is reached, reset to start of buffer.
      	rxn=0;
	}
   	serialData[rxn++] = UDR1; // increment rxn and return new value.      	
	dataFlags |= (1 << RXFLAG);
}


// USART Transmit Interrupt
ISR (USART1_TX_vect){			
	dataFlags |= (1 << TXFLAG);
}

/* ------------------------------------------------------------ */
/***	InitUART
**	Description:
**		Initializes the registers and ports for the UART
**		Connector JD (BOTTOM) - PORT D, USART 1
*/
void usart_init(){
	
	UART_DIR |= (1 << UART_TXPIN);			// set pin to output
	UART_PORT &= ~(1 << UART_TXPIN);		// set pin to low
	UART_PORT &= ~(1 << UART_RXPIN);		// disable pull-up
	//sets up UART1 - baud - 9600!
	UBRR1H = 0x00; //set baud rate high-byte
	UBRR1L = BAUD19200; //set baud rate low-byte
	UCSR1A |= (1 << U2X1); // double transmission speed
	UCSR1B |= (1 << RXCIE1) | (1 << TXCIE1) | (1 << RXEN1) | (1 << TXEN1); //enable transmitter and receiver
	UCSR1C |= (1 << UCSZ11) | (1 << UCSZ10); //8 data bits, 1 Stop bit, no parity
}



/* ------------------------------------------------------------ */
/***	SendChar(char )
**	Description:
**		Sends a character byte to the uart output buffer
** 		in unsigned or signed form
*/

void usart_send_uchar(unsigned char data){
	while (!(UCSR1A & (1 << UDRE1)));	// Wait for empty transmit buffer
	UDR1 = data;
	while(!(dataFlags & (1 << TXFLAG)));
	dataFlags &= ~(1 << TXFLAG);
}

void usart_send_char(char data){
	while (!(UCSR1A & (1 << UDRE1)));	// Wait for empty transmit buffer
	UDR1 = data;
	while(!(dataFlags & (1 << TXFLAG)));
	dataFlags &= ~(1 << TXFLAG);
}

/* -----------------------------------------------------------
// ****	SendInt()
Description:
**		Sends an integer to the uart output buffer
** 		in unsigned or signed form
*/

void usart_send_int(int data){
	usart_send_char(data);
	usart_send_char(data >> 8);
}


void usart_send_uint(WORD data){
	usart_send_uchar(data);
  	usart_send_uchar(data >> 8);
}

//-------------------------usart_send_string------------------------
// Output String (NULL termination), busy-waiting synchronization
// Input: pointer to a NULL-terminated string to be transferred
// Output: none
void usart_send_string(char *pt){  
  	for (;*pt!=0; pt++){
    	if (*pt < ' ' && *pt != '\n')
        	continue;
     	if (*pt == '\n') {
        	usart_send_uchar(CR); usart_send_uchar(LF);
    	}
    	usart_send_uchar(*pt);
  	}
}


//-----------------------usart_send_UDec-----------------------
// Output a 16-bit number in unsigned decimal format
// Input: 16-bit number to be transferred
// Output: none
// Variable format 1-5 digits with no space before or after
void usart_send_UDec(uint16_t n){
// This function uses recursion to convert decimal number
//   of unspecified length as an ASCII string 
  	if(n >= 10){
    	usart_send_UDec(n/10);
    	n = n%10;
  	}
  	usart_send_uchar(n+'0'); /* n is between 0 and 9 */
}

// print float
void usart_send_float_string(float *f, uint8_t precision){
	uint8_t yes=0;
	if(precision>4) precision=4;
	
	uint16_t whole= (int)(*f);
	
	float fracn = (*f)-whole;	
	if(fracn<0.1) yes=1;	
   	
   	if ((*f)<0) usart_send_string("-");	
   	usart_send_UDec(whole); 
	
	if(precision>0){
		usart_send_string("."); 
		if(yes){
			usart_send_string("0"); 		
		}
		uint16_t fraction = (uint16_t)((pow(10,precision))*fracn);
		usart_send_UDec(fraction);
	}
}


void usart_send_float_char(float *f, uint8_t precision){
	if(precision>4) precision=4;

	// It is expected that the float 'whole' is not greater than 65535/32767
	uint16_t whole = (int)(*f);	
	usart_send_uint(whole);
	
	float fracn = (*f)-whole;
	uint16_t fraction = (uint16_t)((pow(10,precision))*fracn);
	usart_send_uint(fraction);

	usart_send_uchar(precision);
}

