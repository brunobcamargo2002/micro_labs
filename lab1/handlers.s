; handlers.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; ------------------------------------------------------------------------------
        THUMB                                   ; Instru��es do tipo Thumb-2
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Inclus�o das constantes relacionadas a GPIO

        INCLUDE gpio.inc
; ------------------------------------------------------------------------------
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  GPIOPortJ_Handler
        IMPORT  SysTick_Wait1ms
; ------------------------------------------------------------------------------
; Fun��o que trata a interrup��o gerada pelos bot�es SW1 e/ou SW2
GPIOPortJ_Handler
        PUSH    {LR, R2}
        ;MOV     R0, #30                         ; Move 80ms de espera para problema do bounce
        ;BL      SysTick_Wait1ms
		
		

        LDR     R0, =GPIO_REGJ + GPIO_MIS_R     ; Carrega o endere�o do MIS
        LDR     R2, [R0]                        ; Carrega o conte�do do MIS

        LDR     R0, =GPIO_REGJ + GPIO_ICR_R     ; Carrega o endere�o do ICR para a porta J
        STR     R2, [R0]                        ; Realiza o ACK
		
		LDR 	R0, =GPIO_REGJ + GPIO_DATA_R
		STR		R3, [R0]

        TST     R2, #1                          ; Verifica se o bot�o 1 foi ativado
        BEQ     pin2
		;TST	    R3, #1
		;BNE		pin2
        ADD     R9, #1                          ; Soma 1 no passo
        CMP     R9, #9                          ; Verifica se o passo passou de 9
        IT      GT
        MOVGT   R9, #1                          ; Se o passo passou de 9 reseta ele para 1
        MOV     R6, #1                          ; Seta flag de change do step

pin2
        TST     R2, #2                          ; Verifica se o bot�o 2 foi ativado
        BEQ     end_j_handler
		;TST		R3, #2
		;BNE		end_j_handler
        NEG     R10, R10                        ; Altera a dire��o
        MOV     R7, #1                          ; Seta flag de change da dire��o

end_j_handler
        POP     {R2}
        POP     {LR}
        BX      LR
		
; ------------------------------------------------------------------------------

        ALIGN                                   ; Garante que o fim da se��o est� alinhada 
        END                                     ; Fim do arquivo
