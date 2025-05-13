; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa espera o usu�rio apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usu�rio pressione a chave USR_SW1, acender� o LED2. Caso o usu�rio pressione 
; a chave USR_SW2, acender� o LED1. Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		
MIN_VALUE	EQU		0
MAX_VALUE	EQU		99
INIT_VALUE 	EQU		0
INIT_STEP 	EQU		1
INIT_DIR 	EQU		1
MAX_STEP    EQU     9
DISPLAY_MS  EQU     1
COUNT_MS    EQU     1000
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
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

; -------------------------------------------------------------------------------
; Fun��o main()

Start  		
	BL  init
MainLoop
	MOV R0, #1
	BL update_time_counts
	BL SysTick_Wait1ms
	
	LDR R1, =DISPLAY_MS			 
	CMP R5, R1					  ;Verifica se precisa atualizar o display
	BLT update_count
	MOV R5, #0
	BL refresh_displays
	BL refresh_LCD
	
update_count
	LDR R1, =COUNT_MS             
	CMP R11, R1 				  ;Verifica se precisa atualizar o contador
	BLT MainLoop
	MOV R1, #1000
	UDIV R0, R11, R1
	MLS R11, R0, R1, R11
	CMP R10, #1                   ;Verifica a dire��o do contador
	BEQ increase
	BNE decrease
	B MainLoop

init
	PUSH {LR}
	BL  PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL  SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL  GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL	LCD_Init
	BL  EnableInterrupts

	LDR R3,  =MIN_VALUE			 ;Inicializa o limite inferior do contador
	LDR R4,  =MAX_VALUE			 ;Inicializa o limite superior do contador
	MOV R5, #0					 ;Inicializa o contador da atualiza��o dos displays 
	MOV R6, #1                   ;Inicializa flag de atualiza��o do passo no LCD
	MOV R7, #1					 ;Inicializa flag de atualiza��o da dire��o no LCD
	LDR	R8,  =INIT_VALUE	     ;Inicializa o contador
	LDR R9,  =INIT_STEP			 ;Inicializa o passo do contador
	LDR R10, =INIT_DIR			 ;Inicializa a dire��o do contador
	MOV R11, #0                   ;Inicializa o contador da atualiza��o da l�gica
	POP {LR}
	BX  LR
	
; Fun��o: map_num
; Entrada: R0 = n�mero de 0 a 9
; Sa�da:  R0 = byte com mapeamento dos segmentos acesos
; Uso:    R1 como registrador tempor�rio
; Preserva: LR

    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
