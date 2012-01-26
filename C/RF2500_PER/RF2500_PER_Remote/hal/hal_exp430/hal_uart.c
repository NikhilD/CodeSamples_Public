/***********************************************************************************
    Filename: hal_uart.c

    Copyright 2007 Texas Instruments, Inc.
***********************************************************************************/

#include "hal_types.h"
#include "hal_uart.h"
#include "hal_board.h"


//----------------------------------------------------------------------------------
//  void halUartInit(uint8 baudrate, uint8 options)
//----------------------------------------------------------------------------------
void halUartInit(uint8 baudrate, uint8 options)
{
    // For the moment, this UART implementation only
    // supports communication settings 115200 8N1
    // i.e. ignore baudrate and options arguments.

     P3SEL |= 0x30;                            // P3.4,5 = USCI_A0 TXD/RXD
     UCA0CTL1 |= UCSSEL_2;                     // SMCLK
     UCA0BR0 = 69;                             // 8MHz 115200
     UCA0BR1 = 0;                              // 8MHz 115200
     UCA0MCTL = UCBRS0;                        // Modulation UCBRSx = 1
     UCA0CTL1 &= ~UCSWRST;                     // **Initialize USCI_A state machine**
     IE2 |= UCA0RXIE;                          // Enable USCI_A0 RX interrupt 
}

//----------------------------------------------------------------------------------
//  void halUartWrite(const uint8* buf, uint16 length)
//----------------------------------------------------------------------------------
void halUartWrite(const uint8* buf, uint16 length)
{
    uint16 i;
    for(i = 0; i < length; i++)
    {
        while (!(IFG2 & UCA0TXIFG));   // Wait for TX buffer ready to receive new byte
        UCA0TXBUF = buf[i];            // Output character
    }
}

//----------------------------------------------------------------------------------
//  void halUartWriteByte(uint8 byte)
//----------------------------------------------------------------------------------
void halUartWriteByte(uint8 byte)
{
  while (!(IFG2&UCA0TXIFG));                // USCI_A0 TX buffer ready?
  UCA0TXBUF = byte;                         // transmit byte
}

//----------------------------------------------------------------------------------
//  void halUartRead(uint8* buf, uint16 length)
//----------------------------------------------------------------------------------
void halUartRead(uint8* buf, uint16 length)
{
}

