
; logic.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------

        INCLUDE hd44780.inc

; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de código
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  LCD_Init
        EXPORT  refresh_LCD
        IMPORT  portK_output
        IMPORT  portM_output
        IMPORT  SysTick_Wait1us

; -------------------------------------------------------------------------------
; Função responsável por inicializar o display LCD
LCD_Init
        PUSH    {LR}

        LDR     R0, =LCD_SET8              ; Inicia as 2 linhas
        BL      instruction_delay50u

        LDR     R0, =LCD_CURINC            ; Autoincremento cursor
        BL      instruction_delay50u

        LDR     R0, =LCD_INITCONFIG        ; Configuração inicial
        BL      instruction_delay50u

        LDR     R0, =LCD_CLEAR             ; Clear display
        BL      instruction_delay1650u

        BL      string_init

        POP     {LR}
        BX      LR

; -------------------------------------------------------------------------------
; Função responsável por inicializar a string fixa do LCD
string_init
        PUSH    {LR}

        MOV     R0, #'P'                   ; Imprime "Passo:"
        BL      data_delay50u
        MOV     R0, #'a'
        BL      data_delay50u
        MOV     R0, #'s'
        BL      data_delay50u
        MOV     R0, #'s'
        BL      data_delay50u
        MOV     R0, #'o'
        BL      data_delay50u
        MOV     R0, #':'
        BL      data_delay50u

        POP     {LR}
        BX      LR
; -------------------------------------------------------------------------------
; Função responsável por atualizar o LCD
refresh_LCD
        PUSH    {LR}

        CMP     R6, #1						; Se ocorreu change no passo realiza o update no display
        BNE     dir_test
        MOV     R0, R9
        BL      step_update
        MOV     R6, #0

dir_test
        CMP     R7, #1                      ; Se ocorreu o change na direção realiza o update no display
        BNE     end_refresh_LCD
        MOV     R0, R10
        BL      dir_update
        MOV     R7, #0

end_refresh_LCD
        POP     {LR}
        BX      LR
		
; -------------------------------------------------------------------------------
; Função responsável por atualizar o passo do LCD
step_update
        PUSH    {LR, R1}
        MOV     R1, R0					    

        LDR     R0, =LCD_ROW0 + 7			; Seleciona a posição do digito do passo
        BL      instruction_delay50u        

        MOV     R0, #'0'                    ; Seleciona o caractere ASCII do dígito do passo e realiza o update
        ADD     R0, R1
        BL      data_delay50u

        POP     {R1}
        POP     {LR}
        BX      LR
; -------------------------------------------------------------------------------
; Função responsável por atualizar a string da direção do LCD
dir_update
        PUSH    {LR, R1}
        MOV     R1, R0

        MOV     R0, #1      			    ; Realiza a limpeza da segunda liha do LCD
        BL      row_clear

        LDR     R0, =LCD_ROW1               ; Seleciona a primeira posição da 2 linha do LCD
        BL      instruction_delay50u

        CMP     R1, #1
        BNE     dec

        MOV     R0, #'C'					; Se for crescente insere a string "CRESCENTE" no LCD
        BL      data_delay50u
        MOV     R0, #'r'
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u
        MOV     R0, #'s'
        BL      data_delay50u
        MOV     R0, #'c'
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u
        MOV     R0, #'n'
        BL      data_delay50u
        MOV     R0, #'t'
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u
        B       end_dir_update

dec
        MOV     R0, #'D'					; Se for decrescente insere a string "DECRESCENTE" no LCD
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u
        MOV     R0, #'c'
        BL      data_delay50u
        MOV     R0, #'r'
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u
        MOV     R0, #'s'
        BL      data_delay50u
        MOV     R0, #'c'
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u
        MOV     R0, #'n'
        BL      data_delay50u
        MOV     R0, #'t'
        BL      data_delay50u
        MOV     R0, #'e'
        BL      data_delay50u

end_dir_update
        POP     {R1}
        POP     {LR}
        BX      LR

; -------------------------------------------------------------------------------
; Função responsável por limpar uma linha do LCD

row_clear
        PUSH    {LR, R1}

        CMP     R0, #0
        ITE     EQ
        LDREQ   R0, =LCD_ROW0			    ; Se for 0 seleciona o endereço da primeira linha
        LDRNE   R0, =LCD_ROW1				; Se for diferente de 0 seleciona o endereço da segunda linha
        BL      instruction_delay50u

        MOV     R1, #16

clear_loop									; Itea sobre as 16 posições do display
        MOV     R0, #' '					; Coloca o caractere vazio
        BL      data_delay50u
        SUBS    R1, R1, #1
        BNE     clear_loop

        POP     {R1}
        POP     {LR}
        BX      LR
; -------------------------------------------------------------------------------
; Função responsável por executar comandos que necessitam de um delay de 40u
instruction_delay50u
        PUSH    {LR, R1}
        MOV     R1, #0						; Seleciona instrução
        B       delay50u

data_delay50u
        PUSH    {LR, R1}
        MOV     R1, #1						; Seleciona dado

delay50u
        BL      portK_output

        MOV     R0, R1
        ORR     R0, #2_100					; Enable ativo
        BL      portM_output
        MOV     R0, #10						; Espera de 10u para o LCD ler a instrução
        BL      SysTick_Wait1us

        MOV     R0, R1
        BIC     R0, #2_100					; Enable desativado
        BL      portM_output
        MOV     R0, #40						; Espera de 40u para o LCD processar a instrução
        BL      SysTick_Wait1us

        POP     {R1}
        POP     {LR}
        BX      LR

; -------------------------------------------------------------------------------
; Função responsável por executar comandos que necessitam de um delay de 1,64 ms
instruction_delay1650u
        PUSH    {LR, R1}
        MOV     R1, #0						; Seleciona instrução
        B       delay1650u

data_delay1650u
        PUSH    {LR, R1}					; Seleciona dado
        MOV     R1, #1

delay1650u
        BL      portK_output

        MOV     R0, R1
        ORR     R0, #2_100					; Enable ativo
        BL      portM_output
        MOV     R0, #10						; Espera de 10u para o LCD ler a instrução
        BL      SysTick_Wait1us

        MOV     R0, R1
        BIC     R0, #2_100					; Enable desativado
        BL      portM_output
        MOV     R0, #1640					; Espera de 1,64m para o LCD ler a instrução
        BL      SysTick_Wait1us

        POP     {R1}
        POP     {LR}
        BX      LR
; -------------------------------------------------------------------------------


        ALIGN                                  ; Garante que o fim da seção está alinhada
        END                                    ; Fim do arquivo
