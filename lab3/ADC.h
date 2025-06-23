#ifndef ADC_H
#define ADC_H

#include <stdint.h>

#include "tm4c1294ncpdt.h"

//Inicialização
void initADC(volatile uint32_t *port, volatile uint8_t pin);

//Leitura
uint16_t readADC(void);

//Struct
typedef struct adc{
	volatile uint32_t *Port;
	volatile uint8_t Pin;
}ADC;

#endif