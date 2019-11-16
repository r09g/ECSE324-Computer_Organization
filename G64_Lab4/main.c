#include <stdio.h>
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/ps2_keyboard.h"


void clear_pxlbuf() {
	VGA_clear_pixelbuff_ASM();
}

void clear_charbuf() {
	VGA_clear_charbuff_ASM();
}

void test_char() {
	int x,y;
	char c = 0;
	
	for (y = 0; y <= 59; y++) {
		for (x = 0; x <= 79; x++) {
			VGA_write_char_ASM(x,y,c++);
		}
	}
}

void test_byte() {
	int x,y;
	char c = 0;
	
	for (y = 0; y <= 59; y++) {
		for (x = 0; x <= 79; x+=3) {
			VGA_write_byte_ASM(x,y,c++);
		}
	}
}

void test_pixel() {
	int x,y;
	unsigned short colour = 0;
	
	for (y = 0; y <= 239; y++) {
		for (x = 0; x <= 319; x++) {
			if((x % 2 == 0) && (y % 2 == 0)){
				VGA_draw_point_ASM(x,y,colour++);
			}
		}
	}
}

void blue_screen() {
	int x,y;
	unsigned short colour = 0b11111;

	for (y = 0; y <= 239; y++) {
		for (x = 0; x <= 319; x++) {
			VGA_draw_point_ASM(x,y,colour);
		}
	}

	for (y = 0; y <= 239; y++) {
		for (x = 0; x <= 319; x+=6) {
			VGA_write_char_ASM(x,y,0x45);
			VGA_write_char_ASM(x+1,y,0x52);
			VGA_write_char_ASM(x+2,y,0x52);
			VGA_write_char_ASM(x+3,y,0x4F);
			VGA_write_char_ASM(x+4,y,0x52);
			VGA_write_char_ASM(x+5,y,0x20);
		}
	}
}


int main() {

	int PBstate;
	int SWstate;
	while(1){
		PBstate = read_PB_data_ASM();
		SWstate = read_slider_switches_ASM();
		if(PBstate == 1){
			if(SWstate > 0){
				test_byte();
			} else {
				test_char();
			}
		}else if(PBstate == 2){
			test_pixel();
		}else if(PBstate == 4){
			clear_charbuf();
		}else if(PBstate == 8){
			clear_pxlbuf();
		}
	}
	return 0;
}

/*
int main() {
	clear_charbuf();
	clear_pxlbuf();
	int x = 0;
	int y = 0;
	int valid;
	char* c = (char*)malloc(2*sizeof(char));
	while(1){
		valid = read_PS2_data_ASM(c);		
		if(valid){
			VGA_write_byte_ASM(x,y,*c);
			x = x + 3;
			if(x > 79){
				x = 0;
				y++;
			}
			if(y > 59){
				clear_charbuf();
				y = 0;
			}
		}
	}
	return 0;
}
*/
