; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		EXPORT refresh_displays
		EXPORT map_num
        IMPORT portA_output
        IMPORT portB_output
        IMPORT portQ_output
		IMPORT SysTick_Wait1ms
		IMPORT update_time_counts

refresh_displays
	PUSH {LR, R2}
	
	MOV R0, #4
	BL update_time_counts
	
	MOV R0, #10	
	UDIV R1, R8, R0			  ;Dezena do número
	MLS R2, R0, R1, R8        ;Unidade do número unidade = num - (10*result_div10)
	
	MOV R0, R1
	BL map_num
	MOV R1, #2_00100000
	BL show_display
	
	MOV R0, R2
	BL map_num
	MOV R1, #2_00010000
	BL show_display
	;Fazer função de mapeamento que recebe como parametro o numero e retorna o map
	;Seta R0(mapeamento) e R1(display ativo)
	;Chama o show_display
	POP{R2}
	POP {LR}
	BX LR

show_display                     ; R0 contém quais segmentos serão ativos e R1 qual é o display alvo
        PUSH    {LR}
        PUSH    {R3, R2, R1}

        AND     R2, R0, #2_00001111     ; Máscara para separar segmentos de R0
        AND     R3, R0, #2_11110000     ; Máscara para separar segmentos de R1

        MOV     R0, R2
        BL      portQ_output            ; Chama função para portQ_output

        MOV     R0, R3
        BL      portA_output            ; Chama função para portA_output

        MOV     R0, R1
        BL      portB_output            ; Chama função para portB_output

        MOV     R0, #1
        BL      SysTick_Wait1ms       ; Chama função para esperar 1ms

        MOV     R0, R1
        BL      portB_output            ; Chama função para portB_output

        MOV     R0, #1
        BL      SysTick_Wait1ms       ; Chama função para esperar 1ms

        POP     {R1, R2, R3}
        POP     {LR}

        BX      LR
		
map_num
    PUSH {LR}

    CMP R0, #0
    BEQ map_0
    CMP R0, #1
    BEQ map_1
    CMP R0, #2
    BEQ map_2
    CMP R0, #3
    BEQ map_3
    CMP R0, #4
    BEQ map_4
    CMP R0, #5
    BEQ map_5
    CMP R0, #6
    BEQ map_6
    CMP R0, #7
    BEQ map_7
    CMP R0, #8
    BEQ map_8
    CMP R0, #9
    BEQ map_9

    ; Número inválido
    MOV R0, #0x00
    B end_map

;map para display de ponta cabeça
map_0
    MOV R0, #2_00111111    ; 0b00111111 (a b c d e f)
    B end_map

map_1
    MOV R0, #2_00110000    ; 0b00000110 (e f)
    B end_map

map_2
    MOV R0, #2_01011011    ; 0b01011011 (a b d e g)
    B end_map

map_3
    MOV R0, #2_01111001    ; 0b01001111 (a d e f g)
    B end_map

map_4
    MOV R0, #2_01110100    ; 0b01100110 (c e f g)
    B end_map

map_5
    MOV R0, #2_01101101    ; 0b01101101 (a c d f g)
    B end_map

map_6
    MOV R0, #2_01101111    ; 0b01111101 (a b c d f g)
    B end_map

map_7
    MOV R0, #2_00111000    ; 0b00000111 (d e f)
    B end_map

map_8
    MOV R0, #2_01111111    ; 0b01111111 (a b c d e f g)
    B end_map

map_9
    MOV R0, #2_01111101    ; 0b01101111 (a b c e f g)

end_map
    POP {LR}
    BX LR

        ALIGN                          ; Garante que o fim da seção está alinhada 
        END                            ; Fim do arquivo
