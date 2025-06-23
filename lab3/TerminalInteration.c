#include "TerminalInteration.h"

volatile uint8_t selected = '1';

uint8_t selectControl(){
	uint8_t selected_control = 0; 
	messageSelectControl(); //Manda a mensagem contendo as opções
	
	//Espera o usuário selecionar 'p' ou 't'
	while(selected_control != 'p' && selected_control != 't'){
		selected_control = ReadByte();
	}
	
	return selected_control; //Retorna a opção selecionada
}

uint8_t selectAngle(){
	messageSelectAngle(); //Manda a mensagem contendo as opções
	
	uint8_t option = 0;
	
	//Espera o usuário selecionar de 1-9 (posição) ou 'p'(alterar controle)
	while((option < '1' || option > '9') && option != 'p'){ 
		option = ReadByte();
	}
	selected = option;
	return option; //Retorna a opção selecionada
}

bool changeToTerminal(){
	uint8_t data = 0;
	
	//Verifica se o usuário apertou 't'
	while(TryReadByte(&data)){
		if(data == 't')
			return true;
	}
	
	return false;
}

void messageSelectControl(){
	WriteString(CLEAR);
	WriteString("Willkommen!!!\r\n");
	WriteString("Press 't' for control via terminal or 'p' for control via potenciometer: ");
}

void messageSelectAngle(){
	WriteString(CLEAR);
	WriteString("Actual Position: ");
	WriteByte(selected);
	WriteString("\r\n");
	WriteString("Press\r\n");
	WriteString("1 - move -90deg\r\n");
	WriteString("2 - move -60deg\r\n");
	WriteString("3 - move -45deg\r\n");
	WriteString("4 - move -30deg\r\n");
	WriteString("5 - move   0deg\r\n");
	WriteString("6 - move  30deg\r\n");
	WriteString("7 - move  45deg\r\n");
	WriteString("8 - move  60deg\r\n");
	WriteString("9 - move  90deg\r\n");
	WriteString("\'p\' - change to potentiometer\r\n");
}

void messageSelectedAngle(int16_t position){
	char position_str[4];
	sprintf(position_str, "%d", position);
	WriteString(CLEAR);
	WriteString("Press 't' for terminal control.");
	WriteString("Actual Position: ");
	WriteString(position_str);
	WriteString(" deg\r\n");
}