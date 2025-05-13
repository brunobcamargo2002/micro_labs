; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
		
		EXPORT increase
		EXPORT decrease
        EXPORT update_time_counts 
			
increase
	PUSH {R2}
	ADD R8, R9                   ;Adiciona o passo ao contador
	CMP R8, R4					 ;Verifica se o passo estourou o limite superior
	BLE end_increase            ;Se não estourou o limite ok
	ADD	R2, R4, #1               ;Salva 1+valor_maximo em R4
	SUB R5, R8, R2				 ;Faz valor_estourado-(valor_maximo+1) que é o deslocamento
	MOV R8, R3                   ;Move o valor mínimo do contador em R8
	ADD R8, R5					 ;Adiciona o deslocamento
	POP {R2}
end_increase
	BX LR
	
decrease
	PUSH {R2}
	SUB R8, R9					 ;Subtrai o passo do contador
	CMP R8, R3					 ;Verifica se o contador estourou o limite inferior
	BGE end_decrease		     ;Se não estourou o limite ok
	SUB R2, R3, #1				 ;Salva MIN_VALUE-1 em R4
	SUB R5, R8, R2   			 ;Faz valor_estourado-(valor_minimo-1) que é o deslocamento
	MOV R8, R4					 ;Move o valor máximo do contador em R8
	ADD R8, R5					 ;Adiciona o deslocamento(valor negativo)
	POP {R2}
end_decrease
	BX LR

update_time_counts
        PUSH    {LR}
        ADD     R5, R0                 ; Incrementa o contador do display
        ADD     R11, R0                ; Incrementa o contador da lógica
        POP     {LR}

        BX      LR

        ALIGN                          ; Garante que o fim da seção está alinhada 
        END                            ; Fim do arquivo
