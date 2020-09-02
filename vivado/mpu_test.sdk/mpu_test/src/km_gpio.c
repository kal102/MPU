/*
 * km_gpio.c
 *
 *  Created on: 28.08.2020
 *      Author: Kacper
 */
#include "xparameters.h"
#include "xgpio.h"


#define CORDIC_IP_S00_AXI_SLV_REG0_OFFSET 0
#define CORDIC_IP_S00_AXI_SLV_REG1_OFFSET 4
/**************************** user definitions ********************************/
#define CHANNEL 1

//processor registers' offset redefinition
#define CONTROL_REG_OFFSET CORDIC_IP_S00_AXI_SLV_REG0_OFFSET
#define LED_REG_OFFSET CORDIC_IP_S00_AXI_SLV_REG1_OFFSET

/***************************** Other functions *******************************/

u8 init(XGpio *ledGpio){
	int status;

	/* Initialize driver for the input angle GPIOe */
	status = XGpio_Initialize(ledGpio, XPAR_AXI_GPIO_0_DEVICE_ID);
	if (status != XST_SUCCESS) {
		return 1;
	}
	XGpio_SetDataDirection(ledGpio, CHANNEL, 0x000);
	XGpio_DiscreteWrite(ledGpio, CHANNEL, 0x000);
	return 0;
}

void setLed(XGpio *ledGpio, int32_t led_index)
{
	int32_t old_state;

	old_state = XGpio_DiscreteRead(ledGpio, CHANNEL);
	XGpio_DiscreteWrite(ledGpio, CHANNEL, old_state | 1<<led_index);
}