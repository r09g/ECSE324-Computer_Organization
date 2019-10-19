// This C program finds the maximum value in an array

int main(){
		int a[5] = {1, 20, 3, 4, 5};	// array of values	
		int i = 1;	// used for for-loop
		int max_val = a[0];	// the initial value of the maximum
		for(i; i < sizeof(a)/sizeof(a[0]); i++){	// loop through the remaining values in the list
			if (a[i] > max_val){	// if there is a new maximum
				max_val = a[i];		// update the maximum
			}
		}
		printf("The max is: %d\n",max_val);	// display maximum in terminal
		return max_val;		// return the max of the array (stored in R4)

}
