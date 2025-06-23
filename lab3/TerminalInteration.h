#ifndef TERMINAL_INTERATION_H
#define TERMINAL_INTERATION_H

#include <stdio.h>
#include <stdbool.h>
#include "UART.h"

#define CLEAR "\033[2J\033[H"

//Obten��o dos inputs do usu�rio
uint8_t selectControl();
uint8_t selectAngle();
bool changeToTerminal();

//Mensagens enviadas ao usu�rio
void messageSelectControl();
void messageSelectAngle();
void messageSelectedAngle(int16_t position);


#endif