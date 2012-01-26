

typedef struct  {
    uint8 header;
    uint8 length;
    uint8 payload[20];    
  } SerialPacket;


void usart_init(void);
void usart_send_byte(unsigned char byte);
void usart_send_bytes(unsigned char * data, unsigned char size);
void usart_send_int(int data);
void usart_send(uint16 * data, uint16 size);
