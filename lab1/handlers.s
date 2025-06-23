; handlers.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; ------------------------------------------------------------------------------
        THUMB                                   ; Instruções do tipo Thumb-2
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Inclusão das constantes relacionadas a GPIO

        INCLUDE gpio.inc
; ------------------------------------------------------------------------------
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  GPIOPortJ_Handler
        IMPORT  SysTick_Wait1ms
; ------------------------------------------------------------------------------
; Função que trata a interrupção gerada pelos botões SW1 e/ou SW2
GPIOPortJ_Handler
        PUSH    {LR, R2}
        ;MOV     R0, #30                         ; Move 80ms de espera para problema do bounce
        ;BL      SysTick_Wait1ms
		
		

        LDR     R0, =GPIO_REGJ + GPIO_MIS_R     ; Carrega o endereço do MIS
        LDR     R2, [R0]                        ; Carrega o conteúdo do MIS

        LDR     R0, =GPIO_REGJ + GPIO_ICR_R     ; Carrega o endereço do ICR para a porta J
        STR     R2, [R0]                        ; Realiza o ACK
		
		LDR 	R0, =GPIO_REGJ + GPIO_DATA_R
		STR		R3, [R0]

        TST     R2, #1                          ; Verifica se o botão 1 foi ativado
        BEQ     pin2
		;TST	    R3, #1
		;BNE		pin2
        ADD     R9, #1                          ; Soma 1 no passo
        CMP     R9, #9                          ; Verifica se o passo passou de 9
        IT      GT
        MOVGT   R9, #1                          ; Se o passo passou de 9 reseta ele para 1
        MOV     R6, #1                          ; Seta flag de change do step

pin2
        TST     R2, #2                          ; Verifica se o botão 2 foi ativado
        BEQ     end_j_handler
		;TST		R3, #2
		;BNE		end_j_handler
        NEG     R10, R10                        ; Altera a direção
        MOV     R7, #1                          ; Seta flag de change da direção

end_j_handler
        POP     {R2}
        POP     {LR}
        BX      LR
		
; ------------------------------------------------------------------------------

        ALIGN                                   ; Garante que o fim da seção está alinhada 
        END                                     ; Fim do arquivo
