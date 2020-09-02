/*
 * km_axis.c
 *
 *  Created on: 28.08.2020
 *      Author: Kacper
 */
#include "km_axis.h"

void Load(unsigned int buffer, unsigned int indexA, unsigned int indexB, unsigned int rows, unsigned int columns, volatile int *data){
	unsigned int i;

	// Command
	putfsl(CMD_LOAD, 0);
	// Buffer A/B
	putfsl(buffer, 0);
	// Buffer A index
	putfsl(indexA, 0);
	// Buffer B index
	putfsl(indexB, 0);
	// Rows
	putfsl(rows, 0);
	// Columns
	putfsl(columns, 0);
	// Reserved
	putfsl(0, 0);
	// Data
	for(i=0; i<rows*columns-1; i++){
		putfsl(data[i], 0);
	}
	cputfsl(data[i], 0);
}

void Multiply(unsigned int indexA, unsigned int indexB, int bias){
	// Command
	putfsl(CMD_MULTIPLY, 0);
	// Buffer A/B
	putfsl(0, 0);
	// Buffer A index
	putfsl(0, 0);
	// Buffer B index
	putfsl(2, 0);
	// Bias
	putfsl(255, 0);
	putfsl(255, 0);
	putfsl(255, 0);
	putfsl(256+bias, 0);
	// Activation
	putfsl(ACTIVATION_NONE, 0);
	// Pooling
	cputfsl(POOLING_NONE, 0);
}

u8 CompareResults(unsigned int rows, unsigned int columns, volatile int *data){
	register int x;
	unsigned i;
	u8 val;

	val=1;
	// Frame Type
	getfsl(x,  0);
	if(x != 1) val = 0;
	getfsl(x,  0);
	// Reserved
	// Rows
	// Reserved
	// Columns
	// Data
	for(i=0; i<rows*columns; i++){
		getfsl(x, 0);
		if(x != data[i]) val = 0;
	}
	return val;
}