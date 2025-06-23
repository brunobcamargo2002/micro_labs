#include "ADC.h"

volatile ADC adc;

void initADC(volatile uint32_t *port, volatile uint8_t pin){
	//Inicializa a struct adc
	adc.Port = port;
	adc.Pin = (1 << pin);

	SYSCTL_RCGCADC_R |= 0x01; // habilita o clock
	ADC0_PC_R = 0x07; // taxa máxima de amostragem
	ADC0_ACTSS_R &= ~0x08; // desabilita SS3 antes da configuração
	ADC0_EMUX_R &= ~0xF000; // trigger de software
	ADC0_SSMUX3_R = 0x09; // seleciona a entrada analógica AIN9
	ADC0_SSCTL3_R &= ~0x0F; // limpa IE0, END0 e TS0 bits
	ADC0_SSCTL3_R |= 0x06; // configura IE0 e END0
	ADC0_ACTSS_R |= 0x08; // reabilita SS3
}

uint16_t readADC(void) {
	uint16_t result;

	//Trigga a conversão
  ADC0_PSSI_R = 0x08; 

	//Espera a conversão ficar pronta
  while ((ADC0_RIS_R & 0x08) == 0);

	//Le os bits da amostragem.
  result = ADC0_SSFIFO3_R & 0xFFF;  // 12 bits úteis (0-4095)

  //Realiza ACK
  ADC0_ISC_R = 0x08;

  return result;
}