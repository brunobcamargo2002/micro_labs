#include "tm4c1294ncpdt.h"
#include "gpio.h"
#include "assembly.h"

#define GPIO_PORTA  (1 << 0)  //bit 0
#define GPIO_PORTE  (1 << 4)  //bit 4
#define GPIO_PORTL  (1 << 10) //bit 10

void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R = (GPIO_PORTA | GPIO_PORTE | GPIO_PORTL);
	//1b.   após isso verificar no PRGPIO se a porta está pronta para uso.
  while((SYSCTL_PRGPIO_R & (GPIO_PORTA | GPIO_PORTE | GPIO_PORTL)) != (GPIO_PORTA | GPIO_PORTE | GPIO_PORTL)){};
	
	// 2. Configuração das portas analógicas
	GPIO_PORTA_AHB_AMSEL_R = 0x00;
	GPIO_PORTE_AHB_AMSEL_R = 0x10; //habilita analógico PE4
	GPIO_PORTL_AMSEL_R = 0x00;
		
	// 3. Seleção da funcionalidade
	GPIO_PORTA_AHB_PCTL_R = 0x11; //Seleciona TX para PA1 e RX para PA0
	GPIO_PORTE_AHB_PCTL_R = 0x00;
	GPIO_PORTL_PCTL_R = 0x00;
		
	// 4. DIR para 0 se for entrada, 1 se for saída
	GPIO_PORTA_AHB_DIR_R = 0x02; //PA0-PA1
	GPIO_PORTE_AHB_DIR_R = 0x00;
  GPIO_PORTL_DIR_R = 0x10; //PL4
	
	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa	
	GPIO_PORTA_AHB_AFSEL_R = 0x03; //Função alternativa para PA1 e PA0
	GPIO_PORTE_AHB_AFSEL_R = 0x10; //Função alternativa para PE4
	GPIO_PORTL_AFSEL_R = 0x00;
	
	// 6. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTA_AHB_DEN_R = 0x03; //PA4-PA7 leds
	GPIO_PORTE_AHB_DEN_R = 0x00;
	GPIO_PORTL_DEN_R = 0x10;
}	