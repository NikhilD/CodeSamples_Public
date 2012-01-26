#include <hal_types.h>
#include <hal_defs.h>
#include <hal_mcu.h>
#include <hal_int.h>
#include <hal_board.h>
#include "timer.h"

volatile uint16 stop_time = 0;
volatile uint8 timerDone = 0;

// sleep for 'time_ms' using timer A. 
// Returns '1' if slept full time and a '0' if something else interrupted sleep (e.g. radio or usart interrupts)
uint8 sleep_ms(uint16 time_ms)
{
  timer_ms(time_ms);                      // run timer for 'time_ms' in milliseconds
  halMcuSetLowPowerMode(HAL_MCU_LPM_0);   // put MCU in sleep mode                 
  // if timer is running (MC_1 = 1), then sleep was interrupted, otherwise sleep has expired
  if(TACTL & MC_1)
  {
    timer_stop();           // stop timer
    return 0;               // set status to '0' to indicate that sleep was interrupted
  }
  else
    return 1;               // return status as '1' to indicate full sleep
  
}

// start timer A to run for 'time_ms'
void timer_ms(uint16 time_ms)
{
  stop_time = time_ms;
  TACTL |= TACLR;                            // clear timer
  TACCR0 = 1000-1;                           // set timer compare value to 1000us or 1ms
  TACCTL0 = CCIE;                            // allow compare interrupt  
  TACTL = MC_1 + ID_3 + TASSEL_2;            // run timer (up mode) with SMCLK as timer clock and divide by 8 for 1MHz clock
  
}

// stop timer A
void timer_stop(void)
{
  TACTL &= ~MC_1;           // stop timerA by clearing count mode
  TAR = 0;                  // reset timer A count register
  timerDone = TRUE;  
}

// Timer A0 interrupt service routine
#pragma vector=TIMERA0_VECTOR
__interrupt void TimerA0_ISR (void)
{
  static uint16 count = 0;
  if(count == stop_time)
  {
    count = 0;                            // reset count
    timer_stop();                         // stop timer and
    __low_power_mode_off_on_exit();       // wake up mcu when interrupt occurs
  }
  else
  {    
    count++;
  }
}
