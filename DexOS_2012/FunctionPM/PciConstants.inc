;=========================================================;
; PciConstants                                 01/04/2011 ;
;---------------------------------------------------------;
; (C) Craig Bamford.                                      ;
;=========================================================;
BIT0            EQU     1               ;
BIT1            EQU     2               ;
BIT2            EQU     4               ;
BIT3            EQU     8               ;
BIT4            EQU     10h             ;
BIT5            EQU     20h             ;
BIT6            EQU     40h             ;
BIT7            EQU     80h             ;
BIT8            EQU     100h            ;
BIT9            EQU     200h            ;
BIT10           EQU     400h            ;
BIT11           EQU     800h            ;
BIT12           EQU     1000h           ;
BIT13           EQU     2000h           ;
BIT14           EQU     4000h           ;
BIT15           EQU     8000h           ;
BIT16           EQU     10000h          ;
BIT17           EQU     20000h          ;
BIT18           EQU     40000h          ;
BIT19           EQU     80000h          ;
BIT20           EQU     100000h         ;
BIT21           EQU     200000h         ;
BIT22           EQU     400000h         ;
BIT23           EQU     800000h         ;
BIT24           EQU     1000000h        ;
BIT25           EQU     2000000h        ;
BIT26           EQU     4000000h        ;
BIT27           EQU     8000000h        ;
BIT28           EQU     10000000h       ;
BIT29           EQU     20000000h       ;
BIT30           EQU     40000000h       ;
BIT31           EQU     80000000h       ;
NABMBAR_REG	EQU	14h		; Native Audio Bus Mastering BAR
NAMBAR_REG	EQU	10h		; Native Audio Mixer BAR
IO_ADDR_MASK	EQU	0FFFEh		; mask off bit 0 for reading BARs
IRQ_REG 	EQU	3ch		; IRQ holder for PCI
INT_REG 	EQU	3dh		; INT pin
PCI_INDEX_PORT	EQU	0CF8h           ;
PCI_DATA_PORT	EQU	0CFCh           ;
PCI32		EQU	BIT31		; bitflag to signal 32bit access
PCI16		EQU	BIT30		; bitflag for 16bit access
