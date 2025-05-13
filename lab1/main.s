; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED2. Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED1. Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		
MIN_VALUE	EQU		0
MAX_VALUE	EQU		99
INIT_VALUE 	EQU		0
INIT_STEP 	EQU		1
INIT_DIR 	EQU		1
MAX_STEP    EQU     9
DISPLAY_MS  EQU     1
COUNT_MS    EQU     1000
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
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
; Função main()

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
	CMP R10, #1                   ;Verifica a direção do contador
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
	MOV R5, #0					 ;Inicializa o contador da atualização dos displays 
	MOV R6, #1                   ;Inicializa flag de atualização do passo no LCD
	MOV R7, #1					 ;Inicializa flag de atualização da direção no LCD
	LDR	R8,  =INIT_VALUE	     ;Inicializa o contador
	LDR R9,  =INIT_STEP			 ;Inicializa o passo do contador
	LDR R10, =INIT_DIR			 ;Inicializa a direção do contador
	MOV R11, #0                   ;Inicializa o contador da atualização da lógica
	POP {LR}
	BX  LR
	
; Função: map_num
; Entrada: R0 = número de 0 a 9
; Saída:  R0 = byte com mapeamento dos segmentos acesos
; Uso:    R1 como registrador temporário
; Preserva: LR

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
