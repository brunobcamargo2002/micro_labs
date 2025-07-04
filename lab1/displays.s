; displays.s
; Desenvolvido para a placa EK-TM4C1294XL
; 13/05/2025

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------

; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT  refresh_displays
        EXPORT  map_num
        IMPORT  portA_output
        IMPORT  portB_output
        IMPORT  portQ_output
        IMPORT  SysTick_Wait1ms
        IMPORT  update_time_counts

; -------------------------------------------------------------------------------
; Fun��o respons�vel por atualizar os 2 displays
refresh_displays
        PUSH    {LR, R2}

        MOV     R0, #4						; Adiciona delay do refresh nos contadores
        BL      update_time_counts

        MOV     R0, #10
        UDIV    R1, R8, R0                  ; Dezena do n�mero
        MLS     R2, R0, R1, R8              ; Unidade = num - (10 * (num / 10))

        MOV     R0, R1						; Imprime a dezena
        BL      map_num
        MOV     R1, #2_00100000
        BL      show_display

        MOV     R0, R2						; Imprime a unidade
        BL      map_num
        MOV     R1, #2_00010000
        BL      show_display

        POP     {R2}
        POP     {LR}
        BX      LR

; -------------------------------------------------------------------------------
; Fun��o respons�vel por atualizar o display

show_display                                 ; R0: segmentos | R1: display ativo
        PUSH    {LR}
        PUSH    {R3, R2, R1}

        AND     R2, R0, #2_00001111          ; M�scara para separar segmentos
        AND     R3, R0, #2_11110000          ; M�scara para separar outros segmentos

        MOV     R0, R2						 ; Define as sa�das na porta Q
        BL      portQ_output

        MOV     R0, R3 						 ; Define as sa�das na porta A
        BL      portA_output

        MOV     R0, R1						 ; Ativa o transitor da dezena ou unidade
        BL      portB_output

        MOV     R0, #1						 ; Espera 1 ms
        BL      SysTick_Wait1ms

        MOV     R0, #0						 ; Desativa o transistor da dezena ou unidade
        BL      portB_output

        MOV     R0, #1						 ; Espera 1 ms
        BL      SysTick_Wait1ms

        POP     {R1, R2, R3}
        POP     {LR}
        BX      LR

; -------------------------------------------------------------------------------
; Fun��o respons�vel por mapear os digitos

map_num
        PUSH    {LR}

        CMP     R0, #0
        BEQ     map_0
        CMP     R0, #1
        BEQ     map_1
        CMP     R0, #2
        BEQ     map_2
        CMP     R0, #3
        BEQ     map_3
        CMP     R0, #4
        BEQ     map_4
        CMP     R0, #5
        BEQ     map_5
        CMP     R0, #6
        BEQ     map_6
        CMP     R0, #7
        BEQ     map_7
        CMP     R0, #8
        BEQ     map_8
        CMP     R0, #9
        BEQ     map_9

        ; N�mero inv�lido
        MOV     R0, #0x00
        B       end_map

; O mapeamento das teclas foi feito rotacionado em 180 graus
map_0
        MOV     R0, #2_00111111              ; a b c d e f
        B       end_map

map_1
        MOV     R0, #2_00110000              ; e f
        B       end_map

map_2
        MOV     R0, #2_01011011              ; a b d e g
        B       end_map

map_3
        MOV     R0, #2_01111001              ; a d e f g
        B       end_map

map_4
        MOV     R0, #2_01110100              ; c e f g
        B       end_map

map_5
        MOV     R0, #2_01101101              ; a c d f g
        B       end_map

map_6
        MOV     R0, #2_01101111              ; a b c d f g
        B       end_map

map_7
        MOV     R0, #2_00111000              ; d e f
        B       end_map

map_8
        MOV     R0, #2_01111111              ; a b c d e f g
        B       end_map

map_9
        MOV     R0, #2_01111101              ; a b c e f g

end_map
        POP     {LR}
        BX      LR

; -------------------------------------------------------------------------------

        ALIGN                                   ; Alinhamento da se��o
        END                                     ; Fim do arquivo
