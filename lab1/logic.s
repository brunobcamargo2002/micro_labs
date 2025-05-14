; logic.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------


; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  increase
        EXPORT  decrease
        EXPORT  update_time_counts 

; -------------------------------------------------------------------------------
; Fun��o respons�vel por incremetar o contador de acordo com o passo

increase
        PUSH    {R2}
        ADD     R8, R9                       ; Adiciona o passo ao contador
        CMP     R8, R4                       ; Verifica se o passo estourou o limite superior
        BLE     end_increase                 ; Se n�o estourou o limite, continua

        ADD     R2, R4, #1                   ; Salva 1+valor_maximo em R4
        SUB     R5, R8, R2                   ; Calcula valor_estourado - (valor_maximo + 1)
        MOV     R8, R3                       ; Move o valor m�nimo do contador em R8
        ADD     R8, R5                       ; Adiciona o deslocamento
		
end_increase
		POP     {R2}
        BX      LR
; -------------------------------------------------------------------------------
; Fun��o respons�vel por decrementar o contador de acordo com o passo

decrease
        PUSH    {R2}
        SUB     R8, R9                       ; Subtrai o passo do contador
        CMP     R8, R3                       ; Verifica se o contador estourou o limite inferior
        BGE     end_decrease                 ; Se n�o estourou o limite, continua

        SUB     R2, R3, #1                   ; Salva MIN_VALUE-1 em R2
        SUB     R5, R8, R2                   ; Calcula valor_estourado - (valor_minimo - 1)
        MOV     R8, R4                       ; Move o valor m�ximo do contador em R8
        ADD     R8, R5                       ; Adiciona o deslocamento (valor negativo)
        
end_decrease
		POP     {R2}
        BX      LR
; -------------------------------------------------------------------------------
; Fun��o respons�vel por incrementar o tempo nos cantadores de refresh do display e do update da l�gica.

update_time_counts
        PUSH    {LR}
        ADD     R5, R0                       ; Incrementa o contador do display
        ADD     R11, R0                      ; Incrementa o contador da l�gica
        POP     {LR}

        BX      LR

; -------------------------------------------------------------------------------

        ALIGN                                ; Garante que o fim da se��o est� alinhado 
        END                                  ; Fim do arquivo
