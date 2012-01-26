;********************************************************
;*														*
;*	file name	: definition of M16C/26A's SFR			*
;*														*
;*	Copyright	: RENESAS TECHNOLOGY CORPORATION		*
;*														*
;*	Version		: 1.00 ( 2003- 9- 3 )					*
;*                1.10 ( 2004- 4-15 )                   *
;*                1.11 ( 2004- 4-16 )                   *
;*														*
;********************************************************
;
;  note:
;	This data is a freeware that SFR for M16C/26A is described.
;	Renesas Technology Corporation assumes no responsibility for any damage
;	that occurred by this data.
;
;-------------------------------------------------------
;	Processor mode register 0
;-------------------------------------------------------
pm0			.equ		0004h
;
pm03		.btequ		3,pm0		; Software reset bit
;
;-------------------------------------------------------
;	Processor mode register 1
;-------------------------------------------------------
pm1			.equ		0005h
;
pm10		.btequ		0,pm1		; Flash data block access bit
pm12		.btequ		2,pm1		; Watchdog timer function select bit
pm17		.btequ		7,pm1		; Wait bit
;
;-------------------------------------------------------
;	System clock control register 0
;-------------------------------------------------------
cm0			.equ		0006h
;
cm00		.btequ		0,cm0		; Clock output function select bit
cm01		.btequ		1,cm0		; Clock output function select bit
cm02		.btequ		2,cm0		; Wait Mode peripheral function Clock stop bit
cm03		.btequ		3,cm0		; Xcin-Xcout drive capacity select bit
cm04		.btequ		4,cm0		; Port Xc select bit
cm05		.btequ		5,cm0		; Main Clock stop bit
cm06		.btequ		6,cm0		; Main Clock division select bit 0
cm07		.btequ		7,cm0		; System clock select bit
;
;-------------------------------------------------------
;	System clock control register 1
;-------------------------------------------------------
cm1			.equ		0007h
;
cm10		.btequ		0,cm1		; All clock stop control bit
cm11		.btequ		1,cm1		; System clock select bit 1
cm15		.btequ		5,cm1		; Xin-Xout drive capacity select bit
cm16		.btequ		6,cm1		; Main Clock division select bit
cm17		.btequ		7,cm1		; Main Clock division select bit
;
;-------------------------------------------------------
;	Address match interrupt enable register
;-------------------------------------------------------
aier		.equ		0009h
;
aier0		.btequ		0,aier		; Address match interrupt 0 enable bit
aier1		.btequ		1,aier		; Address match interrupt 1 enable bit
;
;-------------------------------------------------------
;	Protect register
;-------------------------------------------------------
prcr		.equ		000ah
;
prc0		.btequ		0,prcr		; Enable write to CM0,CM1,CM2,ROCR,PLC0 and PCLKR registers
prc1		.btequ		1,prcr		; Enable write to PM0,PM1,PM2,TB2SC,INVC0 and INVC1 registers
prc2		.btequ		2,prcr		; Enable write to PD9 and PACR registers
prc3		.btequ		3,prcr		; Enable write to VCR2 and D4INT registers
;
;-------------------------------------------------------
;	Oscillation stop detection register
;-------------------------------------------------------
cm2			.equ		000ch
;
cm20		.btequ		0,cm2		; Oscillation stop,reoscillation detection bit
cm21		.btequ		1,cm2		; System clock select bit 2
cm22		.btequ		2,cm2		; Oscillation stop,reoscillation detection flag
cm23		.btequ		3,cm2		; Xin monitor flag
cm27		.btequ		7,cm2		; Operation select bit
;
;-------------------------------------------------------
;	Watchdog timer
;-------------------------------------------------------
wdts		.equ		000eh		; Watchdog timer start register
;
wdc			.equ		000fh		; Watchdog timer control register
;
wdc5		.btequ		5,wdc		; Cold start/warm start discrimination flag
wdc7		.btequ		7,wdc		; Prescaler select bit
;
;-------------------------------------------------------
;	Address match interrupt register 0
;-------------------------------------------------------
rmad0		.equ		0010h
rmad0l		.equ		rmad0		; Address match interrupt register 0L
rmad0m		.equ		rmad0+1		; Address match interrupt register 0M
rmad0h		.equ		rmad0+2		; Address match interrupt register 0H
;
;-------------------------------------------------------
;	Address match interrupt register 1
;-------------------------------------------------------
rmad1		.equ		0014h
rmad1l		.equ		rmad1		; Address match interrupt register 1L
rmad1m		.equ		rmad1+1		; Address match interrupt register 1M
rmad1h		.equ		rmad1+2		; Address match interrupt register 1H
;
;-------------------------------------------------------
;	Voltage detection register 1
;-------------------------------------------------------
vcr1		.equ		0019h
;
vc13		.btequ		3,vcr1		; Voltage down monitor flag
;
;-------------------------------------------------------
;	Voltage detection register 2
;-------------------------------------------------------
vcr2		.equ		001ah
;
vc25		.btequ		5,vcr2		; RAM retention limit detection monitor bit
vc26		.btequ		6,vcr2		; Reset level monitor bit
vc27		.btequ		7,vcr2		; Voltage down monitor bit
;
;-------------------------------------------------------
;	PLL control register 0
;-------------------------------------------------------
plc0		.equ		001ch
;
plc00		.btequ		0,plc0		; PLL multiplying factor select bit
plc01		.btequ		1,plc0		; PLL multiplying factor select bit
plc02		.btequ		2,plc0		; PLL multiplying factor select bit
plc07		.btequ		7,plc0		; operation enable bit
;
;-------------------------------------------------------
;	Processor mode register 2
;-------------------------------------------------------
pm2			.equ		001eh
;
pm20		.btequ		0,pm2		; Specifying wait when accessing SFR
pm21		.btequ		1,pm2		; System clock protective bit
pm22		.btequ		2,pm2		; WDT count source protective bit
pm24		.btequ		4,pm2		; P85/NMI configuration bit
;
;-------------------------------------------------------
;	Voltage down detection interrupt register
;-------------------------------------------------------
d4int		.equ		001fh
;
d40			.btequ		0,d4int		; Voltage down detection interrupt enable bit
d41			.btequ		1,d4int		; STOP mode deactivation control bit
d42			.btequ		2,d4int		; Voltage change detection flag
d43			.btequ		3,d4int		; WDT overflow detect flag
df0			.btequ		4,d4int		; Sampling clock select bit
df1			.btequ		5,d4int		; Sampling clock select bit
;
;-------------------------------------------------------
;	DMA0 source pointer
;-------------------------------------------------------
sar0		.equ		0020h
sar0l		.equ		sar0		; DMA0 source pointer L
sar0m		.equ		sar0+1		; DMA0 source pointer M
sar0h		.equ		sar0+2		; DMA0 source pointer H
;
;-------------------------------------------------------
;	DMA0 destination pointer
;-------------------------------------------------------
dar0		.equ		0024h
dar0l		.equ		dar0		; DMA0 destination pointer L
dar0m		.equ		dar0+1		; DMA0 destination pointer M
dar0h		.equ		dar0+2		; DMA0 destination pointer H
;
;-------------------------------------------------------
;	DMA0 transfer counter
;-------------------------------------------------------
tcr0		.equ		0028h
tcr0l		.equ		tcr0		; DMA0 transfer counter L
tcr0h		.equ		tcr0+1		; DMA0 transfer counter H
;
;-------------------------------------------------------
;	DMA0 control register
;-------------------------------------------------------
dm0con		.equ		002ch
;
dmbit_dm0con	.btequ	0,dm0con	; Transfer unit bit select bit
dmasl_dm0con	.btequ	1,dm0con	; Repeat transfer mode select bit
dmas_dm0con	.btequ		2,dm0con	; DMA request bit
dmae_dm0con	.btequ		3,dm0con	; DMA enable bit
dsd_dm0con	.btequ		4,dm0con	; Source address direction select bit
dad_dm0con	.btequ		5,dm0con	; Destination address direction select bit
;
;-------------------------------------------------------
;	DMA1 source pointer
;-------------------------------------------------------
sar1		.equ		0030h
sar1l		.equ		sar1		; DMA1 source pointer L
sar1m		.equ		sar1+1		; DMA1 source pointer M
sar1h		.equ		sar1+2		; DMA1 source pointer H
;
;-------------------------------------------------------
;	DMA1 destination pointer
;-------------------------------------------------------
dar1		.equ		0034h
dar1l		.equ		dar1		; DMA1 destination pointer L
dar1m		.equ		dar1+1		; DMA1 destination pointer M
dar1h		.equ		dar1+2		; DMA1 destination pointer H
;
;-------------------------------------------------------
;	DMA1 transfer counter
;-------------------------------------------------------
tcr1		.equ		0038h
tcr1l		.equ		tcr1		;DMA1 transfer counter L
tcr1h		.equ		tcr1+1		;DMA1 transfer counter H
;
;-------------------------------------------------------
;	DMA1 control register
;-------------------------------------------------------
dm1con		.equ		003ch
;
dmbit_dm1con	.btequ	0,dm1con	; Transfer unit bit select bit
dmasl_dm1con	.btequ	1,dm1con	; Repeat transfer mode select bit
dmas_dm1con	.btequ		2,dm1con	; DMA request bit
dmae_dm1con	.btequ		3,dm1con	; DMA disable bit
dsd_dm1con	.btequ		4,dm1con	; Source address direction select bit
dad_dm1con	.btequ		5,dm1con	; Destination address direction select bit
;
;-------------------------------------------------------
;	Interrupt control register
;-------------------------------------------------------
int3ic			.equ	0044h		; INT3
ilvl0_int3ic	.btequ	0,int3ic	; Interrupt priority level select bit
ilvl1_int3ic	.btequ	1,int3ic	;
ilvl2_int3ic	.btequ	2,int3ic	;
ir_int3ic		.btequ	3,int3ic	; Interrupt request bit
pol_int3ic		.btequ	4,int3ic	; Polarity select bit
;
int5ic			.equ	0048h		; INT5
ilvl0_int5ic	.btequ	0,int5ic	; Interrupt priority level select bit
ilvl1_int5ic	.btequ	1,int5ic	;
ilvl2_int5ic	.btequ	2,int5ic	;
ir_int5ic		.btequ	3,int5ic	; Interrupt request bit
pol_int5ic		.btequ	4,int5ic	; Polarity select bit
;
int4ic			.equ	0049h		; INT4
ilvl0_int4ic	.btequ	0,int4ic	; Interrupt priority level select bit
ilvl1_int4ic	.btequ	1,int4ic	;
ilvl2_int4ic	.btequ	2,int4ic	;
ir_int4ic		.btequ	3,int4ic	; Interrupt request bit
pol_int4ic		.btequ	4,int4ic	; Polarity select bit
;
bcnic			.equ	004ah		; Bus collision detection interrupt control register
ilvl0_bcnic		.btequ	0,bcnic		; Interrupt priority level select bit
ilvl1_bcnic		.btequ	1,bcnic		;
ilvl2_bcnic		.btequ	2,bcnic		;
ir_bcnic		.btequ	3,bcnic		; Interrupt request bit
;
dm0ic			.equ	004bh		; DMA0 interrupt control register
ilvl0_dm0ic		.btequ	0,dm0ic		; Interrupt priority level select bit
ilvl1_dm0ic		.btequ	1,dm0ic		;
ilvl2_dm0ic		.btequ	2,dm0ic		;
ir_dm0ic		.btequ	3,dm0ic		; Interrupt request bit
;
dm1ic			.equ	004ch		; DMA1 interrupt control register
ilvl0_dm1ic		.btequ	0,dm1ic		; Interrupt priority level select bit
ilvl1_dm1ic		.btequ	1,dm1ic		;
ilvl2_dm1ic		.btequ	2,dm1ic		;
ir_dm1ic		.btequ	3,dm1ic		; Interrupt request bit
;
kupic			.equ	004dh		; Key input interrupt control register
ilvl0_kupic		.btequ	0,kupic		; Interrupt priority level select bit
ilvl1_kupic		.btequ	1,kupic		;
ilvl2_kupic		.btequ	2,kupic		;
ir_kupic		.btequ	3,kupic		; Interrupt request bit
;
adic			.equ	004eh		; A-D interrupt control register
ilvl0_adic		.btequ	0,adic		; Interrupt priority level select bit
ilvl1_adic		.btequ	1,adic		;
ilvl2_adic		.btequ	2,adic		;
ir_adic			.btequ	3,adic		; Interrupt request bit
;
s2tic			.equ	004fh		; UART2 transmit interrupt control register
ilvl0_s2tic		.btequ	0,s2tic		; Interrupt priority level select bit
ilvl1_s2tic		.btequ	1,s2tic		;
ilvl2_s2tic		.btequ	2,s2tic		;
ir_s2tic		.btequ	3,s2tic		; Interrupt request bit
;
s2ric			.equ	0050h		; UART2 receive interrupt control register
ilvl0_s2ric		.btequ	0,s2ric		; Interrupt priority level select bit
ilvl1_s2ric		.btequ	1,s2ric		;
ilvl2_s2ric		.btequ	2,s2ric		;
ir_s2ric		.btequ	3,s2ric		; Interrupt request bit
;
s0tic			.equ	0051h		; UART0 transmit interrupt control register
ilvl0_s0tic		.btequ	0,s0tic		; Interrupt priority level select bit
ilvl1_s0tic		.btequ	1,s0tic		;
ilvl2_s0tic		.btequ	2,s0tic		;
ir_s0tic		.btequ	3,s0tic		; Interrupt request bit
;
s0ric			.equ	0052h		; UART0 receive interrupt control register
ilvl0_s0ric		.btequ	0,s0ric		; Interrupt priority level select bit
ilvl1_s0ric		.btequ	1,s0ric		;
ilvl2_s0ric		.btequ	2,s0ric		;
ir_s0ric		.btequ	3,s0ric		; Interrupt request bit
;
s1tic			.equ	0053h		; UART1 transmit interrupt control register
ilvl0_s1tic		.btequ	0,s1tic		; Interrupt priority level select bit
ilvl1_s1tic		.btequ	1,s1tic		;
ilvl2_s1tic		.btequ	2,s1tic		;
ir_s1tic		.btequ	3,s1tic		; Interrupt request bit
;
s1ric			.equ	0054h		; UART1 receive interrupt control register
ilvl0_s1ric		.btequ	0,s1ric		; Interrupt priority level select bit
ilvl1_s1ric		.btequ	1,s1ric		;
ilvl2_s1ric		.btequ	2,s1ric		;
ir_s1ric		.btequ	3,s1ric		; Interrupt request bit
;
ta0ic			.equ	0055h		; Timer A0
ilvl0_ta0ic		.btequ	0,ta0ic		; Interrupt priority level select bit
ilvl1_ta0ic		.btequ	1,ta0ic		;
ilvl2_ta0ic		.btequ	2,ta0ic		;
ir_ta0ic		.btequ	3,ta0ic		; Interrupt request bit
;
ta1ic			.equ	0056h		; Timer A1
ilvl0_ta1ic		.btequ	0,ta1ic		; Interrupt priority level select bit
ilvl1_ta1ic		.btequ	1,ta1ic		;
ilvl2_ta1ic		.btequ	2,ta1ic		;
ir_ta1ic		.btequ	3,ta1ic		; Interrupt request bit
;
ta2ic			.equ	0057h		; Timer A2
ilvl0_ta2ic		.btequ	0,ta2ic		; Interrupt priority level select bit
ilvl1_ta2ic		.btequ	1,ta2ic		;
ilvl2_ta2ic		.btequ	2,ta2ic		;
ir_ta2ic		.btequ	3,ta2ic		; Interrupt request bit
;
ta3ic			.equ	0058h		; Timer A3
ilvl0_ta3ic		.btequ	0,ta3ic		; Interrupt priority level select bit
ilvl1_ta3ic		.btequ	1,ta3ic		;
ilvl2_ta3ic		.btequ	2,ta3ic		;
ir_ta3ic		.btequ	3,ta3ic		; Interrupt request bit
;
ta4ic			.equ	0059h		; Timer A4
ilvl0_ta4ic		.btequ	0,ta4ic		; Interrupt priority level select bit
ilvl1_ta4ic		.btequ	1,ta4ic		;
ilvl2_ta4ic		.btequ	2,ta4ic		;
ir_ta4ic		.btequ	3,ta4ic		; Interrupt request bit
;
tb0ic			.equ	005ah		; Timer B0
ilvl0_tb0ic		.btequ	0,tb0ic		; Interrupt priority level select bit
ilvl1_tb0ic		.btequ	1,tb0ic		;
ilvl2_tb0ic		.btequ	2,tb0ic		;
ir_tb0ic		.btequ	3,tb0ic		; Interrupt request bit
;
tb1ic			.equ	005bh		; Timer B1
ilvl0_tb1ic		.btequ	0,tb1ic		; Interrupt priority level select bit
ilvl1_tb1ic		.btequ	1,tb1ic		;
ilvl2_tb1ic		.btequ	2,tb1ic		;
ir_tb1ic		.btequ	3,tb1ic		; Interrupt request bit
;
tb2ic			.equ	005ch		; Timer B2
ilvl0_tb2ic		.btequ	0,tb2ic		; Interrupt priority level select bit
ilvl1_tb2ic		.btequ	1,tb2ic		;
ilvl2_tb2ic		.btequ	2,tb2ic		;
ir_tb2ic		.btequ	3,tb2ic		; Interrupt request bit
;
int0ic			.equ	005dh		; INT0
ilvl0_int0ic	.btequ	0,int0ic	; Interrupt priority level select bit
ilvl1_int0ic	.btequ	1,int0ic	;
ilvl2_int0ic	.btequ	2,int0ic	;
ir_int0ic		.btequ	3,int0ic	; Interrupt request bit
pol_int0ic		.btequ	4,int0ic	; Polarity select bit
;
int1ic			.equ	005eh		; INT1
ilvl0_int1ic	.btequ	0,int1ic	; Interrupt priority level select bit
ilvl1_int1ic	.btequ	1,int1ic	;
ilvl2_int1ic	.btequ	2,int1ic	;
ir_int1ic		.btequ	3,int1ic	; Interrupt request bit
pol_int1ic		.btequ	4,int1ic	; Polarity select bit
;
int2ic			.equ	005fh		; INT2
ilvl0_int2ic	.btequ	0,int2ic	; Interrupt priority level select bit
ilvl1_int2ic	.btequ	1,int2ic	;
ilvl2_int2ic	.btequ	2,int2ic	;
ir_int2ic		.btequ	3,int2ic	; Interrupt request bit
pol_int2ic		.btequ	4,int2ic	; Polarity select bit
;
;-------------------------------------------------------
;	Flash memory control register 4
;-------------------------------------------------------
fmr4		.equ		01b3h
;
fmr40		.btequ		0,fmr4		; Erase suspend function enable bit
fmr41		.btequ		1,fmr4		; Erase suspend request bit
fmr46		.btequ		6,fmr4		; Erase status
;
;-------------------------------------------------------
;	Flash memory control register 1
;-------------------------------------------------------
fmr1		.equ		01b5h
;
fmr11		.btequ		1,fmr1		; EW1 mode select bit
fmr16		.btequ		6,fmr1		; Block 0 to 5 rewrite enable bit
fmr17       .btequ      7,fmr1      ; Block A, B access wait bit
;
;-------------------------------------------------------
;	Flash memory control register 0
;-------------------------------------------------------
fmr0		.equ		01b7h
;
fmr00		.btequ		0,fmr0		; RY/BY status flag
fmr01		.btequ		1,fmr0		; CPU rewrite mode select bit
fmr02		.btequ		2,fmr0		; Block 0, 1 rewrite enable bit
fmstp		.btequ		3,fmr0		; Flash memory stop bit
fmr06		.btequ		6,fmr0		; Program status flag
fmr07		.btequ		7,fmr0		; Erase status flag
;
;-------------------------------------------------------
;	Three-phase protect control register
;-------------------------------------------------------
tprc		.equ	025Ah
;
tprc0		.btequ		0,tprc		; Three-phase protect control bit
;
;-------------------------------------------------------
;	Ring oscillator control register
;-------------------------------------------------------
rocr		.equ		025ch
;
rocr0		.btequ		0,rocr		; Frequency select bit
rocr1		.btequ		1,rocr		; Frequency select bit
rocr2		.btequ		2,rocr		; Divider select bit
rocr3		.btequ		3,rocr		; Divider select bit
;
;-------------------------------------------------------
;	Pin assignment control register
;-------------------------------------------------------
pacr		.equ		025dh
;
pacr0		.btequ		0,pacr		; Pin enabling bit
pacr1		.btequ		1,pacr		; Pin enabling bit
pacr2		.btequ		2,pacr		; Pin enabling bit
u1map		.btequ		7,pacr		; UART1 pin remapping bit
;
;-------------------------------------------------------
;	Peripheral clock select register
;-------------------------------------------------------
pclkr		.equ		025eh
;
pclk0		.btequ		0,pclkr		; Timers A,B clock select bit
pclk1		.btequ		1,pclkr		; SI/O clock select bit
pclk5		.btequ		5,pclkr		; Clock output function expansion select bit
;
;-------------------------------------------------------
;	NMI digital debounce register
;-------------------------------------------------------
nddr		.equ		033eh		; 
;
;-------------------------------------------------------
;	P17 digital debounce register
;-------------------------------------------------------
p17ddr		.equ		033fh
;
;-----------------------------------------------------------
;  Timer A1-1 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta11		.equ		0342h		; Timer A1-1
;
;-----------------------------------------------------------
;  Timer A2-1 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta21		.equ		0344h		; Timer A2-1
;
;-----------------------------------------------------------
;  Timer A4-1 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta41		.equ		0346h		; Timer A4-1
;
;-------------------------------------------------------
;	Three-phase PWM control register 0
;-------------------------------------------------------
invc0		.equ		0348h
;
inv00		.btequ		0,invc0		; Effective interrupt output polarity select bit
inv01		.btequ		1,invc0		; Effective interrupt output specification bit
inv02		.btequ		2,invc0		; Mode select bit
inv03		.btequ		3,invc0		; Output control bit
inv04		.btequ		4,invc0		; Positive and negative phase concurrent output disable bit
inv05		.btequ		5,invc0		; Positive and negative phase concurrent output detect flag
inv06		.btequ		6,invc0		; Modulation mode select bit
inv07		.btequ		7,invc0		; Software trigger select bit
;
;-------------------------------------------------------
;	Three-phase PWM control register 1
;-------------------------------------------------------
invc1		.equ		0349h
;
inv10		.btequ		0,invc1		; Timer A1,A2,A4 start trigger signal select bit
inv11		.btequ		1,invc1		; timer A1-1,A2-1,A4-1 control bit
inv12		.btequ		2,invc1		; Dead time timer count source select bit
inv13		.btequ		3,invc1		; Carrier wave detect flag
inv14		.btequ		4,invc1		; Output polarity control bit
inv15		.btequ		5,invc1		; Dead time invalid bit
inv16		.btequ		6,invc1		; Dead time timer trigger select bit
;
;-------------------------------------------------------
;	Three-phase output buffer register 0
;-------------------------------------------------------
idb0		.equ		034ah
;
du0			.btequ		0,idb0		;  U phase output buffer 0
dub0		.btequ		1,idb0		; ~U phase output buffer 0
dv0			.btequ		2,idb0		;  V phase output buffer 0
dvb0		.btequ		3,idb0		; ~V phase output buffer 0
dw0			.btequ		4,idb0		;  W phase output buffer 0
dwb0		.btequ		5,idb0		; ~W phase output buffer 0
;
;-------------------------------------------------------
;	Three-phase output buffer register 1
;-------------------------------------------------------
idb1		.equ		034bh
;
du1			.btequ		0,idb1		;  U phase output buffer 1
dub1		.btequ		1,idb1		; ~U phase output buffer 1
dv1			.btequ		2,idb1		;  V phase output buffer 1
dvb1		.btequ		3,idb1		; ~V phase output buffer 1
dw1			.btequ		4,idb1		;  W phase output buffer 1
dwb1		.btequ		5,idb1		; ~W phase output buffer 1
;
;-------------------------------------------------------
;	Dead time timer  ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
dtt			.equ		034ch
;
;-------------------------------------------------------
;	Timer B2 interrupt occurrence frequency set counter ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
ictb2		.equ		034dh
;
;-------------------------------------------------------
;	Position-data-retain function register
;-------------------------------------------------------
pdrf		.equ		034eh
;
pdrw		.btequ		0,pdrf		; W-phase position data retain bit
pdrv		.btequ		1,pdrf		; V-phase position data retain bit
pdru		.btequ		2,pdrf		; U-phase position data retain bit
pdrt		.btequ		3,pdrf		; Retain-trigger polarity select bit
;
;-------------------------------------------------------
;	Port Function control register
;-------------------------------------------------------
pfcr		.equ		0358h
;
pfc0		.btequ		0,pfcr		; Port P8_0 output function select bit
pfc1		.btequ		1,pfcr		; Port P8_1 output function select bit
pfc2		.btequ		2,pfcr		; Port P7_2 output function select bit
pfc3		.btequ		3,pfcr		; Port P7_3 output function select bit
pfc4		.btequ		4,pfcr		; Port P7_4 output function select bit
pfc5		.btequ		5,pfcr		; Port P7_5 output function select bit
;
;-------------------------------------------------------
;	Interrupt request cause select register 2
;-------------------------------------------------------
ifsr2a		.equ		035eh
;
ifsr20      .btequ		0,ifsr2a    ; Reserved bit (Must be set to "0")
;
;-------------------------------------------------------
;	Interrupt request cause select register
;-------------------------------------------------------
ifsr		.equ		035fh
;
ifsr0		.btequ		0,ifsr		; INT0 interrupt polarity switching bit
ifsr1		.btequ		1,ifsr		; INT1 interrupt polarity switching bit
ifsr2		.btequ		2,ifsr		; INT2 interrupt polarity switching bit
ifsr3		.btequ		3,ifsr		; INT3 interrupt polarity switching bit
ifsr4		.btequ		4,ifsr		; INT4 interrupt polarity switching bit
ifsr5		.btequ		5,ifsr		; INT5 interrupt polarity switching bit
ifsr6		.btequ		6,ifsr		; Interrupt request cause select bit
ifsr7		.btequ		7,ifsr		; Interrupt request cause select bit
;
;-------------------------------------------------------
;	UART2
;-------------------------------------------------------
;-------------------------------------------------------
;	UART2 special mode register 4
;-------------------------------------------------------
u2smr4		.equ		0374h
;
stareq_u2smr4	.btequ	0,u2smr4	; Start condition generate bit
rstareq_u2smr4	.btequ	1,u2smr4	; Restart condition generate bit
stpreq_u2smr4	.btequ	2,u2smr4	; Stop condition generate bit
stspsel_u2smr4	.btequ	3,u2smr4	; SCL,SDA output select bit
ackd_u2smr4		.btequ	4,u2smr4	; ACK data bit
ackc_u2smr4		.btequ	5,u2smr4	; ACK data output enable bit
sclhi_u2smr4	.btequ	6,u2smr4	; SCL output stop enable bit
swc9_u2smr4		.btequ	7,u2smr4	; SCL wait bit 3
;
;-------------------------------------------------------
;	UART2 special mode register 3
;-------------------------------------------------------
u2smr3		.equ		0375h
;
ckph_u2smr3	.btequ		1,u2smr3	; Clock phase set bit
nodc_u2smr3	.btequ		3,u2smr3	; Clock output select bit
dl0_u2smr3	.btequ		5,u2smr3	; SDA2 digital delay setup bit
dl1_u2smr3	.btequ		6,u2smr3	; SDA2 digital delay setup bit
dl2_u2smr3	.btequ		7,u2smr3	; SDA2 digital delay setup bit
;
;-------------------------------------------------------
;	UART2 special mode register 2
;-------------------------------------------------------
u2smr2		.equ		0376h
;
iicm2_u2smr2	.btequ	0,u2smr2	; I2C Bus mode select bit 2
csc_u2smr2		.btequ	1,u2smr2	; Clock-synchronous bit
swc_u2smr2		.btequ	2,u2smr2	; SCL wait output bit
als_u2smr2		.btequ	3,u2smr2	; SDA output stop bit
stac_u2smr2		.btequ	4,u2smr2	; UART2 initialization bit
swc2_u2smr2		.btequ	5,u2smr2	; SCL wait output bit 2
sdhi_u2smr2		.btequ	6,u2smr2	; SDA output disable bit
;
;-------------------------------------------------------
;	UART2 special mode register
;-------------------------------------------------------
u2smr		.equ		0377h
;
iicm_u2smr	.btequ		0,u2smr		; I2C Bus mode select bit
abc_u2smr	.btequ		1,u2smr		; Arbitration lost detecting flag control bit
bbs_u2smr	.btequ		2,u2smr		; Bus busy flag
abscs_u2smr	.btequ		4,u2smr		; Bus collision detect sampling clock select bit
acse_u2smr	.btequ		5,u2smr		; Auto clear function select bit of transmit enable bit
sss_u2smr	.btequ		6,u2smr		; Transmit start condition select bit
;
;-------------------------------------------------------
;	UART2 transmit/receive mode register
;-------------------------------------------------------
u2mr		.equ		0378h
;
smd0_u2mr	.btequ		0,u2mr		; Serial I/O mode select bit
smd1_u2mr	.btequ		1,u2mr		; Serial I/O mode select bit
smd2_u2mr	.btequ		2,u2mr		; Serial I/O mode select bit
ckdir_u2mr	.btequ		3,u2mr		; Internal/external Clock select bit
stps_u2mr	.btequ		4,u2mr		; Stop bit length select bit
pry_u2mr	.btequ		5,u2mr		; Odd/even parity select bit
prye_u2mr	.btequ		6,u2mr		; Parity enable bit
iopol_u2mr	.btequ		7,u2mr		; TxD,RxD I/O polarity reverse bit
;
;-------------------------------------------------------
;  UART2 bit rate generator ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
u2brg		.equ		0379h
;
;-------------------------------------------------------
;  UART2 transmit buffer register ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
u2tb		.equ		037ah
u2tbl		.equ		u2tb		; 		Low
u2tbh		.equ		u2tb+1		;		High
;
;-------------------------------------------------------
;	UART2 transmit/receive control register 0
;-------------------------------------------------------
u2c0		.equ		037ch
;
clk0_u2c0	.btequ		0,u2c0		; BRG count source select bit
clk1_u2c0	.btequ		1,u2c0		; BRG count source select bit
crs_u2c0	.btequ		2,u2c0		; CTS/RTS function select bit
txept_u2c0	.btequ		3,u2c0		; Transmit register empty flag
crd_u2c0	.btequ		4,u2c0		; CTS/RTS disable bit
nch_u2c0    .btequ      5,u2c0      ; Data output select bit
ckpol_u2c0	.btequ		6,u2c0		; CLK polarity select bit
uform_u2c0	.btequ		7,u2c0		; Transfer format select bit
;
;-------------------------------------------------------
;	UART2 transmit/receive control register 1
;-------------------------------------------------------
u2c1		.equ		037dh
;
te_u2c1		.btequ		0,u2c1		; Transmit enable bit
ti_u2c1		.btequ		1,u2c1		; Transmit buffer empty flag
re_u2c1		.btequ		2,u2c1		; Receive enable bit
ri_u2c1		.btequ		3,u2c1		; Receive complete flag
u2irs		.btequ		4,u2c1		; UART2 transmit interrupt cause select bit
u2rrm		.btequ		5,u2c1		; UART2 continuous receive mode enable bit
u2lch		.btequ		6,u2c1		; Data logic select bit
u2ere		.btequ		7,u2c1		; Error signal output enable bit
u2irs_u2c1	.btequ		4,u2c1
u2rrm_u2c1	.btequ		5,u2c1
u2lch_u2c1	.btequ		6,u2c1
u2ere_u2c1	.btequ		7,u2c1
;
;-------------------------------------------------------
;  UART2 receive buffer register
;-------------------------------------------------------
u2rb		.equ		037eh
u2rbl		.equ		u2rb		;		Low
u2rbh		.equ		u2rb+1		;		High
;
abt_u2rb	.btequ		3,u2rbh		; Arbitration lost detection flag
oer_u2rb	.btequ		4,u2rbh		; Overrun error flag
fer_u2rb	.btequ		5,u2rbh		; Framing error flag
per_u2rb	.btequ		6,u2rbh		; Parity error flag
sum_u2rb	.btequ		7,u2rbh		; Error sum flag
;
;-------------------------------------------------------
;	Count start flag
;-------------------------------------------------------
tabsr		.equ		0380h
;
ta0s		.btequ		0,tabsr		; Timer A0 count start flag
ta1s		.btequ		1,tabsr		; Timer A1 count start flag
ta2s		.btequ		2,tabsr		; Timer A2 count start flag
ta3s		.btequ		3,tabsr		; Timer A3 count start flag
ta4s		.btequ		4,tabsr		; Timer A4 count start flag
tb0s		.btequ		5,tabsr		; Timer B0 count start flag
tb1s		.btequ		6,tabsr		; Timer B1 count start flag
tb2s		.btequ		7,tabsr		; Timer B2 count start flag
;
;-------------------------------------------------------
;	Clock prescaler reset flag
;-------------------------------------------------------
cpsrf		.equ		0381h
;
cpsr		.btequ		7,cpsrf		; Clock prescaler reset flag
;
;-------------------------------------------------------
;	One-shot start flag
;-------------------------------------------------------
onsf		.equ		0382h
;
ta0os		.btequ		0,onsf		; Timer A0 one-shot start flag
ta1os		.btequ		1,onsf		; Timer A1 one-shot start flag
ta2os		.btequ		2,onsf		; Timer A2 one-shot start flag
ta3os		.btequ		3,onsf		; Timer A3 one-shot start flag
ta4os		.btequ		4,onsf		; Timer A4 one-shot start flag
tazie		.btequ		5,onsf		; Z-phase input enable bit
ta0tgl		.btequ		6,onsf		; Timer A0 event/trigger select bit
ta0tgh		.btequ		7,onsf		; Timer A0 event/trigger select bit
;
;-------------------------------------------------------
;	Trigger select register
;-------------------------------------------------------
trgsr		.equ		0383h
;
ta1tgl		.btequ		0,trgsr		; Timer A1 event/trigger select bit
ta1tgh		.btequ		1,trgsr		; Timer A1 event/trigger select bit
ta2tgl		.btequ		2,trgsr		; Timer A2 event/trigger select bit
ta2tgh		.btequ		3,trgsr		; Timer A2 event/trigger select bit
ta3tgl		.btequ		4,trgsr		; Timer A3 event/trigger select bit
ta3tgh		.btequ		5,trgsr		; Timer A3 event/trigger select bit
ta4tgl		.btequ		6,trgsr		; Timer A4 event/trigger select bit
ta4tgh		.btequ		7,trgsr		; Timer A4 event/trigger select bit
;
;-------------------------------------------------------
;	Up/down flag
;-------------------------------------------------------
udf		.equ		0384h
;
ta0ud		.btequ		0,udf		; Timer A0 up/down flag
ta1ud		.btequ		1,udf		; Timer A1 up/down flag
ta2ud		.btequ		2,udf		; Timer A2 up/down flag
ta3ud		.btequ		3,udf		; Timer A3 up/down flag
ta4ud		.btequ		4,udf		; Timer A4 up/down flag
ta2p		.btequ		5,udf		; Timer A2 two-phase pulse signal processing select bit
ta3p		.btequ		6,udf		; Timer A3 two-phase pulse signal processing select bit
ta4p		.btequ		7,udf		; Timer A4 two-phase pulse signal processing select bit
;
;-----------------------------------------------------------
;  Timer A0 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta0			.equ		0386h		; Timer A0
;
;-----------------------------------------------------------
;  Timer A1 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta1			.equ		0388h		; Timer A1
;
;-----------------------------------------------------------
;  Timer A2 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta2			.equ		038ah		; Timer A2
;
;-----------------------------------------------------------
;  Timer A3 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta3			.equ		038ch		; Timer A3
;
;-----------------------------------------------------------
;  Timer A4 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
ta4			.equ		038eh		; Timer A4
;
;-----------------------------------------------------------
;  Timer B0 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
tb0			.equ		0390h		; Timer B0
;
;-----------------------------------------------------------
;  Timer B1 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
tb1			.equ		0392h		; Timer B1
;
;-----------------------------------------------------------
;  Timer B2 register : The register must be accessed in 16-bit units.
;-----------------------------------------------------------
tb2			.equ		0394h		; TimerB2
;
;-----------------------------------------------------------
;  Timer A0 mode register
;-----------------------------------------------------------
ta0mr		.equ		0396h
;
tmod0_ta0mr	.btequ		0,ta0mr		; Operation mode select bit
tmod1_ta0mr	.btequ		1,ta0mr		; Operation mode select bit
mr0_ta0mr	.btequ		2,ta0mr		;
mr1_ta0mr	.btequ		3,ta0mr		;
mr2_ta0mr	.btequ		4,ta0mr		;
mr3_ta0mr	.btequ		5,ta0mr		;
tck0_ta0mr	.btequ		6,ta0mr		; Count source select bit
tck1_ta0mr	.btequ		7,ta0mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer A1 mode register
;-----------------------------------------------------------
ta1mr		.equ		0397h
;
tmod0_ta1mr	.btequ		0,ta1mr		; Operation mode select bit
tmod1_ta1mr	.btequ		1,ta1mr		; Operation mode select bit
mr0_ta1mr	.btequ		2,ta1mr		;
mr1_ta1mr	.btequ		3,ta1mr		;
mr2_ta1mr	.btequ		4,ta1mr		;
mr3_ta1mr	.btequ		5,ta1mr		;
tck0_ta1mr	.btequ		6,ta1mr		; Count source select bit
tck1_ta1mr	.btequ		7,ta1mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer A2 mode register
;-----------------------------------------------------------
ta2mr		.equ		0398h
;
tmod0_ta2mr	.btequ		0,ta2mr		; Operation mode select bit
tmod1_ta2mr	.btequ		1,ta2mr		; Operation mode select bit
mr0_ta2mr	.btequ		2,ta2mr		;
mr1_ta2mr	.btequ		3,ta2mr		;
mr2_ta2mr	.btequ		4,ta2mr		;
mr3_ta2mr	.btequ		5,ta2mr		;
tck0_ta2mr	.btequ		6,ta2mr		; Count source select bit
tck1_ta2mr	.btequ		7,ta2mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer A3 mode register
;-----------------------------------------------------------
ta3mr		.equ		0399h
;
tmod0_ta3mr	.btequ		0,ta3mr		; Operation mode select bit
tmod1_ta3mr	.btequ		1,ta3mr		; Operation mode select bit
mr0_ta3mr	.btequ		2,ta3mr		;
mr1_ta3mr	.btequ		3,ta3mr		;
mr2_ta3mr	.btequ		4,ta3mr		;
mr3_ta3mr	.btequ		5,ta3mr		;
tck0_ta3mr	.btequ		6,ta3mr		; Count source select bit
tck1_ta3mr	.btequ		7,ta3mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer A4 mode register
;-----------------------------------------------------------
ta4mr		.equ		039ah
;
tmod0_ta4mr	.btequ		0,ta4mr		; Operation mode select bit
tmod1_ta4mr	.btequ		1,ta4mr		; Operation mode select bit
mr0_ta4mr	.btequ		2,ta4mr		;
mr1_ta4mr	.btequ		3,ta4mr		;
mr2_ta4mr	.btequ		4,ta4mr		;
mr3_ta4mr	.btequ		5,ta4mr		;
tck0_ta4mr	.btequ		6,ta4mr		; Count source select bit
tck1_ta4mr	.btequ		7,ta4mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer B0 mode register
;-----------------------------------------------------------
tb0mr		.equ		039bh
;
tmod0_tb0mr	.btequ		0,tb0mr		; Operation mode select bit
tmod1_tb0mr	.btequ		1,tb0mr		; Operation mode select bit
mr0_tb0mr	.btequ		2,tb0mr		;
mr1_tb0mr	.btequ		3,tb0mr		;
mr2_tb0mr	.btequ		4,tb0mr		;
mr3_tb0mr	.btequ		5,tb0mr		;
tck0_tb0mr	.btequ		6,tb0mr		; Count source select bit
tck1_tb0mr	.btequ		7,tb0mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer B1 mode register
;-----------------------------------------------------------
tb1mr		.equ		039ch
;
tmod0_tb1mr	.btequ		0,tb1mr		; Operation mode select bit
tmod1_tb1mr	.btequ		1,tb1mr		; Operation mode select bit
mr0_tb1mr	.btequ		2,tb1mr		;
mr1_tb1mr	.btequ		3,tb1mr		;
mr2_tb1mr	.btequ		4,tb1mr		;
mr3_tb1mr	.btequ		5,tb1mr		;
tck0_tb1mr	.btequ		6,tb1mr		; Count source select bit
tck1_tb1mr	.btequ		7,tb1mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer B2 mode register
;-----------------------------------------------------------
tb2mr		.equ		039dh
;
tmod0_tb2mr	.btequ		0,tb2mr		; Operation mode select bit
tmod1_tb2mr	.btequ		1,tb2mr		; Operation mode select bit
mr0_tb2mr	.btequ		2,tb2mr		;
mr1_tb2mr	.btequ		3,tb2mr		;
mr2_tb2mr	.btequ		4,tb2mr		;
mr3_tb2mr	.btequ		5,tb2mr		;
tck0_tb2mr	.btequ		6,tb2mr		; Count source select bit
tck1_tb2mr	.btequ		7,tb2mr		; Count source select bit
;
;-----------------------------------------------------------
;  Timer B2 special mode register
;-----------------------------------------------------------
tb2sc		.equ		039eh
;
pwcon_tb2sc		.btequ	0,tb2sc		; Timer B2 reload timing switching bit
ivpcr1_tb2sc	.btequ	1,tb2sc		; Three-phase output port ~SD control bit 1
tb0en_tb2sc		.btequ	2,tb2sc		; Timer B0 operation mode select bit
tb1en_tb2sc		.btequ	3,tb2sc		; Timer B1 operation mode select bit
tb2sel_tb2sc	.btequ	4,tb2sc		; Trigger select bit
;
;-------------------------------------------------------
;	UART0 transmit/receive mode register
;-------------------------------------------------------
u0mr		.equ		03a0h
;
smd0_u0mr	.btequ		0,u0mr		; Serial I/O mode select bit
smd1_u0mr	.btequ		1,u0mr		; Serial I/O mode select bit
smd2_u0mr	.btequ		2,u0mr		; Serial I/O mode select bit
ckdir_u0mr	.btequ		3,u0mr		; Internal/external clock select bit
stps_u0mr	.btequ		4,u0mr		; Stop bit length select bit
pry_u0mr	.btequ		5,u0mr		; Odd/even parity select bit
prye_u0mr	.btequ		6,u0mr		; Parity enable bit
;
;-------------------------------------------------------
;  UART0 bit rate generator ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
u0brg		.equ		03a1h
;
;-------------------------------------------------------
;  UART0 transmit buffer register ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
u0tb		.equ		03a2h		; UART0 transmit buffer register
u0tbl		.equ		u0tb		; 		Low
u0tbh		.equ		u0tb+1		;		High
;
;-------------------------------------------------------
;  UART0 transmit/receive control register 0
;-------------------------------------------------------
u0c0		.equ		03a4h
;
clk0_u0c0	.btequ		0,u0c0		; BRG count source select bit
clk1_u0c0	.btequ		1,u0c0		; BRG count source select bit
crs_u0c0	.btequ		2,u0c0		; CTS/RTS function select bit
txept_u0c0	.btequ		3,u0c0		; Transmit register empty flag
crd_u0c0	.btequ		4,u0c0		; CTS/RTS enable bit
nch_u0c0	.btequ		5,u0c0		; Data output select bit
ckpol_u0c0	.btequ		6,u0c0		; CLK polarity select bit
uform_u0c0	.btequ		7,u0c0		; Transfer format select bit
;
;-------------------------------------------------------
;  UART0 transmit/receive control register 1
;-------------------------------------------------------
u0c1		.equ		03a5h
;
te_u0c1		.btequ		0,u0c1		; Transmit enable bit
ti_u0c1		.btequ		1,u0c1		; Transmit buffer empty flag
re_u0c1		.btequ		2,u0c1		; Receive enable bit
ri_u0c1		.btequ		3,u0c1		; Receive complete flag
;
;-------------------------------------------------------
;  UART0 receive buffer register
;-------------------------------------------------------
u0rb		.equ		03a6h
u0rbl		.equ		u0rb		;		Low
u0rbh		.equ		u0rb+1		;		High
oer_u0rb	.btequ		4,u0rbh		; Overrun error flag
fer_u0rb	.btequ		5,u0rbh		; Framing error flag
per_u0rb	.btequ		6,u0rbh		; Parity error flag
sum_u0rb	.btequ		7,u0rbh		; Error sum flag
;
;-------------------------------------------------------
;	UART1 transmit/receive mode register
;-------------------------------------------------------
u1mr		.equ		03a8h
;
smd0_u1mr	.btequ		0,u1mr		; Serial I/O mode select bit
smd1_u1mr	.btequ		1,u1mr		; Serial I/O mode select bit
smd2_u1mr	.btequ		2,u1mr		; Serial I/O mode select bit
ckdir_u1mr	.btequ		3,u1mr		; Internal/external clock select bit
stps_u1mr	.btequ		4,u1mr		; Stop bit length select bit
pry_u1mr	.btequ		5,u1mr		; Odd/even parity select bit
prye_u1mr	.btequ		6,u1mr		; Parity enable bit
;
;-------------------------------------------------------
;  UART1 bit rate generator ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
u1brg		.equ		03a9h
;
;-------------------------------------------------------
;  UART1 transmit buffer register ; Use "MOV" instruction to write to this register.
;-------------------------------------------------------
u1tb		.equ		03aah
u1tbl		.equ		u1tb		; 		Low
u1tbh		.equ		u1tb+1		;		High
;
;-------------------------------------------------------
;  UART1 transmit/receive control register 0
;-------------------------------------------------------
u1c0		.equ		03ach
;
clk0_u1c0	.btequ		0,u1c0		; BRG count source select bit
clk1_u1c0	.btequ		1,u1c0		; BRG count source select bit
crs_u1c0	.btequ		2,u1c0		; CTS/RTS function select bit
txept_u1c0	.btequ		3,u1c0		; Transmit register empty flag
crd_u1c0	.btequ		4,u1c0		; CTS/RTS disable bit
nch_u1c0	.btequ		5,u1c0		; Data output select bit
ckpol_u1c0	.btequ		6,u1c0		; CLK polarity  select bit
uform_u1c0	.btequ		7,u1c0		; Transfer format select bit
;
;-------------------------------------------------------
;  UART1 transmit/receive control register 1
;-------------------------------------------------------
u1c1		.equ		03adh
;
te_u1c1		.btequ		0,u1c1		; Transmit enable bit
ti_u1c1		.btequ		1,u1c1		; Transmit buffer empty flag
re_u1c1		.btequ		2,u1c1		; Receive enable bit
ri_u1c1		.btequ		3,u1c1		; Receive complete flag
;
;-------------------------------------------------------
;  UART1 receive register
;-------------------------------------------------------
u1rb		.equ		03aeh
u1rbl		.equ		u1rb		;		Low
u1rbh		.equ		u1rb+1		;		High
;
oer_u1rb	.btequ		4,u1rbh		; Overrun error flag
fer_u1rb	.btequ		5,u1rbh		; Framing error flag
per_u1rb	.btequ		6,u1rbh		; Parity error flag
sum_u1rb	.btequ		7,u1rbh		; Error sum flag
;
;-------------------------------------------------------
;  UART transmit/receive control register 2
;-------------------------------------------------------
ucon		.equ		03b0h
;
u0irs		.btequ		0,ucon		; UART0 transmit interrupt cause select bit
u1irs		.btequ		1,ucon		; UART1 transmit interrupt cause select bit
u0rrm		.btequ		2,ucon		; UART0 continuous receive mode disable bit
u1rrm		.btequ		3,ucon		; UART1 continuous receive mode disable bit
clkmd0		.btequ		4,ucon		; UART1 CLK/CLKS select bit 0
clkmd1		.btequ		5,ucon		; UART1 CLK/CLKS select bit 1
rcsp		.btequ		6,ucon		; Separate UART0 RTS/CTS bit
;
;--------------------------------------------------------
;	CRC snoop address register
;--------------------------------------------------------
crcsar		.equ		03b4h
crcsarl		.equ		crcsar		;		Low
crcsarh		.equ		crcsar+1	;		High
;
crcsar0		.btequ		0,crcsarl	; CRC mode polynomial selection bit
crcsar1		.btequ		1,crcsarl	; CRC mode polynomial selection bit
crcsar2		.btequ		2,crcsarl	; CRC mode polynomial selection bit
crcsar3		.btequ		3,crcsarl	; CRC mode polynomial selection bit
crcsar4		.btequ		4,crcsarl	; CRC mode polynomial selection bit
crcsar5		.btequ		5,crcsarl	; CRC mode polynomial selection bit
crcsar6		.btequ		6,crcsarl	; CRC mode polynomial selection bit
crcsar7		.btequ		7,crcsarl	; CRC mode polynomial selection bit
crcsar8		.btequ		0,crcsarh	; CRC mode polynomial selection bit
crcsar9		.btequ		1,crcsarh	; CRC mode polynomial selection bit
crcsr		.btequ		6,crcsarh	; CRC snoop on read enable bit
crcsw		.btequ		7,crcsarh	; CRC snoop on write enable bit
;
;--------------------------------------------------------
;	CRC mode register
;--------------------------------------------------------
crcmr		.equ		03b6h
;
crcps		.btequ		0,crcmr		; CRC mode polynomial selection bit
crcms		.btequ		7,crcmr		; CRC mode selection bit
;
;--------------------------------------------------------
;	DMA0 request cause select register
;--------------------------------------------------------
dm0sl		.equ		03b8h
;
dsel0_dm0sl	.btequ		0,dm0sl		; DMA request cause select bit
dsel1_dm0sl	.btequ		1,dm0sl		; DMA request cause select bit
dsel2_dm0sl	.btequ		2,dm0sl		; DMA request cause select bit
dsel3_dm0sl	.btequ		3,dm0sl		; DMA request cause select bit
dms_dm0sl	.btequ		6,dm0sl		; DMA request cause expansion select bit
dsr_dm0sl	.btequ		7,dm0sl		; Software DMA request bit
;
;--------------------------------------------------------
;	DMA1 request cause select register
;--------------------------------------------------------
dm1sl		.equ		03bah
;
dsel0_dm1sl	.btequ		0,dm1sl		; DMA request cause select bit
dsel1_dm1sl	.btequ		1,dm1sl		; DMA request cause select bit
dsel2_dm1sl	.btequ		2,dm1sl		; DMA request cause select bit
dsel3_dm1sl	.btequ		3,dm1sl		; DMA request cause select bit
dms_dm1sl	.btequ		6,dm1sl		; DMA request cause expansion select bit
dsr_dm1sl	.btequ		7,dm1sl		; Software DMA request bit
;
;-------------------------------------------------------
;	CRC data register
;-------------------------------------------------------
crcd		.equ		03bch
crcdl		.equ		crcd		;		Low
crcdh		.equ		crcd+1		; 		High
;
;-------------------------------------------------------
;	CRC input register
;-------------------------------------------------------
crcin		.equ		03beh
;
;-------------------------------------------------------
;  A-D register 0
;-------------------------------------------------------
ad0			.equ		03c0h
ad0l		.equ		ad0			;		Low
ad0h		.equ		ad0+1		;		High
;
;-------------------------------------------------------
;  AD register 1
;-------------------------------------------------------
ad1			.equ		03c2h
ad1l		.equ		ad1			;		Low
ad1h		.equ		ad1+1		;		High
;
;-------------------------------------------------------
;  AD register 2
;-------------------------------------------------------
ad2			.equ		03c4h
ad2l		.equ		ad2			;		Low
ad2h		.equ		ad2+1		;		High
;
;-------------------------------------------------------
;  AD register 3
;-------------------------------------------------------
ad3			.equ		03c6h
ad3l		.equ		ad3			;		Low
ad3h		.equ		ad3+1		;		High
;
;-------------------------------------------------------
;  AD register 4
;-------------------------------------------------------
ad4			.equ		03c8h
ad4l		.equ		ad4			;		Low
ad4h		.equ		ad4+1		;		High
;
;-------------------------------------------------------
;  AD register 5
;-------------------------------------------------------
ad5			.equ		03cah
ad5l		.equ		ad5			;		Low
ad5h		.equ		ad5+1		;		High
;
;-------------------------------------------------------
;  AD register 6
;-------------------------------------------------------
ad6			.equ		03cch
ad6l		.equ		ad6			;		Low
ad6h		.equ		ad6+1		;		High
;
;-------------------------------------------------------
;  AD register 7
;-------------------------------------------------------
ad7			.equ		03ceh
ad7l		.equ		ad7			;		Low
ad7h		.equ		ad7+1		;		High
;
;-------------------------------------------------------
;  AD trigger control register
;-------------------------------------------------------
adtrgcon	.equ		03d2h
;
sse			.btequ		0,adtrgcon	; A-D operation mode select bit 2
dte			.btequ		1,adtrgcon	; A-D operation mode select bit 3
hptrg0		.btequ		2,adtrgcon	; AN0 trigger select bit
hptrg1		.btequ		3,adtrgcon	; AN1 trigger select bit
;
;-------------------------------------------------------
;  AD convert status register 0
;-------------------------------------------------------
adstat0		.equ		03d3h
;
aderr0		.btequ		0,adstat0	; AN1 trigger status flag
aderr1		.btequ		1,adstat0	; Conversion termination flag
adtcsf		.btequ		3,adstat0	; Delayed triggered sweep status flag
adstt0		.btequ		4,adstat0	; AN0 conversion status flag
adstt1		.btequ		5,adstat0	; AN1 conversion status flag
adstrt0		.btequ		6,adstat0	; AN0 conversion completion status flag
adstrt1		.btequ		7,adstat0	; AN1 conversion completion status flag
;
;-------------------------------------------------------
;  AD control register 2
;-------------------------------------------------------
adcon2		.equ		03d4h
;
smp			.btequ		0,adcon2	; AD conversion method select bit
adgsel0		.btequ		1,adcon2	; AD input group select bit
adgsel1		.btequ		2,adcon2	; AD input group select bit
cks2		.btequ		4,adcon2	; Frequency select bit 2
trg1		.btequ		5,adcon2	; Trigger select bit
;
;-------------------------------------------------------
;  AD control register 0
;-------------------------------------------------------
adcon0		.equ		03d6h
;
ch0			.btequ		0,adcon0	; Analog input pin select bit
ch1			.btequ		1,adcon0	; Analog input pin select bit
ch2			.btequ		2,adcon0	; Analog input pin select bit
md0			.btequ		3,adcon0	; AD operation mode select bit 0
md1			.btequ		4,adcon0	; AD operation mode select bit 0
trg			.btequ		5,adcon0	; Trigger select bit
adst		.btequ		6,adcon0	; AD conversion start flag
cks0		.btequ		7,adcon0	; Frequency select bit 0
;
;-------------------------------------------------------
;  AD control register 1
;-------------------------------------------------------
adcon1		.equ		03d7h
;
scan0		.btequ		0,adcon1	; AD sweep pin select bit
scan1		.btequ		1,adcon1	; AD sweep pin select bit
md2			.btequ		2,adcon1	; AD operation mode select bit 1
bits		.btequ		3,adcon1	; 8/10 bit mode select bit
cks1		.btequ		4,adcon1	; Frequency select bit 1
vcut		.btequ		5,adcon1	; Vref connect bit
;
;-------------------------------------------------------
;  Port P1 register
;-------------------------------------------------------
p1			.equ		03e1h
;
p1_5		.btequ		5,p1
p1_6		.btequ		6,p1
p1_7		.btequ		7,p1
;
;-------------------------------------------------------
;  Port P1 direction register
;-------------------------------------------------------
pd1			.equ		03e3h
;
pd1_5		.btequ		5,pd1
pd1_6		.btequ		6,pd1
pd1_7		.btequ		7,pd1
;
;-------------------------------------------------------
;  Port P6 register
;-------------------------------------------------------
p6			.equ		03ech
;
p6_0		.btequ		0,p6
p6_1		.btequ		1,p6
p6_2		.btequ		2,p6
p6_3		.btequ		3,p6
p6_4		.btequ		4,p6
p6_5		.btequ		5,p6
p6_6		.btequ		6,p6
p6_7		.btequ		7,p6
;
;-------------------------------------------------------
;  Port P7 register
;-------------------------------------------------------
p7			.equ		03edh
;
p7_0		.btequ		0,p7
p7_1		.btequ		1,p7
p7_2		.btequ		2,p7
p7_3		.btequ		3,p7
p7_4		.btequ		4,p7
p7_5		.btequ		5,p7
p7_6		.btequ		6,p7
p7_7		.btequ		7,p7
;
;-------------------------------------------------------
;  Port P6 direction register
;-------------------------------------------------------
pd6			.equ		03eeh
;
pd6_0		.btequ		0,pd6
pd6_1		.btequ		1,pd6
pd6_2		.btequ		2,pd6
pd6_3		.btequ		3,pd6
pd6_4		.btequ		4,pd6
pd6_5		.btequ		5,pd6
pd6_6		.btequ		6,pd6
pd6_7		.btequ		7,pd6
;
;-------------------------------------------------------
;  Port P7 direction register
;-------------------------------------------------------
pd7			.equ		03efh
;
pd7_0		.btequ		0,pd7
pd7_1		.btequ		1,pd7
pd7_2		.btequ		2,pd7
pd7_3		.btequ		3,pd7
pd7_4		.btequ		4,pd7
pd7_5		.btequ		5,pd7
pd7_6		.btequ		6,pd7
pd7_7		.btequ		7,pd7
;
;-------------------------------------------------------
;  Port P8 register
;-------------------------------------------------------
p8			.equ		03f0h
;
p8_0		.btequ		0,p8
p8_1		.btequ		1,p8
p8_2		.btequ		2,p8
p8_3		.btequ		3,p8
p8_4		.btequ		4,p8
p8_5		.btequ		5,p8
p8_6		.btequ		6,p8
p8_7		.btequ		7,p8
;
;-------------------------------------------------------
;  Port P9 register
;-------------------------------------------------------
p9			.equ		03f1h
;
p9_0		.btequ		0,p9
p9_1		.btequ		1,p9
p9_2		.btequ		2,p9
p9_3		.btequ		3,p9
;
;-------------------------------------------------------
;  Port P8 direction register
;-------------------------------------------------------
pd8			.equ		03f2h
;
pd8_0		.btequ		0,pd8
pd8_1		.btequ		1,pd8
pd8_2		.btequ		2,pd8
pd8_3		.btequ		3,pd8
pd8_4		.btequ		4,pd8
pd8_5		.btequ		5,pd8
pd8_6		.btequ		6,pd8
pd8_7		.btequ		7,pd8
;
;-------------------------------------------------------
;  Port P9 direction register
;-------------------------------------------------------
pd9			.equ		03f3h
;
pd9_0		.btequ		0,pd9
pd9_1		.btequ		1,pd9
pd9_2		.btequ		2,pd9
pd9_3		.btequ		3,pd9
;
;-------------------------------------------------------
;  Port P10 register
;-------------------------------------------------------
p10			.equ		03f4h
;
p10_0		.btequ		0,p10
p10_1		.btequ		1,p10
p10_2		.btequ		2,p10
p10_3		.btequ		3,p10
p10_4		.btequ		4,p10
p10_5		.btequ		5,p10
p10_6		.btequ		6,p10
p10_7		.btequ		7,p10
;
;-------------------------------------------------------
;  Port P10 direction register
;-------------------------------------------------------
pd10		.equ		03f6h
;
pd10_0		.btequ		0,pd10
pd10_1		.btequ		1,pd10
pd10_2		.btequ		2,pd10
pd10_3		.btequ		3,pd10
pd10_4		.btequ		4,pd10
pd10_5		.btequ		5,pd10
pd10_6		.btequ		6,pd10
pd10_7		.btequ		7,pd10
;
;-------------------------------------------------------
;	Pull-up control register 0
;-------------------------------------------------------
pur0		.equ		03fch
;
pu03		.btequ		3,pur0		; Pull-up register 03
;
;-------------------------------------------------------
;	Pull-up control register 1
;-------------------------------------------------------
pur1		.equ		03fdh
;
pu14		.btequ		4,pur1		; Pull-up register 14
pu15		.btequ		5,pur1		; Pull-up register 15
pu16		.btequ		6,pur1		; Pull-up register 16
pu17		.btequ		7,pur1		; Pull-up register 17
;
;-------------------------------------------------------
;	Pull-up control register 2
;-------------------------------------------------------
pur2		.equ		03feh
;
pu20		.btequ		0,pur2		; Pull-up register 20
pu21		.btequ		1,pur2		; Pull-up register 21
pu22		.btequ		2,pur2		; Pull-up register 22
pu24		.btequ		4,pur2		; Pull-up register 24
pu25		.btequ		5,pur2		; Pull-up register 25
;
;-------------------------------------------------------
;	Port control register
;-------------------------------------------------------
pcr			.equ		03ffh
;
pcr0		.btequ		0,pcr		; Port 1 control bit
