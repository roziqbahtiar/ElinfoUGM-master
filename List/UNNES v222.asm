
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _maxSpeed=R5
	.DEF _minSpeed=R4
	.DEF _speedStep=R7
	.DEF _kp=R8
	.DEF _error=R10
	.DEF _errorDiff=R12
	.DEF _sensor=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_fullBlock:
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
_emptyBlock:
	.DB  0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F
_leftHorn:
	.DB  0x10,0x18,0x1C,0x1F,0x1F,0xF,0x7,0x3
_rightHorn:
	.DB  0x1,0x3,0xF,0x1F,0x1F,0x1E,0x1C,0x18
_leftArrow:
	.DB  0x1,0x7,0xF,0x1F,0x1F,0xF,0x7,0x1
_rightArrow:
	.DB  0x10,0x1C,0x1E,0x1F,0x1F,0x1E,0x1C,0x10

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x0,0x0,0x80,0x3F
_0x4:
	.DB  0x0,0x0,0x80,0x3F
_0x5:
	.DB  0x1
_0x63:
	.DB  0x52,0x4F,0x42,0x4F,0x54,0x49,0x4B,0x41
	.DB  0x20,0x55,0x4E,0x4E,0x45,0x53,0x20,0x0
	.DB  0x0,0x4,0x42,0x49,0x53,0x4D,0x49,0x4C
	.DB  0x4C,0x41,0x48,0x5,0x0
_0xC5:
	.DB  0x0,0xFF,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  _kd
	.DW  _0x3*2

	.DW  0x04
	.DW  _ki
	.DW  _0x4*2

	.DW  0x0A
	.DW  0x04
	.DW  _0xC5*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/30/2013
;Author  : Ardika
;Company : CrowjaEmbedder
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x60
;
;// definisi tombol-tombol
;#define CMD_UP          PINC.4
;#define CMD_DOWN        PINC.5
;#define CMD_OK          PINC.6
;#define CMD_CANCEL      PINC.7
;#define ANY_KEY_PRESSED (PINC & 0xF0)
;
;// Detektor persimpangan jalan
;#define RIGHT_WING  PIND.0
;#define LEFT_WING   PIND.1
;
;// definisi kendali motor
;#define RIGHT_PWM   OCR1AL
;#define LEFT_PWM    OCR1BL
;#define TOP_PWM     255
;#define BOTTOM_PWM  0
;#define RIGHT_DR1   PORTD.6
;#define RIGHT_DR2   PORTD.7
;#define LEFT_DR1    PORTD.2
;#define LEFT_DR2    PORTD.3
;
;// definisi custom character LCD
;#define FULL_BLOCK  0
;#define EMPTY_BLOCK 1
;#define LEFT_HORN   2
;#define RIGHT_HORN  3
;#define LEFT_ARROW  4
;#define RIGHT_ARROW 5
;
;// definisi untuk melakukan kalibrasi
;#define CALIBRATING_COUNT   100
;
;// Permodelan menu menggunakan linked list
;struct menu {
;    char text[16];
;    struct menu *prev;
;    struct menu *next;
;    struct menu *child;
;    void (*onExecute)();
;};
;
;typedef struct menu Menu;
;
;//flash Menu start = {"Mulai",,,NULL,};
;
;
;
;flash unsigned char fullBlock[8] = {
;    0b11111,
;    0b11111,
;    0b11111,
;    0b11111,
;    0b11111,
;    0b11111,
;    0b11111,
;    0b11111
;};
;
;flash unsigned char emptyBlock[8] = {
;    0b11111,
;    0b10001,
;    0b10001,
;    0b10001,
;    0b10001,
;    0b10001,
;    0b10001,
;    0b11111
;};
;
;flash unsigned char leftHorn[8] = {
;	0b10000,
;	0b11000,
;	0b11100,
;	0b11111,
;	0b11111,
;	0b01111,
;	0b00111,
;	0b00011
;};
;
;flash unsigned char  rightHorn[8] = {
;	0b00001,
;	0b00011,
;	0b01111,
;	0b11111,
;	0b11111,
;	0b11110,
;	0b11100,
;	0b11000
;};
;
;flash unsigned char leftArrow[8] = {
;	0b00001,
;	0b00111,
;	0b01111,
;	0b11111,
;	0b11111,
;	0b01111,
;	0b00111,
;	0b00001
;};
;
;flash unsigned char  rightArrow[8] = {
;	0b10000,
;	0b11100,
;	0b11110,
;	0b11111,
;	0b11111,
;	0b11110,
;	0b11100,
;	0b10000
;};
;
;
;
;// Variabel-variabel kontrol yang tersimpan di memory non-volatile
;eeprom unsigned char eeMaxSpeed = 255;
;eeprom unsigned char eeMinSpeed = 0;
;eeprom int eeKp = 125;
;eeprom float eeKd = 0.0f;
;eeprom float eeKi = 0.3f;
;
;// Varibel kepekaan sensor dalam memory non-volaitile
;eeprom unsigned char eeWhiteMin[8] = {5,5,5,5,5,5,5,5};   // Nilai pembacaan minimal untuk putih
;eeprom unsigned char eeBlackMax[8] = {230,230,230,230,230,230,230,230};  // Nilai pembacaan maksimal untuk hitam
;eeprom unsigned char eeMiddleVal[8] = {120,120,120,120,120,120,120,120};   // Nilai tengah antara white min dan black max
;
;// Varibael-varibel kontrol yang disimpan di memory volatile untuk perhitungan kontrol
;unsigned char maxSpeed = 255;     // nilai kecepatan maksimal
;unsigned char minSpeed = 0;
;unsigned char speedStep = 0;
;
;int kp = 0;           // konstanta proposional
;float kd = 1.0f;           // konstanta derivatif

	.DSEG
;float ki = 1.0f;           // konstanta integral
;int error = 0;        // nilai error pembacaan sensor saat ini
;int errorDiff = 0;    // selisih error dan error sebelumnya
;int lastError = 0;    // nilai error sebelumnya
;int propotional = 0;
;int integral = 0;
;float derivative = 0;
;
;
;int sp;           // nilai set point sensor
;int currentPosition;
;int targetPosition = 0;
;int integral;
;//int derivative;
;int previousError = 0;
;int dt = 1;
;int output = 0;
;
;
;// Variabel kepekaan sensor dalam memory volatile untuk perhitungan
;unsigned char whiteMin[8] = {0};   // Nilai pembacaan minimal untuk putih
;unsigned char blackMax[8] = {0};  // Nilai pembacaan maksimal untuk hitam
;unsigned char middleVal[8] = {0};   // Nilai tengah antara white min dan black max
;
;// Varibel penyimpan nilai sensor biner, dimana tiap satu sensor nilainya diwakili oleh 1-bit
;// yang merupakan hasil perbandingan pembacaan nilai analog sensor dengan nilai kepekaan sensor
;unsigned char sensor = 0;
;// Flag yang menandakan warna garis saat ini, 0: hitam, 1: putih
;bit lineColorFlag = 0;
;
;//prototype fungsi
;void define_char(unsigned char flash *pc,unsigned char char_code);
;unsigned char read_adc(unsigned char adc_input);
;void scanLineRelative();
;void scanLineActual();
;void loadVariables();
;void saveVariables();
;void lcdOn(unsigned char on);
;void lcdOnWing();
;void go();
;void back();
;void left();
;void right();
;void stop(unsigned char usingPowerBrake);
;void lcdPrintByte(unsigned char value);
;void printADCSensor();
;void printBinarySensor();
;void whiteCalibrating();
;void blackCalibrating();
;void applyCalibratedValue();
;void pid();
;void showStartup();
;void LCDInit();
;void myPID();
;
;
;void main(void)
; 0000 00DD {

	.CSEG
_main:
; 0000 00DE 
; 0000 00DF     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00E0     DDRA=0x00;
	OUT  0x1A,R30
; 0000 00E1 
; 0000 00E2     PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00E3     DDRB=0xFF;
	OUT  0x17,R30
; 0000 00E4 
; 0000 00E5     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00E6     DDRC=0x00;
	OUT  0x14,R30
; 0000 00E7 
; 0000 00E8     PORTD=0x00;
	OUT  0x12,R30
; 0000 00E9     DDRD=0xFC;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 00EA 
; 0000 00EB     // Timer/Counter 1 initialization
; 0000 00EC     // Clock source: System Clock
; 0000 00ED     // Clock value: 250.000 kHz
; 0000 00EE     // Mode: Fast PWM top=0x00FF
; 0000 00EF     // OC1A output: Non-Inv.
; 0000 00F0     // OC1B output: Non-Inv.
; 0000 00F1     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 00F2     TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 00F3     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00F4     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F5     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F6     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F7     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F8     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F9     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00FA     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00FB 
; 0000 00FC     // ADC initialization
; 0000 00FD     // ADC Clock frequency: 125.000 kHz
; 0000 00FE     // ADC Voltage Reference: AVCC pin
; 0000 00FF     // Only the 8 most significant bits of
; 0000 0100     // the AD conversion result are used
; 0000 0101     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0102     ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0103 
; 0000 0104     LCDInit();
	RCALL _LCDInit
; 0000 0105 
; 0000 0106     loadVariables();
	RCALL _loadVariables
; 0000 0107     applyCalibratedValue();
	RCALL _applyCalibratedValue
; 0000 0108 
; 0000 0109     //showStartup();
; 0000 010A     go();
	RCALL _go
; 0000 010B 
; 0000 010C     while (1) {
_0x6:
; 0000 010D         //lcd_gotoxy(0,0);
; 0000 010E         //scanLineActual();
; 0000 010F         //scanLineRelative();
; 0000 0110         scanLineActual();
	RCALL _scanLineActual
; 0000 0111         myPID();
	RCALL _myPID
; 0000 0112         //printBinarySensor();
; 0000 0113         //printADCSensor();
; 0000 0114 
; 0000 0115 
; 0000 0116     }
	RJMP _0x6
; 0000 0117 }
_0x9:
	RJMP _0x9
;
;
;/* function used to define user characters */
;void define_char(unsigned char flash *pc,unsigned char char_code)
; 0000 011C {
_define_char:
; 0000 011D     unsigned char i,a;
; 0000 011E     a=(char_code<<3) | 0x40;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 011F     for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0xB:
	CPI  R17,8
	BRSH _0xC
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	CALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0xB
_0xC:
; 0000 0120 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0126 {
_read_adc:
; 0000 0127     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0128     // Delay needed for the stabilization of the ADC input voltage
; 0000 0129     //delay_us(10);
; 0000 012A     // Start the AD conversion
; 0000 012B     ADCSRA|=0x40;
	SBI  0x6,6
; 0000 012C     // Wait for the AD conversion to complete
; 0000 012D     while (!(ADCSRA & 0x10));
_0xD:
	SBIS 0x6,4
	RJMP _0xD
; 0000 012E         ADCSRA |= 0x10;
	SBI  0x6,4
; 0000 012F     return ADCH;
	IN   R30,0x5
	JMP  _0x2020001
; 0000 0130 }
;
;// Fungsi scan garis aktual dimana nilai pembacaan hitam adalah 1 dan nilai pembacaan putih adalah 0
;void scanLineActual()
; 0000 0134 {
_scanLineActual:
; 0000 0135     unsigned char i = 8;
; 0000 0136     unsigned char adcRead;
; 0000 0137 
; 0000 0138     sensor = 0;   // reset nilai sensor
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	adcRead -> R16
	LDI  R17,8
	CLR  R6
; 0000 0139     while (i--) {
_0x10:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x12
; 0000 013A         adcRead = read_adc(i);  // Baca nilai ADC ada bit ke-i
	MOV  R26,R17
	RCALL _read_adc
	MOV  R16,R30
; 0000 013B         if (adcRead > middleVal[i])
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_middleVal)
	SBCI R31,HIGH(-_middleVal)
	LD   R30,Z
	CP   R30,R16
	BRSH _0x13
; 0000 013C             sensor |= (1<<i);
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R6,R30
; 0000 013D     }
_0x13:
	RJMP _0x10
_0x12:
; 0000 013E     lineColorFlag = 0;   // pada pembacaan aktual, sayap persimpangan mengangsumsikan garis adalah hitam
	CLT
	BLD  R2,0
; 0000 013F }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;// Fungsi scan garis relatif dimana garis dibaca secara relatif terhadap perbandingan antara blok hitam dan putih yang terbaca
;// jika blok putih > blok hitam maka garis adalah hitam, sebaihnya garis adalah putih. Garis tetap dibaca sebagai bit set/1
;void scanLineRelative()
; 0000 0145 {
; 0000 0146     unsigned char i = 8;
; 0000 0147     unsigned char adcRead;  // Variabel pembacaan nilai ADC
; 0000 0148     // JUmlah warna hitam yang terdeteksi oleh sensor
; 0000 0149     unsigned char blackCount = 0;
; 0000 014A 
; 0000 014B     sensor = 0x00;   // Hapus nilai sensor sebelumnya
;	i -> R17
;	adcRead -> R16
;	blackCount -> R19
; 0000 014C     while (i--) {
; 0000 014D         adcRead = read_adc(i);  // Baca nilai ADC ada bit ke-i
; 0000 014E         if (adcRead > middleVal[i]) {
; 0000 014F             blackCount++;       // Increment jumlah blok hitam yang terbaca
; 0000 0150             sensor |= (1<<i);
; 0000 0151         }
; 0000 0152     }
; 0000 0153     if (blackCount >= 4) {   // Jika blok hitam yg terdeteksi banyak, maka garisnya adalah putih
; 0000 0154         sensor = ~sensor;
; 0000 0155         lineColorFlag = 1;
; 0000 0156     }
; 0000 0157     else
; 0000 0158         lineColorFlag = 0;
; 0000 0159 }
;
;void loadVariables()
; 0000 015C {
_loadVariables:
; 0000 015D     unsigned char i = 0;
; 0000 015E     eeprom int *ptr;
; 0000 015F     eeprom unsigned char *ptr1;
; 0000 0160     eeprom float *ptr2;
; 0000 0161 
; 0000 0162     ptr1 = &eeMaxSpeed;
	SBIW R28,2
	CALL __SAVELOCR6
;	i -> R17
;	*ptr -> R18,R19
;	*ptr1 -> R20,R21
;	*ptr2 -> Y+6
	LDI  R17,0
	__POINTWRM 20,21,_eeMaxSpeed
; 0000 0163     maxSpeed = *ptr1;
	MOVW R26,R20
	CALL __EEPROMRDB
	MOV  R5,R30
; 0000 0164     ptr1 = &eeMinSpeed;
	__POINTWRM 20,21,_eeMinSpeed
; 0000 0165     minSpeed = *ptr1;
	MOVW R26,R20
	CALL __EEPROMRDB
	MOV  R4,R30
; 0000 0166     speedStep = (maxSpeed - minSpeed) / 8;
	MOV  R26,R5
	CLR  R27
	MOV  R30,R4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	MOV  R7,R30
; 0000 0167 
; 0000 0168     ptr = &eeKp;
	__POINTWRM 18,19,_eeKp
; 0000 0169     kp = *ptr;
	MOVW R26,R18
	CALL __EEPROMRDW
	MOVW R8,R30
; 0000 016A     ptr2 = &eeKd;
	LDI  R30,LOW(_eeKd)
	LDI  R31,HIGH(_eeKd)
	CALL SUBOPT_0x1
; 0000 016B     kd = *ptr2;
	STS  _kd,R30
	STS  _kd+1,R31
	STS  _kd+2,R22
	STS  _kd+3,R23
; 0000 016C     ptr2 = &eeKi;
	LDI  R30,LOW(_eeKi)
	LDI  R31,HIGH(_eeKi)
	CALL SUBOPT_0x1
; 0000 016D     ki = *ptr2;
	STS  _ki,R30
	STS  _ki+1,R31
	STS  _ki+2,R22
	STS  _ki+3,R23
; 0000 016E 
; 0000 016F     for (; i<8; i++) {
_0x1B:
	CPI  R17,8
	BRSH _0x1C
; 0000 0170         ptr1 = &eeWhiteMin[i];
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_eeWhiteMin)
	SBCI R31,HIGH(-_eeWhiteMin)
	MOVW R20,R30
; 0000 0171         whiteMin[i] = *ptr1;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_whiteMin)
	SBCI R31,HIGH(-_whiteMin)
	CALL SUBOPT_0x2
; 0000 0172         ptr1 = &eeBlackMax[i];
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_eeBlackMax)
	SBCI R31,HIGH(-_eeBlackMax)
	MOVW R20,R30
; 0000 0173         blackMax[i] = *ptr1;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_blackMax)
	SBCI R31,HIGH(-_blackMax)
	CALL SUBOPT_0x2
; 0000 0174     }
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 0175 }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
;
;void saveVariables()
; 0000 0178 {
; 0000 0179     unsigned char i = 0;
; 0000 017A     eeprom int *ptr;
; 0000 017B     eeprom unsigned char *ptr1;
; 0000 017C     eeprom float *ptr2;
; 0000 017D 
; 0000 017E     ptr1 = &eeMaxSpeed;
;	i -> R17
;	*ptr -> R18,R19
;	*ptr1 -> R20,R21
;	*ptr2 -> Y+6
; 0000 017F     *ptr1 = maxSpeed;
; 0000 0180     ptr1 = &eeMinSpeed;
; 0000 0181     *ptr1 = minSpeed;
; 0000 0182     ptr = &eeKp;
; 0000 0183     *ptr = kp;
; 0000 0184     ptr2 = &eeKd;
; 0000 0185     *ptr2 = kd;
; 0000 0186     ptr2 = &eeKi;
; 0000 0187     *ptr2 = ki;
; 0000 0188 
; 0000 0189     for (; i<8; i++) {
; 0000 018A         ptr1 = &eeWhiteMin[i];
; 0000 018B         *ptr1 = whiteMin[i];
; 0000 018C         ptr1 = &eeBlackMax[i];
; 0000 018D         *ptr1 = blackMax[i];
; 0000 018E     }
; 0000 018F }
;
;
;void lcdOn(unsigned char on)
; 0000 0193 {
_lcdOn:
; 0000 0194     PORTB.3 = on;
	ST   -Y,R26
;	on -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x20
	CBI  0x18,3
	RJMP _0x21
_0x20:
	SBI  0x18,3
_0x21:
; 0000 0195 }
	JMP  _0x2020001
;
;void lcdOnWing()
; 0000 0198 {
; 0000 0199     PORTB.3 = !((LEFT_WING) | (RIGHT_WING));
; 0000 019A }
;
;void go()
; 0000 019D {
_go:
; 0000 019E     RIGHT_DR1 = 0; RIGHT_DR2 = 1;
	CBI  0x12,6
	SBI  0x12,7
; 0000 019F     LEFT_DR1 = 0; LEFT_DR2 = 1;
	CBI  0x12,2
	SBI  0x12,3
; 0000 01A0 }
	RET
;
;void back()
; 0000 01A3 {
; 0000 01A4     RIGHT_DR1 = 1; RIGHT_DR2 = 0;
; 0000 01A5     LEFT_DR1 = 1; LEFT_DR2 = 0;
; 0000 01A6 }
;
;void left()
; 0000 01A9 {
; 0000 01AA     RIGHT_DR1 = 0; RIGHT_DR2 = 1;
; 0000 01AB     LEFT_DR1 = 0; LEFT_DR2 = 0;
; 0000 01AC }
;
;void right()
; 0000 01AF {
; 0000 01B0     RIGHT_DR1 = 0; RIGHT_DR2 = 0;
; 0000 01B1     LEFT_DR1 = 0; LEFT_DR2 = 1;
; 0000 01B2 }
;
;void stop(unsigned char usingPowerBrake)
; 0000 01B5 {
; 0000 01B6     RIGHT_DR1 = RIGHT_DR2 = LEFT_DR1 = LEFT_DR2 = 0;
;	usingPowerBrake -> Y+0
; 0000 01B7     if (usingPowerBrake) {
; 0000 01B8         back();
; 0000 01B9         LEFT_PWM = RIGHT_PWM = 255;
; 0000 01BA         delay_ms(100);
; 0000 01BB         LEFT_PWM = RIGHT_PWM = 0;
; 0000 01BC     }
; 0000 01BD 
; 0000 01BE }
;
;void lcdPrintByte(unsigned char value)
; 0000 01C1 {
_lcdPrintByte:
; 0000 01C2     unsigned char ten = (value % 100) / 10;
; 0000 01C3     lcd_putchar('0' + (value / 100));
	ST   -Y,R26
	ST   -Y,R17
;	value -> Y+1
;	ten -> R17
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R17,R30
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 01C4     lcd_putchar('0' + ten);
	MOV  R26,R17
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
; 0000 01C5     lcd_putchar('0' + (value % 10));
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 01C6 }
	LDD  R17,Y+0
	JMP  _0x2020002
;
;void printADCSensor()
; 0000 01C9 {
; 0000 01CA     lcd_gotoxy(0,0); lcdPrintByte(read_adc(0));
; 0000 01CB     lcd_gotoxy(4,0); lcdPrintByte(read_adc(1));
; 0000 01CC     lcd_gotoxy(8,0); lcdPrintByte(read_adc(2));
; 0000 01CD     lcd_gotoxy(12,0); lcdPrintByte(read_adc(3));
; 0000 01CE     lcd_gotoxy(0,1); lcdPrintByte(read_adc(4));
; 0000 01CF     lcd_gotoxy(4,1); lcdPrintByte(read_adc(5));
; 0000 01D0     lcd_gotoxy(8,1); lcdPrintByte(read_adc(6));
; 0000 01D1     lcd_gotoxy(12,1); lcdPrintByte(read_adc(7));
; 0000 01D2 }
;
;void printBinarySensor()
; 0000 01D5 {
_printBinarySensor:
; 0000 01D6     unsigned char i = 0;
; 0000 01D7 
; 0000 01D8     for (; i<8; i++) {
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
_0x4E:
	CPI  R17,8
	BRSH _0x4F
; 0000 01D9         if (sensor & (1<<i))
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R6
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x50
; 0000 01DA             lcd_putchar(FULL_BLOCK);
	LDI  R26,LOW(0)
	RJMP _0xC3
; 0000 01DB         else
_0x50:
; 0000 01DC             lcd_putchar(EMPTY_BLOCK);
	LDI  R26,LOW(1)
_0xC3:
	CALL _lcd_putchar
; 0000 01DD     }
	SUBI R17,-1
	RJMP _0x4E
_0x4F:
; 0000 01DE }
	RJMP _0x2020003
;
;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;//// REGION CALIBRATING FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;/*
;    PROSEDUR MELAKUKAN KALIBRASI:
;        Panggil kedua fungsi blackCalibrating() dan whiteCalibrating()
;        Panggil fungsi applyCalibratedValue()
;*/
;
;void blackCalibrating()
; 0000 01EB {
; 0000 01EC     unsigned char i;
; 0000 01ED     unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor
; 0000 01EE     unsigned char calibratedBlackMax;  // Nilai hitam maksimal hasil kalibrasi hitam, untuk tiap sensor
; 0000 01EF     unsigned char readADC;  // nilai pembacaan ADC
; 0000 01F0 
; 0000 01F1     // Kalibrasi HItam
; 0000 01F2     for (i=0; i<8; i++) {
;	i -> R17
;	calibratingCount -> R16
;	calibratedBlackMax -> R19
;	readADC -> R18
; 0000 01F3         calibratingCount = CALIBRATING_COUNT;
; 0000 01F4         calibratedBlackMax = 0;     // Atur nilainya menjadi nilai minimal tipedata unsigned byte, karena kita akan mencari nilai maksimum
; 0000 01F5         while (calibratingCount--) {
; 0000 01F6             readADC = read_adc(i);
; 0000 01F7             if (readADC > calibratedBlackMax)
; 0000 01F8                 calibratedBlackMax = readADC;
; 0000 01F9         }
; 0000 01FA         blackMax[i] = eeBlackMax[i] = calibratedBlackMax;  // simpan nilai kalibarasi di ram sekaligus di eeprom
; 0000 01FB     }
; 0000 01FC 
; 0000 01FD }
;
;void whiteCalibrating()
; 0000 0200 {
; 0000 0201     unsigned char i;
; 0000 0202     unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor
; 0000 0203     unsigned char calibratedWhiteMin;  // Nilai hitam minimum hasil kalibrasi putih, untuk tiap sensor
; 0000 0204     unsigned char readADC;  // nilai pembacaan ADC
; 0000 0205 
; 0000 0206     // Kalibrasi HItam
; 0000 0207     for (i=0; i<8; i++) {
;	i -> R17
;	calibratingCount -> R16
;	calibratedWhiteMin -> R19
;	readADC -> R18
; 0000 0208         calibratingCount = CALIBRATING_COUNT;
; 0000 0209         calibratedWhiteMin = 255;     // Atur nilainya menjadi nilai maksimal tipedata unsigned byte, karena kita akan mencari nilai minimum
; 0000 020A         while (calibratingCount--) {
; 0000 020B             readADC = read_adc(i);
; 0000 020C             if (readADC < calibratedWhiteMin)
; 0000 020D                 calibratedWhiteMin = readADC;
; 0000 020E         }
; 0000 020F         whiteMin[i] = eeWhiteMin[i] = calibratedWhiteMin;  // simpan nilai kalibarasi di ram sekaligus di eeprom
; 0000 0210     }
; 0000 0211 }
;
;void applyCalibratedValue()
; 0000 0214 {
_applyCalibratedValue:
; 0000 0215     unsigned char i = 0;
; 0000 0216 
; 0000 0217     for (; i<8; i++) {
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
_0x61:
	CPI  R17,8
	BRSH _0x62
; 0000 0218         middleVal[i] = eeMiddleVal[i] = ((blackMax[i] - whiteMin[i]) / 2);
	CALL SUBOPT_0x0
	MOVW R24,R30
	MOVW R0,R30
	MOVW R26,R30
	SUBI R30,LOW(-_middleVal)
	SBCI R31,HIGH(-_middleVal)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SUBI R30,LOW(-_eeMiddleVal)
	SBCI R31,HIGH(-_eeMiddleVal)
	MOVW R22,R30
	MOVW R30,R0
	SUBI R30,LOW(-_blackMax)
	SBCI R31,HIGH(-_blackMax)
	LD   R26,Z
	LDI  R27,0
	MOVW R30,R24
	SUBI R30,LOW(-_whiteMin)
	SBCI R31,HIGH(-_whiteMin)
	LD   R30,Z
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRB
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0219     }
	SUBI R17,-1
	RJMP _0x61
_0x62:
; 0000 021A }
_0x2020003:
	LD   R17,Y+
	RET
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;//// END OF REGION CALIBRATING FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;void showStartup()
; 0000 0220 {
; 0000 0221     char str[12] = "\4BISMILLAH\5";
; 0000 0222     char str1[17] = "ROBOTIKA UNNES ";
; 0000 0223     unsigned char i = 0;
; 0000 0224 
; 0000 0225     lcd_gotoxy(3,0);
;	str -> Y+18
;	str1 -> Y+1
;	i -> R17
; 0000 0226     for (; i<11; i++) {
; 0000 0227         lcd_putchar(str[i]);
; 0000 0228         delay_ms(100);
; 0000 0229     }
; 0000 022A     lcd_gotoxy(1,1);
; 0000 022B     for (i=0; i<15; i++) {
; 0000 022C         lcd_putchar(str1[i]);
; 0000 022D         delay_ms(100);
; 0000 022E     }
; 0000 022F     delay_ms(2000);
; 0000 0230     lcd_clear();
; 0000 0231 }
;
;void LCDInit()
; 0000 0234 {
_LCDInit:
; 0000 0235     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0236     lcd_clear();
	RCALL _lcd_clear
; 0000 0237     define_char(fullBlock,FULL_BLOCK);
	LDI  R30,LOW(_fullBlock*2)
	LDI  R31,HIGH(_fullBlock*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _define_char
; 0000 0238     define_char(emptyBlock,EMPTY_BLOCK);
	LDI  R30,LOW(_emptyBlock*2)
	LDI  R31,HIGH(_emptyBlock*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _define_char
; 0000 0239     define_char(leftHorn,LEFT_HORN);
	LDI  R30,LOW(_leftHorn*2)
	LDI  R31,HIGH(_leftHorn*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _define_char
; 0000 023A     define_char(rightHorn,RIGHT_HORN);
	LDI  R30,LOW(_rightHorn*2)
	LDI  R31,HIGH(_rightHorn*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _define_char
; 0000 023B     define_char(leftArrow,LEFT_ARROW);
	LDI  R30,LOW(_leftArrow*2)
	LDI  R31,HIGH(_leftArrow*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _define_char
; 0000 023C     define_char(rightArrow,RIGHT_ARROW);
	LDI  R30,LOW(_rightArrow*2)
	LDI  R31,HIGH(_rightArrow*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _define_char
; 0000 023D     lcdOn(1);
	LDI  R26,LOW(1)
	RCALL _lcdOn
; 0000 023E     lcd_clear();
	RCALL _lcd_clear
; 0000 023F }
	RET
;
;unsigned char abs(int val)
; 0000 0242 {
; 0000 0243     return ((val<0)?(-val):(val));
;	val -> Y+0
; 0000 0244 }
;
;void myPID()
; 0000 0247 {
_myPID:
; 0000 0248     int leftpwm,rightpwm;
; 0000 0249     int movement;
; 0000 024A 
; 0000 024B     switch (sensor) {
	CALL __SAVELOCR6
;	leftpwm -> R16,R17
;	rightpwm -> R18,R19
;	movement -> R20,R21
	MOV  R30,R6
	LDI  R31,0
; 0000 024C         case 0b00000001:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x70
; 0000 024D             error = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0xC4
; 0000 024E             break;
; 0000 024F         case 0b00000011:
_0x70:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ _0x72
; 0000 0250         case 0b00000111:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x73
_0x72:
; 0000 0251             error = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0xC4
; 0000 0252             break;
; 0000 0253         case 0b00000010:
_0x73:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x74
; 0000 0254             error = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0xC4
; 0000 0255             break;
; 0000 0256         case 0b00000110:
_0x74:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x76
; 0000 0257         case 0b00001110:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x77
_0x76:
; 0000 0258             error = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0xC4
; 0000 0259             break;
; 0000 025A         case 0b00000100:
_0x77:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x78
; 0000 025B             error = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0xC4
; 0000 025C             break;
; 0000 025D         case 0b00001100:
_0x78:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ _0x7A
; 0000 025E         case 0b00011100:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0x7B
_0x7A:
; 0000 025F             error = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0xC4
; 0000 0260             break;
; 0000 0261         case 0b00001000:
_0x7B:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x7C
; 0000 0262             error = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xC4
; 0000 0263             break;
; 0000 0264         case 0b00011000:
_0x7C:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x7D
; 0000 0265             error = 0;
	CLR  R10
	CLR  R11
; 0000 0266             break;
	RJMP _0x6F
; 0000 0267         case 0b00010000:
_0x7D:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x7E
; 0000 0268             error = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0xC4
; 0000 0269             break;
; 0000 026A         case 0b00110000:
_0x7E:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BREQ _0x80
; 0000 026B         case 0b00111000:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x81
_0x80:
; 0000 026C             error = -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0xC4
; 0000 026D             break;
; 0000 026E         case 0b00100000:
_0x81:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x82
; 0000 026F             error = -3;
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	MOVW R10,R30
; 0000 0270         case 0b01100000:
	RJMP _0x83
_0x82:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x84
_0x83:
; 0000 0271         case 0b01110000:
	RJMP _0x85
_0x84:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x86
_0x85:
; 0000 0272             error = -4;
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	RJMP _0xC4
; 0000 0273             break;
; 0000 0274         case 0b01000000:
_0x86:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x87
; 0000 0275             error = -5;
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	RJMP _0xC4
; 0000 0276             break;
; 0000 0277         case 0b11000000:
_0x87:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BREQ _0x89
; 0000 0278         case 0b11100000:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BRNE _0x8A
_0x89:
; 0000 0279             error = -6;
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	RJMP _0xC4
; 0000 027A             break;
; 0000 027B         case 0b10000000:
_0x8A:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x8B
; 0000 027C             error = -7;
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	RJMP _0xC4
; 0000 027D             break;
; 0000 027E         case 0b00000000:
_0x8B:
	SBIW R30,0
	BRNE _0x6F
; 0000 027F             if (error < 0)
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRGE _0x8D
; 0000 0280                 error = -8;
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	RJMP _0xC4
; 0000 0281             else if (error > 0)
_0x8D:
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRGE _0x8F
; 0000 0282                 error = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
_0xC4:
	MOVW R10,R30
; 0000 0283             break;
_0x8F:
; 0000 0284     }
_0x6F:
; 0000 0285 
; 0000 0286     // hitung nilai unsur proposional
; 0000 0287     propotional = kp * error;
	MOVW R30,R10
	MOVW R26,R8
	CALL __MULW12
	STS  _propotional,R30
	STS  _propotional+1,R31
; 0000 0288     integral += (error);
	MOVW R30,R10
	LDS  R26,_integral
	LDS  R27,_integral+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _integral,R30
	STS  _integral+1,R31
; 0000 0289     integral =   ki* integral;
	LDS  R26,_ki
	LDS  R27,_ki+1
	LDS  R24,_ki+2
	LDS  R25,_ki+3
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	LDI  R26,LOW(_integral)
	LDI  R27,HIGH(_integral)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 028A     derivative = (error - previousError);
	LDS  R26,_previousError
	LDS  R27,_previousError+1
	MOVW R30,R10
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_derivative)
	LDI  R27,HIGH(_derivative)
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
; 0000 028B 
; 0000 028C    // movement = propotional;
; 0000 028D     movement = propotional + integral;// + (kd * derivative);
	LDS  R30,_integral
	LDS  R31,_integral+1
	LDS  R26,_propotional
	LDS  R27,_propotional+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
; 0000 028E     previousError = error;
	__PUTWMRN _previousError,0,10,11
; 0000 028F 
; 0000 0290     if (movement == 0)
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x90
; 0000 0291         leftpwm = rightpwm = maxSpeed;
	RCALL SUBOPT_0x3
	MOVW R18,R30
	MOVW R16,R30
; 0000 0292     else if (movement > 0) {   // Ke kanan
	RJMP _0x91
_0x90:
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRGE _0x92
; 0000 0293         rightpwm = maxSpeed - (movement);//* 15 );//speedStep);
	RCALL SUBOPT_0x3
	SUB  R30,R20
	SBC  R31,R21
	MOVW R18,R30
; 0000 0294         leftpwm = maxSpeed + (movement);// * 15);//speedStep);//- 30;
	RCALL SUBOPT_0x3
	ADD  R30,R20
	ADC  R31,R21
	MOVW R16,R30
; 0000 0295     }
; 0000 0296     else if (movement < 0) {
	RJMP _0x93
_0x92:
	TST  R21
	BRPL _0x94
; 0000 0297         leftpwm = maxSpeed + (movement);// *15);// speedStep);
	RCALL SUBOPT_0x3
	ADD  R30,R20
	ADC  R31,R21
	MOVW R16,R30
; 0000 0298         rightpwm = maxSpeed - (movement);// *15);// speedStep);//- 30;
	RCALL SUBOPT_0x3
	SUB  R30,R20
	SBC  R31,R21
	MOVW R18,R30
; 0000 0299     }
; 0000 029A     if (leftpwm < minSpeed)
_0x94:
_0x93:
_0x91:
	MOV  R30,R4
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x95
; 0000 029B         leftpwm = minSpeed;
	MOV  R16,R4
	CLR  R17
; 0000 029C     if (leftpwm > maxSpeed)
_0x95:
	MOV  R30,R5
	MOVW R26,R16
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x96
; 0000 029D         leftpwm = maxSpeed;
	MOV  R16,R5
	CLR  R17
; 0000 029E     if (rightpwm < minSpeed)
_0x96:
	MOV  R30,R4
	MOVW R26,R18
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x97
; 0000 029F         rightpwm = minSpeed;
	MOV  R18,R4
	CLR  R19
; 0000 02A0     if (rightpwm > maxSpeed)
_0x97:
	MOV  R30,R5
	MOVW R26,R18
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x98
; 0000 02A1         rightpwm = maxSpeed;
	MOV  R18,R5
	CLR  R19
; 0000 02A2 
; 0000 02A3     LEFT_PWM = leftpwm;
_0x98:
	OUT  0x28,R16
; 0000 02A4     RIGHT_PWM = rightpwm;
	OUT  0x2A,R18
; 0000 02A5 
; 0000 02A6     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
; 0000 02A7     lcdPrintByte(rightpwm);
	MOV  R26,R18
	RCALL _lcdPrintByte
; 0000 02A8     lcd_gotoxy(13,0);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x4
; 0000 02A9     lcdPrintByte(leftpwm);
	MOV  R26,R16
	RCALL _lcdPrintByte
; 0000 02AA     lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x4
; 0000 02AB     printBinarySensor();
	RCALL _printBinarySensor
; 0000 02AC 
; 0000 02AD }
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;
;void pid()
; 0000 02B0 {
; 0000 02B1     int errorA =0, errorB=0;
; 0000 02B2     switch(sensor) {
;	errorA -> R16,R17
;	errorB -> R18,R19
; 0000 02B3         case 0b00000000:
; 0000 02B4             if(errorA >=0 && errorA <=5){
; 0000 02B5             }
; 0000 02B6             if(errorB >=0 && errorB <=5){
; 0000 02B7             }
; 0000 02B8             break;
; 0000 02B9             case 0b00000001: errorA = 7;errorB = 0; lcd_putchar('L');break;
; 0000 02BA             case 0b00000011: errorA = 6;errorB = 0; break;
; 0000 02BB             case 0b00000010: errorA = 5;errorB = 0; break;
; 0000 02BC             case 0b00000110: errorA = 4;errorB = 0; break;
; 0000 02BD             case 0b00000100: errorA = 3;errorB = 0;break;
; 0000 02BE             case 0b00001100: errorA = 2;errorB = 0; break;
; 0000 02BF             case 0b00001000: errorA = 1;errorB = 0; break;
; 0000 02C0             case 0b00011000: errorA = 0;errorB =0 ;break;
; 0000 02C1             case 0b00010000: errorA = 0;errorB = 1; break;
; 0000 02C2             case 0b00110000: errorA = 0;errorB = 2; break;
; 0000 02C3             case 0b00100000: errorA = 0;errorB = 3; break;
; 0000 02C4             case 0b01100000: errorA = 0;errorB = 4;break;
; 0000 02C5             case 0b01000000: errorA = 0;errorB = 5; break;
; 0000 02C6             case 0b11000000: errorA = 0;errorB = 6; break;
; 0000 02C7             case 0b10000000: errorA = 0;errorB = 7; break;
; 0000 02C8         }
; 0000 02C9 
; 0000 02CA 
; 0000 02CB 
; 0000 02CC 
; 0000 02CD    if(errorA == 0 && errorB == 0) currentPosition = 0;
; 0000 02CE         if(errorA >= 1 ) currentPosition = errorA;
; 0000 02CF         if(errorB >= 1 ) currentPosition = errorB;
; 0000 02D0 
; 0000 02D1         error = targetPosition - currentPosition;
; 0000 02D2         output = 100 ;//( kp*error );
; 0000 02D3 
; 0000 02D4        /* integral = integral + (error*dt);
; 0000 02D5         derivative = ((error) - (previousError))/dt;
; 0000 02D6         output = (kp*error) + (ki*integral) + (kd*derivative);
; 0000 02D7         previousError = error;*/
; 0000 02D8 
; 0000 02D9 
; 0000 02DA         if (output < 0 ){
; 0000 02DB         lcd_putchar('o');
; 0000 02DC         go();
; 0000 02DD         RIGHT_PWM = LEFT_PWM = 220;}
; 0000 02DE         if (output >0 && (errorA >=1 && errorA <=7)){lcd_putchar('L');go();RIGHT_PWM = 200 - output; LEFT_PWM = 0;}
; 0000 02DF         if (output >0 && (errorB >=1 && errorB <=7)){lcd_putchar('R');go();LEFT_PWM = 10 - output; RIGHT_PWM = 200;}
; 0000 02E0       //     if (output < 1 ){
; 0000 02E1       //  lcd_putchar('o');
; 0000 02E2        // left();
; 0000 02E3       //  RIGHT_PWM =200; LEFT_PWM = 40;}
; 0000 02E4      //   if (output >0 && (errorA >=1 && errorA <=7)){lcd_putchar('L');  left();RIGHT_PWM = maxSpeed - output; LEFT_PWM = maxSpeed;}
; 0000 02E5     //    if (output >0 && (errorB >=1 && errorB <=7)){lcd_putchar('R'); left();LEFT_PWM = maxSpeed - output; RIGHT_PWM = maxSpeed;}
; 0000 02E6      //      if (output > 0 ){
; 0000 02E7      //   lcd_putchar('o');
; 0000 02E8        // right();
; 0000 02E9       //  RIGHT_PWM =40; LEFT_PWM = 180;}
; 0000 02EA       //  if (output >0 && (errorA <=1 && errorA >=7)){lcd_putchar('L');right();RIGHT_PWM = maxSpeed - output; LEFT_PWM = maxSpeed;}
; 0000 02EB       //  if (output >0 && (errorB <=1 && errorB >=7)){lcd_putchar('R');right();LEFT_PWM = maxSpeed - output; RIGHT_PWM = maxSpeed;}
; 0000 02EC 
; 0000 02ED 
; 0000 02EE         //delay_ms(dt);
; 0000 02EF }
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 11
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	RJMP _0x2020001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2020001
_lcd_write_byte:
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020002
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x5
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020001
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.ESEG
_eeMaxSpeed:
	.DB  0xFF
_eeMinSpeed:
	.DB  0x0
_eeKp:
	.DB  0x7D,0x0
_eeKd:
	.DB  0x0,0x0,0x0,0x0
_eeKi:
	.DB  0x9A,0x99,0x99,0x3E
_eeWhiteMin:
	.DB  0x5,0x5,0x5,0x5
	.DB  0x5,0x5,0x5,0x5
_eeBlackMax:
	.DB  0xE6,0xE6,0xE6,0xE6
	.DB  0xE6,0xE6,0xE6,0xE6
_eeMiddleVal:
	.DB  0x78,0x78,0x78,0x78
	.DB  0x78,0x78,0x78,0x78

	.DSEG
_kd:
	.BYTE 0x4
_ki:
	.BYTE 0x4
_propotional:
	.BYTE 0x2
_integral:
	.BYTE 0x2
_derivative:
	.BYTE 0x4
_currentPosition:
	.BYTE 0x2
_targetPosition:
	.BYTE 0x2
_previousError:
	.BYTE 0x2
_output:
	.BYTE 0x2
_whiteMin:
	.BYTE 0x8
_blackMax:
	.BYTE 0x8
_middleVal:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	MOVW R0,R30
	MOVW R26,R20
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	MOV  R30,R5
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
