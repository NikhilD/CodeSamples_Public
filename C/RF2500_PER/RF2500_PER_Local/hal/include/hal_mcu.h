/***********************************************************************************
    Filename: hal_mcu.h

    Copyright 2007 Texas Instruments, Inc.
***********************************************************************************/

#ifndef HAL_MCU_H
#define HAL_MCU_H

#ifdef __cplusplus
extern "C" {
#endif

#include <hal_types.h>
#include "msp430.h"
  
enum {
    HAL_MCU_LPM_0,
    HAL_MCU_LPM_1,
    HAL_MCU_LPM_2,
    HAL_MCU_LPM_3,
    HAL_MCU_LPM_4
};

#define FCLK_MHZ 8           // system clock frequency is defined as 8MHz

#define halMcuWaitUs(time_us) __delay_cycles(time_us*FCLK_MHZ)       // Macro for a time delay in microseconds

//----------------------------------------------------------------------------------
// Function declarations
//----------------------------------------------------------------------------------

void halMcuInit(void);
void halMcuWait_ms(uint8 time);
void halMcuSetLowPowerMode(uint8 mode);


#ifdef  __cplusplus
}
#endif

/**********************************************************************************/
#endif
