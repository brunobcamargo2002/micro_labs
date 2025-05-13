; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; ------------------------------------------------------------------------------
        THUMB                                   ; Instru��es do tipo Thumb-2
; ------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
        AREA    DATA, ALIGN=2

; Constantes de configura��o
MIN_VALUE       EQU     0
MAX_VALUE       EQU     99
INIT_VALUE      EQU     0
INIT_STEP       EQU     1
INIT_DIR        EQU     1
MAX_STEP        EQU     9
DISPLAY_MS      EQU     1
COUNT_MS        EQU     1000

; ------------------------------------------------------------------------------
; �rea de C�digo - C�digo armazenado na mem�ria de c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  Start                         ; Permite chamar a fun��o Start de outro arquivo

        ; Fun��es externas utilizadas
        IMPORT  PLL_Init
        IMPORT  SysTick_Init
        IMPORT  GPIO_Init
        IMPORT  LCD_Init
        IMPORT  EnableInterrupts
        IMPORT  refresh_displays
        IMPORT  refresh_LCD
        IMPORT  increase
        IMPORT  decrease
        IMPORT  update_time_counts
        IMPORT  SysTick_Wait1ms

; ------------------------------------------------------------------------------
; Fun��o principal: main()
Start
        BL      init                          ; Inicializa��es

MainLoop
        MOV     R0, #1
        BL      update_time_counts
        BL      SysTick_Wait1ms

        LDR     R1, =DISPLAY_MS               ; Verifica se precisa atualizar o display
        CMP     R5, R1
        BLT     update_count

        MOV     R5, #0
        BL      refresh_displays
        BL      refresh_LCD

update_count
        LDR     R1, =COUNT_MS                 ; Verifica se precisa atualizar o contador
        CMP     R11, R1
        BLT     MainLoop

        MOV     R1, #1000
		SUB 	R11, #1000					  ; Subtrai 1 segundo do contador de tempo

        CMP     R10, #1                       ; Verifica a dire��o do contador
        BEQ     increase
        BNE     decrease

        B       MainLoop

; ------------------------------------------------------------------------------
; Inicializa��o dos perif�ricos e vari�veis
init
        PUSH    {LR}

        BL      PLL_Init                      ; Inicializa clock para 80 MHz
        BL      SysTick_Init                  ; Inicializa SysTick
        BL      GPIO_Init                     ; Inicializa GPIOs
        BL      LCD_Init                      ; Inicializa LCD
        BL      EnableInterrupts              ; Habilita interrup��es

        ; Inicializa��o das vari�veis globais
        LDR     R3, =MIN_VALUE                ; Limite inferior do contador
        LDR     R4, =MAX_VALUE                ; Limite superior do contador
        MOV     R5, #0                        ; Contador de atualiza��o do display
        MOV     R6, #1                        ; Flag: atualiza��o do passo no LCD
        MOV     R7, #1                        ; Flag: atualiza��o da dire��o no LCD
        LDR     R8, =INIT_VALUE               ; Valor inicial do contador
        LDR     R9, =INIT_STEP                ; Passo inicial do contador
        LDR     R10, =INIT_DIR                ; Dire��o inicial do contador
        MOV     R11, #0                       ; Contador de l�gica

        POP     {LR}
        BX      LR


        ALIGN                                   ; Garante alinhamento
        END                                     ; Fim do arquivo
