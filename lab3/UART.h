#ifndef UART_H
#define UART_H

#include <stdint.h>
#include <math.h>
#include <stdbool.h>

#include "tm4c1294ncpdt.h"
#include "constants.h"

struct UART;
enum BAUDRATE;
enum PARITY;
enum STOPBITS;

//Inicialização
void initUART(enum BAUDRATE baudrate, enum PARITY parity, enum STOPBITS stop_bits, volatile uint32_t * tx_port, volatile uint8_t tx_pin, volatile uint32_t * rx_port, volatile uint8_t rx_pin);

//Funções de Leitura
uint8_t ReadByte();
bool TryReadByte(uint8_t* data);

//Funções de Escrita
void WriteByte(uint8_t data);
void WriteString(const char *str);

//Enums de configuração
enum BAUDRATE{
	BD_9600 = 9600,
	BD_19200 = 19200,
	BD_33600 = 33600,
	BD_57600 = 57600,
	BD_115200 = 115200
};

enum PARITY{
	NONE,
	EVEN,
	ODD
};

enum STOPBITS{
	SB_1 = 1,
	SB_2
};

//Struct
typedef struct uart{
	volatile enum BAUDRATE Baudrate;
	volatile enum PARITY Parity;
	volatile enum STOPBITS StopBits;
	volatile uint32_t *TXPort, *RXPort;
	volatile uint8_t TXPin, RXPin;
}UART;

#endif