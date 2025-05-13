; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
	    INCLUDE gpio.inc
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo  
		EXPORT portA_output
		EXPORT portB_output
		EXPORT portK_output
		EXPORT portM_output
		EXPORT portQ_output
        IMPORT EnableInterrupts
        IMPORT DisableInterrupts
		IMPORT SysTick_Wait1ms
;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV 	R2, #GPIO_PORTA
			ORR 	R2, #GPIO_PORTB
			ORR		R2, #GPIO_PORTJ
			ORR		R2, #GPIO_PORTK
			ORR  	R2, #GPIO_PORTM
			ORR		R2, #GPIO_PORTQ
            STR     R2, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
            CMP     R1, R2							;CMP de R1 com R2
            BNE     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
; 2. Limpar o AMSEL para desabilitar a analógica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
			
			LDR     R0, =GPIO_REGA + GPIO_AMSEL_R   ;Carrega o R0 com o endereço do AMSEL para a porta A
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta A da memória
			
			LDR     R0, =GPIO_REGB + GPIO_AMSEL_R   ;Carrega o R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta B da memória
			
			LDR     R0, =GPIO_REGJ + GPIO_AMSEL_R   ;Carrega o R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
			
			LDR     R0, =GPIO_REGK + GPIO_AMSEL_R   ;Carrega o R0 com o endereço do AMSEL para a porta K
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta K da memória
			
			LDR     R0, =GPIO_REGM + GPIO_AMSEL_R   ;Carrega o R0 com o endereço do AMSEL para a porta M
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta M da memória
			
            LDR     R0, =GPIO_REGQ + GPIO_AMSEL_R   ;Carrega o R0 com o endereço do AMSEL para a porta Q
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta Q da memória
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			
			LDR     R0, =GPIO_REGA + GPIO_PCTL_R	;Carrega o R0 com o endereço do PCTL para a porta A
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
			
			LDR     R0, =GPIO_REGB + GPIO_PCTL_R	;Carrega o R0 com o endereço do PCTL para a porta B
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
			
			LDR     R0, =GPIO_REGJ + GPIO_PCTL_R	;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
			
			LDR     R0, =GPIO_REGK + GPIO_PCTL_R	;Carrega o R0 com o endereço do PCTL para a porta K
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta K da memória
			
			LDR     R0, =GPIO_REGM + GPIO_PCTL_R	;Carrega o R0 com o endereço do PCTL para a porta M
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta M da memória
			
            LDR     R0, =GPIO_REGQ + GPIO_PCTL_R	;Carrega o R0 com o endereço do PCTL para a porta Q
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória

; 4. DIR para 0 se for entrada, 1 se for saída
			LDR     R0, =GPIO_REGA + GPIO_DIR_R		;Carrega o R0 com o endereço do DIR para a porta A
			MOV     R1, #2_11110000 			    ;Define os pinos como saída			
            STR     R1, [R0]						;
			
			LDR     R0, =GPIO_REGB + GPIO_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_00110000					;Define os pinos como saída				
            STR     R1, [R0]						;
			
			LDR     R0, =GPIO_REGJ + GPIO_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
			MOV     R1, #0x00						;Define os pinos como entrada				
            STR     R1, [R0]						;
			
			LDR     R0, =GPIO_REGK + GPIO_DIR_R		;Carrega o R0 com o endereço do DIR para a porta K
			MOV     R1, #2_11111111					;Define os pinos como saída				
            STR     R1, [R0]
			
			LDR     R0, =GPIO_REGM + GPIO_DIR_R		;Carrega o R0 com o endereço do DIR para a porta M
			MOV     R1, #2_00000111					;Define os pinos como saída				
            STR     R1, [R0]
			
			LDR     R0, =GPIO_REGQ + GPIO_DIR_R		;Carrega o R0 com o endereço do DIR para a porta Q
			MOV     R1, #2_00001111						;Define os pinos como saída				
            STR     R1, [R0]						;
									
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
			
            LDR     R0, =GPIO_REGA + GPIO_AFSEL_R   ;Carrega o endereço do AFSEL da porta A
            STR     R1, [R0]                        ;Escreve na porta
			
			LDR     R0, =GPIO_REGB + GPIO_AFSEL_R   ;Carrega o endereço do AFSEL da porta B
            STR     R1, [R0]                        ;Escreve na porta
			
			LDR     R0, =GPIO_REGJ + GPIO_AFSEL_R   ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			
			LDR     R0, =GPIO_REGK + GPIO_AFSEL_R   ;Carrega o endereço do AFSEL da porta K
            STR     R1, [R0]                        ;Escreve na porta
			
			LDR     R0, =GPIO_REGM + GPIO_AFSEL_R   ;Carrega o endereço do AFSEL da porta M
            STR     R1, [R0]                        ;Escreve na porta
			
			LDR     R0, =GPIO_REGQ + GPIO_AFSEL_R   ;Carrega o endereço do AFSEL da porta Q
            STR     R1, [R0]                        ;Escreve na porta
			
; 6. Setar os bits de DEN para habilitar I/O digital
			LDR     R0, =GPIO_REGA + GPIO_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTA_DEN_R
			MOV     R2, #2_11110000                     ;Habilita I/O digital dos pinos
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_REGB + GPIO_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTB_DEN_R
			MOV     R2, #2_00110000                     ;Habilita I/O digital dos pinos
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_REGJ + GPIO_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTJ_DEN_R
			MOV     R2, #2_00000011                     ;Habilita I/O digital do SW1 e do SW2
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_REGK + GPIO_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTK_DEN_R
			MOV     R2, #2_11111111                     ;Habilita I/O digital dos pinos
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_REGM + GPIO_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTM_DEN_R
			MOV     R2, #2_00000111                     ;Habilita I/O digital dos pinos
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
            LDR     R0, =GPIO_REGQ + GPIO_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTQ_DEN_R
			MOV     R2, #2_00001111                     ;Habilita I/O digital dos pinos
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_REGJ + GPIO_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up

;Interrupções
; 8. Desabilitar a interrupção no registrador IM
			LDR     R0, =GPIO_REGJ + GPIO_IM_R          ;Carrega o endereço do IM para a porta J
			MOV     R1, #2_00							;Desabilitar as interrupções  
            STR     R1, [R0]							;Escreve no registrador
            
; 9. Configurar o tipo de interrupção por borda no registrador IS
			LDR     R0, =GPIO_REGJ + GPIO_IS_R			;Carrega o endereço do IS para a porta J
			MOV     R1, #2_00							;Por Borda  
            STR     R1, [R0]							;Escreve no registrador

; 10. Configurar  borda única no registrador IBE
			LDR     R0, =GPIO_REGJ + GPIO_IBE_R			;Carrega o endereço do IBE para a porta J
			MOV     R1, #2_00							;Borda Única  
            STR     R1, [R0]							;Escreve no registrador
			
; 11. Configurar  borda de descida (botão pressionado) no registrador IEV
			LDR     R0, =GPIO_REGJ + GPIO_IEV_R			;Carrega o endereço do IEV para a porta J
			MOV     R1, #2_00							;Borda de descida
            STR     R1, [R0]							;Escreve no registrador

; 12. ACK nos registradores dos pinos
			LDR 	R0, =GPIO_REGJ + GPIO_ICR_R         ;Carrega o endereço do ICR para a porta J
			MOV     R1, #2_11							;ACK
			STR     R1, [R0]
  
; 12. Habilitar a interrupção no registrador IM
			LDR     R0, =GPIO_REGJ + GPIO_IM_R			;Carrega o endereço do IM para a porta J
			MOV     R1, #2_11							;Habilitar as interrupções  
            STR     R1, [R0]							;Escreve no registrador
            
;Interrupção número 51            
; 13. Setar a prioridade no NVIC
			LDR     R0, =NVIC_PRI12_R           		;Carrega o endereço do NVIC para o grupo que tem o J entre 48 e 51
			MOV     R1, #3  		                    ;Prioridade 3
			LSL     R1, R1, #29							;Desloca 29 bits para a esquerda já que o J é a quarta prioridade do PRI12
            STR     R1, [R0]							;Escreve no registrador da memória
; 14. Habilitar a interrupção no NVIC
			LDR     R0, =NVIC_EN1_R           			;Carrega o endereço do NVIC para o grupo que tem o J entre 32 e 63
			MOV     R1, #1
			LSL     R1, #19								;Desloca 19 bits para a esquerda já que o J é a interrupção do bit 51 no EN2
            STR     R1, [R0]							;Escreve no registrador da memória
; Habilita as interrupções

			BX  LR

; -------------------------------------------------------------------------------

portA_output
	PUSH {R2, R1}
	LDR	R1, =GPIO_REGA + GPIO_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par?metro de entrada
	STR R0, [R1]                            ;Escreve na porta F o barramento de dados dos pinos F4 e F0
	POP {R1, R2}
	BX LR
	
portB_output
	PUSH {R2, R1}
	LDR	R1, =GPIO_REGB + GPIO_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par?metro de entrada
	STR R0, [R1]
	POP {R1, R2}
	BX LR
	
portK_output
	PUSH {R2, R1}
	LDR	R1, =GPIO_REGK + GPIO_DATA_R		;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11111111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par?metro de entrada
	STR R0, [R1]
	POP {R1, R2}
	BX LR
	
portM_output
	PUSH {R2, R1}
	LDR	R1, =GPIO_REGM + GPIO_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00000111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par?metro de entrada
	STR R0, [R1]
	POP {R1, R2}
	BX LR
	
portQ_output
	PUSH {R2, R1}
	LDR	R1, =GPIO_REGQ + GPIO_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par?metro de entrada
	STR R0, [R1]
	POP {R1, R2}
	BX LR	
			
        
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo