; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
		THUMB
			
		INCLUDE gpio.inc

        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT GPIOPortJ_Handler

GPIOPortJ_Handler
        PUSH    {LR, R2}
        ;MOV     R0, #5                           ; Move 80ms de espera para problema do bounce
        ;BL      wait1ms_addcount

        LDR     R0, =GPIO_REGJ + GPIO_MIS_R     ; Carrega o endereço do MIS
        LDR     R2, [R0]                        ; Carrega o conteúdo do MIS

        LDR     R0, =GPIO_REGJ + GPIO_ICR_R     ; Carrega o endereço do ICR para a porta J
        STR     R2, [R0]                        ; Realiza o ACK

        TST     R2, #1                          ; Verifica se o botão 1 foi ativado
        BEQ     pin2
        ADD     R9, #1                          ; Soma 1 no passo
        CMP     R9, #9                          ; Verifica se o passo passou de 9
        IT      GT
        MOVGT   R9, #1                          ; Se o passo passou de 9 reseta ele para 1
		MOV 	R6, #1							; Seta flag de atualização no LCD

pin2
        TST     R2, #2                          ; Verifica se o botão 2 foi ativado
        BEQ     end_j_handler
        NEG     R10, R10                        ; Altera a direção
		MOV     R7, #1                          ; Seta flag de atualização do LCD

end_j_handler
		POP		{R2}
        POP     {LR}
        BX      LR

        ALIGN                                  ; Garante que o fim da seção está alinhada 
        END                                    ; Fim do arquivo
