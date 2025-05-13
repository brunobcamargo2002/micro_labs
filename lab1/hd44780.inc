;Comandos de inicialização do display
LCD_INITCONFIG     EQU     0x0C      ; Display on, cursor off, blink off
LCD_CLEAR          EQU     0x01      ; Clear display
LCD_SET8           EQU     0x38      ; 8-bit mode, 2 lines, 5x8 dots
LCD_CURINC         EQU     0x06      ; Cursor auto-increment

;Primeira posição de cada linha
LCD_ROW0           EQU     0x80      ; First row start address
LCD_ROW1           EQU     0xC0      ; Second row start address
