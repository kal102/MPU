/*
 * main.c
 *
 *  Created on: 22.08.2020
 *      Author: Kacper
 */

#include "mb_interface.h"

#define MAX_COUNT 1000
#define BUFFER_SIZE 16

/*
 * Write 16 32-bit words as efficiently as possible.
 */
static void inline write_axis(volatile unsigned int *a)
{
    register int a0,  a1,  a2,  a3;
    register int a4,  a5,  a6,  a7;
    register int a8,  a9,  a10, a11;
    register int a12, a13, a14, a15;

    a3  = a[3];  a1  = a[1];  a2  = a[2];  a0  = a[0];
    a7  = a[7];  a5  = a[5];  a6  = a[6];  a4  = a[4];
    a11 = a[11]; a9  = a[9];  a10 = a[10]; a8  = a[8];
    a15 = a[15]; a13 = a[13]; a14 = a[14]; a12 = a[12];

    putfsl(a0,  0); putfsl(a1,  1); putfsl(a2,  2); putfsl(a3,  3);
    putfsl(a4,  4); putfsl(a5,  5); putfsl(a6,  6); putfsl(a7,  7);
    putfsl(a8,  8); putfsl(a9,  9); putfsl(a10, 10); putfsl(a11, 11);
    putfsl(a12, 12); putfsl(a13, 13); putfsl(a14, 14); putfsl(a15, 15);
}

/*
 * Read 16 32-bit words as efficiently as possible.
 */
static void inline read_axis(volatile unsigned int *a)
{
    register int a0,  a1,  a2,  a3;
    register int a4,  a5,  a6,  a7;
    register int a8,  a9,  a10, a11;
    register int a12, a13, a14, a15;

    getfsl(a0,  0); getfsl(a1,  0); getfsl(a2,  0); getfsl(a3,  0);
    getfsl(a4,  0); getfsl(a5,  0); getfsl(a6,  0); getfsl(a7,  0);
    getfsl(a8,  0); getfsl(a9,  0); getfsl(a10, 0); getfsl(a11, 0);
    getfsl(a12, 0); getfsl(a13, 0); getfsl(a14, 0); getfsl(a15, 0);

    a[3]  = a3;  a[1]  = a1;  a[2]  = a2;  a[0]  = a0;
    a[7]  = a7;  a[5]  = a5;  a[6]  = a6;  a[4]  = a4;
    a[11] = a11; a[9]  = a9;  a[10] = a10; a[8]  = a8;
    a[15] = a15; a[13] = a13; a[14] = a14; a[12] = a12;
}

int main()
{
    volatile unsigned int outbuffer[BUFFER_SIZE] = {
       0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf
    };
    volatile unsigned int inbuffer[BUFFER_SIZE];
    int count = 0;
    int i;

    /* Perform transfers */
    //while (count++ < MAX_COUNT) {
    //    write_axis(outbuffer);
    //    read_axis(inbuffer);
    //}
    for (i=0; i<20; i++){
    	putfsl(i, 0);
    	putfsl(i, 1);
    	putfsl(i, 2);
    	putfsl(i, 3);
    	putfsl(i, 4);
    	putfsl(i, 5);
    }

    return 0;
}