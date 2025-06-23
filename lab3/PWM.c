#include "PWM.h"

volatile bool Active = false;
volatile bool High = true;

const uint8_t prescale = 78; //Cada passo é de aproximadamente 1us

volatile uint32_t Period_us = 20000;
volatile uint32_t DutyCycle_us = 10000;

volatile uint32_t *PortPWM = NULL;
volatile uint8_t PinPWM = 0;

void initConfigPWM(uint32_t freq_hz, uint32_t dutycycle_us, volatile uint32_t *port_pwm, uint8_t pin_pwm){
	
	initParameters_us(freq_hz, dutycycle_us);
	setOutput(port_pwm, pin_pwm);
	
	//Ativa o temporizador
	SYSCTL_RCGCTIMER_R |= 0x04; //ativa clock do timer2
	while(!(SYSCTL_PRTIMER_R & 0x04)){}  //espera o timer2 estar pronto
  
	//Configuração do modo
	TIMER2_CTL_R &= ~(0x01); //desabilita o timer
	TIMER2_CFG_R = 0x04; //configura para 16 bits
	TIMER2_TAMR_R = 0x01; //configura one-shot
		
	setSteps(DutyCycle_us); //steps
	TIMER2_TAPR_R = prescale; //prescale
	
	//Configuração interrupções a nível de periférico
	TIMER2_ICR_R = 0x01; //limpeza da interrupção
  TIMER2_IMR_R = 0x01; //habilita a interrupção do periférico
	
	//Configuração da interrupção NVIC
	NVIC_EN0_R = (1 << 23);
	NVIC_PRI5_R = (NVIC_PRI5_R & ~(7 << 29)) | (4 << 29);
}

void startPWM(){ //Inicializa o PWM
	TIMER2_CTL_R |= 0x01; //Inicia a contagem
	Active = true;
	High = true; //Inicializa em alto
	writePin(High);
}

void stopPWM(){ //Desabita o PWM
	Active = false;
}

void setDutyCycle_us(uint32_t dutycycle_us){ //Altera o duty cycle
	DutyCycle_us = dutycycle_us;
}

uint32_t getDutyCycle_us(){ //Obtém o duty cycle atual
	return DutyCycle_us;
}

static void initParameters_us(uint32_t freq_hz, uint32_t dutycycle_us){ 
	Period_us = 1000000UL / freq_hz; //Período da onda
	DutyCycle_us = dutycycle_us;
}

static void setOutput(volatile uint32_t * port, uint8_t pin){ //Set do GPIO que será a saída do sinal
	PortPWM = port;
	PinPWM = (1 << pin);
}

static void setSteps(uint32_t time_us){ //Set da temporização do contador
	TIMER2_TAILR_R = ((time_us * (SYS_CLK / 1000000UL)) / (prescale + 1)) - 1;
}

static void enableCounting(){ //Habilita a contagem
	TIMER2_CTL_R |= 0x01;
}

static void writePin(bool high){ //Escreve HIGH ou LOW no pino de saída
	if (high)
		*PortPWM |= PinPWM;   // Seta o bit do pino (liga)
	else
		*PortPWM &= ~PinPWM;  // Limpa o bit do pino (desliga)
}


void Timer2A_Handler(void){
	TIMER2_ICR_R = 0x01; //ACK
	
	if(Active){
		High = !High; //Inverte o sinal
		writePin(High);
		uint32_t time = (High) ? DutyCycle_us : Period_us - DutyCycle_us;
		setSteps(time);
		enableCounting();
	}
}
