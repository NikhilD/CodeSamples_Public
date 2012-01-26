#include <stdio.h>
#include <Msp430Adc12.h>
#include "../../defines.h"

module MoteC{
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
		interface UARTByteString;
        interface McuSleep as Sleep;
		interface HplMsp430Interrupt;
    }
} 
implementation {
  
	uint8_t UartBuf[UARTSIZE], uartPtr=0, netCtr=0, selfHC=MAX_HC, doFlag1=0, doFlag2=0;
	int8_t GBL_dBmVal[MAXRCVCNT];
	float GBL_pgVal[MAXRCVCNT];
	uint8_t GBL_lQi[MAXRCVCNT], GBL_srcNode, GBL_info, GBL_XmitCnt = XMITCNT, numPktsInfo, pktTimeInfo;
	int16_t guideCtr=0, msgCtr=0;
	uint16_t GBL_intpktTime=NETWORK_WAIT;	
	float newselfPG=0, selfPG=0.0;
	message_t packet;	
	bool locked = FALSE;
		
/****************	User Defined Functions	********************/	
	void putDelay(uint16_t j);
	void CommSendUART(uint8_t data);
	void clearDataBuffer(void);
	void doPGCalculation(float, int8_t);
	float scaleValues(float, float, float);
	void SendtoNetwork(uint8_t);	
/***************************************************************/

/****************	User Defined Tasks	********************/

	task void sendNetTask(){		
		doFlag1 = SENDNET;
		call Timer0.startOneShot((WEE_WAIT*TOS_NODE_ID)+1);
	}

	task void robotGuideTask(){
		doFlag2 = GUIDEBOT;
		guideCtr = 0;
		numPktsInfo = (GBL_info & 0xF0) >> 4;
		pktTimeInfo = GBL_info & 0x0F;
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
		switch(pktTimeInfo) {
			case 1:
				GBL_intpktTime = 50;
				break;
			case 2:
				GBL_intpktTime = 100;
				break;
			case 3:
				GBL_intpktTime = 200;
				break;
			case 4:
				GBL_intpktTime = 400;
				break;
			case 5:
				GBL_intpktTime = 500;
				break;
		}
		call Timer1.startOneShot(NETWORK_WAIT);			
	}
	
	task void stopGuideTask(){
		if(call Timer1.isRunning()){call Timer1.stop();}	
		doFlag2 = 0;
	}
	
	task void uartSendTask(){
		uartPtr=0;
		doFlag2 = SENDUART;
		call Timer1.startPeriodic(UART_WAIT);
	} 		
/***************************************************************/

	void putDelay(uint16_t j) {
		uint16_t i;
		for (i = 0; i < j; i++);
	}

	void CommSendUART(uint8_t data){
		error_t error;
		error = call UARTByteString.sendByte(data);
	}
	
	void doPGCalculation(float pgVal, int8_t dBmVal){
		float actdBm  = (float)dBmVal - 45.0;	// RSSI offset for TMOTE Sky
		float scaledBm = scaleValues(actdBm, 1.0, 0.0);		
		newselfPG = pgVal*scaledBm;
	}
	
	float scaleValues(float inVal, float omax, float omin){
		if((inVal>MINDBM)&&(inVal<MAXDBM)){	
			float iRange = MAXDBM - MINDBM;
			float oRange = omax - omin;
			float multFac = oRange/iRange;
			float num = (MAXDBM*omin) - (omax*MINDBM);
			float outVal = (inVal*multFac) + (num/iRange);
			return outVal;
		} else {
			return -10.0;
		}
	}
		
	void SendtoNetwork(uint8_t type){
		radio_msg_t* rsm;	uint32_t pgVal;
		*(float*)&pgVal = selfPG;
		if (locked) {return;}
		else {			
			rsm = (radio_msg_t*) call Packet.getPayload(&packet, sizeof(radio_msg_t));
			if (rsm == NULL) {
				return;
			}            
			if (call Packet.maxPayloadLength() < sizeof(radio_msg_t)) {return;}
			switch(type){
				case SENDNET:
					rsm->msgType = NET_MSG;
					rsm->srcGP = NET_GP;
					break;				
				case GUIDEBOT:
					rsm->msgType = PGNODE_MSG;
					rsm->srcGP = NET_GP;
					break;
			}			
			rsm->srcNode = TOS_NODE_ID;
			rsm->srcID = NET_BASE_ID;
			rsm->hopCnt = selfHC;
			rsm->pgVal = pgVal;
			rsm->dBmVal = 100;
			rsm->lQi = 100;
			rsm->numMsgs = guideCtr;
			call CC2420Packet.setPower( &packet, TXPOWER4);
			if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_msg_t)) == SUCCESS){atomic{locked = TRUE;}}
		}
	}
	
/***************************************************************/
/***************************************************************/
	
	event void Boot.booted(){
		call RadioControl.start();
	}

	event void Timer0.fired(){
		post robotGuideTask();
		// if(doFlag1 == SENDNET){		
			// SendtoNetwork(SENDNET);
			// doFlag1 = 0;		
		// }	
	}

	event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
		radio_msg_t* rsm;			uint8_t msgSize, type=0, gp=0, id=0, hopCnt, netLQI;
		uint32_t temp;		float netPG;		int8_t netDBM, msg=0;
		
		msgSize = sizeof(radio_msg_t);
		if (len != msgSize) {		
			call Leds.led0Toggle();
			return bufPtr;
		}    
		rsm = (radio_msg_t*)payload;	
		type = rsm->msgType;
		switch(type){
			case NET_MSG:
				gp = rsm->srcGP;
				switch(gp){
					case NET_GP:
						hopCnt = rsm->hopCnt;
						if(hopCnt<selfHC){						
							atomic{selfHC = hopCnt+1;}
							temp = rsm->pgVal;
							netPG = *(float *)&temp;
							netDBM = call CC2420Packet.getRssi(bufPtr);
							netLQI = call CC2420Packet.getLqi(bufPtr);
							doPGCalculation(netPG, netDBM);
							if(newselfPG>selfPG){
								if(call Timer0.isRunning()){call Timer0.stop();}
								atomic{selfPG = newselfPG;}
								post sendNetTask();
							}
						}
						break;
					case BOT_GP:
						id = rsm->srcID;
						if(id==BASE_ID){
							msg = rsm->lQi;
							if(msg==ANNOUNCE){
								post sendNetTask();
							}
						}
						break;
				}
				break;
			case PGNODE_MSG:				
				break;
			case BOT_MSG:				
				break;
			case BASE_MSG:				
				gp = rsm->srcGP;
				id = rsm->srcID;
				if((gp==BOT_GP)&&(id==BASE_ID)){					
					if(rsm->lQi == STOP){
						post stopGuideTask();
					}else if(rsm->srcNode == TOS_NODE_ID){
						GBL_info = rsm->lQi;
						post robotGuideTask();
					}
				}
				break;			
		}				
		call Leds.led0Toggle();
		return bufPtr;    
	}

	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
		if (&packet == bufPtr) {
			call Leds.led2Toggle();
			locked = FALSE;
			call Timer1.startOneShot(GBL_intpktTime);
		}
	}  
	
	event void Timer1.fired(){
		switch(doFlag2){
			case GUIDEBOT:
				if(guideCtr>=GBL_XmitCnt){
					//call HplMsp430Interrupt.enable();
					if(call Timer1.isRunning()){call Timer1.stop();}
				} else {
					//call Leds.led1Toggle();			
					SendtoNetwork(GUIDEBOT);
					atomic{guideCtr++;}
				}				
				break;
			case SENDUART:
				if(uartPtr>=UARTSIZE){
					call Timer1.stop();
				} else {
					call Leds.led1Toggle();			
					CommSendUART(UartBuf[uartPtr]);		
				}
				atomic{uartPtr++;}
				break;
		}
	}

	event void RadioControl.startDone(error_t err) {
		error_t Err = SUCCESS;
		if (err == SUCCESS) {
			//call HplMsp430Interrupt.enable();	
			//Err = call UARTByteString.request();
			//if(Err == SUCCESS){
				// call Leds.led0Toggle();
			//}	
		}
	}
	
	async event void HplMsp430Interrupt.fired() {		
		call HplMsp430Interrupt.disable();
		call HplMsp430Interrupt.clear();
		call Leds.led2Toggle();
		atomic{selfHC = TOS_NODE_ID;}
		atomic{selfPG = (1000.0/TOS_NODE_ID);}
		call Timer0.startOneShot(NETWORK_WAIT*MLTFCTR);		
	}
	
	event void RadioControl.stopDone(error_t err) {}	
	event void UARTByteString.sendByteDone(error_t error){}
	event void UARTByteString.sendStringDone(error_t error) {}		
	event void UARTByteString.receiveByteDone(uint8_t byte, error_t error){}
	event void UARTByteString.reqGranted(error_t error){}	

}
