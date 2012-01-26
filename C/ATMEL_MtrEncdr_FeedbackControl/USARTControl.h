/************************************************************************/
/*																		*/
/*	USARTControl.h	--													*/
/*																		*/
/************************************************************************/

/* ------------------------------------------------------------ */
/*					Miscellaneous Declarations					*/
/* ------------------------------------------------------------ */
#define	BAUD9600	103		//	setting for Fosc = 8MHz, U2Xn=1
#define	BAUD19200	51		//	setting for Fosc = 8MHz, U2Xn=1

/* ------------------------------------------------------------ */
/*					General Type Declarations					*/
/* ------------------------------------------------------------ */
#define CR   0x0D
#define LF   0x0A

/* ------------------------------------------------------------ */
/*					Object Class Declarations					*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Variable Declarations						*/
/* ------------------------------------------------------------ */

#define UART_PORT		PORTD
#define UART_DIR		DDRD
#define UART_RXPIN		bnJD9	
#define	UART_TXPIN		bnJD10


/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

void usart_init(void);
void usart_send_uchar(unsigned char );
void usart_send_char(char );
void usart_send_int(int );
void usart_send_uint(WORD );
void usart_send_UDec(uint16_t );
void usart_send_string(char *);
void usart_send_float_string(float *, uint8_t);
void usart_send_float_char(float *, uint8_t);
