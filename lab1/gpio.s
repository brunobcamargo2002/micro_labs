; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
        INCLUDE gpio.inc
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de código
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  GPIO_Init            
        EXPORT  portA_output
        EXPORT  portB_output
        EXPORT  portK_output
        EXPORT  portM_output
        EXPORT  portQ_output
        IMPORT  EnableInterrupts
        IMPORT  DisableInterrupts
        IMPORT  SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Função GPIO_Init
GPIO_Init
; 1. Ativar o clock para as portas
        LDR     R0, =SYSCTL_RCGCGPIO_R
        MOV     R2, #GPIO_PORTA
        ORR     R2, #GPIO_PORTB
        ORR     R2, #GPIO_PORTJ
        ORR     R2, #GPIO_PORTK
        ORR     R2, #GPIO_PORTM
        ORR     R2, #GPIO_PORTQ
        STR     R2, [R0]

        LDR     R0, =SYSCTL_PRGPIO_R
EsperaGPIO
        LDR     R1, [R0]
        CMP     R1, R2
        BNE     EsperaGPIO

; 2. Desabilitar analógica (AMSEL)
        MOV     R1, #0x00
        LDR     R0, =GPIO_REGA + GPIO_AMSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGB + GPIO_AMSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGJ + GPIO_AMSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGK + GPIO_AMSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGM + GPIO_AMSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGQ + GPIO_AMSEL_R
        STR     R1, [R0]

; 3. Configurar modo GPIO (PCTL)
        MOV     R1, #0x00
        LDR     R0, =GPIO_REGA + GPIO_PCTL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGB + GPIO_PCTL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGJ + GPIO_PCTL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGK + GPIO_PCTL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGM + GPIO_PCTL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGQ + GPIO_PCTL_R
        STR     R1, [R0]

; 4. Configurar DIR (direção dos pinos)
        LDR     R0, =GPIO_REGA + GPIO_DIR_R
        MOV     R1, #2_11110000
        STR     R1, [R0]
        LDR     R0, =GPIO_REGB + GPIO_DIR_R
        MOV     R1, #2_00110000
        STR     R1, [R0]
        LDR     R0, =GPIO_REGJ + GPIO_DIR_R
        MOV     R1, #0x00
        STR     R1, [R0]
        LDR     R0, =GPIO_REGK + GPIO_DIR_R
        MOV     R1, #2_11111111
        STR     R1, [R0]
        LDR     R0, =GPIO_REGM + GPIO_DIR_R
        MOV     R1, #2_00000111
        STR     R1, [R0]
        LDR     R0, =GPIO_REGQ + GPIO_DIR_R
        MOV     R1, #2_00001111
        STR     R1, [R0]

; 5. Desabilitar função alternativa (AFSEL)
        MOV     R1, #0x00
        LDR     R0, =GPIO_REGA + GPIO_AFSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGB + GPIO_AFSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGJ + GPIO_AFSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGK + GPIO_AFSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGM + GPIO_AFSEL_R
        STR     R1, [R0]
        LDR     R0, =GPIO_REGQ + GPIO_AFSEL_R
        STR     R1, [R0]

; 6. Habilitar I/O digital (DEN)
        LDR     R0, =GPIO_REGA + GPIO_DEN_R
        LDR     R1, [R0]
        MOV     R2, #2_11110000
        ORR     R1, R2
        STR     R1, [R0]

        LDR     R0, =GPIO_REGB + GPIO_DEN_R
        LDR     R1, [R0]
        MOV     R2, #2_00110000
        ORR     R1, R2
        STR     R1, [R0]

        LDR     R0, =GPIO_REGJ + GPIO_DEN_R
        LDR     R1, [R0]
        MOV     R2, #2_00000011
        ORR     R1, R2
        STR     R1, [R0]

        LDR     R0, =GPIO_REGK + GPIO_DEN_R
        LDR     R1, [R0]
        MOV     R2, #2_11111111
        ORR     R1, R2
        STR     R1, [R0]

        LDR     R0, =GPIO_REGM + GPIO_DEN_R
        LDR     R1, [R0]
        MOV     R2, #2_00000111
        ORR     R1, R2
        STR     R1, [R0]

        LDR     R0, =GPIO_REGQ + GPIO_DEN_R
        LDR     R1, [R0]
        MOV     R2, #2_00001111
        ORR     R1, R2
        STR     R1, [R0]

; 7. Habilitar pull-up interno (PUR)
        LDR     R0, =GPIO_REGJ + GPIO_PUR_R
        MOV     R1, #2_00000011
        STR     R1, [R0]

; Configurações de Interrupção (IM, IS, IBE, IEV, ICR, NVIC)
        LDR     R0, =GPIO_REGJ + GPIO_IM_R
        MOV     R1, #0x00
        STR     R1, [R0]

        LDR     R0, =GPIO_REGJ + GPIO_IS_R
        STR     R1, [R0]

        LDR     R0, =GPIO_REGJ + GPIO_IBE_R
        STR     R1, [R0]

        LDR     R0, =GPIO_REGJ + GPIO_IEV_R
        STR     R1, [R0]

        LDR     R0, =GPIO_REGJ + GPIO_ICR_R
        MOV     R1, #2_11
        STR     R1, [R0]

        LDR     R0, =GPIO_REGJ + GPIO_IM_R
        STR     R1, [R0]

        LDR     R0, =NVIC_PRI12_R
        MOV     R1, #3
        LSL     R1, R1, #29
        STR     R1, [R0]

        LDR     R0, =NVIC_EN1_R
        MOV     R1, #1
        LSL     R1, #19
        STR     R1, [R0]

        BX      LR

; -------------------------------------------------------------------------------
; Funções de saída por porta
portA_output
        PUSH    {R2, R1}
        LDR     R1, =GPIO_REGA + GPIO_DATA_R
        LDR     R2, [R1]
        BIC     R2, #2_11110000
        ORR     R0, R0, R2
        STR     R0, [R1]
        POP     {R1, R2}
        BX      LR

portB_output
        PUSH    {R2, R1}
        LDR     R1, =GPIO_REGB + GPIO_DATA_R
        LDR     R2, [R1]
        BIC     R2, #2_00110000
        ORR     R0, R0, R2
        STR     R0, [R1]
        POP     {R1, R2}
        BX      LR

portK_output
        PUSH    {R2, R1}
        LDR     R1, =GPIO_REGK + GPIO_DATA_R
        LDR     R2, [R1]
        BIC     R2, #2_11111111
        ORR     R0, R0, R2
        STR     R0, [R1]
        POP     {R1, R2}
        BX      LR

portM_output
        PUSH    {R2, R1}
        LDR     R1, =GPIO_REGM + GPIO_DATA_R
        LDR     R2, [R1]
        BIC     R2, #2_00000111
        ORR     R0, R0, R2
        STR     R0, [R1]
        POP     {R1, R2}
        BX      LR

portQ_output
        PUSH    {R2, R1}
        LDR     R1, =GPIO_REGQ + GPIO_DATA_R
        LDR     R2, [R1]
        BIC     R2, #2_00001111
        ORR     R0, R0, R2
        STR     R0, [R1]
        POP     {R1, R2}
        BX      LR
