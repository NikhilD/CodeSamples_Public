#include "../../defines.h"

configuration BaseConfig { } 
implementation {
  components MainC,
             BaseC as App,
             LedsC,
             new TimerMilliC() as Timer0,
			 new TimerMilliC() as Timer1,
			 new TimerMilliC() as Timer2,
			 //new TimerMilliC() as Timer3,
             new AMSenderC(AM_RADIO_MSG),
             new AMReceiverC(AM_RADIO_MSG),
             ActiveMessageC as Radio,			 
			 UARTByteStringConfig,
			 HplMsp430InterruptC,
			 RandomC,
             CC2420PacketC;          

  App -> MainC.Boot;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Timer1 -> Timer1;
  App.Timer2 -> Timer2;
  //App.Timer3 -> Timer3;
  App.RadioReceive -> AMReceiverC;
  App.RadioSend -> AMSenderC;      
  App.RadioControl -> Radio;  
  App.CC2420Packet -> CC2420PacketC;
  App.Packet -> AMSenderC;
  App.Random -> RandomC;
  App.UARTByteString -> UARTByteStringConfig;
  App.HplMsp430Interrupt -> HplMsp430InterruptC.Port27;			// this is the pin to which the "User Button" on Tmote Sky is connected
}
