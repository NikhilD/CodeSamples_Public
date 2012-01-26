/******************************************************************************
    Filename: hal_mcu.c

    Copyright 2007 Texas Instruments, Inc.
******************************************************************************/

#include "msp430x22x4.h"
#include "hal_types.h"
#include "hal_defs.h"
#include "hal_board.h"
#include "hal_mcu.h"


//----------------------------------------------------------------------------------
//  void halMcuInit(void)
//
//  DESCRIPTION:
//    Turn off watchdog and set up system clock. Set system clock to 8 MHz
//----------------------------------------------------------------------------------
void halMcuInit(void)
{
    // Stop watchdog
    WDTCTL = WDTPW + WDTHOLD;

    // Set clock source to DCO @ 8 MHz
    BCSCTL1 = CALBC1_8MHZ;                   // Set DCO to 8MHz
    DCOCTL = CALDCO_8MHZ; 
    
}             

//-----------------------------------------------------------------------------
//  void halMcuSetLowPowerMode(uint8 mode)
//
//  DESCRIPTION:
//    Sets the MCU in a low power mode. Will turn global interrupts on at
//    the same time as entering the LPM mode. The MCU must be waken from
//    an interrupt (status register on stack must be modified).
//-----------------------------------------------------------------------------
void halMcuSetLowPowerMode(uint8 mode)
{
    switch (mode)
    {
        case HAL_MCU_LPM_0:
            __low_power_mode_0();
            break;
        case HAL_MCU_LPM_1:
            __low_power_mode_1();
            break;
        case HAL_MCU_LPM_2:
            __low_power_mode_2();
            break;
        case HAL_MCU_LPM_3:
            __low_power_mode_3();
            break;
        case HAL_MCU_LPM_4:
            __low_power_mode_4();
            break;
    }
}

void halMcuWait_ms(uint8 time){
  
  uint8 i;
  for(i=0;i<time;i++){halMcuWaitUs(1000l);}
}


