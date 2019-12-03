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

// This function computes the amplitude based on the frequency and current sample
// a floating point value is returned
float signal(float f, int t) {
	// first truncate frequency to obtain integer index value
	// should not use round since we interpolate afterwards
	int index = ((int) f) * t;
	double fraction = f * t - index;	// obtain the extra fraction
	index = index % 48000;	// reduce the index to within 1 period
	// apply first order interpolation
	if(index == 47999) {
		// case where the interpolation happens between tail and head
		// wraps around the sine wave
		return ((1.0 - fraction) * sine[index] + fraction * sine[0]);
	} else {
		// straightforward first order interpolation
		return ((1.0 - fraction) * sine[index] + fraction * sine[index + 1]);
	}

}


/*
// Part 0: generate square wave
int main() {

	int counter = 0;	// used to control frequency of wave

	while(1) {
		// fs = 48000; fwave = 100 cycles/sec; for each cycle there are 480 samples
		// 240 "1" and 240 "0"
		if(counter < 240){
			// only increment counter if 1 is returned (successful)
			// will keep writing the same value if not successful
			if(audio_write_ASM(0x00FFFFFF)){
				counter++;	
			}
		} else {
			if(audio_write_ASM(0x00000000)){	// returns 1 if successful
				counter++;
			}
			if(counter == 480) {
				counter = 0; // reset counter when a period is finished
			}
		}
	}
	return 0;
}



/*
// Part 1: make wave
int main() {

	int counter = 0;	// used to control frequency of wave

	while(1) {
		// reset counter when a period is finished
		if(counter == 48000) {
			counter = 0;
		}
		// compute the amplitude corresponding to the current frequency and sample
		if(audio_write_ASM((int)(signal(130.813,counter)))) {	// frequency here
			counter++;
		}		
	}
	return 0;
}

*/


int main(){
	
	// Setup interrupt for timer0
	int_setup(1, (int []){199});
	
	// setup timer
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0; //microsecond timer
	hps_tim.timeout = 10; //1/48000 = 20.8
	hps_tim.LD_en = 1; // initial count value
	hps_tim.INT_en = 1; //enabling the interrupt
	hps_tim.enable = 1; //enable bit to 1
	HPS_TIM_config_ASM(&hps_tim);

	float mul = 1;		// changes the amplitude
	char keyboard_input;	// store keyboard input
	float frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};	// frequency vector
	int counter = 0; // counts time
	float content[8][48000]; // 2D array stores all the samples of all the notes
	int released = 0;	// indicates whether a release of the key has been detected
	int pressed;	// indicates whether a key is pressed
	int valid[] = {0,0,0,0,0,0,0,0};	// stores status of which notes are played
	float output;	// stores the final output amplitude
	
	// compute table of amplitudes for all notes
	int i = 0;
	for (counter = 0; counter < 47999 ; counter++ ){
		for (i = 0; i < 8 ; i++ ){
			content[i][counter] = signal(frequencies[i],counter);
		}
	}


	while(1){
		output = 0;
		
		// keyboard interrupt is detected
		if (hps_tim0_int_flag){
			hps_tim0_int_flag = 0;	
			pressed = read_ps2_data_ASM(&keyboard_input); // key pressed will be written into variable

			// For keyboard "A"
			if (pressed == 1 && keyboard_input == 0x1C) {
				if(released == 0){ // pressed
					valid[0] = 1; // note on
				}
				if(released == 1){ //released
					valid[0] = 0; // note off
					released = 0; // restore variable to 0 for future use
				}	
			}
			
			// For keyboard "S"
			if (pressed == 1 && keyboard_input == 0x1B) {
				if(released == 0){ //pressed
					valid[1] = 1; //note on
				}
				if(released == 1){ //released
					valid[1] = 0; //note off
					released = 0;
				}	
			}

			// For keyboard "D"
			if (pressed == 1 && keyboard_input == 0x23) {
				if(released == 0){ //pressed
					valid[2] = 1; //note on
				}
				if(released == 1){ //released
					valid[2] = 0; //note off
					released = 0;
				}	
			}

			// For keyboard "F"
			if (pressed == 1 && keyboard_input == 0x2B) {
				if(released == 0){ //pressed
					valid[3] = 1; //note on
				}
				if(released == 1){ //released
					valid[3] = 0; //note off
					released = 0;
				}	
			}

			// For keyboard "J"
			if (pressed == 1 && keyboard_input == 0x3B) {
				if(released == 0){ //pressed
					valid[4] = 1; //note on
				}
				if(released == 1){ //released
					valid[4] = 0; //note off
					released = 0;
				}	
			}

			// For keyboard "K"
			if (pressed == 1 && keyboard_input == 0x42) {
				if(released == 0){ //pressed
					valid[5] = 1; //note on
				}
				if(released == 1){ //released
					valid[5] = 0; //note off
					released = 0;
				}	
			}

			// For keyboard "L"
			if (pressed == 1 && keyboard_input == 0x4B) {
				if(released == 0){ //pressed
					valid[6] = 1; //note on
				}
				if(released == 1){ //released
					valid[6] = 0; //note off
					released = 0;
				}	
			}

			// For keyboard ";"
			if (pressed == 1 && keyboard_input == 0x4C) {
				if(released == 0){ //pressed
					valid[7] = 1; //note on
				}
				if(released == 1){ //released
					valid[7] = 0; //note off
					released = 0;
				}	
			}
			
			// When a break code is detected
			if (pressed == 1 && keyboard_input == 0xF0) {
				released = 1;	// indicate release of the key
			}

			// For keyboard ">" to turn up volume
			if (pressed == 1 && keyboard_input == 0x49) {
				if(released == 0){ // pressed
					mul = mul + 1;
				}
				// Here we can directly restore indicator state since mul is updated
				released = 0;
			}
			
			// For keyboard "<" to turn down volume
			if (pressed == 1 && keyboard_input == 0x41) {
				if(released == 0){ // pressed
					if(mul >= 1) {	// ensure volume is not negative
						mul = mul - 1;
					}
				}
				// Here we can directly restore indicator state since mul is updated
				released = 0;
			}
		}
		
		// combine different notes
		int num = 0;	// used for storing number of active notes for amplitude normalization
		for ( i = 0; i < 8; i++ ){
			if (valid[i] == 1){
				 	output += content[i][counter];
					num += 1;
				}
		}

		// normalize output amplitude after combining
		if(num > 0){
			output = output / num;
		}

		audio_write_data_ASM(mul*output, mul*output);	// assert output

		// increment counter and wrap counter when period is finished
		counter++;
		if(counter >= 48000){
			counter = 0;
		}

	}
	return 0;
}






