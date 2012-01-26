#include "../../defines.h"

configuration NodeConfig { } 
implementation {
  components MainC,
             NodeC as App,
             LedsC,
             new TimerMilliC() as Timer0,
			 new TimerMilliC() as Timer1,
             new AMSenderC(AM_RADIO_MSG),
             new AMReceiverC(AM_RADIO_MSG),
             McuSleepC as Sleep,
			 CC2420PacketC,		 
			 UARTByteStringConfig,
			 HplMsp430InterruptC,
             ActiveMessageC;

  App -> MainC.Boot;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Timer1 -> Timer1;
  App.Receive -> AMReceiverC;
  App.AMSend -> AMSenderC;  
  App.CC2420Packet -> CC2420PacketC;
  App.RadioControl -> ActiveMessageC;
  App.Packet -> AMSenderC;
  App.Sleep -> Sleep;
  App.UARTByteString -> UARTByteStringConfig;
  App.HplMsp430Interrupt -> HplMsp430InterruptC.Port27;			// this is the pin to which the "User Button" on Tmote Sky is connected
}
