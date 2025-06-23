#ifndef PWM_H
#define PWM_H

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#include "tm4c1294ncpdt.h"
#include "constants.h"


//Control Functions
void initConfigPWM(uint32_t freq_hz, uint32_t dutycycle_us, volatile uint32_t *port_pwm, uint8_t pin_pwm);
void startPWM();
void stopPWM();
void setDutyCycle_us(uint32_t dutycycle_us);

//Getters
uint32_t getDutyCycle_us();

//PWM Interruption
void Timer2A_Handler(void);

//Intern Functions
static void initParameters_us(uint32_t freq_hz, uint32_t dutycycle_us);
static void setOutput(volatile uint32_t * port, uint8_t pin);
static void setSteps(uint32_t time_us);
static void enableCounting();
static void writePin(bool high);




#endif