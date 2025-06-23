/*==================================================================================================================
Autores: Otávio Pepe, Bruno Camargo e Alexandre Vinicius  
Descrição: Programa em C para controlar um servo motor através de uma comunicação UART ou via conversor AC.  
Data: 23/06/2025  
==================================================================================================================*/

#include "assembly.h"
#include "gpio.h"
#include "ServoMotor.h"
#include "UART.h"
#include "ADC.h"
#include "TerminalInteration.h"

int main(void) {
  PLL_Init();
  SysTick_Init();
  GPIO_Init();

	//Inicializações
  initServoMotor(-90, 90, 490, 2195); //Servo inicia o PWM
  initUART(BD_9600, EVEN, SB_1, &GPIO_PORTA_AHB_DATA_R, 1, &GPIO_PORTA_AHB_DATA_R, 0);
	initADC(&GPIO_PORTE_AHB_DATA_R, 1 << 4);
	
  uint8_t control = selectControl(); //Terminal ou potenciometro
	uint8_t count_100ms = 0; //Controle do tempo para a atualização da posição quando controlado pelo potenciometro.
	setAngle(-90);
  while (1) {
		//Controle por terminal
		if (control == 't') { 
      switch (selectAngle()) {
        case '1': setAngle(-90); break;
        case '2': setAngle(-60); break;
        case '3': setAngle(-45); break;
        case '4': setAngle(-30); break;
        case '5': setAngle(0);   break;
        case '6': setAngle(30);  break;
        case '7': setAngle(45);  break;
        case '8': setAngle(60);  break;
        case '9': setAngle(90);  break;
        case 'p': control = 'p'; break;
        default: break;
      }
    } 
		//Controle por potenciometro
		else {
			setAngleBySample(readADC()); //move o motor.
			if(count_100ms == 10){ //Atualiza a posição quando der 1s.
				messageSelectedAngle(getAngle());
				count_100ms = 0;
			}
			SysTick_Wait1ms(100);
			count_100ms++;
			if(changeToTerminal()){ //Verifica se a tecla 't' foi clicada.
				control='t';
				count_100ms = 0;
			}
    }
  }
}
