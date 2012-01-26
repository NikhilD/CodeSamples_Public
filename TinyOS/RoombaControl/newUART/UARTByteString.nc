interface UARTByteString
{
  command error_t request();
  event void reqGranted(error_t error);
  command error_t release();
  command error_t sendString(char *str);
  event void sendStringDone(error_t error);
  command error_t sendByte(uint8_t data);
  event void sendByteDone(error_t error);  
  event void receiveByteDone(uint8_t data, error_t error);  
}
