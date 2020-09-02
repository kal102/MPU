/*
 * km_axis.h
 *
 *  Created on: 28.08.2020
 *      Author: Kacper
 */

#ifndef SRC_KM_AXIS_H_
#define SRC_KM_AXIS_H_

#include "mb_interface.h"

/* MPU commands */
#define CMD_NONE     0
#define CMD_LOAD     1
#define CMD_MULTIPLY 2

/* Buffer */
#define BUFFER_A 0
#define BUFFER_B 1

/* Activation functions */
#define ACTIVATION_NONE 0
#define ACTIVATION_RELU 1

/* Pooling functions */
#define POOLING_NONE 0
#define POOLING_MAX  1

/* Frame types */
#define FRAME_NONE      0
#define FRAME_DATA      1
#define FRAME_ERR_DIM   3
#define FRAME_ERR_CMD   2
#define FRAME_ERR_FRAME 6

void Load(unsigned int buffer, unsigned int indexA, unsigned int indexB, unsigned int rows, unsigned int columns, volatile int *data);
void Multiply(unsigned int indexA, unsigned int indexB, int bias);
u8 CompareResults(unsigned int rows, unsigned int columns, volatile int *data);

#endif /* SRC_KM_AXIS_H_ */