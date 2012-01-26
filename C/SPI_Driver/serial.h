#ifndef SERIAL_H
#define SERIAL_H

//#define NULL (0)
 
// direction selection for GPIO
#define DIR_IN  (0)
#define DIR_OUT (1)


// polarity selection for interrupts
#define FALLING_EDGE (0) 
#define RISING_EDGE  (1)

#define SYNCH_CHAR '~'

#define Q_SIZE (32)

typedef struct {
  unsigned char Data[Q_SIZE];
  unsigned int Head; // points to oldest data element 
  unsigned int Tail; // points to next free space
  unsigned int Size; // quantity of elements in queue
} Q_T;

//Q_T tx_q, rx_q;

int Q_Empty(Q_T * q);
int Q_Full(Q_T * q);
int Q_Enqueue(Q_T * q, unsigned char d);
unsigned char Q_Dequeue(Q_T * q);
void Q_Init(Q_T * q);
extern void delay(long unsigned int n);
extern void init_UART0(void);
extern void send_string(_far char * s);
extern void send_char(unsigned char s);
void send_serial_msg(void);

#endif