// PER Local Main Function
#include <hal_types.h>
#include <hal_defs.h>
#include <hal_board.h>
#include <hal_uart.h>
#include <hal_led.h>
#include <hal_spi.h>
#include <hal_int.h>
#include <hal_mcu.h>
#include <hal_rf.h>
#include <cc2500.h>
#include <stdlib.h>
#include <timer.h>
#include <radio.h>
#include "usart.h"

#define ADDRESS_LENGTH 5


// Global Variables
extern volatile uint8 packetSent;
extern volatile uint8 packetReceived;
extern SerialPacket serialRxData;
extern SerialPacket serialTxData;
extern volatile uint8 serialReceived;

uint8 local_address[ADDRESS_LENGTH]  = {0xE7,0xA2,0x21,0xB1,0x00};
uint8 remote_address[ADDRESS_LENGTH]  = {2,162,33,177,231}; 

uint8 data[64];
uint8 rxLength; uint8 rxStatus[2];
uint16 test_type = 0; 
uint8 Routine = 0, RUN = 1; 
uint8 RSSI;
uint16 thisPktNum=0, lastPktNum=0, PKT_CNT=0, timeout;
int16 failPkts=0;

// Main()'s Functions
void system_init(void);
void Serial_RCV(void);                                 // Receive Serial Input data
void Single_Test(void);                                // Single Test function 
void Continuous_Test(void);                            // Continuous Test function
void PER_Test_PL_Ack(void);                            // ACK under uC control PER
void Ask_PktCnt(void);
void send_status(uint8 test_code, uint8 PLWidth, uint16 count);
void getRSSI(void);
void SerialOut(uint16 packets);
void ClearData(void);

//*****************
//  main()...
//*****************
void main(void)
{ 
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;                 
  
  // Initialize System
  system_init();
/*  for(;;){
    halMcuWaitUs(50000l);
  halLedSet(1);
  halMcuWaitUs(50000l);
  halLedClear(1);
  }*/
  while(RUN)
  {  
    switch(Routine){
        case 0: Serial_RCV();       break;      // Check for Command from Serial Input
        case 1: Single_Test();      break;      // Conduct the tests...
        case 2: Continuous_Test();  break;      
        case 3: PER_Test_PL_Ack();  break;
        case 4: Ask_PktCnt();       break;
        default: break;
    }    
  }
    
//  halMcuSetLowPowerMode(HAL_MCU_LPM_0);       // sleep
   
}

//**************************************************************
//  Serial_RCV()...
//  Analyzes the Serial input data for the execution command required to execute the tests...
//  The packet format input has the command number in the ser_rx_pkt.header byte...
//  serialRxData.header = '1' (Decimal 49)...Single Packet Test
//  serialRxData.header = '2' (Decimal 50)...Continuous Packets Test
//  serialRxData.header = '3' (Decimal 51)...1000 Packet - PER Test with auto acknowledgement disabled 
//  serialRxData.header = '4' (Decimal 52)...1000 Packet - PER Test with auto acknowledgement disabled and Payload Ack Back under uC control.
//  serialRxData.header = '5' (Decimal 53)...Ask for Lost Pkt Cnt for test_types
//
//**************************************************************
void Serial_RCV(void)
{
  halLedSet(2);
  halMcuWaitUs(5000l);
  usart_init();
  halMcuWaitUs(5000l);
  halLedClear(1);halLedClear(2);
  test_type=0;serialRxData.header=0;
  
  for(;;)
  {
    if(serialReceived)
    {
      test_type = serialRxData.header;
      serialReceived = FALSE;     
      break;
    }    
  }
  if(test_type==49){Routine = 1;} 
  else if(test_type==50){Routine = 2;} 
  else if(test_type==51){Routine = 3;}   
  else if(test_type==52){Routine = 4;}
  else{Routine = 0;}  
}

//**************************************************************
//  Single_Test()...
//  Local Node sends a Single Packet with arbitrary data to the Remote Node and waits for an ACK.
//  0x01...for Single Test Command
//  Communicate '1' to UART if successful ACK OR '0' if no ACK. 
//  Only payload[1] matters for the serial comm...payload[0] is also sent to keep consistency for the Matlab UART receiver. (MSB first reqd.)
//
//**************************************************************
void Single_Test(void){
 
  uint8 ack_cnt=0;
  send_status(0x01, ACK_WIDTH, 1);  
  timeout = CHAN_WAIT_TIME + 10;
  radioMode(RX_MODE);
  packetReceived = FALSE;
  while(1){
    if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) == RX_OK))
    {
      ack_cnt++;     
      halLedToggle(2);                                // Toggle Green LED for successful reception of data
      packetReceived = FALSE;
      getRSSI();
      break;
    }
    else if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) != RX_OK))
    {
      halLedToggle(1);                               // Toggle Red LED for failure      
      packetReceived = FALSE;
      break;
    }
    else{
      timeout--;
      halMcuWaitUs(1000l);
    }
    if(timeout == 0){halLedToggle(1);break;}
  }
  SerialOut(ack_cnt); 
  radioMode(TX_MODE);  
  Routine = 0;
}  

//**************************************************************
//  Continuous_Test()...
//  Sends 100 Packets continuously with arbitrary data... checks for Ack on each of the packets
//  0x02...for Continuous Test Command
//  Communicate the number of successful Ack Counts to the UART at the end of the test.
//  Each packet is sent after a delay of 500 ms.
//  Only payload[1] matters for the serial comm...payload[0] is also sent to keep consistency for the Matlab UART receiver. (MSB first reqd)
//
//**************************************************************
void Continuous_Test(void){   

  uint8 i, ack_cnt=0;
  PKT_CNT = 100;                                  // Number of Packets in this test

  for(i=1;i<PKT_CNT+1;i++){
    send_status(0x02, ACK_WIDTH, i);     // Transmit and Act based on acknowledgement received from Remote Node...
    timeout = CHAN_WAIT_TIME + 10;
    radioMode(RX_MODE);
    packetReceived = FALSE;
    while(1){
      if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) == RX_OK))
      {
        ack_cnt++;     
        halLedToggle(2);                                // Toggle Green LED for successful reception of data
        getRSSI();
        packetReceived = FALSE;
        break;
      }
      else if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) != RX_OK))
      {
        halLedToggle(1);                               // Toggle Red LED for failure      
        getRSSI();
        packetReceived = FALSE;
        break;
      }
      else{
        timeout--;
        halMcuWaitUs(1000l);
      }
      if(timeout == 0){halLedToggle(1);break;}
    }
    halMcuWait_ms(250);              
    halMcuWait_ms(250);              // wait 500ms
  }
  SerialOut(ack_cnt);           
  radioMode(TX_MODE);  
  Routine = 0;
}

//**************************************************************
//  PER_Test_PL_Ack()...
//  Requests Remote Node to prepare for "1000 Packet - PER Test with auto acknowledgement disabled and Payload Ack Back under uC control"
//  ... Auto Ack is disabled at both Local and Remote Nodes... the remote node acknowledges the Rx'd packet by Tx'ing the Rx'd packet itself.
//  0x04...for PER Test with Payload Ack Back under uC control
//  A successful packet test is a successful exchange of the packet between Local and Remote Nodes with same packet number on both sides.
//  This test is different from the "PER_Test_No_Ack()". Here we want to know exactly which of the 1000 packets was dropped.
//  A time delay of 150 ms. is used to time out Local Node for each increment of Packet Number in case "Ack" is not received in time.
//  Each packet itself acts as the packet number being Tx'd and Rx'd.
//  Both payload[0] & payload[1] matter for the serial comm. at the Matlab UART receiver.(MSB first reqd.)
//
//**************************************************************
void PER_Test_PL_Ack(void){   

  uint8 i=0,j=0;
  uint16 k=0;
  thisPktNum = 0; lastPktNum = 0; failPkts = 0;
  PKT_CNT = 1000;                                 // Number of packets in this test

  for(k=1;k<PKT_CNT+1;k++){
    send_status(0x03, ACK_WIDTH, k);     // Transmit and Act based on acknowledgement received from Remote Node...
    timeout = CHAN_WAIT_TIME + 10;
    radioMode(RX_MODE);
    packetReceived = FALSE;
    while(1){
      if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) == RX_OK))
      {
        i = data[7];    // LSB
        j = data[8];    // MSB
        thisPktNum = (j << 8) + i;                        // Get packet number from buffer
//        failPkts += (thisPktNum - lastPktNum - 1);    // Increment failed packets as difference between new received pkt number 
        lastPktNum = thisPktNum;                      // and last stored pkt number      
        halLedToggle(2);                                // Toggle Green LED for successful reception of data
        getRSSI();
        packetReceived = FALSE;
        break;
      }
      else if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) != RX_OK))
      {
        halLedToggle(1);                               // Toggle Red LED for failure      
        packetReceived = FALSE;
        failPkts++;
        break;
      }
      else{
        timeout--;
        halMcuWaitUs(1000l);
      }
      if(timeout == 0){
        halLedToggle(1);failPkts++;
        break;}
    }
    halMcuWaitUs(50000l);              
  }
  if(failPkts<=0){failPkts = 0;}
  SerialOut(failPkts);            
  radioMode(TX_MODE);  
  Routine = 0;
}

//**************************************************************
//  Ask_PktCnt()...
//  Requests Remote Node to transmit the number of fail packets in the test
//  Both payload[0] & payload[1] matter for the serial comm. at the Matlab UART receiver.(MSB first reqd.)
//
//**************************************************************
void Ask_PktCnt(void){
  
  send_status(0x04, ACK_WIDTH, 0);
  radioMode(RX_MODE);
  packetReceived = FALSE;
  timeout = CHAN_WAIT_TIME + 10;
  while(1){
    if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) == RX_OK))
    {
      packetReceived = FALSE;
      halLedToggle(2);
      break;
    }
    else if((packetReceived == TRUE) && (getRecvPacket(data,&rxLength,rxStatus) != RX_OK))
      {
        halLedToggle(1);                               // Toggle Red LED for failure      
        packetReceived = FALSE;
        break;
      }
    else
    {
      timeout--;
      halMcuWaitUs(1000l);
    }
    if(timeout == 0){halLedToggle(1);break;}// Toggle Red LED to indicate failure of the particular packet
  }   
  serialRxData.payload[0] = data[8]; serialRxData.payload[1] = data[7];       //Communicate the number of failed packets.
  serialRxData.payload[2] = data[10]; serialRxData.payload[3] = data[9]; 
  usart_send_byte(serialRxData.payload[0]);usart_send_byte(serialRxData.payload[1]);
  usart_send_byte(serialRxData.payload[2]);usart_send_byte(serialRxData.payload[3]);
  radioMode(TX_MODE);                 // Re-initialize Local Node radio using Tx mode and static address
  Routine = 0;
}

//**************************************************************** 
//  send_status()...
//  send the Local node Data to Remote Node
//****************************************************************
void send_status(uint8 test_code, uint8 PLWidth, uint16 count)
{
  uint8 i;
  uint8 length;
  length = PLWidth + 9;
  
  data[0] = length;                      // length of payload will be 15 bytes
  data[1] = remote_address[0];
  data[2] = remote_address[1];
  data[3] = remote_address[2];
  data[4] = remote_address[3];
  data[5] = remote_address[4];
  
  data[6] = test_code;                        // original code from sender for confirmation
  data[7] = count;
  data[8] = count >> 8;
  data[9] = 0;
    
  for(i=10;i<PLWidth+10;i++){
    data[i] = 0;
  }
  
  if(checkChannel(CHAN_WAIT_TIME))
    txSendPacket(data,length+1);           // send packet to local node
}

//**************************************************************** 
//  getRSSI()...
//  retrieve and store RSSI value 
//****************************************************************
void getRSSI(void){

  RSSI = rxStatus[0];
  if(RSSI >= 128){RSSI = ((RSSI-256)/2) - RSSI_OFFSET;}
  else if(RSSI < 128){RSSI = (RSSI/2) - RSSI_OFFSET;}  
  RSSI ^= 0xFF;
  RSSI++;
}

void SerialOut(uint16 packets){

  serialRxData.payload[0] = packets >> 8; serialRxData.payload[1] = packets;       //Communicate the number of acknowledged packets.
  serialRxData.payload[2] = 0; serialRxData.payload[3] = RSSI; 
  usart_send_byte(serialRxData.payload[0]);usart_send_byte(serialRxData.payload[1]);
  usart_send_byte(serialRxData.payload[2]);usart_send_byte(serialRxData.payload[3]);             
}

void ClearData(void){

  thisPktNum=0, lastPktNum=0, PKT_CNT=0; failPkts=0; RSSI=0;
}
//**************************************************************** 
//  system_init()...
//  Initialize system parameters
//****************************************************************
void system_init(void)
{
//  uint8 i = 0;
  
  // Configure all ports to output low to save power (prevents floating inputs)
  P1DIR = 0xFF;                             // All P1.x outputs
  P1OUT = 0;                                // All P1.x reset
  P2DIR = 0xFF;                             // All P2.x outputs
  P2OUT = 0;                                // All P2.x reset
  P3DIR = 0xFF;                             // All P3.x outputs
  P3OUT = 0;                                // All P3.x reset
  P4DIR = 0xFF;                             // All P4.x outputs
  P4OUT = 0;                                // All P4.x reset  
    
  halBoardInit();                    // initialize board, ports, LEDs, spi
  halIntOff();                       // turn of global interrupts for now
  halMcuWaitUs(50000l);
  halMcuWaitUs(50000l);
  usart_init();                 // initialize usart
  // Initialize Radio  
  radioInit(TX_MODE);
  serialReceived = FALSE;
  halMcuWaitUs(50000l);
  halIntOn();
  
}

