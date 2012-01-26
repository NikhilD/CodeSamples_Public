// tab space = 4
/*********************************************************************
* DISCLAIMER:                                                        *
* The software supplied by Renesas Technology America Inc. is        *
* intended and supplied for use on Renesas Technology products.      *
* This software is owned by Renesas Technology America, Inc. or      *
* Renesas Technology Corporation and is protected under applicable   *
* copyright laws. All rights are reserved.                           *
*                                                                    *
* THIS SOFTWARE IS PROVIDED "AS IS". NO WARRANTIES, WHETHER EXPRESS, *
* IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO IMPLIED 		 *
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE *
* APPLY TO THIS SOFTWARE. RENESAS TECHNOLOGY AMERICA, INC. AND       *
* AND RENESAS TECHNOLOGY CORPORATION RESERVE THE RIGHT, WITHOUT      *
* NOTICE, TO MAKE CHANGES TO THIS SOFTWARE. NEITHER RENESAS          *
* TECHNOLOGY AMERICA, INC. NOR RENESAS TECHNOLOGY CORPORATION SHALL, *
* IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR        *
* CONSEQUENTIAL DAMAGES FOR ANY REASON WHATSOEVER ARISING OUT OF THE *
* USE OR APPLICATION OF THIS SOFTWARE.                               *
*********************************************************************/

/*-----------------------------------------------------------------------------
  FILE NAME: mcu_init.c
-----------
DESCRIPTION: System clock and processor mode initilization
-----------
    DETAILS: For M16C/26A

------------------
 Revision History
------------------
   1.0 Oct 11, 2004
       Initial Version

-----------------------------------------------------------------------------*/
#include "qsk_bsp.h"
#include "mcu_init.h"


/**************************************************************************
Name       : mcu_init()   
Parameters : none                   
Returns    : nothing      
Description: The starter kit startup file initializes the clock circuit
             to the main crystal with a divide by 1.  This function also sets
			 the main clock to divide by 1 in case the SKP startup file is not 
			 used.  It then enables the PLL 
     
***************************************************************************/
void mcu_init(void)
{
    unsigned int count = 20000;


    prc1 = 1;                       /* enable access to processor mode registers */
    pm20 = 0;                       /* 2 wait states for sfr access...this is the reset value
                                       necessary for >16Mhz operation, can be set to 1 wait for <=16Mhz */
    prc1 = 0;                       /* disable access to processor mode registers */

    /* configure and switch main clock to PLL at 20MHz */
    prc0 = 1;                       /* enable access to clock registers */
    cm1 = 0x20;                     /* set to hi-drive Xin, divide by 1 */
    cm0 = 0x08;                     /* set to main clock using divide by 1 */
    cm21 = 0;                       /* switch to Xin */
    plc0 = 0x11;                    /* configure PLL to x2 */
    plc0 = 0x91;                    /* enable PLL */
    while(count > 0) count--;       /* wait for PLL to stabilize (20mS maximum, 200,000 cycles @10Mhz)
                                       this decrement with no optimization is 12 cycles each (20,000*12 cycles=240,000=24mS) */
    cm11 = 1;                       /* switch to PLL */
    prc0 = 0;                       /* disable access to clock registers */
 
	prc1 = 1;
	pm10 = 1;		// enable data flash area
	prc1 = 0;
	
	// Pin Enabling bits
  	prc2 = 1;
	pacr0 = 0;
  	pacr1 = 0;
  	pacr2 = 1; 
	u1map = 0;
	prc2 = 0;
	
	ENABLE_LEDS;
	//ENABLE_SWITCHES;
}