configuration UARTByteStringConfig
{
  provides interface UARTByteString;
}
implementation 
{
  components UARTByteStringC as Uart;
  components new Msp430Uart1C() as UartC;
  components LedsC;
  
  Uart.Resource -> UartC.Resource;
  Uart.Leds -> LedsC;
  Uart.UartStream -> UartC.UartStream;
  Uart.UartByte -> UartC.UartByte;  
  Uart.Msp430UartConfigure <- UartC.Msp430UartConfigure;
  UARTByteString = Uart;
}
