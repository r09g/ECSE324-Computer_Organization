#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/audio_driver.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"


// based on frequency and time input compute signal value
float signal(float f, int t) {
	int index = ((int) f) * t;	// truncates directly
	double fraction = f * t - index; // f*t must be greater/equal to the truncated version
	index = index % 48000;
	if(index == 47999) {
		return ((1.0 - fraction) * sine[index] + fraction * sine[0]);
	} else {
		return ((1.0 - fraction) * sine[index] + fraction * sine[index + 1]);
	}

}


/*
// Part 0: square wave
int main() {

	int counter = 0;

	while(1) {
		// fs = 48000; fwave = 100 cycles/sec; for each cycle there are 480 samples
		// 240 "1" and 240 "0"
		if(counter < 240){
			if(audio_write_ASM(0x00FFFFFF)){	// returns 1 if successful
				// returns 0 if error
				counter++;
			}
		} else {
			if(audio_write_ASM(0x00000000)){	// returns 1 if successful
				counter++;
			}
			if(counter == 480) {
				counter = 0; // reset counter
			}
		}
	}
	return 0;
}



/*
// Part 1: make wave
int main() {

	int counter = 0;

	while(1) {
		if(counter == 48000) {
			counter = 0;
		}
		// try int
		if(audio_write_ASM(signal(130.813,counter))) {	// frequency here
			counter++;
		}		
	}
	return 0;
}

*/


int main(){
	
	// Setup interrupt for timer0
	int_setup(1, (int []){199});

	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0; //microsecond timer
	hps_tim.timeout = 10; //1/48000 = 20.8
	hps_tim.LD_en = 1; // initial count value
	hps_tim.INT_en = 1; //enabling the interrupt
	hps_tim.enable = 1; //enable bit to 1
	HPS_TIM_config_ASM(&hps_tim);

	// whether a key has been released
	//float amplitude = 1;
	float mul = 1;		// changes the amplitude
	char keyboard_input;
	float frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};	// frequency vector
	int counter = 0; // counts time
	float content[8][48000];
	int released = 0;
	int pressed;
	int valid[] = {0,0,0,0,0,0,0,0};
	float output;
	int i = 0;
	for (counter = 0; counter < 47999 ; counter++ ){
		for (i = 0; i < 8 ; i++ ){
			content[i][counter] = signal(frequencies[i],counter);
		}
	}


	while(1){
		output = 0;

		if (hps_tim0_int_flag){
			hps_tim0_int_flag = 0;	
			pressed = read_ps2_data_ASM(&keyboard_input); // key pressed will be written into variable

			
			if (pressed == 1 && keyboard_input == 0x1C) {
				if(released == 0){ //pressed
					valid[0] = 1; //note on
				}
				if(released == 1){ //released
					valid[0] = 0; //note off
					released = 0;
				}	
			}

			if (pressed == 1 && keyboard_input == 0x1B) {
				if(released == 0){ //pressed
					valid[1] = 1; //note on
				}
				if(released == 1){ //released
					valid[1] = 0; //note off
					released = 0;
				}	
			}

			if (pressed == 1 && keyboard_input == 0x23) {
				if(released == 0){ //pressed
					valid[2] = 1; //note on
				}
				if(released == 1){ //released
					valid[2] = 0; //note off
					released = 0;
				}	
			}
			if (pressed == 1 && keyboard_input == 0x2B) {
				if(released == 0){ //pressed
					valid[3] = 1; //note on
				}
				if(released == 1){ //released
					valid[3] = 0; //note off
					released = 0;
				}	
			}
			if (pressed == 1 && keyboard_input == 0x3B) {
				if(released == 0){ //pressed
					valid[4] = 1; //note on
				}
				if(released == 1){ //released
					valid[4] = 0; //note off
					released = 0;
				}	
			}
			if (pressed == 1 && keyboard_input == 0x42) {
				if(released == 0){ //pressed
					valid[5] = 1; //note on
				}
				if(released == 1){ //released
					valid[5] = 0; //note off
					released = 0;
				}	
			}
			if (pressed == 1 && keyboard_input == 0x4B) {
				if(released == 0){ //pressed
					valid[6] = 1; //note on
				}
				if(released == 1){ //released
					valid[6] = 0; //note off
					released = 0;
				}	
			}
			if (pressed == 1 && keyboard_input == 0x4C) {
				if(released == 0){ //pressed
					valid[7] = 1; //note on
				}
				if(released == 1){ //released
					valid[7] = 0; //note off
					released = 0;
				}	
			}

			if (pressed == 1 && keyboard_input == 0xF0) {
				released = 1;
			}

			// volumn up
			if (pressed == 1 && keyboard_input == 0x49) {
				if(released == 0){ //pressed
//					amplitude = 2 * amplitude;
					mul = mul + 1;		// mul step size 0.25
				}
				released = 0;
			}
			// volumn down
			if (pressed == 1 && keyboard_input == 0x41) {
				if(released == 0){ //pressed
//					amplitude = 0.5 * amplitude;
					if(mul >= 1) {
						mul = mul - 1;	// mul step size 0.25
					}
				}
				released = 0;
			}
		}
		
		int num = 0;
		for ( i = 0; i < 8; i++ ){
			if (valid[i] == 1){
				 	output += content[i][counter];
					num += 1;
				}
		}

// normalize amplitude
		if(num > 0){
			output = output / num;
		}

		audio_write_data_ASM(mul*output, mul*output);
		//audio_write_ASM(mul*amplitude*output);
		counter++;
		if(counter >= 48000){
			counter = 0;
		}

	}
	return 0;
}






