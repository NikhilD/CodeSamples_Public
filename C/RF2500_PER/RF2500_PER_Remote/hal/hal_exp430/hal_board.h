 /******************************************************************************
    Filename: hal_board.h

    Copyright 2007 Texas Instruments, Inc.
******************************************************************************/

#ifndef HAL_BOARD_H
#define HAL_BOARD_H

#include "hal_types.h"
#include "hal_defs.h"
#include "hal_digio.h"

#include <msp430.h>
#include "hal_msp430.h"


//----------------------------------------------------------------------------------
//  Easy access, zero overhead LED macros
//  Adapted to hardware interface on MSP430 Experimenter Board
//----------------------------------------------------------------------------------
#define HAL_LED_SET_1   (P1OUT |= BIT0)
#define HAL_LED_SET_2   (P1OUT |= BIT1)

#define HAL_LED_CLR_1   (P1OUT &= ~BIT0)
#define HAL_LED_CLR_2   (P1OUT &= ~BIT1)

#define HAL_LED_TGL_1   (P1OUT ^= BIT0)
#define HAL_LED_TGL_2   (P1OUT ^= BIT1)



//----------------------------------------------------------------------------------
//  Port and pin where GDO0 and GDO2 from CC1100/CC2500 are connected
//----------------------------------------------------------------------------------
#define HAL_IO_GDO0_PORT  2
#define HAL_IO_GDO0_PIN   6
#define HAL_IO_GDO2_PORT  2
#define HAL_IO_GDO2_PIN   7
#define HAL_SPI_SOMI_PORT 3
#define HAL_SPI_SOMI_PIN  2
#define HAL_SPI_SIMO_PORT 3
#define HAL_SPI_SIMO_PIN  1
#define HAL_SPI_CLK_PORT  3
#define HAL_SPI_CLK_PIN   3
#define HAL_SPI_CS_PORT   3
#define HAL_SPI_CS_PIN    0

//----------------------------------------------------------------------------------
// Select interface on MSP430 to use for SPI (define only one!)
//----------------------------------------------------------------------------------

// #define HAL_SPI_INTERFACE_USART0
// #define HAL_SPI_INTERFACE_USART1
// #define HAL_SPI_INTERFACE_USCIA0
// #define HAL_SPI_INTERFACE_USCIA1
#define HAL_SPI_INTERFACE_USCIB0
// #define HAL_SPI_INTERFACE_USCIB1
// #define HAL_SPI_INTERFACE_USI
// #define HAL_SPI_INTERFACE_BITBANG



#ifdef __cplusplus
extern "C" {
#endif


extern const digioConfig pinLed1;
extern const digioConfig pinLed2;
extern const digioConfig pinS1;
extern const digioConfig pinS2;
extern const digioConfig pinGDO0;
extern const digioConfig pinGDO2;



//----------------------------------------------------------------------------------
// Function declarations
//----------------------------------------------------------------------------------

void halBoardInit(void);


#ifdef __cplusplus
}
#endif

/**********************************************************************************/
#endif
