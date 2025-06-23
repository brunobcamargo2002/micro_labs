#ifndef SERVO_MOTOR_H
#define SERVO_MOTOR_H

#include "stdint.h"

#include "PWM.h"

//Inicialização
void initServoMotor(int32_t min_angle, int32_t max_angle, int32_t min_dutycycle_us, int32_t max_dutycycle_us);

//Atualização do ângulo
void setAngle(int32_t angle);
void setAngleBySample(int16_t sample);

//Getters
int16_t getAngle();

//Funções internas
static void setMinAngle(int32_t min_angle);
static void setMaxAngle(int32_t max_angle);
static void setMinDutyCycle_us(uint32_t min_dutycycle_us);
static void setMaxDutyCycle_us(uint32_t max_dutycycle_us);



#endif