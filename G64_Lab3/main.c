// C code for tests 
// Date: 20191103
// Author: Raymond Yang, Chang Zhou

// c header files
#include <stdio.h>
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/address_map_arm.h"

/*
// TEST FOR LEDS & SLIDER SWICTH
int main() {
	while(1) {
		write_LEDs_ASM(read_slider_switches_ASM());
	}
	return 0;
}
*/


/*
// TEST FOR HEX DISPLAY:
int main() {
	HEX_write_ASM(HEX1 | HEX2 | HEX3 | HEX4 | HEX5 | HEX0, 0);
	HEX_clear_ASM(HEX1 | HEX2 | HEX3);
	return 0;
}
*/


/*
// TEST FOR HEX DISPLAY & LED & PUSHBUTTONS & SLIDERSWITCHES
int main() {
	while(1) {
		int slider_switches = read_slider_switches_ASM();	// read current state of slider switches
		write_LEDs_ASM(slider_switches);			// activate LEDs based on active slider switches
		if (slider_switches >= 0b1000000000){			// if the 10th switch is on
			HEX_clear_ASM(HEX1 | HEX2 | HEX3 | HEX4 | HEX5 | HEX0);		// clear all values	
		}else{
			HEX_write_ASM(HEX4, 8);				// all segments of the leftmost LEDs are always on
			HEX_write_ASM(HEX5, 8);				
			char val = 0b1111 & slider_switches;		// store the slider switch states in "val"
			while(PB_data_is_pressed_ASM(PB0)||PB_data_is_pressed_ASM(PB1)||PB_data_is_pressed_ASM(PB2)||PB_data_is_pressed_ASM(PB3)){
				// if any button is pressed (hold on)
				slider_switches = read_slider_switches_ASM();		// read state of slider switches
				if (slider_switches >= 0b1000000000){
					break;				// nothing will appear if the 10th switch is active
				}
				if (0b0001 & read_PB_data_ASM()){
					// if the first button is pressed (PB0)
					HEX_write_ASM(HEX0, val);	// write to the right most LED
				}
				if (0b0010 & read_PB_data_ASM()){
					// if the button PB1 is pressed
					HEX_write_ASM(HEX1, val);	// write to LED1
				}
				if (0b0100 & read_PB_data_ASM()){
					// if the button PB2 is pressed
					HEX_write_ASM(HEX2, val);	// write to LED2
				}
				if (0b1000 & read_PB_data_ASM()){
					// if the button PB3 is pressed
					HEX_write_ASM(HEX3, val);	// write to LED3
				}
			}
			HEX_clear_ASM(HEX1 | HEX2 | HEX3 | HEX0);	// clear all displays if button is released
		}
	}
	return 0;
}
*/


// TEST FOR STOPWATCH
int main() {
	int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;	// initialization
	int active = 0;
	HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);			// display all 0 at beginning
	
	// configure timer for stopwatch
	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000; // 0.01 sec  = 10 millisec
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
	HPS_TIM_config_ASM(&hps_tim);

	// configure timer for polling push buttons
	HPS_TIM_config_t hps_tim_pb;

	hps_tim_pb.tim = TIM1;
	hps_tim_pb.timeout = 100; // 0.001 sec  = 1 millisec
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 1;
	hps_tim_pb.enable = 1;
	HPS_TIM_config_ASM(&hps_tim_pb);

	while(1) {
		if(HPS_TIM_read_INT_ASM(TIM1)){			// timer reaches 0
				HPS_TIM_clear_INT_ASM(TIM1);
				if (read_PB_edgecap_ASM() == 2){	// PB1 pressed = stop	
					active = 0;			// do not count and update the LED display 
				}
				if (read_PB_edgecap_ASM() == 4){	// PB2 pressed = reset
					HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);	// clear to 0
					count0 = 0;	// set all counts to 0 to restart counting
					count1 = 0;
					count2 = 0;
					count3 = 0;
					count4 = 0;
					count5 = 0;
				}
				if (read_PB_edgecap_ASM() == 1){	// PB0 pressed = start
					active = 1;			// start counting and updating LED display
				}
				PB_clear_edgecap_ASM(PB0 | PB1 | PB2);	// clear the edgecapture register for all push buttons	
			}
		
		if (active){
			if(HPS_TIM_read_INT_ASM(TIM0)){
				HPS_TIM_clear_INT_ASM(TIM0);	
				if(++count0 == 10) {	// ms
					count0 = 0;
					if (++count1 == 10){
						count1 = 0;
						if (++count2 == 10){	// s
							count2 = 0;
							if (++count3 == 6){
								count3 = 0;
								if (++count4 == 10){	// min
									count4 = 0;
									if (++count5 == 6){
										count5 = 0;
									}
								}
							}
						}
					}
				}
				// update hex displays
				HEX_write_ASM(HEX0, count0);
				HEX_write_ASM(HEX1, count1);
				HEX_write_ASM(HEX2, count2);
				HEX_write_ASM(HEX3, count3);
				HEX_write_ASM(HEX4, count4);
				HEX_write_ASM(HEX5, count5);
			}
		}
	}
	return 0;
}


/*
int main(){
	int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0, active = 0;		// initialization
	int_setup(2, (int []){199,73});		// the HPS timer interrupt and FPGA push button interrupt IDs
	HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);	// display all 0 in the beginning
	
	// configure timer for stopwatch
	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000; // 0.01 sec  = 10 millisec
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
	
	HPS_TIM_config_ASM(&hps_tim);

	enable_PB_INT_ASM(PB0 | PB1 | PB2);	// enable interrupt capability for all push buttons

	while(1){
		if(active){
			if(hps_tim0_int_flag){
				hps_tim0_int_flag = 0;
				if(++count0 == 10) {	// ms	
					count0 = 0;
					if (++count1 == 10){
						count1 = 0;
						if (++count2 == 10){	// s
							count2 = 0;
							if (++count3 == 6){
								count3 = 0;
								if (++count4 == 10){	// min
									count4 = 0;
									if (++count5 == 6){
										count5 = 0;
									}
								}
							}
						}
					}
				}
				// update HEX displays
				HEX_write_ASM(HEX0, count0);
				HEX_write_ASM(HEX1, count1);
				HEX_write_ASM(HEX2, count2);
				HEX_write_ASM(HEX3, count3);
				HEX_write_ASM(HEX4, count4);
				HEX_write_ASM(HEX5, count5);			
			}
		}

		// if PB0 = start is selected
		if(fpga_pb_int_flag == 1){
			fpga_pb_int_flag = 0;
			active = 1;	// start
		// if PB1 = stop or PB1+PB2 = start and stop are both selected
		}else if(fpga_pb_int_flag == 2 || fpga_pb_int_flag == 3){
			fpga_pb_int_flag = 0;
			active = 0;	// stop overrides the start
		// if PB2 = clear is selected
		}else if(fpga_pb_int_flag == 4){
			fpga_pb_int_flag = 0;	
			HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);	// clear all values to 0
			count0 = 0;	// clear all counts
			count1 = 0;
			count2 = 0;
			count3 = 0;
			count4 = 0;
			count5 = 0;
		// if PB2 = clear and PB1 = stop are both pressed together
		}else if(fpga_pb_int_flag == 6){
			fpga_pb_int_flag = 0;
			active = 0;	// stop counting and updating values
			count0 = 0;	// reset all counts
			count1 = 0;
			count2 = 0;
			count3 = 0;
			count4 = 0;
			count5 = 0;
			HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);	// update the LED display so they show 0
		}else{// do nothing}
	}
	return 0;
}
*/
