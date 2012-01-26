;*******************************************************************************
; C Start up file for M16C/Tiny SKPs
; Copyright 2004 Renesas Technology America, Inc,
; All Rights Reserved.
;
; sect30_26askp.inc: section definition
; This program is applicable when using the basic I/O library
;
;******************************************************************************

; Revision History
; 0.1  modified standard file for skp requirements
; 1.0  SKP release

;---------------------------------------------------------------------
; HEAP SIZE definition.  Used for memory allocation functions 
;(malloc,realloc, etc...) 
;---------------------------------------------------------------------
.if  __HEAP__ == 1 
HEAPSIZE  .equ  0H
.else

.if  __HEAPSIZE__ == 0
HEAPSIZE  .equ  300H
.else
HEAPSIZE  .equ  __HEAPSIZE__
.endif

.endif

;---------------------------------------------------------------------
; STACK SIZE definition.  This set the user stack size. Sample programs do not
; use the user stack, both interrupts and function calls use the interrupt stack
; so size is set to 0
;---------------------------------------------------------------------
.if  __USTACKSIZE__ == 0
STACKSIZE  .equ  0
.else
STACKSIZE  .equ  __USTACKSIZE__
.endif

;---------------------------------------------------------------------
; INTERRUPT STACK SIZE definition
;---------------------------------------------------------------------
.if  __ISTACKSIZE__ == 0
ISTACKSIZE  .equ  300h
.else
ISTACKSIZE  .equ  __ISTACKSIZE__
.endif

;---------------------------------------------------------------------
; INTERRUPT VECTOR ADDRESS  definition
; Do NOT set to an area that conflicts with the ROM monitor which starts
; at 0FF900h.  Size of the vector table is 256 bytes
;---------------------------------------------------------------------

VECTOR_ADR   .equ  0ff800h

;====================================================================
; Initialize Macro declarations. These macro's are used in the startup 
; file (ncrto_28skp.a30) for initializing C variables. Clears global 
; variables, sets intialized variables, etc.
;---------------------------------------------------------------------
N_BZERO  .macro  TOP_ ,SECT_
  mov.b  #00H, R0L
  mov.w  #(TOP_ & 0FFFFH), A1
  mov.w  #sizeof SECT_ , R3
  sstr.b  
  .endm

N_BCOPY .macro  FROM_,TO_,SECT_
  mov.w  #(FROM_ & 0FFFFH),A0
  mov.b  #(FROM_ >>16),R1H
  mov.w  #TO_ ,A1
  mov.w  #sizeof SECT_ , R3
  smovf.b
  .endm

HEAPINIT .macro
  .glb  __mbase
  .glb  __mnext
  .glb  __msize
  mov.w  #(heap_top&0FFFFH), __mbase
  mov.w  #(heap_top>>16), __mbase+2
  mov.w  #(heap_top&0FFFFH), __mnext
  mov.w  #(heap_top>>16), __mnext+2
  mov.w  #(HEAPSIZE&0FFFFH), __msize
  mov.w  #(HEAPSIZE>>16), __msize+2
  .endm


;---------------------------------------------------------------
; Special page vectors. This macro puts the jump address of  
; functions defined as special page into the special page vector
; table.  See example call below.  See the M16C Software Manual and
; the NC30 manual for more information on special page vectors
;---------------------------------------------------------------
;  macro define for special page
;
;  Format:
;  SPECIAL  number
;

SPECIAL  .macro  NUM
  .org  0FFFFEH-(NUM*2)
  .glb  __SPECIAL_@NUM
  .word  __SPECIAL_@NUM  & 0FFFFH
.endm

;---------------------------------------------------------------
; Section allocation. The following declarations sets the location of the
; sections in the memory map.  Do not change these settings without 
; referring to the NC30 manual on startup files
;---------------------------------------------------------------
; Near RAM data area
;---------------------------------------------------------------
; SBDATA area
  .section  data_SE,DATA
  .org  400H
data_SE_top:

  .section  bss_SE,DATA,ALIGN
bss_SE_top:

  .section  data_SO,DATA
data_SO_top:

  .section  bss_SO,DATA
bss_SO_top:

; near RAM area
  .section  data_NE,DATA,ALIGN
data_NE_top:

  .section  bss_NE,DATA,ALIGN
bss_NE_top:

  .section  data_NO,DATA
data_NO_top:

  .section  bss_NO,DATA
bss_NO_top:

;---------------------------------------------------------------
; Stack section.  If the user stack is not required do not modify the
; declarations below, instead set USTACKSIZE (above) to zero
;---------------------------------------------------------------
  .section  stack,DATA
  .blkb  STACKSIZE
stack_top:

	.blkb	ISTACKSIZE
istack_top:

;---------------------------------------------------------------
; Heap section. If the heap is not required, and the RAM 
; allocated to the heap is needed, do not modify the declarations
; below, simply set the HEAPSIZE (above) to zero.
;---------------------------------------------------------------
  .section  heap,DATA
heap_top:
  .blkb  HEAPSIZE

;---------------------------------------------------------------
; Near ROM data area. For "near const".
; Near ROM is all ROM below adress 10000h
; Data Flash is located from 0F000h to 0FFFFh.  To access this 
; flash the user program must enable access (set pm10 to 1)
;---------------------------------------------------------------
  .section  rom_NE,ROMDATA
  .org        0F000H      ; Data Flash - 2KB X 2  
rom_NE_top:

	.section	rom_NO,ROMDATA
rom_NO_top:



;---------------------------------------------------------------
; Far ROM data area
;---------------------------------------------------------------
  .section  rom_FE,ROMDATA
  .org    0F0000H      ; For M16C/26A  M30260F8A 64K flash
rom_FE_top:

  .section  rom_FO,ROMDATA
rom_FO_top:

;---------------------------------------------------------------
; Initial data of 'data' section
;---------------------------------------------------------------
  .section  data_SEI,ROMDATA
data_SEI_top:

  .section  data_SOI,ROMDATA
data_SOI_top:

  .section  data_NEI,ROMDATA
data_NEI_top:
 
  .section  data_NOI,ROMDATA
data_NOI_top:
 
  .section  data_FEI,ROMDATA
data_FEI_top:
 
  .section  data_FOI,ROMDATA
data_FOI_top:

;---------------------------------------------------------------
; Switch Table section
;---------------------------------------------------------------
  .section        switch_table,ROMDATA
switch_table_top:

 
;---------------------------------------------------------------
; Code area
;---------------------------------------------------------------

  .section  program

  .section  interrupt

  ;.org  ;special page code must be set internal ROM area
  .section  program_S

;---------------------------------------------------------------
; Variable Vector section
; For proper interrupt operation, replace "dummy_int" with the service
; assembler label or absolute address of the interrupt service routine
;---------------------------------------------------------------
  .section  vector,ROMDATA  ; variable vector table
  .org  VECTOR_ADR 

  .lword  dummy_int    ; BRK  (vector 0)
  .lword  dummy_int    ;   (vector 1) reserved
  .lword  dummy_int    ;   (vector 2) reserved
  .lword  dummy_int    ;   (vector 3) reserved
  .lword  dummy_int    ; INT3(for user)(vector 4)
  .lword  dummy_int    ;   (vector 5) reserved
  .lword  dummy_int    ;   (vector 6) reserved
  .lword  dummy_int	   ;   (vector 7) reserved
  .lword  dummy_int	   ; INT5  (vector 8)
  .lword  dummy_int	   ; INT4  (vector 9)
  .lword  dummy_int	   ; UART2 Bus collision detection iic  (vector 10)
  .lword  dummy_int	   ; DMA0 (for user) (vector 11)
  .lword  dummy_int	   ; DMA1 (for user) (vector 12)
  .lword  dummy_int	   ; Key input    (for user) (vector 13)
  .lword  dummy_int	   ; AD Converter (for user) (vector 14)
  .lword  dummy_int	   ; UART2 transmit/NACK, (for user) (vector 15) 
  .lword  dummy_int	   ; UART2 receive/ACK,(for user)(vector 16) 
  ;.lword  dummy_int	   ; UART0 transmit (for user) (vector 17)
  .glb	  _u0_tx_isr
  .lword  _u0_tx_isr		; UART0 transmit (for user)
  .glb	  _u0_rx_isr
  .lword  _u0_rx_isr		; UART0 receive: use for UART0 recieve interrupt.
  ;.lword  dummy_int	   ; UART0 receive: (for user)(vector 18)	
  .lword  dummy_int	   ; UART1 transmit (for user) (vector 19)
  .lword  dummy_int	   ; UART1 receive: (for user) (vector 20)
  ;.glb	  _TimerA0_Intr
  ;.lword  _TimerA0_Intr	   ; TIMER A0 (for user)(vector 21)
  .lword  dummy_int	   ; TIMER A0 (for user)(vector 21)
  .lword  dummy_int	   ; TIMER A1 (for user)(vector 22)
  .lword  dummy_int	   ; TIMER A2 (for user)(vector 23)
  .lword  dummy_int	   ; TIMER A3 (for user)(vector 24)
  .lword  dummy_int	   ; TIMER A4 (for user) (vector 25)
  .lword  dummy_int	   ; TIMER B0 (for user) (vector 26)
  .lword  dummy_int	   ; TIMER B1 (for user) (vector 27)
  .lword  dummy_int	   ; TIMER B2 (for user) (vector 28)
  .lword  dummy_int	   ; INT0 (for user) (vector 29)
  .lword  dummy_int	   ; INT1 (for user) (vector 30)  
  .lword  dummy_int	   ; INT2 (for user) (vector 31) 
  .lword  dummy_int	   ; Software interrupt (for user) (vector 32) 
	; fill as needed from vector 33 to 63  

;===============================================================
; Fixed Vector section
;---------------------------------------------------------------
  .section  fvector      ; fixed vector table
;===============================================================
; Special Page definition
;---------------------------------------------------------------
; Special page functions can be specified using
; "#pragma SPECIAL" directive and the macro defined above.
; Uncomment the proper line below to call the macro.
; See NC30 manual for more information.
;
;---------------------------------------------------------------
;  SPECIAL 255
;  SPECIAL 254
;  SPECIAL 253
;      :
;	   :
;  (omitted)
;	   :
;	   :
;  SPECIAL 24
;  SPECIAL 23
;  SPECIAL 22
;  SPECIAL 21
;  SPECIAL 20
;  SPECIAL 19
;  SPECIAL 18
;
;===============================================================
; Fixed Vector section
;---------------------------------------------------------------
  .org  0fffdcH
UDI:
  .lword  dummy_int
OVER_FLOW:
  .lword  dummy_int
BRKI:
  .lword  dummy_int
ADDRESS_MATCH:
  .lword  dummy_int
SINGLE_STEP:
  .lword  dummy_int
WDT:
  .lword  dummy_int
DBC:
  .lword  dummy_int
NMI:
  .lword  dummy_int
RESET:
  .lword  start








