
#define FIFO_THRESHOLD       0x07
#define FIFO_THRESHOLD_BYTES 32
#define FIFO_SIZE            64

#define RX_OK                0
#define RX_LENGTH_VIOLATION  1
#define RX_CRC_MISMATCH      2
#define RX_FIFO_OVERFLOW     3
#define RX_TIMEOUT           4

#define ACK_WIDTH            0
#define TRX_PL_WIDTH         18

#define RSSI_OFFSET         72        // RSSI_OFFSET Value depends on data rate...'72' for 250 kbps

#define RX_MODE         0x00
#define TX_MODE         0x01
#define STNDBY_MODE     0x02
#define PWRDWN_MODE     0x03

#define CHAN_WAIT_TIME  10

static void txISR(void);
static void ccaISR(void);
static void rxISR(void);
void radioInit(uint8 mode);
void radioMode(uint8 mode);
void radioRxInit(void);
void radioTxInit(void);
void radioCCAInit(void);
uint8 txSendPacket(uint8* data, uint8 length);
uint8 rxRecvPacket(uint8* data, uint8* length, uint8* packetStatus);
uint8 rxRecvPacketTime(uint8* data, uint8* length, uint8* packetStatus, uint8 time);
uint8 getRecvPacket(uint8* data, uint8* length, uint8 *packetStatus);
uint8 checkChannel(uint8 wait);
