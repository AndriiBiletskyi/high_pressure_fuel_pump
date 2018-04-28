
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _A1=R5
	.DEF _A2=R4
	.DEF _A3=R7
	.DEF _A4=R6
	.DEF _speed_show=R8
	.DEF _en_speed_measure=R11
	.DEF _cycles=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_capt_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_digit_G000:
	.DB  0x81,0xF3,0x49,0x61,0x33,0x25,0x5,0xF1
	.DB  0x1,0x21

_0x49:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x90,0x1

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  _0x49*2

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
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
;#include <delay.h>
;#include <spi.h>
;
;#define PLUS        (PINC.1==0)
;#define MINUS       (PINC.0==0)
;#define START       (PINC.2==0)
;#define CS_ON       PORTB&=~(1<<2);
;#define CS_OFF      PORTB|=(1<<2);
;#define DELAY       400
;#define STEP_CYCLE  10
;#define MAX_CYCLE   990
;#define MIN_CYCLE   0
;
;
;static flash unsigned char digit[]={
;    0b10000001, //0
;    0b11110011, //1
;    0b01001001, //2
;    0b01100001, //3
;    0b00110011, //4
;    0b00100101, //5
;    0b00000101, //6
;    0b11110001, //7
;    0b00000001, //8
;    0b00100001  //9
;};
;char A1=0,A2=0,A3=0,A4=0;
;unsigned long int count = 0;
;unsigned long int speed = 0;
;unsigned int speed_show = 0;
;char en_speed_measure = 0;
;int cycles = 400;
;int left = 0;
;
;void init(void);//Initialization of the entire periphery
;interrupt [TIM0_OVF] void timer0_ovf_isr(void);//counting time
;interrupt [TIM1_CAPT] void timer1_capt_isr(void);//counting speed
;void sem_seg(int a);//definition of the value of segments
;void buttons(void);//processing of buttons strokes
;void send_hc595(char anods, char led_1, char led_2);//data transfer
;void set_speed(void);//setting the speed
;void set_timer(char mode);//setting timer's mode
;
;void main(void)
; 0000 0037 {

	.CSEG
_main:
; 0000 0038     char led_anods  = 0b11111111;
; 0000 0039     char led_first  = 0b11111111;
; 0000 003A     char led_second = 0b11111111;
; 0000 003B     char first_indikator    = 1;
; 0000 003C     char second_indikator   = 5;
; 0000 003D 
; 0000 003E     init();
;	led_anods -> R17
;	led_first -> R16
;	led_second -> R19
;	first_indikator -> R18
;	second_indikator -> R21
	LDI  R17,255
	LDI  R16,255
	LDI  R19,255
	LDI  R18,1
	LDI  R21,5
	RCALL _init
; 0000 003F 
; 0000 0040 while (1)
_0x3:
; 0000 0041       {
; 0000 0042         led_anods = 0b11111111;
	LDI  R17,LOW(255)
; 0000 0043 
; 0000 0044         first_indikator++;
	SUBI R18,-1
; 0000 0045 
; 0000 0046         if(speed_show<10){
	RCALL SUBOPT_0x0
	BRSH _0x6
; 0000 0047             if(first_indikator>4)
	CPI  R18,5
	BRLO _0x7
; 0000 0048                 first_indikator = 4;
	LDI  R18,LOW(4)
; 0000 0049         }
_0x7:
; 0000 004A 
; 0000 004B         if((speed_show>=10) && (speed_show<100)){
_0x6:
	RCALL SUBOPT_0x0
	BRLO _0x9
	RCALL SUBOPT_0x1
	BRLO _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 004C             if(first_indikator>4)
	CPI  R18,5
	BRLO _0xB
; 0000 004D                 first_indikator = 3;
	LDI  R18,LOW(3)
; 0000 004E         }
_0xB:
; 0000 004F 
; 0000 0050         if((speed_show>=100) && (speed_show<1000)){
_0x8:
	RCALL SUBOPT_0x1
	BRLO _0xD
	RCALL SUBOPT_0x2
	BRLO _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 0051             if(first_indikator>4)
	CPI  R18,5
	BRLO _0xF
; 0000 0052                 first_indikator = 2;
	LDI  R18,LOW(2)
; 0000 0053         }
_0xF:
; 0000 0054 
; 0000 0055         if(speed_show>=1000){
_0xC:
	RCALL SUBOPT_0x2
	BRLO _0x10
; 0000 0056             if(first_indikator>4)
	CPI  R18,5
	BRLO _0x11
; 0000 0057                 first_indikator = 1;
	LDI  R18,LOW(1)
; 0000 0058         }
_0x11:
; 0000 0059 
; 0000 005A         second_indikator++;
_0x10:
	SUBI R21,-1
; 0000 005B 
; 0000 005C         if(second_indikator>7)
	CPI  R21,8
	BRLO _0x12
; 0000 005D             second_indikator = 5;
	LDI  R21,LOW(5)
; 0000 005E 
; 0000 005F         led_anods&=~(1<<first_indikator);
_0x12:
	MOV  R30,R18
	RCALL SUBOPT_0x3
; 0000 0060         led_anods&=~(1<<second_indikator);
	MOV  R30,R21
	RCALL SUBOPT_0x3
; 0000 0061 
; 0000 0062         sem_seg(left);
	RCALL SUBOPT_0x4
	RCALL _sem_seg
; 0000 0063 
; 0000 0064         if(second_indikator==5)
	CPI  R21,5
	BRNE _0x13
; 0000 0065             led_second = digit[A3];
	RCALL SUBOPT_0x5
	LPM  R19,Z
; 0000 0066 
; 0000 0067         if(second_indikator==6)
_0x13:
	CPI  R21,6
	BRNE _0x14
; 0000 0068             led_second = digit[A2];
	RCALL SUBOPT_0x6
	LPM  R19,Z
; 0000 0069 
; 0000 006A         if(second_indikator==7)
_0x14:
	CPI  R21,7
	BRNE _0x15
; 0000 006B             led_second = digit[A1];
	RCALL SUBOPT_0x7
	LPM  R19,Z
; 0000 006C 
; 0000 006D         sem_seg(speed_show);
_0x15:
	MOVW R26,R8
	RCALL _sem_seg
; 0000 006E 
; 0000 006F         if(first_indikator==1)
	CPI  R18,1
	BRNE _0x16
; 0000 0070             led_first = digit[A4];
	MOV  R30,R6
	RCALL SUBOPT_0x8
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	LPM  R16,Z
; 0000 0071 
; 0000 0072         if(first_indikator==2)
_0x16:
	CPI  R18,2
	BRNE _0x17
; 0000 0073             led_first = digit[A3];
	RCALL SUBOPT_0x5
	LPM  R16,Z
; 0000 0074 
; 0000 0075         if(first_indikator==3)
_0x17:
	CPI  R18,3
	BRNE _0x18
; 0000 0076             led_first = digit[A2];
	RCALL SUBOPT_0x6
	LPM  R16,Z
; 0000 0077 
; 0000 0078         if(first_indikator==4)
_0x18:
	CPI  R18,4
	BRNE _0x19
; 0000 0079             led_first = digit[A1];
	RCALL SUBOPT_0x7
	LPM  R16,Z
; 0000 007A 
; 0000 007B         send_hc595(led_anods,led_first,led_second);
_0x19:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _send_hc595
; 0000 007C 
; 0000 007D         buttons();
	RCALL _buttons
; 0000 007E         set_speed();
	RCALL _set_speed
; 0000 007F 
; 0000 0080       }
	RJMP _0x3
; 0000 0081 }
_0x1A:
	RJMP _0x1A
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0086 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0087    count++;
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
; 0000 0088 
; 0000 0089    if(count>98){
	LDS  R26,_count
	LDS  R27,_count+1
	LDS  R24,_count+2
	LDS  R25,_count+3
	__CPD2N 0x63
	BRLO _0x1B
; 0000 008A         count = 0;
	RCALL SUBOPT_0x9
; 0000 008B         speed = 0;
	LDI  R30,LOW(0)
	STS  _speed,R30
	STS  _speed+1,R30
	STS  _speed+2,R30
	STS  _speed+3,R30
; 0000 008C         en_speed_measure = 0;
	CLR  R11
; 0000 008D    }
; 0000 008E }
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;interrupt [TIM1_CAPT] void timer1_capt_isr(void)
; 0000 0093 {
_timer1_capt_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0094     if(en_speed_measure){
	TST  R11
	BREQ _0x1C
; 0000 0095         speed = 250000/(count*256 + TCNT0);
	LDS  R30,_count
	LDS  R31,_count+1
	LDS  R22,_count+2
	LDS  R23,_count+3
	__GETD2N 0x100
	RCALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	IN   R30,0x32
	RCALL SUBOPT_0x8
	RCALL __CWD1
	RCALL __ADDD12
	__GETD2N 0x3D090
	RCALL __DIVD21U
	STS  _speed,R30
	STS  _speed+1,R31
	STS  _speed+2,R22
	STS  _speed+3,R23
; 0000 0096         TCNT0 = 1;
	LDI  R30,LOW(1)
	OUT  0x32,R30
; 0000 0097         count = 0;
	RCALL SUBOPT_0x9
; 0000 0098     }
; 0000 0099     en_speed_measure = 1;
_0x1C:
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 009A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;void sem_seg(int a)
; 0000 009F {
_sem_seg:
; 0000 00A0     A1=a%10;
	ST   -Y,R27
	ST   -Y,R26
;	a -> Y+0
	RCALL SUBOPT_0xA
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R5,R30
; 0000 00A1     A2=(a%100)/10;
	RCALL SUBOPT_0xA
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R4,R30
; 0000 00A2     A3=(a%1000)/100;
	RCALL SUBOPT_0xA
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R7,R30
; 0000 00A3     A4=(a%10000)/1000;
	RCALL SUBOPT_0xA
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21
	MOV  R6,R30
; 0000 00A4 }
	ADIW R28,2
	RET
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;void buttons(void)
; 0000 00A9 {
_buttons:
; 0000 00AA     static char is_but_pres = 0;
; 0000 00AB     static char is_stop = 0;
; 0000 00AC     static unsigned int pause = 0;
; 0000 00AD     static unsigned int pause_start = 0;
; 0000 00AE     static unsigned int pause_stop = 0;
; 0000 00AF     static char is_start_pres = 0;
; 0000 00B0     static char rele = 0;
; 0000 00B1 
; 0000 00B2     if(PLUS){
	SBIC 0x13,1
	RJMP _0x1D
; 0000 00B3         if(!is_but_pres){
	RCALL SUBOPT_0xB
	BRNE _0x1E
; 0000 00B4             cycles += STEP_CYCLE;
	MOVW R30,R12
	ADIW R30,10
	MOVW R12,R30
; 0000 00B5 
; 0000 00B6             if(cycles>MAX_CYCLE)
	LDI  R30,LOW(990)
	LDI  R31,HIGH(990)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x1F
; 0000 00B7                 cycles = MIN_CYCLE;
	CLR  R12
	CLR  R13
; 0000 00B8 
; 0000 00B9             is_but_pres = 1;
_0x1F:
	LDI  R30,LOW(1)
	STS  _is_but_pres_S0000004000,R30
; 0000 00BA         }
; 0000 00BB     }
_0x1E:
; 0000 00BC 
; 0000 00BD     if(MINUS){
_0x1D:
	SBIC 0x13,0
	RJMP _0x20
; 0000 00BE         if(!is_but_pres){
	RCALL SUBOPT_0xB
	BRNE _0x21
; 0000 00BF             cycles -= STEP_CYCLE;
	MOVW R30,R12
	SBIW R30,10
	MOVW R12,R30
; 0000 00C0 
; 0000 00C1             if(cycles<MIN_CYCLE)
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRGE _0x22
; 0000 00C2                 cycles = MAX_CYCLE;
	LDI  R30,LOW(990)
	LDI  R31,HIGH(990)
	MOVW R12,R30
; 0000 00C3 
; 0000 00C4             is_but_pres = 1;
_0x22:
	LDI  R30,LOW(1)
	STS  _is_but_pres_S0000004000,R30
; 0000 00C5         }
; 0000 00C6     }
_0x21:
; 0000 00C7 
; 0000 00C8     if(is_but_pres){
_0x20:
	RCALL SUBOPT_0xB
	BREQ _0x23
; 0000 00C9         pause++;
	LDI  R26,LOW(_pause_S0000004000)
	LDI  R27,HIGH(_pause_S0000004000)
	RCALL SUBOPT_0xC
; 0000 00CA         if(pause>DELAY){
	LDS  R26,_pause_S0000004000
	LDS  R27,_pause_S0000004000+1
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLO _0x24
; 0000 00CB             is_but_pres = 0;
	LDI  R30,LOW(0)
	STS  _is_but_pres_S0000004000,R30
; 0000 00CC             pause = 0;
	STS  _pause_S0000004000,R30
	STS  _pause_S0000004000+1,R30
; 0000 00CD         }
; 0000 00CE     }
_0x24:
; 0000 00CF 
; 0000 00D0     if(START)
_0x23:
	SBIC 0x13,2
	RJMP _0x25
; 0000 00D1         is_start_pres = 1;
	LDI  R30,LOW(1)
	STS  _is_start_pres_S0000004000,R30
; 0000 00D2 
; 0000 00D3     if(is_start_pres && !is_stop){
_0x25:
	LDS  R30,_is_start_pres_S0000004000
	CPI  R30,0
	BREQ _0x27
	LDS  R30,_is_stop_S0000004000
	CPI  R30,0
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
; 0000 00D4         pause_start++;
	LDI  R26,LOW(_pause_start_S0000004000)
	LDI  R27,HIGH(_pause_start_S0000004000)
	RCALL SUBOPT_0xC
; 0000 00D5         if(pause_start>4*DELAY){
	LDS  R26,_pause_start_S0000004000
	LDS  R27,_pause_start_S0000004000+1
	CPI  R26,LOW(0x641)
	LDI  R30,HIGH(0x641)
	CPC  R27,R30
	BRLO _0x29
; 0000 00D6             if(START){
	SBIC 0x13,2
	RJMP _0x2A
; 0000 00D7                 is_stop = 1;
	LDI  R30,LOW(1)
	STS  _is_stop_S0000004000,R30
; 0000 00D8             }else{
	RJMP _0x2B
_0x2A:
; 0000 00D9                 is_start_pres = 0;
	RCALL SUBOPT_0xD
; 0000 00DA                 pause_start = 0;
; 0000 00DB                 if(rele){
	RCALL SUBOPT_0xE
	BREQ _0x2C
; 0000 00DC                     rele = 0;
	LDI  R30,LOW(0)
	RJMP _0x47
; 0000 00DD                 }else {
_0x2C:
; 0000 00DE                     rele = 1;
	LDI  R30,LOW(1)
_0x47:
	STS  _rele_S0000004000,R30
; 0000 00DF                 }
; 0000 00E0 
; 0000 00E1                 if(rele){
	RCALL SUBOPT_0xE
	BREQ _0x2E
; 0000 00E2                     set_timer(3);
	LDI  R26,LOW(3)
	RJMP _0x48
; 0000 00E3                 }else {
_0x2E:
; 0000 00E4                     set_timer(2);
	LDI  R26,LOW(2)
_0x48:
	RCALL _set_timer
; 0000 00E5                 }
; 0000 00E6             }
_0x2B:
; 0000 00E7         }
; 0000 00E8 
; 0000 00E9     }
_0x29:
; 0000 00EA 
; 0000 00EB     if(is_stop){
_0x26:
	LDS  R30,_is_stop_S0000004000
	CPI  R30,0
	BREQ _0x30
; 0000 00EC         pause_stop++;
	LDI  R26,LOW(_pause_stop_S0000004000)
	LDI  R27,HIGH(_pause_stop_S0000004000)
	RCALL SUBOPT_0xC
; 0000 00ED         rele = 0;
	RCALL SUBOPT_0xF
; 0000 00EE         set_timer(1);
; 0000 00EF         if(pause_stop>5*DELAY){
	LDS  R26,_pause_stop_S0000004000
	LDS  R27,_pause_stop_S0000004000+1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x31
; 0000 00F0             is_start_pres = 0;
	RCALL SUBOPT_0xD
; 0000 00F1             pause_start = 0;
; 0000 00F2             is_stop = 0;
	LDI  R30,LOW(0)
	STS  _is_stop_S0000004000,R30
; 0000 00F3             pause_stop=0;
	STS  _pause_stop_S0000004000,R30
	STS  _pause_stop_S0000004000+1,R30
; 0000 00F4         }
; 0000 00F5     }
_0x31:
; 0000 00F6 
; 0000 00F7     left = cycles - TCNT1/60;
_0x30:
	IN   R30,0x2C
	IN   R31,0x2C+1
	MOVW R26,R30
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RCALL __DIVW21U
	MOVW R26,R30
	MOVW R30,R12
	SUB  R30,R26
	SBC  R31,R27
	STS  _left,R30
	STS  _left+1,R31
; 0000 00F8 
; 0000 00F9     if(left<1){
	RCALL SUBOPT_0x4
	SBIW R26,1
	BRGE _0x32
; 0000 00FA         left = 0;
	LDI  R30,LOW(0)
	STS  _left,R30
	STS  _left+1,R30
; 0000 00FB         rele = 0;
	RCALL SUBOPT_0xF
; 0000 00FC         set_timer(1);
; 0000 00FD     }
; 0000 00FE 
; 0000 00FF     if(rele){
_0x32:
	RCALL SUBOPT_0xE
	BREQ _0x33
; 0000 0100         PORTD|=(1<<7);
	SBI  0x12,7
; 0000 0101     }else {
	RJMP _0x34
_0x33:
; 0000 0102         PORTD&=~(1<<7);
	CBI  0x12,7
; 0000 0103     }
_0x34:
; 0000 0104 }
	RET
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;void set_timer(char mode)
; 0000 0109 {
_set_timer:
; 0000 010A     /*
; 0000 010B         MODES:
; 0000 010C         0 - disable, reset counter
; 0000 010D         1 - enable interrupt from each puls, disable counting pulses, reset counter
; 0000 010E         2 - enable interrupt from each puls, disable counting pulses
; 0000 010F         3 - enable interrupt from each puls, enable counting pulses
; 0000 0110     */
; 0000 0111     switch(mode)
	ST   -Y,R26
;	mode -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x8
; 0000 0112     {
; 0000 0113         case 0: TCCR1B = 0x00;
	SBIW R30,0
	BRNE _0x38
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x10
; 0000 0114                 TCNT1H = 0x00;
; 0000 0115                 TCNT1L = 0x00;
; 0000 0116             break;
	RJMP _0x37
; 0000 0117 
; 0000 0118         case 1: TCCR1B = 0x40;
_0x38:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x39
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x10
; 0000 0119                 TCNT1H = 0x00;
; 0000 011A                 TCNT1L = 0x00;
; 0000 011B             break;
	RJMP _0x37
; 0000 011C 
; 0000 011D         case 2: TCCR1B = 0x40;
_0x39:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3A
	LDI  R30,LOW(64)
	OUT  0x2E,R30
; 0000 011E             break;
	RJMP _0x37
; 0000 011F 
; 0000 0120         case 3: TCCR1B = 0x47;
_0x3A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C
	LDI  R30,LOW(71)
	OUT  0x2E,R30
; 0000 0121             break;
; 0000 0122 
; 0000 0123         default:
_0x3C:
; 0000 0124     }
_0x37:
; 0000 0125 }
	ADIW R28,1
	RET
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;void set_speed(void)
; 0000 012A {
_set_speed:
; 0000 012B     static unsigned int pause = 0;
; 0000 012C 
; 0000 012D     if(pause>2*DELAY){
	LDS  R26,_pause_S0000006000
	LDS  R27,_pause_S0000006000+1
	CPI  R26,LOW(0x321)
	LDI  R30,HIGH(0x321)
	CPC  R27,R30
	BRLO _0x3D
; 0000 012E         speed_show = speed;
	__GETWRMN 8,9,0,_speed
; 0000 012F         pause = 0;
	LDI  R30,LOW(0)
	STS  _pause_S0000006000,R30
	STS  _pause_S0000006000+1,R30
; 0000 0130     }
; 0000 0131     pause++;
_0x3D:
	LDI  R26,LOW(_pause_S0000006000)
	LDI  R27,HIGH(_pause_S0000006000)
	RCALL SUBOPT_0xC
; 0000 0132 }
	RET
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;void send_hc595(char anods, char led_1, char led_2)
; 0000 0137 {
_send_hc595:
; 0000 0138     CS_ON
	ST   -Y,R26
;	anods -> Y+2
;	led_1 -> Y+1
;	led_2 -> Y+0
	CBI  0x18,2
; 0000 0139     SPDR = anods;
	LDD  R30,Y+2
	OUT  0xF,R30
; 0000 013A     while(!(SPSR & (1<<SPIF))){}
_0x3E:
	SBIS 0xE,7
	RJMP _0x3E
; 0000 013B     SPDR = led_2;
	LD   R30,Y
	OUT  0xF,R30
; 0000 013C     while(!(SPSR & (1<<SPIF))){}
_0x41:
	SBIS 0xE,7
	RJMP _0x41
; 0000 013D     SPDR = led_1;
	LDD  R30,Y+1
	OUT  0xF,R30
; 0000 013E     while(!(SPSR & (1<<SPIF))){}
_0x44:
	SBIS 0xE,7
	RJMP _0x44
; 0000 013F     CS_OFF
	SBI  0x18,2
; 0000 0140 }
	ADIW R28,3
	RET
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
;void init(void)
; 0000 0145 {
_init:
; 0000 0146  // Input/Output Ports initialization
; 0000 0147 // Port B initialization
; 0000 0148 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 0149 // State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T
; 0000 014A PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 014B DDRB=0b00101110;
	LDI  R30,LOW(46)
	OUT  0x17,R30
; 0000 014C 
; 0000 014D // Port C initialization
; 0000 014E // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014F // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0150 PORTC=0b0011111;
	LDI  R30,LOW(31)
	OUT  0x15,R30
; 0000 0151 DDRC=0b0000000;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0152 
; 0000 0153 // Port D initialization
; 0000 0154 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0155 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0156 PORTD=0b00100000;
	LDI  R30,LOW(32)
	OUT  0x12,R30
; 0000 0157 DDRD=0b10000000;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 0158 
; 0000 0159 // Timer/Counter 0 initialization
; 0000 015A // Clock source: System Clock
; 0000 015B // Clock value: 250,000 kHz
; 0000 015C TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 015D TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 015E 
; 0000 015F // Timer/Counter 1 initialization
; 0000 0160 // Clock source: System Clock
; 0000 0161 // Clock value: Timer1 Stopped
; 0000 0162 // Mode: Normal top=0xFFFF
; 0000 0163 // OC1A output: Discon.
; 0000 0164 // OC1B output: Discon.
; 0000 0165 // Noise Canceler: Off
; 0000 0166 // Input Capture on Rising Edge
; 0000 0167 // Timer1 Overflow Interrupt: Off
; 0000 0168 // Input Capture Interrupt: On
; 0000 0169 // Compare A Match Interrupt: Off
; 0000 016A // Compare B Match Interrupt: Off
; 0000 016B TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 016C TCCR1B=0x40;  //TCCR1B=0x40; impuls prerblvanie,  TCCR1B=0x47; s4et i prerblvanie
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x10
; 0000 016D TCNT1H=0x00;
; 0000 016E TCNT1L=0x00;
; 0000 016F ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0170 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0171 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0172 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0173 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0174 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0175 
; 0000 0176 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0177 TIMSK=0x21;
	LDI  R30,LOW(33)
	OUT  0x39,R30
; 0000 0178 
; 0000 0179 // Analog Comparator initialization
; 0000 017A // Analog Comparator: Off
; 0000 017B // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 017C ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 017D SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 017E 
; 0000 017F // SPI initialization
; 0000 0180 // SPI Type: Master
; 0000 0181 // SPI Clock Rate: 125,000 kHz
; 0000 0182 // SPI Clock Phase: Cycle Start
; 0000 0183 // SPI Clock Polarity: High
; 0000 0184 // SPI Data Order: MSB First
; 0000 0185 SPCR=0x53;//5b
	LDI  R30,LOW(83)
	OUT  0xD,R30
; 0000 0186 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0187 
; 0000 0188 #asm("sei")
	sei
; 0000 0189 }
	RET
;//-----------------------------------------------------------
;//
;//-----------------------------------------------------------
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

	.CSEG

	.DSEG
_count:
	.BYTE 0x4
_speed:
	.BYTE 0x4
_left:
	.BYTE 0x2
_is_but_pres_S0000004000:
	.BYTE 0x1
_is_stop_S0000004000:
	.BYTE 0x1
_pause_S0000004000:
	.BYTE 0x2
_pause_start_S0000004000:
	.BYTE 0x2
_pause_stop_S0000004000:
	.BYTE 0x2
_is_start_pres_S0000004000:
	.BYTE 0x1
_rele_S0000004000:
	.BYTE 0x1
_pause_S0000006000:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	AND  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R26,_left
	LDS  R27,_left+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _count,R30
	STS  _count+1,R30
	STS  _count+2,R30
	STS  _count+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDS  R30,_is_but_pres_S0000004000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  _is_start_pres_S0000004000,R30
	STS  _pause_start_S0000004000,R30
	STS  _pause_start_S0000004000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDS  R30,_rele_S0000004000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _rele_S0000004000,R30
	LDI  R26,LOW(1)
	RJMP _set_timer

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET


	.CSEG
__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
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

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

;END OF CODE MARKER
__END_OF_CODE:
