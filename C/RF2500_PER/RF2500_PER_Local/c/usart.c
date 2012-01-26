
#include <hal_types.h>
#include <hal_defs.h>
#include <hal_int.h>
#include <hal_board.h>
#include <hal_mcu.h>
#include "usart.h"

volatile uint8 serialReceived;
SerialPacket serialRxData;
SerialPacket serialTxData;

// create rx and tx packet structures for serial communication

void usart_init(void)
{
  P3SEL |= BIT4 + BIT5;                      // P3.4,5 = USCI_A0 TXD/RXD
  UCA0CTL1 |= UCSSEL_2;                     // SMCLK
  UCA0BR0 = 65;                             // 8MHz 9600...UCBRx=833
  UCA0BR1 = 3;                              // 8MHz 9600
  UCA0MCTL = UCBRS1;                        // Modulation UCBRSx = 2
  UCA0CTL1 &= ~UCSWRST;                     // **Initialize USCI_A state machine**
  IE2 |= UCA0RXIE;                          // Enable USCI_A0 RX interrupt   
}

// send a byte
void usart_send_byte(uint8 data)
{
  while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
  UCA0TXBUF = data;                         // transmit byte
}

// transmit an integer sending the MSB last since this is how Matlab interprets an integer using fread()
void usart_send_int(int data)
{
  
  while (!(IFG2&UCA0TXIFG));       // USCI_A0 TX buffer ready?
  UCA0TXBUF = (char)data;          // transmit LSB 
  
  while (!(IFG2&UCA0TXIFG));       // USCI_A0 TX buffer ready?
  UCA0TXBUF = (char)(data >> 8);   // transmit MSB
  
}

void usart_send_bytes(uint8 * data, uint8 size)
{
  uint8 i = 0;
  
  for(i = 0; i < size; i++)
  {
     while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
     UCA0TXBUF = data[i];                      // transmit byte    
  }
  
}

void usart_send(uint16 * data, uint16 size)
{
  unsigned int i = 0;
  
  for(i = 0; i < size; i++)
  {
    while (!(IFG2&UCA0TXIFG));           // USCI_A0 TX buffer ready?
    UCA0TXBUF = (uint8)data[i];          // transmit LSB 
  
    while (!(IFG2&UCA0TXIFG));           // USCI_A0 TX buffer ready?
    UCA0TXBUF = (uint8)(data[i] >> 8);   // transmit MSB 
  }
  
}

// Echo back RXed character, confirm TX buffer is ready first
#pragma vector=USCIAB0RX_VECTOR
__interrupt void USCI0RX_ISR(void)
{
  serialRxData.header = UCA0RXBUF;                      // grab byte from rx buffer
  serialReceived = TRUE;
//    __low_power_mode_off_on_exit();       // wake up mcu when interrupt occurs
}
  
  
