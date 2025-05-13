; Declarações EQU - Defines
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R    EQU    0x400FE608
SYSCTL_PRGPIO_R      EQU    0x400FEA08

; ========================
; NVIC
NVIC_EN1_R           EQU    0xE000E104
NVIC_PRI12_R         EQU    0xE000E430        
; ========================
; Definições dos Ports

; Prefixo das portas
GPIO_REGA            EQU    0x40058000
GPIO_REGB            EQU    0x40059000
GPIO_REGC            EQU    0x4005A000
GPIO_REGD            EQU    0x4005B000
GPIO_REGE            EQU    0x4005C000
GPIO_REGF            EQU    0x4005D000
GPIO_REGG            EQU    0x4005E000
GPIO_REGH            EQU    0x4005F000
GPIO_REGJ            EQU    0x40060000
GPIO_REGK            EQU    0x40061000
GPIO_REGL            EQU    0x40062000    
GPIO_REGM            EQU    0x40063000
GPIO_REGN            EQU    0x40064000
GPIO_REGP            EQU    0x40065000
GPIO_REGQ            EQU    0x40066000

; Sufixos das portas
GPIO_DATA_R          EQU    0x3FC
GPIO_DIR_R           EQU    0x400
GPIO_IS_R            EQU    0x404
GPIO_IBE_R           EQU    0x408
GPIO_IEV_R           EQU    0x40C
GPIO_IM_R            EQU    0x410
GPIO_RIS_R           EQU    0x414
GPIO_MIS_R           EQU    0x418
GPIO_ICR_R           EQU    0x41C
GPIO_AFSEL_R         EQU    0x420
GPIO_DR2R_R          EQU    0x500
GPIO_DR4R_R          EQU    0x504
GPIO_DR8R_R          EQU    0x508
GPIO_ODR_R           EQU    0x50C
GPIO_PUR_R           EQU    0x510
GPIO_PDR_R           EQU    0x514
GPIO_SLR_R           EQU    0x518
GPIO_DEN_R           EQU    0x51C
GPIO_LOCK_R          EQU    0x520
GPIO_CR_R            EQU    0x524
GPIO_AMSEL_R         EQU    0x528
GPIO_PCTL_R          EQU    0x52C
GPIO_ADCCTL_R        EQU    0x530
GPIO_DMACTL_R        EQU    0x534
GPIO_SI_R            EQU    0x538
GPIO_DR12R_R         EQU    0x53C
GPIO_WAKEPEN_        EQU    0x540
GPIO_WAKELVLR        EQU    0x544
GPIO_WAKESTT_R       EQU    0x548
GPIO_PP_R            EQU    0xFC0
GPIO_PC_R            EQU    0xFC4

; Posicao Teste das Portas
GPIO_PORTA           EQU    2_000000000000001
GPIO_PORTB           EQU    2_000000000000010
GPIO_PORTC           EQU    2_000000000000100
GPIO_PORTD           EQU    2_000000000001000
GPIO_PORTE           EQU    2_000000000010000
GPIO_PORTF           EQU    2_000000000100000
GPIO_PORTG           EQU    2_000000001000000
GPIO_PORTH           EQU    2_000000010000000
GPIO_PORTJ           EQU    2_000000100000000
GPIO_PORTK           EQU    2_000001000000000
GPIO_PORTL           EQU    2_000010000000000
GPIO_PORTM           EQU    2_000100000000000
GPIO_PORTN           EQU    2_001000000000000
GPIO_PORTP           EQU    2_010000000000000
GPIO_PORTQ           EQU    2_100000000000000
