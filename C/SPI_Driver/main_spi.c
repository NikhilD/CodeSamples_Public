/***********************************************************************
 * DISCLAIMER:                                                         *
 * The software supplied by Renesas Technology America Inc. is         *
 * intended and supplied for use on Renesas Technology products.       *
 * This software is owned by Renesas Technology America, Inc. or       *
 * Renesas Technology Corporation and is protected under applicable    *
 * copyright laws. All rights are reserved.                            *
 *                                                                     * 
 * THIS SOFTWARE IS PROVIDED "AS IS". NO WARRANTIES, WHETHER EXPRESS,  *
 * IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO IMPLIED 		   *
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  *
 * APPLY TO THIS SOFTWARE. RENESAS TECHNOLOGY AMERICA, INC. AND        *
 * AND RENESAS TECHNOLOGY CORPORATION RESERVE THE RIGHT, WITHOUT       *
 * NOTICE, TO MAKE CHANGES TO THIS SOFTWARE. NEITHER RENESAS           *
 * TECHNOLOGY AMERICA, INC. NOR RENESAS TECHNOLOGY CORPORATION SHALL,  * 
 * IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR         *
 * CONSEQUENTIAL DAMAGES FOR ANY REASON WHATSOEVER ARISING OUT OF THE  *
 * USE OR APPLICATION OF THIS SOFTWARE.                                *
 ***********************************************************************/

/*==========================================================================
*											   						 	
*   File Name: main_spi.c          
*                                                                  
*   Description: main routine for SPI demo using polling method 	 	
*											  						 	
*	This program communicates to a digital potentiometer, X9111, using	
*   SPI. The X9111 connection to the SKP16C26A's expansion port is as 	
*  	follows:															
*		X9111 pin		SKP16C26A 										
*		 	1  SO    	p7_1, RXD2										
*		    2  A0     	GND												
*		    3  NC    													
*			4  CS'   	p7_3 											
*			5  SCK     	p7_2, CLK2										
*			6  SI		p7_0, TXD2										
*			7  Vss  	GND												
*			8  WP'    	Vcc												
*			9  A1     	GND												
*			10 HOLD'  	Vcc												
*			11 Rw  		- look at this pin with an oscilloscope		
*			12 Rh     	Vcc												
*			13 Rl     	GND												
*			14 Vcc    	Vcc  											
*
*===========================================================================
*   Revision history: 
*
*   1.0 SKP Release 
*==========================================================================*/

#include "qsk_bsp.h"	// include QSK board support package

/* Prototype declarations */
void mcu_init(void);							// MCU initialization
void ta0_irq(void);								// Timer A0 interrupt service routine 
void init_SPI(void);							// Initializes SPI interface using UART2 
void write_x9111(int value);					// Formats buffer for writing wiper position to pot
int read_x9111(void);							// Formats buffer for reading wiper position from pot
void SPI_send_receive(char *data, int bytes);	// The SPI transfer function
void init_ta0(void);							// Used to initiate X9111 writing/reading 
void lcd_init(void);	// initialize LCD display

/* Interrupt function declarations */ 
#pragma INTERRUPT ta0_irq
void ta0_irq(void);								// Timer A0 interrupt service routine 

#define CHIP_SELECT 		p7_3
#define CHIP_SELECT_DDR		pd7_3
#define SPI_CLK_RATE 500e3			// 500kHz bit rate

/* global variables */
unsigned char new_sample;			// if 1, initiates writes/reads of X9111
int  wrt_pot_value, rd_pot_value; 	// Input and output X9111 data
unsigned char up_down;		   		// 0: count down, 1:count up 
unsigned char buff[4];		   		// Data buffer for SPI transfers
union {						   		// Union used to convert number format
	struct {
		unsigned char low;
		unsigned char high;
	} bytes;
	unsigned int value;
} data_val;


/*****************************************************************************
Name:      		main_spi      
Parameters:		none 
Returns:        none
Description:  	main program loop.   
*****************************************************************************/
void main(void)
{

	mcu_init();
   
  	/* LED initialization for this demo - macro defined in skp_bsp.h */
  	ENABLE_LEDS;
	
	lcd_init();
	
	up_down = 1;  new_sample = 0; wrt_pot_value = 0; // Initialize control values. 
	
	/* initialize timer and SPI interface */
	init_SPI();
	init_ta0();
	
	while(1){
		if(new_sample){						// time to get new sample?
			new_sample = 0;
			write_x9111(wrt_pot_value);		// Write new pot value
			_asm("nop");
			
			rd_pot_value = read_x9111();	// Read current pot value
			
			if(up_down){ 					// 1? then count up	    
				++wrt_pot_value;			// increment wrt_pot_value
				if(wrt_pot_value > 1022)		  
					up_down = 0;
			}
			else { 							// 0 so count down
				--wrt_pot_value;			// decrement wrt_pot_value. 
				if(wrt_pot_value == 0)
					up_down = 1;
			}
		}
	 }
}

/*****************************************************************************
Name:      	init_SPI     
Parameters: none                    
Returns:    none
Description: Initialize SPI interface - UART2 in SPI Mode 3 and chip select port.
*****************************************************************************/
void init_SPI(void)
{
  
  	/* initialize chip select port */
  	CHIP_SELECT = 1;		// Bring CHIP_SELECT high
  	CHIP_SELECT_DDR = 1;	// Change CHIP_SELECT port to output

  	/* configure UART2 for SPI */
  	u2c0   = 0x90;		/* MSB first, CKPOL=0 (Tx on falling/Rx on rising),
							no CTS/RTS, CMOS TxD, count source is f1 */
			// 10010000   UART2 transmit/receive control register 0
			// ||||||||----  BRG count source bit 0 
			// |||||||-----	 BRG count source bit 1
			// ||||||------	 CTS'/RTS' function select bit
			// |||||-------	 Transmit register empty flag
			// ||||--------	 CTS'/RTS' disable bit
			// |||---------	 NCH 
			// ||----------	 Clk polarity select bit 
			// |-----------	 Transfer format select bit   

  	u2c1   = 0x00;		/* no data reverse, rx & tx disabled */
			// 00000000   	UART2 transmit/receive control register 1
			// ||||||||----  Transmit enable bit
			// |||||||-----	 Transmit buffer empty flag
			// ||||||------	 Receive enable bit
			// |||||-------	 Receive complete flag
			// ||||--------	 UART2 transmit interrupt cause select bit
			// |||---------	 UART2 continuous receive mode enable bit
			// ||----------	 Data logic select bit
			// |-----------	 Error signal output enable bit

  	u2brg  = (unsigned char) (((f1_CLK_SPEED/2)/SPI_CLK_RATE)-1);
	  	  /* value to set in brg can be calculated by:
	  	  		value_in_brg = ((brg_count_source/2)/SPI_CLK_RATE) - 1
		  		note: 1. A divide by 2 is done by the MCU internally.
				  	  2. BCLK is switched to f1 in ncrt0_26askp_spi.a30

		  in this example: BRG count source = f1 (10MHz - Xin crystal in SKP16C26A)
						   bit rate = 500kHz
						   brg = ((10MHz/2)/500kHz) - 1 = 9 */

	/* Set SPI to mode 3 */
  	ckpol_u2c0 = 0;		// Clock polarity, bit 6 of U2C0 register
   	ckph_u2smr3 = 0;	// Clock phase, bit 1 of U2SMR3 register. 

  	u2mr   = 0x01;		/* synchronous mode, internal clock, no reverse*/
			// 00000001   UART2 transmits/receive mode register
			// ||||||||---- Serial I/O model select bit 0
			// |||||||-----	Serial I/O model select bit 1 
			// ||||||------	Serial I/O model select bit 2
			// |||||-------	Internal clock 
			// ||||--------	Stop bit length
			// |||---------	Odd/Even parity
			// ||----------	Parity enable bit
			// |-----------	TXD/RXD I/O polarity reverse bit
}


/*****************************************************************************
Name:		write_x9111           
Parameters: int value                    
Returns:    none    
Description: Writes new output value to digital pot    
*****************************************************************************/
void write_x9111(int value){

	buff[0] = 0x50;				   	// Device ID, slave address, and Write command
	buff[1] = 0xa0;				   	// Instruction opcode
	data_val.value = value;		   	// Convert little endian to big endian
	buff[2] = data_val.bytes.high; 	// Place write data into buffer  (MSB)
	buff[3] = data_val.bytes.low;  	// Places write data into buffer (LSB)
	SPI_send_receive(&buff[0],4);  	// Call SPI transfer function
}

/*****************************************************************************
Name:		read_x9111           
Parameters: none                    
Returns:    digital pot value    
Description: Reads new output value from digital pot    
*****************************************************************************/
int read_x9111(void)
{

	unsigned char change;
	
	buff[0] = 0x51;				   	// Device ID, slave address, and Read command
	buff[1] = 0x80;				   	// Instruction opcode
	buff[2] = 0xFF;				   	// Zero data buffers
	buff[3] = 0xFF;
	
	SPI_send_receive(&buff[0],4);  	// Call SPI transfer function 
	data_val.bytes.high = buff[2]; 	// Convert big endian to little endian
	data_val.bytes.low = buff[3];
	
	return data_val.value; 		   	// Return data
}

/*****************************************************************************
Name:        SPI_send_receive   
Parameters:  data and number of bytes to send/receive                   
Returns:     none
Description: Performs SPI transfers. The CS of the device is brought low prior
			 to the serial data transfers and brought high afterwards.    
*****************************************************************************/
void SPI_send_receive(char *data, int bytes )
{

	int i;
	char *data_buff;
	
	while( !ti_u2c1 );			// Ensure transmit buffer is empty 
  	while( !txept_u2c0 );		// Ensure transmit register is empty
	i = u2rbl; 					// Read receive buffer to empty it 
  	re_u2c1 = 1;				// Enable rx
    te_u2c1 = 1;				// Enable tx
	data_buff = data; 			// Initialize data pointer
	
	CHIP_SELECT = 0;  			// Bring CS low to enable device access
	
	for(i = 0; i <  bytes ; i++) {
		u2tbl = *data_buff;		// Transmit data
		while( !ri_u2c1 );		// Wait for rx to be completed
		*data_buff = u2rbl;  	// Copy received data to buffer
		++data_buff;			// Increment data pointer
	}
	
  	re_u2c1 = 0;				// Disable rx
  	te_u2c1 = 0;				// Disable tx
  	CHIP_SELECT = 1;			// Bring CS' high
}

/*****************************************************************************
Name: init_ta0  
Parameters:  none
Returns:     none
Description: Initializes timer A0 to generate an interrupt every 1ms. The 
             SKP16C26A is running the PLL at 20MHz. BCLK is set to f1 of 
 			 Xin in ncrt0_26askp_spi.a30.  
*****************************************************************************/
void init_ta0(void)
{

	ta0 = (unsigned int) (((f1_CLK_SPEED/32)*1e-3)-1);	// ((20MHz/32)*1ms)-1 
	ta0mr = 0x80;		// Timer mode,  f32 source

	DISABLE_IRQ;		// Disable global interrupts
	ta0ic = 3;			// Enable timer A0 interrupt
	ENABLE_IRQ; 		// Enable global interrupts

	ta0s = 1;			// Start timer A0
}


/* ******************************************************************
 Description: Initializes and then displays demo name
 Entry: none
 Returns: nothing
 
********************************************************************/
void lcd_init(void)
{
	InitDisplay();
	
	DisplayString(LCD_LINE1," USART  ");
	DisplayString(LCD_LINE2,"  SPI   ");
} 


/*****************************************************************************
Name: ta0_irq  
Parameters:  none
Returns:     none
Description: Timer A0 interrupt service routine that changes a flag to 
			 initiate an SPI write or read operation.

			 Timer A0 vector in sect30_26askp_spi.inc file was modified to 
			 point to this routine.
*****************************************************************************/
void ta0_irq (void)
{
	new_sample = 1;
}

