#include <stdio.h>
#include <math.h>

#include "../../defines.h"
#include "../../newUART/UARTByteString.h"

module BaseC{
    uses {
        interface SplitControl as RadioControl;
        interface Timer<TMilli> as Timer0;
		interface Timer<TMilli> as Timer1;
		interface Timer<TMilli> as Timer2;
        interface Boot;
        interface Leds;        
        interface Receive as RadioReceive;        
        interface AMSend as RadioSend;        
        interface Packet;   
		interface CC2420Packet; 
		interface UARTByteString;
		interface HplMsp430Interrupt;
		interface Random;
    }
} 
implementation {
  
	uint8_t GBL_UartBuf[UARTSIZE], GBL_uartPtr=0, GBL_netRec=0, GBL_botRec=0, GBL_doFlag=0, GBL_PGIndx=0; 
	uint8_t GBL_botFlag=0, GBL_botDBMs[MAXRCVCNT], GBL_uartFlag = 0, GBL_XmitCnt=XMITCNT, numPktsInfo=0;
	int16_t GBL_botRecCTR=-1, GBL_ID=-1;
	uint8_t GBL_netIDs[NEIGHSIZE], GBL_botIDs[MAXRCVCNT], GBL_netLQIs[NEIGHSIZE], GBL_botLQIs[MAXRCVCNT], GBL_srcNode[MAXRCVCNT], GBL_uartInfo=0;
	uint32_t GBL_temp;	
	float GBL_netPGs[NEIGHSIZE], GBL_botPGs[MAXRCVCNT];	
	int8_t GBL_netDBMs[NEIGHSIZE], GBL_botDBMs1[MAXRCVCNT];
	message_t GBL_packet;
	bool GBL_locked = FALSE, GBL_startDone = FALSE, GBL_pgNodeMsg = FALSE;

/****************	User Defined Functions	********************/
	void putDelay(uint16_t j);
	void CommSendUART(uint8_t data);
	void clearDataBuffer(void);
	void CommSendRADIO(uint8_t type, int16_t destNode, uint8_t info);
	uint8_t	chkIDs(uint8_t, uint8_t *); 
	void initializeFlags(void);
	void doPGDirection(void);
	void doBotDirection(void);
	float getMAX(float, float);
	float scaleValues(float, float, float);
	void genRandomData(void);
/***************************************************************/

/****************	User Defined Tasks	********************/

	task void announceTask(){
		clearDataBuffer();		
		initializeFlags();
		CommSendRADIO(ANNOUNCE, TOS_NODE_ID, 0);
		GBL_doFlag = PGDIR;
		call Timer0.startOneShot(NETWORK_WAIT);
	}
	
	task void doDirectionTask(){
		if(GBL_doFlag == PGDIR){
			GBL_doFlag = 0;
			doPGDirection();
		}
		if(GBL_botFlag == BOTDIR){
			GBL_botRecCTR=0;
			doBotDirection();
		}		
	} 
	
	task void radioSendTask(){
		CommSendRADIO(GIVEPGNODE, GBL_ID, 0);
	}
	
	task void uartSendTask(){
		atomic{GBL_uartPtr=0;}
		CommSendUART(GBL_UartBuf[0]);
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
	
	void clearDataBuffer() {
		int i;
		atomic {
			for (i = 0; i < 3; i++) {
				GBL_UartBuf[i] = 0;
			}	
			for (i = 0; i < NEIGHSIZE; i++) {
				GBL_netIDs[i] = 0;
				GBL_netPGs[i] = -1000;
				GBL_netDBMs[i] = -128;
				GBL_netLQIs[i] = 0;
			}
			for (i = 0; i < MAXRCVCNT; i++) {
				GBL_botIDs[i] = 0;
				GBL_botPGs[i] = -1000;
				GBL_botDBMs[i] = -128;
				GBL_botLQIs[i] = 0;
			}			
		}
	}
	
	void CommSendRADIO(uint8_t type, int16_t destNode, uint8_t info){
		radio_msg_t* rsm;
		if (GBL_locked) {return;}
		else {			
			rsm = (radio_msg_t*) call Packet.getPayload(&GBL_packet, sizeof(radio_msg_t));
			if (rsm == NULL) {
				return;
			}            
			if (call Packet.maxPayloadLength() < sizeof(radio_msg_t)) {return;}
			call CC2420Packet.setPower( &GBL_packet, TXPOWER1);
			rsm->hopCnt = 0;
			rsm->pgVal = 100;
			rsm->dBmVal = 100;
			rsm->srcNode = destNode;
			rsm->distance = 0;
			switch(type){
				case ANNOUNCE:
					rsm->msgType = NET_MSG;
					rsm->srcGP = BOT_GP;
					rsm->srcID = TOS_NODE_ID;
					rsm->lQi = ANNOUNCE;
					break;
				case GIVEPGNODE:
					rsm->msgType = BASE_MSG;
					rsm->srcGP = BOT_GP;
					rsm->srcID = TOS_NODE_ID;
					rsm->lQi = info;
					break;
				case STOP:
					rsm->msgType = BASE_MSG;
					rsm->srcGP = BOT_GP;
					rsm->srcID = TOS_NODE_ID;
					rsm->lQi = STOP;						
					break;
			}
			if (call RadioSend.send(AM_BROADCAST_ADDR, &GBL_packet, sizeof(radio_msg_t)) == SUCCESS){atomic{GBL_locked = TRUE;}}
		}
	}
	
	uint8_t	chkIDs(uint8_t id, uint8_t *IDs){
		uint8_t i=0;
		for(i=0;i<NEIGHSIZE;i++){
			if(id == IDs[i]){
				return 0;
			}
		}
		return 1;
	}
	
	void initializeFlags(){
		atomic{
			GBL_startDone = FALSE;
			GBL_pgNodeMsg = FALSE;
			GBL_botRec=0;
			GBL_botRecCTR=0;
			GBL_botFlag = 0;
			GBL_uartFlag = 0;
		}
	}
	
	void doPGDirection(){
		// determine highest PG-Value in neighbors
		int i=0;	float temp = GBL_netPGs[0];		
		for (i=1;i<NEIGHSIZE;i++) {
			if(temp<GBL_netPGs[i]){
				temp = GBL_netPGs[i];
				GBL_PGIndx = i;
			}
		}
		CommSendRADIO(GIVEPGNODE, TOS_NODE_ID, 0);
	}
	
	void doBotDirection(){				
		uint8_t i=0;
		if(GBL_botRecCTR>=GBL_botRec){			
			clearDataBuffer();
			initializeFlags();			
			call HplMsp430Interrupt.enable();
			// call UARTByteString.receiveByte();
			call Leds.led2Toggle();		
		} else {
			for(i=0; i<UARTSIZE; i++) {
				GBL_UartBuf[i] = GBL_botDBMs[GBL_botRecCTR];
				GBL_botRecCTR++;
			}
			post uartSendTask();
		}		
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
			return 0.0;
		}
	}
	
	float getMAX(float val1, float val2){
		if(val1>val2) {return val1;}
		else {return val2;}
	}
	
	void genRandomData() {
		uint8_t i=0;
		for(i=0; i<20; i++) {
			GBL_botDBMs[i] = call Random.rand16() & 0x00FF;
		}
		GBL_botRec = 20;	
		GBL_botFlag = BOTDIR;						
		post doDirectionTask();
	}
/***************************************************************/
	event void Boot.booted(){
		call RadioControl.start();	
	}

	event message_t* RadioReceive.receive(message_t* bufPtr, void* payload, uint8_t len) {  
		radio_msg_t* rsm;			uint8_t msgSize, nodeLQI, msgType, gp=0, nodeID;
		uint32_t temp;	float nodePG;
		int8_t nodeDBM;
		
		msgSize = sizeof(radio_msg_t);
		if (len != msgSize) {
			// call Leds.led2Toggle();
			return bufPtr;
		} 
			
		rsm = (radio_msg_t*)payload;	
		msgType = rsm->msgType;
		switch(msgType){
			case NET_MSG:
				gp = rsm->srcGP;
				if((gp==NET_GP) && (!GBL_startDone)){
					if(chkIDs(rsm->srcID, GBL_netIDs)){
						GBL_netIDs[GBL_netRec] = rsm->srcID;
						temp = rsm->pgVal;
						GBL_netPGs[GBL_netRec] = *(float *)&temp;
						GBL_netDBMs[GBL_netRec] = call CC2420Packet.getRssi(bufPtr);
						GBL_netLQIs[GBL_netRec] = call CC2420Packet.getLqi(bufPtr);
						atomic{GBL_netRec++;}
						if(GBL_netRec>=NEIGHSIZE){
							GBL_netRec=0;
							if(call Timer0.isRunning()){call Timer0.stop();}
							atomic{GBL_startDone = TRUE;}							
							post doDirectionTask();
						}						
					}
				}
				break;
			case BOT_MSG:
				gp = rsm->srcGP;
				if(gp==BOT_GP){
					// call Leds.led0Toggle();
					GBL_srcNode[GBL_botRec] = rsm->srcNode;
					nodeID = rsm->srcID;
					GBL_botIDs[GBL_botRec] = rsm->srcID;
					temp = rsm->pgVal;
					GBL_botPGs[GBL_botRec] = *(float *)&temp;
					GBL_botDBMs[GBL_botRec] = rsm->dBmVal;
					GBL_botLQIs[GBL_botRec] = rsm->lQi;
					atomic{GBL_botRec++;}					
					call Leds.led2Toggle();
					// if(GBL_botRec>=TOTRCVCNT){
						// call Leds.led0Toggle();
						// atomic{GBL_botFlag = BOTDIR;}
						// post doDirectionTask();
					// }
				}
				break;
			case PGNODE_MSG:
				if(call Timer2.isRunning()) call Timer2.stop();
				atomic{GBL_pgNodeMsg = TRUE;}
				GBL_srcNode[GBL_botRec] = rsm->srcNode;				
				GBL_botIDs[GBL_botRec] = rsm->srcID;
				temp = rsm->pgVal;
				GBL_botPGs[GBL_botRec] = *(float *)&temp;
				nodeDBM = call CC2420Packet.getRssi(bufPtr);
				GBL_botLQIs[GBL_botRec] = call CC2420Packet.getLqi(bufPtr);
				GBL_botDBMs[GBL_botRec] = nodeDBM;
				atomic{GBL_botRec++;}
				call Leds.led1Toggle();
				call Timer2.startOneShot(NETWORK_WAIT*(GBL_XmitCnt-GBL_botRec+MLTFCTR));
				atomic{GBL_uartFlag=1;	GBL_uartPtr=0;}
				CommSendUART(nodeDBM);
				if((rsm->numMsgs>=(GBL_XmitCnt-1))||(GBL_botRec>=GBL_XmitCnt)) {
					call Leds.led0Toggle();
					if(call Timer2.isRunning()) call Timer2.stop();
					call Timer2.startOneShot(BOT_WAIT);
				}
				break;
		}				
		return bufPtr;    
	}
		
	event void RadioSend.sendDone(message_t* bufPtr, error_t error) {
		if (&GBL_packet == bufPtr) {
			atomic{GBL_locked = FALSE;}					
		}
	}

	event void RadioControl.startDone(error_t err) {
		error_t Err = SUCCESS;
		if (err == SUCCESS) {	
			clearDataBuffer();
			call HplMsp430Interrupt.enable();
			// Err = call UARTByteString.receiveByte();
			Err = call UARTByteString.request();
			if(Err == SUCCESS){
				// call Leds.led0Toggle();
			}
			// do nothing for now
		}
	}	

	event void Timer0.fired(){
		if(GBL_doFlag == START){		
			post announceTask();
		} else if(GBL_doFlag == PGDIR){
			GBL_netRec=0;
			atomic{GBL_startDone = TRUE;}
			post doDirectionTask();
		} 
		// GBL_doFlag = 0;
	}  
	
	event void Timer1.fired() {
		uint8_t swFlag=0, info = 0;
		if(GBL_uartInfo==50) {
			swFlag = STOP;
			info = 0;
		} else {
			swFlag = GIVEPGNODE;
			info = GBL_uartInfo;
		}
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
		CommSendRADIO(swFlag, NET_BASE_ID, info);
	}
	
	event void Timer2.fired() {
		atomic{GBL_botFlag = BOTDIR;}
		if(GBL_uartFlag==1) {
			GBL_UartBuf[0] = 69;
			GBL_uartPtr = 0;	
			CommSendUART(GBL_UartBuf[0]);			
			call HplMsp430Interrupt.enable();
			call Leds.led2Toggle();
		} else if(GBL_uartFlag==2) {
			doBotDirection();
		}
	}
	
	event void UARTByteString.sendByteDone(error_t error)  {
		if(error == FAIL){
			// call Leds.led2Toggle();
		}
		else{ 
			atomic{GBL_uartPtr++;}
			if(GBL_uartFlag==1) {
				GBL_uartPtr=0;
			} else {
				if(GBL_uartPtr>=UARTSIZE){
					doBotDirection();
				} else {
					CommSendUART(GBL_UartBuf[GBL_uartPtr]);		
				}
			}	
			call Leds.led2Toggle();
		}
	}
	
	async event void HplMsp430Interrupt.fired() {		
		call HplMsp430Interrupt.clear();
		call HplMsp430Interrupt.disable();		
		call Leds.led2Toggle();	
		atomic{GBL_uartFlag = 2;}
		//genRandomData();	
		call Timer2.startOneShot(NETWORK_WAIT*2);
	}
	
	event void UARTByteString.sendStringDone(error_t error) {}	
	
	event void UARTByteString.receiveByteDone(uint8_t byte, error_t error){
		if(error==SUCCESS){
			if(byte==69) {
				call Leds.led0Toggle();
				atomic{GBL_uartFlag = 2;}
				call Timer2.startOneShot(NETWORK_WAIT*MLTFCTR);				
			} else {
				call Leds.led0Toggle();
				clearDataBuffer();			initializeFlags();
				call Timer1.startOneShot(1000);
				atomic{GBL_uartInfo = byte;}
			}
		}
	}
	
	event void RadioControl.stopDone(error_t err) {} 
	event void UARTByteString.reqGranted(error_t error){}
}
