#include "UART.h"

volatile UART uart;

void initUART(enum BAUDRATE baudrate, enum PARITY parity, enum STOPBITS stop_bits, volatile uint32_t * tx_port, volatile uint8_t tx_pin, volatile uint32_t * rx_port, volatile uint8_t rx_pin){
	
	//Configurações do uart
	uart.Baudrate = baudrate;
	uart.Parity = parity;
	uart.StopBits = stop_bits;
	uart.TXPort = tx_port;
	uart.TXPin = (1 << tx_pin);
	uart.RXPort = tx_port;
	uart.RXPin = (1 << tx_pin);
	
	//ativa clock
	SYSCTL_RCGCUART_R = 0x01;
	while(!(SYSCTL_PRUART_R & 0x01)){}
		
	//desabilita e seta a divisão do sysclk para 16
	UART0_CTL_R = UART0_CTL_R & !((1 << 0) | (1 << 5));
		
	//configuração do baudrate
	double bd_div = SYS_CLK / (double)(16 * baudrate); //Calculo do divisor do clock
		
	uint16_t ibd_div = bd_div; //Parte inteira do divisor
	uint8_t fbd_div = (uint8_t)round((bd_div - ibd_div) * 64); //Fração do divisor
		
	if(fbd_div == 64){ //Se fração for 64 então incrementa parte inteira e zera fração
		ibd_div++;
		fbd_div = 0;
	}
	UART0_IBRD_R = ibd_div; 
	UART0_FBRD_R = fbd_div;
	
	//Configuração da palavra
	uint32_t config_lcrh = 0x70; // 8 bits word e fila buffer 16 palavras
	
	//Paridade
	if(parity == EVEN || parity == ODD){
		config_lcrh |= 0x02; //Habilita paridade
		if(parity == EVEN)
			config_lcrh |= 0x04; //Configura paridade par
	}
	
	//Stop Bits
	if(stop_bits == SB_2)
		config_lcrh |= 0x08; //Configura 2 stop bits
	UART0_LCRH_R = config_lcrh;
	
	//Seleção do clock do sistema
	UART0_CC_R = 0;
	
	//Ativa RXE, TXE e UART
	UART0_CTL_R = UART0_CTL_R | (1 << 9) | (1 << 8) | (1 << 0);
}

uint8_t ReadByte()
{
	uint32_t uart_dr;
	bool parityError, framingError;
	
	while(1){
		while (UART0_FR_R & (1 << 4)); //Espera dado ficar disponível
		
		uart_dr = UART0_DR_R; //Leitura do dado
		parityError  = (uart_dr & (1 << 9)) != 0; //Verifica erro de paridade
    framingError = (uart_dr & (1 << 8)) != 0; //Verifica erro no(s) stop bit(s)
		
		if ((uart.Parity != NONE && parityError) || framingError) {
			continue; // Byte inválido, descarta e tenta de novo
    }
		
		return (uint8_t)(uart_dr & 0xFF); // Retorna a mensagem
	}
}

bool TryReadByte(uint8_t* data) {
    if (UART0_FR_R & (1 << 4)) { //Verifica se tem dado disponível
        return false;
    }
		
		uint32_t uart_dr = UART0_DR_R; //Leitura do dado
		bool parityError = (uart_dr & (1 << 9)) != 0; //Verifica erro de paridade
		bool framingError = (uart_dr & (1 << 8)) != 0; //Verifica erro no(s) stop bit(s)
		
		if ((uart.Parity != NONE && parityError) || framingError) {
			return false; // Byte inválido
    }

    *data = (uint8_t)(uart_dr & 0xFF); //Escreve a mensagem
    return true; //Sucesso na leitura
}

void WriteByte(uint8_t data)
{
    while (UART0_FR_R & (1 << 5)); //Espera liberar espaço na fila

    UART0_DR_R = data; //Escreve o dado para transmissão
}

void WriteString(const char *str)
{
    while (*str != '\0') {
        WriteByte((uint8_t)*str); //Escreve o caractere
        str++; //Próximo caractere
    }
}