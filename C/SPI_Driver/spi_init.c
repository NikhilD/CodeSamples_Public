

#include "qsk_bsp.h"	// include QSK board support package
#include "spi_init.h"

/* global variables */
unsigned char new_sample, data_value, overflow_count=0, sample_time=0;			// if 1, initiates writes/reads 
unsigned char buff[4];		   		// Data buffer for SPI transfers
/*union {						   		// Union used to convert number format
	struct {
		unsigned char low;
		unsigned char high;
	} bytes;
	unsigned int value;
} data_val;*/

/*****************************************************************************
Name:      	spi_init     
Parameters: none                    
Returns:    none
Description: Initialize SPI interface - UART1 in SPI Mode 3 and chip select port.
*****************************************************************************/
void spi_init(void)
{
  
  	/* initialize chip select port */  	
  	CHIP_SELECT_DDR = 1;	// Change CHIP_SELECT port to output
	SCLK_DDR = 1;			// SCLK Port as output
	MISO_DDR = 0;			// MISO Port as output
	MOSI_DDR = 1;			// MOSI Port as output
	
	CHIP_SELECT = 1;		// Bring CHIP_SELECT high
	
  	/* configure UART1 for SPI */
  	u1c0   = 0x90;		/* MSB first, CKPOL=0 (Tx on falling/Rx on rising),
							no CTS/RTS, CMOS TxD, count source is f1 */
			// 10010000   UART1 transmit/receive control register 0
			// ||||||||----  BRG count source bit 0 
			// |||||||-----	 BRG count source bit 1
			// ||||||------	 CTS'/RTS' function select bit
			// |||||-------	 Transmit register empty flag
			// ||||--------	 CTS'/RTS' disable bit
			// |||---------	 NCH 
			// ||----------	 Clk polarity select bit 
			// |-----------	 Transfer format select bit   

  	u1c1   = 0x00;		/* no data reverse, rx & tx disabled */
			// 00000000   	UART1 transmit/receive control register 1
			// ||||||||----  Transmit enable bit
			// |||||||-----	 Transmit buffer empty flag
			// ||||||------	 Receive enable bit
			// |||||-------	 Receive complete flag
			// ||||--------	 UART2 transmit interrupt cause select bit
			// |||---------	 UART2 continuous receive mode enable bit
			// ||----------	 Data logic select bit
			// |-----------	 Error signal output enable bit

  	u1brg  = (unsigned char) (((f1_CLK_SPEED/2)/SPI_CLK_RATE)-1);
	  	  /* value to set in brg can be calculated by:
	  	  		value_in_brg = ((brg_count_source/2)/SPI_CLK_RATE) - 1
		  		note: 1. A divide by 2 is done by the MCU internally.
				  	  2. BCLK is switched to f1 in ncrt0_26askp_spi.a30

		  in this example: BRG count source = f1 (20MHz - Xin crystal in SKP16C26A)
						   bit rate = 500kHz
						   brg = ((20MHz/2)/500kHz) - 1 = 19 */

	/* Set SPI to mode 3 
  	ckpol_u2c0 = 0;		// Clock polarity, bit 6 of U2C0 register
   	ckph_u2smr3 = 0;	// Clock phase, bit 1 of U2SMR3 register.
	*/
  	u1mr   = 0x01;		/* synchronous mode, internal clock, no reverse*/
			// 00000001   UART1 transmits/receive mode register
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
Name:		spi_write          
Parameters: int value                    
Returns:    none    
Description: Writes new output value
*****************************************************************************/
void spi_write(unsigned char value, unsigned int addr){

	buff[0] = 0xF0;				   	// Instruction opcode
	buff[1] = ((addr & 0xFF00)>>8);				   	// Device ID, slave address, and Write command
	buff[2] = (addr & 0x00FF);				   	// Device ID, slave address, and Write command
	buff[3] = value;  	// Places write data into buffer (LSB)
	spi_comm(&buff[0],4);  	// Call SPI transfer function
}

/*****************************************************************************
Name:		spi_read
Parameters: none                    
Returns:    digital pot value    
Description: Reads new output value  
*****************************************************************************/
unsigned char spi_read(unsigned int addr)
{
	buff[0] = 0x0F;				   	// Instruction opcode
	buff[1] = ((addr & 0xFF00)>>8);				   	// Device ID, slave address, and Read command
	buff[2] = (addr & 0x00FF);				   	// Device ID, slave address, and Read command
	buff[3] = 0xFF;
	
	spi_comm(&buff[0],4);  	// Call SPI transfer function 	
	data_value = buff[3];
	
	return data_value; 		   	// Return data
}

/*****************************************************************************
Name:        SPI_send_receive   
Parameters:  data and number of bytes to send/receive                   
Returns:     none
Description: Performs SPI transfers. The CS of the device is brought low prior
			 to the serial data transfers and brought high afterwards.    
*****************************************************************************/
void spi_comm(char *data, int bytes )
{

	int i;
	char *data_buff;
	
	while( !ti_u1c1 );			// Ensure transmit buffer is empty 
  	while( !txept_u1c0 );		// Ensure transmit register is empty
	i = u1rbl; 					// Read receive buffer to empty it 
  	re_u1c1 = 1;				// Enable rx
    te_u1c1 = 1;				// Enable tx
	data_buff = data; 			// Initialize data pointer
	
	CHIP_SELECT = 0;  			// Bring CS low to enable device access
	
	for(i = 0; i <  bytes ; i++) {
		u1tbl = *data_buff;		// Transmit data
		while( !ri_u1c1 );		// Wait for rx to be completed
		*data_buff = u1rbl;  	// Copy received data to buffer
		++data_buff;			// Increment data pointer
	}
	
  	re_u1c1 = 0;				// Disable rx
  	te_u1c1 = 0;				// Disable tx
  	CHIP_SELECT = 1;			// Bring CS' high
}

/*****************************************************************************
Name: Init_Sampling  
Parameters:  none
Returns:     none
Description: Initializes timer A0 to generate an interrupt every 1ms. The 
             SKP16C26A is running the PLL at 20MHz. BCLK is set to f1 of 
 			 Xin in ncrt0_26askp_spi.a30.  
*****************************************************************************/
void Init_Sampling(void)
{	// Timer A0 

	//ta0 = (unsigned int) (((f1_CLK_SPEED/32)*1e-3)-1);	// ((20MHz/32)*1ms)-1 
	ta0 = 0x7fff;
	ta0mr = 0x80;		// Timer mode,  f32 source
	
	sample_time = 10;
	DISABLE_IRQ;		// Disable global interrupts
	ta0ic = 3;			// Enable timer A0 interrupt
	ENABLE_IRQ; 		// Enable global interrupts

	ta0s = 1;			// Start timer A0
}


/*****************************************************************************
Name: TimerA0_Intr  
Parameters:  none
Returns:     none
Description: Timer A0 interrupt service routine that changes a flag to 
			 initiate an SPI write or read operation.

			 Timer A0 vector in sect30_26askp_spi.inc file was modified to 
			 point to this routine.
*****************************************************************************/
void TimerA0_Intr(void)								// Timer A0 interrupt service routine 
{
	DISABLE_IRQ;		// Disable global interrupts
	overflow_count++; 
  	if(overflow_count>=sample_time){
		new_sample = 1;
		GRN_LED = LED_ON;
		overflow_count=0;
	}
	ENABLE_IRQ; 		// Enable global interrupts 
}

