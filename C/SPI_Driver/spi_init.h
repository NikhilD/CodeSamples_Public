#ifndef _SPI_INIT_H
#define _SPI_INIT_H

/* Prototype declarations */

extern void spi_write(unsigned char value, unsigned int addr);					// Formats buffer for writing
extern unsigned char spi_read(unsigned int addr);							// Formats buffer for reading
extern void spi_comm(char *data, int bytes);		// The SPI transfer function
extern void Init_Sampling(void);							// Used to initiate writing/reading 

/* Interrupt function declarations */ 
#pragma INTERRUPT TimerA0_Intr
void TimerA0_Intr(void);								// Timer A0 interrupt service routine 

#define CHIP_SELECT 		p6_4
#define CHIP_SELECT_DDR		pd6_4
#define SPI_CLK_RATE 		500e3			// 500kHz bit rate
#define SCLK 				p6_5
#define SCLK_DDR			pd6_5
#define MISO 				p6_6
#define MISO_DDR			pd6_6
#define MOSI 				p6_7
#define MOSI_DDR 			pd6_7

extern void spi_init(void);

#endif