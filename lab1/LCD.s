; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código

		INCLUDE hd44780.inc

        AREA    |.text|, CODE, READONLY, ALIGN=2
		
		
		EXPORT LCD_Init
		EXPORT refresh_LCD
		IMPORT portK_output
		IMPORT portM_output
		IMPORT SysTick_Wait1us

LCD_Init
		PUSH	{LR}
		 
		LDR R0, =LCD_SET8            ;inicia as 2 linhas
		BL instruction_delay50u
		
		LDR R0, =LCD_CURINC            ;autoincremento cursor
		BL instruction_delay50u
		
		LDR R0, =LCD_CURON            ;cursor
		BL instruction_delay50u
		
		LDR R0, =LCD_CLEAR            ;clear
		BL instruction_delay1650u
		
		BL string_init
		
		POP		{LR}
		
		BX 		LR	

string_init
		PUSH	{LR}
		
		MOV R0, #'P'
		BL data_delay50u
		
		MOV R0, #'a'
		BL data_delay50u
		
		MOV R0, #'s'
		BL data_delay50u
		
		MOV R0, #'s'
		BL data_delay50u
		
		MOV R0, #'o'
		BL data_delay50u
		
		MOV R0, #':'
		BL data_delay50u
		
		POP		{LR}
		
		BX 		LR	

refresh_LCD
		PUSH {LR}

		CMP R6, #1
		BNE dir_test
		MOV R0, R9
		BL step_update
		MOV R6, #0
dir_test
		CMP R7, #1
		BNE end_refresh_LCD
		MOV R0, R10
		BL dir_update
		MOV R7, #0
end_refresh_LCD
		POP {LR}
		
		BX LR

step_update
		PUSH {LR, R1}
		MOV R1, R0
		
		LDR R0, =LCD_ROW0 + 7
		BL instruction_delay50u
		
		MOV R0, #'0'
		ADD R0, R1
		BL data_delay50u
		
		POP {R1}
		POP {LR}
		
		BX LR
		
dir_update
		PUSH {LR, R1}
		
		MOV R1, R0
		
		LDR R0, =LCD_ROW1
		BL instruction_delay50u
		
		BL row_clear
		
		LDR R0, =LCD_ROW1
		BL instruction_delay50u
		
		CMP R1, #1
		BNE dec
		MOV R0, #'C'
		BL data_delay50u
		MOV R0, #'r'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
		MOV R0, #'s'
		BL data_delay50u
		MOV R0, #'c'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
		MOV R0, #'n'
		BL data_delay50u
		MOV R0, #'t'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
		B end_dir_update
dec
		MOV R0, #'D'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
		MOV R0, #'c'
		BL data_delay50u
		MOV R0, #'r'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
		MOV R0, #'s'
		BL data_delay50u
		MOV R0, #'c'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
		MOV R0, #'n'
		BL data_delay50u
		MOV R0, #'t'
		BL data_delay50u
		MOV R0, #'e'
		BL data_delay50u
end_dir_update
		POP {R1}
		POP {LR}
		
		BX LR
		
row_clear
		PUSH {LR, R1}
		
		CMP R0, #0
		ITE EQ
		LDREQ R0, =LCD_ROW0
		LDRNE R0, =LCD_ROW1
		BL instruction_delay50u
		
		MOV R1, #16        
clear_loop
		MOV R0, #' '    
		BL data_delay50u
		SUBS R1, R1, #1
		BNE clear_loop
		
		POP {R1}
		POP {LR}
		
		BX LR

instruction_delay50u
		PUSH    {LR, R1}

		MOV R1, #0
		B delay50u
data_delay50u
		PUSH    {LR, R1}
		
		MOV R1, #1
delay50u
        
		BL portK_output
	
		MOV R0, R1
		ORR R0, #2_100
		BL portM_output
		MOV R0, #10
		BL SysTick_Wait1us
		
		MOV R0, R1
		BIC R0, #2_100
		BL portM_output
		MOV R0, #40
		BL SysTick_Wait1us
		
		POP     {R1}
        POP     {LR}

        BX      LR


instruction_delay1650u
		PUSH    {LR, R1}
		
		MOV R1, #0
		B delay1650u
data_delay1650u
		PUSH    {LR, R1}
		
		MOV R1, #1
delay1650u
		
        BL portK_output
		
		MOV R0, R1
		ORR R0, #2_100
		BL portM_output
		MOV R0, #10
		BL SysTick_Wait1us
		
		MOV R0, R1
		BIC R0, #2_100
		BL portM_output
		MOV R0, #1640
		BL SysTick_Wait1us
		
		POP 	{R1}
        POP     {LR}

        BX      LR
		
			
        ALIGN                          ; Garante que o fim da seção está alinhada 
        END                            ; Fim do arquivo