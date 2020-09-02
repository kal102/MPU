/*
 * main.c
 *
 *  Created on: 28.08.2020
 *      Author: Kacper
 */


#include "xparameters.h"
#include "xgpio.h"
#include "math.h"
#include "km_gpio.h"
#include "km_axis.h"

/***************************** Main function *********************************/

int main()
{
	XGpio ledGpio;

	// A:
	// |  36 -127    9 |
	//
	// B:
	// |  99   13 -115 |
	// | 101   18    1 |
	// |  13  118   61 |
	//
	// C_predicted:
	// |    -9150      -760     -3722 |
    volatile int A[3] = {36, -127, 9};
    volatile int B[9] = {99, 101, 13, 13, 18, 118, -115, 1, 61};
    volatile int C_predicted[3] = {-9150, -760, -3722};

	/* Init GPIO leds */
	if(init(&ledGpio)) {
		goto FAILURE;
	}

	// Run matrix multiplication test
    /* Send matrix A over AXI stream */
	Load(BUFFER_A, 0, 0, 1, 3, A);
	setLed(&ledGpio, 0);// set LD0
	/* Send matrix B over AXI stream */
	Load(BUFFER_B, 0, 2, 3, 3, B);
	setLed(&ledGpio, 1);// set LD1
	/* Send multiply command through AXI stream */
	Multiply(0, 2, -4);
	setLed(&ledGpio, 2);// set LD2
	/* Load result matrix from AXI stream and compare it with predicted data*/
	if(CompareResults(1, 3, C_predicted)){// result is correct
		setLed(&ledGpio, 3);// set LD3
	}
	else{//result is not correct
		setLed(&ledGpio, 4);// set LD4
	}

	/* Failure or end trap */
	FAILURE:
	while(1);
}
