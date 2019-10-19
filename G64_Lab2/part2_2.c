// This program finds the maximum value of an array using the MIN_2 subroutine
// Date: 20191018
// Author: Raymond Yang, Chang Zhou

extern int MIN_2 (int x, int y); // the subroutine, external linkage
int main(){
		int a[5] = {1, 20, 3, 4, 5};	// values
		int max_val = a[0];	// assume initial maximum
		int min_val;	// used to store minimum found
		int i = 1;	// used for for-loop counting
		for(i; i < sizeof(a)/sizeof(a[0]); i++){
			min_val = MIN_2(a[i], max_val);	// call subroutine to find mininmum of two numbers
			if (min_val == max_val){	// if the current maximum is the minimum of the two numbers
				max_val = a[i];	// then the other number (bigger) is the new maximum
			}
		}
		printf("The max is %d\n",max_val);	// display maximum
		return max_val;

}
