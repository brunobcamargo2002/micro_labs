#include "ServoMotor.h"

volatile int32_t MinAngle = -90;
volatile int32_t MaxAngle =  90;

volatile uint16_t MaxSample = 0xFFF;

volatile uint32_t MinDutyCycle_us = 500;
volatile uint32_t MaxDutyCycle_us = 2500;

void initServoMotor(int32_t min_angle, int32_t max_angle, int32_t min_dutycycle_us, int32_t max_dutycycle_us){
	initConfigPWM(50, 1320, &GPIO_PORTL_DATA_R, 4); //Inicializa o PWM
	
	//Iniciliazação dos valores
	setMinAngle(min_angle);
	setMaxAngle(max_angle);
	setMinDutyCycle_us(min_dutycycle_us);
	setMaxDutyCycle_us(max_dutycycle_us);
	
	//Inicia o PWM
	startPWM();
}

void setAngle(int32_t angle){
	float proportion = (float)(angle - MinAngle)/(MaxAngle - MinAngle);
	setDutyCycle_us(MinDutyCycle_us + proportion * (MaxDutyCycle_us - MinDutyCycle_us));
}

void setAngleBySample(int16_t sample){
	float proportion = (float)(sample)/(MaxSample);
	setDutyCycle_us(MinDutyCycle_us + proportion * (MaxDutyCycle_us - MinDutyCycle_us));
}

int16_t getAngle(){
    float proportion = (float)(getDutyCycle_us() - MinDutyCycle_us) / (float)(MaxDutyCycle_us - MinDutyCycle_us);
    return  MinAngle + proportion * (MaxAngle - MinAngle);
}

static void setMinAngle(int32_t min_angle){
	MinAngle = min_angle;
}

static void setMaxAngle(int32_t max_angle){
	MaxAngle = max_angle;
}

static void setMinDutyCycle_us(uint32_t min_dutycycle_us){
	MinDutyCycle_us = min_dutycycle_us;
}

static void setMaxDutyCycle_us(uint32_t max_dutycycle_us){
	MaxDutyCycle_us = max_dutycycle_us;
}

