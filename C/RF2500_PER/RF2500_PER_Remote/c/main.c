// PER Remote Main Function
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
#include <radio.h>
#include <timer.h>

#define ADDRESS_LENGTH 5

// Global Variables
extern volatile uint8 packetSent;
extern volatile uint8 packetReceived;

uint16 TEST_PKT_CNT = 0, thisPktNum = 0, lastPktNum = 0;
int16 failPkts=0;


// Predefine a static address 
uint8 remote_address[ADDRESS_LENGTH]  = {2,162,33,177,231}; 
uint8 local_address[ADDRESS_LENGTH]  = {0xE7,0xA2,0x21,0xB1,0x00}; 
uint8 data[64];
uint8 rxStatus[2]; 
int8 RSSI;

// Main() Functions

void system_init(void);
void radio_handler(void);
void getRSSI(void);
void packetSorter(uint8 * packet, uint8 * length);
uint8 address_checker(uint8 * test_address);
void Packet_Ack(uint8 *test_code);
void PERTest_NoAck(uint8 *test_code);
void PERTest_PLAck(uint8 *test_code);
void Send_PktCnt(uint8 *test_code);
void send_status(uint8 *test_code, uint8 PLWidth, uint16 count);


//**************************************************
// Main()
//**************************************************
void main(void)
{ 
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;                 
    
  // Initialize System
  system_init();
  thisPktNum = 0;lastPktNum = 0;failPkts = 0;
  radioMode(RX_MODE);
  halMcuWaitUs(2500l);
  for (;;)
  {  
    halLedSet(2);             // set green led to indicate readiness
    // check flags upon waking up
    if(packetReceived)
    {
      halLedClear(2);         // clear green led once RF signal rx'd
      radio_handler();           // execute radio handler to handle flags
      packetReceived = FALSE;
    }
  }
}

//**************************************************
//  radio_handler()...
//  Get the Received Packet and undertake the different functions 
//  according to the required test
//
//**************************************************
void radio_handler(void)
{
  uint8 status;
  uint8 packetLength;
    
  status = getRecvPacket(data,&packetLength, rxStatus);
  // check status to make sure packet is good
  if(status == RX_OK)
  {
    getRSSI();
    // check 5 byte address to make sure packet was intended for this node
    if(address_checker(&data[1]))
    {   
      // send data to packet sorter
      packetSorter(data,&packetLength);
//      data[55] = 0;
    }
    
  }
  radioMode(RX_MODE);          // Initialize Radio
}

//**************************************************
//  address_checker()...
//  checks the address in the packet for the correct node address
//  returns 0 - if test address does not match
//  returns 1 - if test address matches
//
//**************************************************
uint8 address_checker(uint8 * test_address)
{
  uint8 i;
  // the data[1-5] are the address bytes
  for(i = 0; i < ADDRESS_LENGTH; i++)
  {
    if(test_address[i] != remote_address[i])
    {
      return 0;
    }
  }  
  return 1;
  
}

//**************************************************
//  packetSorter()...
//  Sorts for the packet for the test command and packet count
//
//**************************************************
void packetSorter(uint8 * packet, uint8 * length)
{
  uint8 test_code, i=0, j=0;
  
  test_code = packet[6];
  i = packet[7];
  j = packet[8];
  TEST_PKT_CNT = (j << 8) + i;
  
  halLedSet(1);             // set red led to indicate working
  // packet format
  // 0   - command  // 1-9 - data        
  switch(test_code)
  {
  case 0:                      // status code (return crack,power,and time of crack)
    break;
  case 1:                       // Single Packet Test
    Packet_Ack(&test_code);      // Ack the Single Packet
    halLedClear(1);             // Clear red led to indicate done
    break;
  case 2:                      // Continuous Packet Test
    Packet_Ack(&test_code);   // Continuously Ack the Packets 'Pkt_Cnt' times
    halLedClear(1);             // toggle red led to indicate done
    break;
  case 3:                      // PERTest_PLAck
    PERTest_PLAck(&test_code);           // 1000 Packet - PER Test with auto acknowledgement disabled and Payload Ack Back under uC control. 
    halLedClear(1);             // toggle red led to indicate done
    break;
  case 4:                      // Send Latest Packet Count for the last test
    Send_PktCnt(&test_code);           // 1000 Packet - PER Test with auto acknowledgement disabled and Payload Ack Back under uC control. 
    halLedClear(1);             // toggle red led to indicate done
    break;
  default:
    break;        
  }  
}

//***************************************************************
//  Packet_Ack()...
//  - Remote Node transmits the Acknowledgement for Rx'd packet...
//  - Used only for Single and Continuous packet tests
//
//***************************************************************
void Packet_Ack(uint8 *test_code){
     
  thisPktNum = TEST_PKT_CNT;                        // Get packet number from buffer
  failPkts += (thisPktNum - lastPktNum - 1);    // Increment failed packets as difference between new received pkt number 
  lastPktNum = thisPktNum;                      // and last stored pkt number   
  if(failPkts<=0){failPkts = 0;}
  halMcuWaitUs(2500l);
  send_status(test_code, ACK_WIDTH, lastPktNum);
}

//***************************************************************
//  PERTest_PLAck()...
//  The Remote Node has received a command to conduct the 
//  1000 Packet - PER Test with auto acknowledgement disabled and Payload Ack Back under uC control!
//  - Remote Node goes into RX_Mode and waits to Rx packets from Local Node...
//  - Upon Rx'ing the packet, Remote Node goes into TX_Mode and transmits the Rx'd packet back 
//    to the Local Node. 
//  
//***************************************************************
void PERTest_PLAck(uint8 *test_code){
     
  thisPktNum = TEST_PKT_CNT;                        // Get packet number from buffer
  failPkts += (thisPktNum - lastPktNum - 1);    // Increment failed packets as difference between new received pkt number 
  lastPktNum = thisPktNum;                      // and last stored pkt number  
  if(failPkts<=0){failPkts = 0;}
  halMcuWaitUs(2500l);
  send_status(test_code, ACK_WIDTH, lastPktNum);
}

//**************************************************************
//  Send_PktCnt()...
//  Acknowledges the Local Node request and transmits the number of fail packets in the test.
//
//**************************************************************
void Send_PktCnt(uint8 *test_code){
     
  halMcuWait_ms(2);
  send_status(test_code, ACK_WIDTH, failPkts);
  halMcuWait_ms(5);
  thisPktNum = 0;lastPktNum = 0;failPkts = 0;
}

//**************************************************************** 
//  getRSSI()...
//  retrieve and store RSSI value 
//****************************************************************
void getRSSI(void){
  
  RSSI = rxStatus[0];
  if(RSSI < 127){RSSI = (RSSI/2) - RSSI_OFFSET;}
  else {RSSI = ((RSSI-255)/2) - RSSI_OFFSET;}
  RSSI ^= 0xFF;
  RSSI++;
}

//**************************************************************** 
//  send_status()...
//  send the Remote node Data to Local Node
//****************************************************************
void send_status(uint8 *test_code, uint8 PLWidth, uint16 count)
{
  uint8 i;
  uint8 length;
  
  length = PLWidth + 9;
  
  data[0] = length;                      // length of payload will be 15 bytes
  data[1] = local_address[0];
  data[2] = local_address[1];
  data[3] = local_address[2];
  data[4] = local_address[3];
  data[5] = local_address[4];
  
  data[6] = *test_code;                        // original code from sender for confirmation
  data[7] = count;
  data[8] = count >> 8;
  data[9] = RSSI;
   
  for(i=10;i<PLWidth+10;i++){
    data[i] = 0;
  }
  
  if(checkChannel(CHAN_WAIT_TIME))
    txSendPacket(data,length+1);           // send packet to local node
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
  // Initialize Radio  
  radioInit(STNDBY_MODE);
  halMcuWaitUs(50000l);
  halIntOn();
  
}
