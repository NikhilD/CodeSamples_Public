/* 	This program demonstrates the serial I/O using interrupts.
	It communicates via UART0 at desired baud, 8 data bits
	no parity bit and one stop bit. UART0's TxD is at P6_3
	and RxD is at P6_2. Two queues (tx_q and rx_q) are used
	to buffer data between the program and the UART.

	demo() sends a greeting message and then sends a 
	response each time a character is received by the UART.
	
*/

#include "qsk_bsp.h"
#include "serial.h"
#include "spi_init.h"

#define  CNTR_IPL 0x03   // TB0  priority interrupt level

Q_T tx_q, rx_q;
unsigned long t=0;
unsigned char serial_msg[5] = {0,0,0,0,0};
extern unsigned char buff[4], rd_value;

int Q_Empty(Q_T * q) {
  return q->Size == 0;
}

int Q_Full(Q_T * q) {
  return q->Size == Q_SIZE;
}

int Q_Enqueue(Q_T * q, unsigned char d) {
  // if queue is full, abort rather than overwrite and return
  // an error code
  if (!Q_Full(q)) {
    q->Data[q->Tail++] = d;
    q->Tail %= Q_SIZE;
    q->Size++;
    return 1; // success
  } else 
    return 0; // failure
}

unsigned char Q_Dequeue(Q_T * q) {
  // Must check to see if queue is empty before dequeueing
  unsigned char t=0;
  if (!Q_Empty(q)) {
    t = q->Data[q->Head];
    q->Data[q->Head++] = 0; // empty unused entries for debugging
    q->Head %= Q_SIZE;
    q->Size--;
  }
  return t;
}

void Q_Init(Q_T * q) {
  unsigned int i;
  for (i=0; i<Q_SIZE; i++)  
    q->Data[i] = 0;  // to simplify our lives when debugging
  q->Head = 0;
  q->Tail = 0;
  q->Size = 0;
}

void delay(long unsigned int n){
  while (n--);
}

void init_UART0(void) {
  // UART 0 bit rate generator
  u0brg = (unsigned char) (f1_CLK_SPEED/(16*57600) - 1); 

  // UART 0 transmit/receive mode register
  smd2_u0mr = 1;   // eight data bits
  smd1_u0mr = 0; 
  smd0_u0mr = 1;
  ckdir_u0mr = 0; // internal clock
  stps_u0mr = 0;
  pry_u0mr = 0; 
  prye_u0mr = 0; // no parity

  // uart0 t/r control register 0
  // 20 MHz -> 57,600 baud
  clk1_u0c0 = 0; // select f/1 clock
  clk0_u0c0 = 0;
  nch_u0c0 = 0; // CMOS push-pull output
  ckpol_u0c0 = 0; // required
  uform_u0c0 = 0; // required
  crs_u0c0 = 0; // required
  crd_u0c0 = 1; // required

  // uart0 t/r control register 1
  te_u0c1 = 1; // enable transmitter
  re_u0c1 = 1; // enable receiver

  // uart t/r control register 2
  u0irs = 0;   // select interrupt source
  u1rrm = 0;   // select interrupt source
  clkmd0 = 0;  // n/a
  clkmd1 = 0;  // n/a
  rcsp=1;	   // rxdo port to p6_2

  // enable UART0 rx and tx interrupts, set priority levels
  s0ric = 5;
  s0tic = 4;
  
}

#pragma INTERRUPT /B u0_tx_isr
void u0_tx_isr(void) {  
  if (!Q_Empty(&tx_q))
    u0tbl = Q_Dequeue(&tx_q);  
}

#pragma INTERRUPT /B u0_rx_isr
void u0_rx_isr(void) {  
  rx_q.Data[30] = u0rbl;
  send_serial_msg();    
}

void send_string(_far char * s) {
  // enqueue a null-terminated string for serial tx

  while (*s) {
    if (Q_Enqueue(&tx_q, *s))
      s++;
    else { 
      // queue is full, wait for some time or signal an error?
    }
  }
  
  // if transmitter not busy, get it started
  if (ti_u0c1) {
    u0tbl = Q_Dequeue(&tx_q);
  }
}

void send_char(unsigned char s) {
  // if transmitter not busy, get it started
  if (ti_u0c1) {
    u0tbl = s;
  }
}

void send_serial_msg(){
		
	send_string("here\n\r");
	//send_string(&buff[0]);
	send_char(rd_value);
	RED_LED = LED_ON;
}

