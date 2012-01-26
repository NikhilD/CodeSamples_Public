#include "../defines.h"
#include "UARTByteString.h"

module UARTByteStringC 
{
  uses 
  {
    interface Resource;
    interface UartStream;
	interface UartByte;
	interface Leds;
  }
  provides
  {
    interface Msp430UartConfigure;
    interface UARTByteString;
  }
}
implementation 
{

  msp430_uart_union_config_t msp430_uart_115200_config = {
    {
      utxe : 1,      urxe : 1,
      ubr : UBR_1MHZ_115200,      umctl : UMCTL_1MHZ_115200,
      ssel : 0x02,      pena : 0,
      pev : 0,      spb : 0,
      clen : 1,      listen : 0,
      mm : 0,      ckpl : 0,
      urxse : 0,      urxeie : 1,
      urxwie : 0,      utxe : 1,
      urxe : 1
    }
  };
  
  uint16_t bufferLength = 0;
  char strBuffer[BUFFER_SIZE];
  uint8_t sendstr=0, rcvstr;
  uint8_t SendFlag = SENTNONE;  
  
/***************************************************************/
  task void sendDoneSuccessTask() {    
	if(SendFlag==SENTSTRING){		
		signal UARTByteString.sendStringDone(SUCCESS);	
	}else{		
		signal UARTByteString.sendByteDone(SUCCESS);
	}
	SendFlag = SENTNONE;
  }

  task void sendDoneFailTask() {    
    if(SendFlag==SENTSTRING){
		signal UARTByteString.sendStringDone(FAIL);	
	}else{
		signal UARTByteString.sendByteDone(FAIL);
	}
	SendFlag = SENTNONE;
  } 
  
/***************************************************************/  

  command error_t UARTByteString.sendString(char *str) {
	error_t result;
    bufferLength = strlen(str);
    if(bufferLength > BUFFER_SIZE)
      return FAIL;
    memcpy(strBuffer,str,bufferLength);
	SendFlag = SENTSTRING;
    result = call UartStream.send(strBuffer,bufferLength);
	if(result == FAIL){
		post sendDoneFailTask();
	}
    return SUCCESS;
  }

  command error_t UARTByteString.sendByte(uint8_t data) {
	error_t result;
    sendstr = data;
	SendFlag = SENTBYTE;
    result = call UartByte.send(sendstr);
	if(result == FAIL){
		post sendDoneFailTask();
	}else{			
		post sendDoneSuccessTask();
	}
    return SUCCESS;
  }
  
  event void Resource.granted() {	
	signal UARTByteString.reqGranted(SUCCESS);	
  }
  
  command error_t UARTByteString.request() {
	error_t reqErr;
	call UartStream.enableReceiveInterrupt();
	reqErr = call Resource.request();
	return reqErr;
  }
  
  command error_t UARTByteString.release() {
	error_t relErr;
	call UartStream.disableReceiveInterrupt();
	relErr = call Resource.release();
	return relErr;
  }
  
  async event void UartStream.sendDone(uint8_t *buf, uint16_t len, error_t error) {
    if(error == SUCCESS)
      post sendDoneSuccessTask();
    else
      post sendDoneFailTask();
  }
  
  async command msp430_uart_union_config_t* Msp430UartConfigure.getConfig() {
    return &msp430_uart_115200_config;	
  }

  async event void UartStream.receivedByte(uint8_t byte) {	
	signal UARTByteString.receiveByteDone(byte, SUCCESS);
  }

  async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error){}
  
}
