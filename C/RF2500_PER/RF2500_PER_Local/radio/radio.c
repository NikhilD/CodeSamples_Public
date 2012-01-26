#include <hal_types.h>
#include <hal_defs.h>
#include <hal_mcu.h>
#include <hal_int.h>
#include <hal_board.h>
#include <hal_rf.h>
#include <cc2500.h>
#include "my_rf_settings.h"
#include <timer.h>
#include "radio.h"


//----------------------------------------------------------------------------------
//  Variables used in this file
//----------------------------------------------------------------------------------
volatile uint8 packetSent;
volatile uint8 packetReceived;
volatile uint8 clearChannel;
extern volatile uint8 timerDone;

//----------------------------------------------------------------------------------
//  void txISR(void)
//
//  DESCRIPTION:
//    This function is called (in interrupt context) every time a packet has been
//    transmitted.
//----------------------------------------------------------------------------------
static void txISR(void)
{
    packetSent = TRUE;
}

//----------------------------------------------------------------------------------
//  void rxISR(void)
//
//  DESCRIPTION:
//    This function is called (in interrupt context) every time a packet has been
//    revceived.
//----------------------------------------------------------------------------------
static void rxISR(void)
{
    packetReceived = TRUE;
}

//----------------------------------------------------------------------------------
//  void ccaISR(void)
//
//  DESCRIPTION:
//    This function is called (in interrupt context) every time the channel is
//    found to be clear before Tx'ing
//----------------------------------------------------------------------------------
static void ccaISR(void)
{
    clearChannel = TRUE;
}

//----------------------------------------------------------------------------------
//  void radioInit(uint8)
//
//  DESCRIPTION:
//    This function is called from system_init() to initialize the radio interface
//    with specified settings and mode.
//----------------------------------------------------------------------------------
void radioInit(uint8 mode)                        // Initialize Radio
{
  // Reset CC2500
  halRfResetChip();
  
  // Put radio to sleep
  halRfStrobe(CC2500_SPWD);  

  // Setup chip with register settings from SmartRF Studio
  halRfConfig(&myRfConfig, myPaTable, myPaTableLen);
  
  // Additional chip configuration for this example
  halRfWriteReg(CC2500_MCSM0,    0x18);   // Calibration from IDLE to TX/RX
  halRfWriteReg(CC2500_MCSM1,    0x30);   // CCA (RSSI below threshold & not currently receiving a packet), IDLE after TX and RX
  halRfWriteReg(CC2500_PKTCTRL0, 0x45);   // Enable data whitening and CRC
  halRfWriteReg(CC2500_PKTCTRL1, 0x04);   // Enable append mode
  halRfWriteReg(CC2500_IOCFG0,   0x06);   // Set GDO0 to be packet received signal
  
  // The packets being sent are smaller than the size of the
  // FIFO, thus all larger packets should be discarded. The packet length
  // filtering on the receiver side is necessary in order to handle the
  // CC2500 RX FIFO overflow errata, described in the CC2500 Errata Note.
  // Given a FIFO size of 64, the maximum packet is set such that the FIFO
  // has room for the length byte + payload + 2 appended status bytes (giving
  // a maximum payload size of 64 - 1 - 2 = 61.
  halRfWriteReg(CC2500_PKTLEN,     61);   // Max payload data length  
   
  radioMode(mode);            // put radio in selected 'mode'
  
}

void radioMode(uint8 mode)
{
  uint16 key;
  key = halIntLock();             // turn off interrupts to protect this code
  radioCCAInit();
  switch(mode)
  {
  case RX_MODE:                   // receiver mode
    radioRxInit();                // initialize radio interface for receiving
    halRfStrobe(CC2500_SRX);      // Set radio in RX mode
    break;
  case TX_MODE:                   // transmitter mode 
    radioTxInit();                // initialize radio for transmitting
    break;
  case STNDBY_MODE:               // standby mode
    break;
  case PWRDWN_MODE:               // power down mode
    halRfStrobe(CC2500_SPWD);
    break;
  }
  
  halIntUnlock(key);              // put interrupts back in previous state
}

//----------------------------------------------------------------------------------
//  void radioTxInit(void)
//
//  DESCRIPTION:
//    Set up chip to operate in TX mode
//----------------------------------------------------------------------------------
void radioTxInit(void)
{
  // Connect TX interrupt to event on GDO0
  halDigioIntSetEdge(&pinGDO0, HAL_DIGIO_INT_FALLING_EDGE);
  halDigioIntConnect(&pinGDO0, &txISR);
  halDigioIntEnable(&pinGDO0);
}

//----------------------------------------------------------------------------------
//  void RadioRxInit(void)
//
//  DESCRIPTION:
//    Set up chip to operate in RX mode
//----------------------------------------------------------------------------------
void radioRxInit(void)
{
  // Connect RX interrupt to event on GDO0
  halDigioIntSetEdge(&pinGDO0, HAL_DIGIO_INT_FALLING_EDGE);
  halDigioIntConnect(&pinGDO0, &rxISR);
  halDigioIntEnable(&pinGDO0);
  
}

//----------------------------------------------------------------------------------
//  void RadioCCAInit(void)
//
//  DESCRIPTION:
//    Set up chip to indicate CCA before Tx.
//----------------------------------------------------------------------------------
void radioCCAInit(void)
{
  // Connect CCA interrupt to event on GDO2
  halDigioIntSetEdge(&pinGDO2, HAL_DIGIO_INT_RISING_EDGE);  
  halDigioIntConnect(&pinGDO2, &ccaISR);
  halDigioIntEnable(&pinGDO2);  
}

//----------------------------------------------------------------------------------
//  uint8 txSendPacket(uint8* data, uint8 length)
//
//  DESCRIPTION:
//    Send a packet that is smaller than the size of the FIFO, making it possible
//    to write the whole packet at once. Wait for the radio to signal that the packet
//    has been transmitted.
//
//  ARGUMENTS:
//    data   - Data to send. First byte contains length byte
//    length - Total length of packet to send
//
//  RETURNS:
//    This function always returns 0.
//----------------------------------------------------------------------------------
uint8 txSendPacket(uint8* data, uint8 length)
{
    uint16 key;
    packetSent = FALSE;
        
    radioMode(TX_MODE);    

    // Write data to FIFO
    halRfWriteFifo(data, length);

    // Set radio in transmit mode
    halRfStrobe(CC2500_STX);

    // Wait for packet to be sent
    key = halIntLock();
    while(!packetSent)
    {
        halMcuSetLowPowerMode(HAL_MCU_LPM_3);
        key = halIntLock();
    }
    halIntUnlock(key);
    return(0);
}

//----------------------------------------------------------------------------------
//  uint8 rxRecvPacket(uint8* data, uint8* length)
//
//  DESCRIPTION:
//    Receive a packet that is smaller than the size of the FIFO, i.e. wait for the
//    complete packet to be received before reading from the FIFO. This function sets
//    the CC1100/CC2500 in RX and waits for the chip to signal that a packet is received.
//
//  ARGUMENTS:
//    data   - Where to write incoming data.
//    length - Length of payload.
//
//  RETURNS:
//    0 if a packet was received successfully.
//    1 if chip is in overflow state (packet longer than FIFO).
//    2 if the length of the packet is illegal (0 or > 61).
//    3 if the CRC of the packet is not OK.
//----------------------------------------------------------------------------------
uint8 rxRecvPacket(uint8* data, uint8* length, uint8* packetStatus)
{
//    uint8 packet_status[2];
    uint8 status;
    uint16 key;

    packetReceived = FALSE;
    status = RX_OK;
    
    // Put radio in receive mode
    radioMode(RX_MODE);                    

    // Wait for incoming packet
    key = halIntLock();
    while(!packetReceived)
    {
        halMcuSetLowPowerMode(HAL_MCU_LPM_3);
        key = halIntLock();
    }
    halIntUnlock(key);

    // Read first element of packet from the RX FIFO
    status = halRfReadFifo(length, 1);

    if ((status & CC2500_STATUS_STATE_BM) == CC2500_STATE_RX_OVERFLOW)
    {
        halRfStrobe(CC2500_SIDLE);
        halRfStrobe(CC2500_SFRX);
        status = RX_FIFO_OVERFLOW;
    }
    else if (*length == 0 || *length > 61)
    {
        halRfStrobe(CC2500_SIDLE);
        halRfStrobe(CC2500_SFRX);
        status = RX_LENGTH_VIOLATION;
    }
    else
    {
        data[0] = *length;
        // Get payload
        halRfReadFifo(&data[1], *length);

        (*length)++;               // increment packet length to include address at first position
        
        // Get the packet status bytes [RSSI, LQI]
        halRfReadFifo(packetStatus, 2);

        // Check CRC
        if ((packetStatus[1] & CC2500_LQI_CRC_OK_BM) != CC2500_LQI_CRC_OK_BM)
        {
            status = RX_CRC_MISMATCH;
        }
        else
        {
            status = RX_OK;
        }
    }
    return(status);
}

//----------------------------------------------------------------------------------
//  uint8 rxRecvPacketTime(uint8* data, uint8* length, uint8* packetStatus, uint8 time)
//
//  DESCRIPTION:
//    Receive a packet that is smaller than the size of the FIFO, i.e. wait for the
//    complete packet to be received before reading from the FIFO. This function sets
//    the CC1100/CC2500 in RX and waits for the chip to signal that a packet is received.
//
//  ARGUMENTS:
//    data   - Where to write incoming data.
//    length - Length of payload.
//    time- Length of time to wait for an incoming packet before giving up
//
//  RETURNS:
//    0 if a packet was received successfully.
//    1 if chip is in overflow state (packet longer than FIFO).
//    2 if the length of the packet is illegal (0 or > 61).
//    3 if the CRC of the packet is not OK.
//    4 if the timer timed out with no packet received
//----------------------------------------------------------------------------------
uint8 rxRecvPacketTime(uint8* data, uint8* length, uint8* packetStatus, uint8 time)
{
    //uint8 packet_status[2];
    uint8 status;
    uint16 key;
    
    packetReceived = FALSE;
    status = RX_OK;
    
    // Put radio in receive mode
    radioMode(RX_MODE);                       
    
    // Wait for incoming packet for 'timeout' period of time        
    sleep_ms(time);
    
    key = halIntLock();
    // Check for packet received
    if(packetReceived)
    {      
      halIntUnlock(key);
      
      // Read first element of packet from the RX FIFO
      status = halRfReadFifo(length, 1);
      
      if ((status & CC2500_STATUS_STATE_BM) == CC2500_STATE_RX_OVERFLOW)
      {
        halRfStrobe(CC2500_SIDLE);
        halRfStrobe(CC2500_SFRX);
        status = RX_FIFO_OVERFLOW;
      }
      else if (*length == 0 || *length > 61)
      {
        halRfStrobe(CC2500_SIDLE);
        halRfStrobe(CC2500_SFRX);
        status = RX_LENGTH_VIOLATION;
      }
      else
      {
        data[0] = *length;
        // Get payload
        halRfReadFifo(&data[1], *length);

        (*length)++;               // increment packet length to include address at first position
        
        // Get the packet status bytes [RSSI, LQI]
        halRfReadFifo(packetStatus, 2);
        
        // Check CRC
        if ((packetStatus[1] & CC2500_LQI_CRC_OK_BM) != CC2500_LQI_CRC_OK_BM)
        {
          status = RX_CRC_MISMATCH;
        }
        else
        {
          status = RX_OK;
        }
      }      
    }
    else
    {
      status = 4;       // if packet was not received then most likely a timeout occurred
    }
    return(status);
}

//----------------------------------------------------------------------------------
//  uint8 getRecvPacket(uint8* data, uint8* length, uint8 *packetStatus)
//
//  DESCRIPTION:
//    Get received packet. Use when 'packetReceived' flag has been set
//
//  ARGUMENTS:
//    data   - Where to write incoming data.
//    length - Length of payload.
//
//  RETURNS:
//    0 if a packet was received successfully.
//    1 if chip is in overflow state (packet longer than FIFO).
//    2 if the length of the packet is illegal (0 or > 61).
//    3 if the CRC of the packet is not OK.
//----------------------------------------------------------------------------------
uint8 getRecvPacket(uint8* data, uint8* length, uint8 *packetStatus)
{
//    uint8 packet_status[2];
    uint8 status;

//    packetReceived = FALSE;
    status = RX_OK;
 
    // Read first element of packet from the RX FIFO (length byte)
    status = halRfReadFifo(length, 1);

    if ((status & CC2500_STATUS_STATE_BM) == CC2500_STATE_RX_OVERFLOW)
    {
        halRfStrobe(CC2500_SIDLE);
        halRfStrobe(CC2500_SFRX);
        status = RX_FIFO_OVERFLOW;
    }
    else if (*length == 0 || *length > 61)
    {
        halRfStrobe(CC2500_SIDLE);
        halRfStrobe(CC2500_SFRX);
        status = RX_LENGTH_VIOLATION;
    }
    else
    {
        data[0] = *length;
        // Get payload
        halRfReadFifo(&data[1], *length);

        (*length)++;               // increment packet length to include address at first position
        
        // Get the packet status bytes [RSSI, LQI]
        halRfReadFifo(packetStatus, 2);

        // Check CRC
        if ((packetStatus[1] & CC2500_LQI_CRC_OK_BM) != CC2500_LQI_CRC_OK_BM)
        {
            status = RX_CRC_MISMATCH;
        }
        else
        {
            status = RX_OK;
        }
    }
    return(status);
}

uint8 checkChannel(uint8 wait){
  uint8 status=0;
  radioMode(RX_MODE);
  while(TRUE){
    if(clearChannel){
      clearChannel = FALSE;
      timer_ms(wait);
      radioMode(RX_MODE);
      while(TRUE){
        if(timerDone){
          if(halDigioGet(&pinGDO2)){
            status = 1;
          }
          timerDone = FALSE;
          break;
        }
      }
      break;
    }
  }
  return status;
}
