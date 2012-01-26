#include <stdio.h>
#include <Msp430Adc12.h>
#include "../../defines.h"

module NodeC{
    uses {        
        interface SplitControl as RadioControl;
        interface Timer<TMilli> as Timer0;
		interface Timer<TMilli> as Timer1;
        interface Boot;
        interface Leds;
        interface Receive;
        interface AMSend;
        interface Packet;
		interface CC2420Packet;
        interface McuSleep as Sleep;		
		interface UARTByteString;
		interface HplMsp430Interrupt;
    }
} 
implementation {
  
	int8_t GBL_dBmVal[MAXRCVCNT], GBL_avgdBm;
	float GBL_pgVal[MAXRCVCNT], GBL_avgPG;
	uint8_t netID = NET_BASE_ID, GBL_lQi[MAXRCVCNT], GBL_avglQi, GBL_srcNode, GBL_UartBuf[MAXRCVCNT], GBL_uartPtr=0; 
	uint8_t GBL_uartInfo=0, GBL_XmitCnt=XMITCNT, numPktsInfo=0;
	int16_t guideCtr=0, msgCtr=0;
	message_t packet;	
	bool locked=FALSE, doNothing=FALSE;
		
/****************	User Defined Functions	********************/	
	void SendtoBase(void);	
	void CommSendUART(uint8_t data);
	void clearDataBuffer(void);
/***************************************************************/

/****************	User Defined Tasks	********************/	
	task void avgCalculationTask(){	
		numPktsInfo = (GBL_uartInfo & 0xF0) >> 4;
		switch(numPktsInfo) {
			case 1:
				GBL_XmitCnt = 25;
				break;
			case 2:
				GBL_XmitCnt = 50;
				break;
			case 3:
				GBL_XmitCnt = 100;
				break;
			case 4:
				GBL_XmitCnt = 150;
				break;
			case 5:
				GBL_XmitCnt = 200;
				break;
		}
	}	
	
	task void uartSendTask() {
		while(guideCtr>=0) {
			guideCtr--;
			GBL_UartBuf[guideCtr] = GBL_dBmVal[guideCtr];
		}
		// for(i=0; i<MAXRCVCNT; i++) {
			// GBL_UartBuf[i] = GBL_dBmVal[i];
		// }
		GBL_uartPtr=0;
		CommSendUART(GBL_UartBuf[0]);
	}
	
/***************************************************************/

	void CommSendUART(uint8_t data){
		error_t error;
		error = call UARTByteString.sendByte(data);
	}
	
	void SendtoBase(){
		uint32_t pgVal;
		*(float*)&pgVal = GBL_pgVal[guideCtr];
		if (locked) {return;}
		else {
			radio_msg_t* rsm;
			rsm = (radio_msg_t*) call Packet.getPayload(&packet, sizeof(radio_msg_t));
			if (rsm == NULL) {
				return;
			}            
			if (call Packet.maxPayloadLength() < sizeof(radio_msg_t)) {return;}
			rsm->msgType = BOT_MSG;
			rsm->srcNode = GBL_srcNode;
			rsm->srcGP = BOT_GP;
			rsm->srcID = TOS_NODE_ID;
			rsm->hopCnt = 0;
			rsm->pgVal = pgVal;
			rsm->dBmVal = GBL_dBmVal[guideCtr];
			rsm->lQi = GBL_lQi[guideCtr];
			rsm->numMsgs = guideCtr;
			call CC2420Packet.setPower( &packet, TXPOWER1);
			if (call AMSend.send(BASE_ID, &packet, sizeof(radio_msg_t)) == SUCCESS){atomic{locked = TRUE;}}
		}
	}
	
	void clearDataBuffer() {
		int i;
		atomic {
			for (i = 0; i < MAXRCVCNT; i++) {
				GBL_UartBuf[i] = 0;
				GBL_pgVal[i] = -1000;
				GBL_dBmVal[i] = -128;
				GBL_lQi[i] = 0;
			}			
		}
	}
	
/***************************************************************/
/***************************************************************/
	
	event void Boot.booted(){
		call RadioControl.start();
	}

	event void Timer0.fired(){    		
		SendtoBase();		
	}

	event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
		radio_msg_t* rsm;			uint8_t msgSize, type=0, gp=0, id=0, dest=10;
		uint32_t temp;
		
		msgSize = sizeof(radio_msg_t);
		if (len != msgSize) {		
			// call Leds.led0Toggle();
			return bufPtr;
		}		
		rsm = (radio_msg_t*)payload;	
		type = rsm->msgType;
		if((guideCtr>=MAXRCVCNT)&&(type==PGNODE_MSG)){
			return bufPtr;
		}
		switch(type){
			case PGNODE_MSG:
				if(!doNothing){
					GBL_srcNode = rsm->srcNode;
					gp = rsm->srcGP;
					id = rsm->srcID;
					if((gp==NET_GP)&&(id==netID)){
						temp = rsm->pgVal;
						GBL_pgVal[guideCtr] = *(float *)&temp;
						GBL_dBmVal[guideCtr] = call CC2420Packet.getRssi(bufPtr);
						GBL_lQi[guideCtr] = call CC2420Packet.getLqi(bufPtr);	
						msgCtr=rsm->numMsgs;
						guideCtr++;	
						// if((rsm->numMsgs>=(XMITCNT-1))||(guideCtr>=XMITCNT)){		
							// call Timer1.startOneShot(START_WAIT*MLTFCTR*TOS_NODE_ID);
						// }
					}
				}					
				break;
			case BOT_MSG:				
				break;
			case BASE_MSG:
				gp = rsm->srcGP;
				id = rsm->srcID;
				dest = rsm->srcNode;
				guideCtr=0;
				if((gp==BOT_GP)&&(id==BASE_ID)&&(dest==NET_BASE_ID)){
					call Leds.led0Toggle();
					GBL_uartInfo = rsm->lQi;
					post avgCalculationTask();
					//call Timer1.startOneShot(START_WAIT);
				}
				break;
		}		
		call Leds.led1Toggle();
		return bufPtr;    
	}

	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
		if (&packet == bufPtr) {
			call Leds.led2Toggle();
			locked = FALSE;
			guideCtr--;
			if(guideCtr<0){
				guideCtr=0;
				// call Leds.led1Off();	call Leds.led2Off();
				// call Leds.led0Toggle();
				call HplMsp430Interrupt.enable();
				if(call Timer0.isRunning()){call Timer0.stop();}
			} else {
				call Timer0.startOneShot(BOT_WAIT);
			}
		}
	}  

	event void RadioControl.startDone(error_t err) {
		error_t Err = SUCCESS;
		if (err == SUCCESS) {
			clearDataBuffer();
			call HplMsp430Interrupt.enable();
			Err = call UARTByteString.request();
			if(Err == SUCCESS){
				call Leds.led0Toggle();
			}
		}
	}
	
	event void UARTByteString.sendByteDone(error_t error)  {
		if(error == FAIL){
			// call Leds.led2Toggle();
		}
		else{ 
			atomic{GBL_uartPtr++;}
			if(GBL_uartPtr>=GBL_XmitCnt){
				atomic{guideCtr=0; GBL_uartPtr=0;}
				clearDataBuffer();
				call HplMsp430Interrupt.enable();				
			} else {
				CommSendUART(GBL_UartBuf[GBL_uartPtr]);		
			}
			call Leds.led2Toggle();
		}
	}
	
	async event void HplMsp430Interrupt.fired() {		
		call HplMsp430Interrupt.disable();
		call HplMsp430Interrupt.clear();
		// call Leds.led2Toggle();		
		call Timer1.startOneShot(NETWORK_WAIT);
	}
	
	event void Timer1.fired(){
		// call Leds.led2Toggle();		
		// post avgCalculationTask();
		post uartSendTask();
	}	
	
	event void UARTByteString.receiveByteDone(uint8_t byte, error_t error) {
		if(error==SUCCESS){
			if(byte==51){
				call Leds.led0Toggle();
				call Timer1.startOneShot(NETWORK_WAIT);
			}
		}
	}
	
	event void RadioControl.stopDone(error_t err) {}	
	event void UARTByteString.reqGranted(error_t error) {}
	event void UARTByteString.sendStringDone(error_t error) {}	
}
