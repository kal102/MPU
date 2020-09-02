/*
 * km_gpio.h
 *
 *  Created on: 28.08.2020
 *      Author: Kacper
 */

#ifndef SRC_KM_GPIO_H_
#define SRC_KM_GPIO_H_

#include "xparameters.h"
#include "xgpio.h"
#include "km_gpio.h"

u8 init(XGpio *ledGpio);
void setLed(XGpio *ledGpio, int32_t leds);

#endif /* SRC_KM_GPIO_H_ */