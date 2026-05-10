#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Filename: I2CExample.py
Author: Michal Brejcha
Date: 2026-05-07
Version: 1.0
Description: Ukázka I2C komunikace pro předmět PPS - program je určen pro RPI3
"""

import smbus2

class I2CExample:
    """
    Objekt ukázkového příkladu I2C komunikace
    """
    def __init__(self):
        """
        Nastavení SPI komunikace
        """
        self.__dev = smbus2.SMBus(bus=1)

    def __del__(self):
        """
        Uzavření komunikace
        """
        if self.__dev is not None and self.__dev.is_open:
            self.__dev.close()

    def transaction_call(self):
        int_list = [ord(i) for i in 'B1B13PPS\n'.split()]
        self.__dev.write_i2c_block_data(i2c_addr=44, register=9, data=int_list)


if __name__ == '__main__':
    obj = I2CExample()
    obj.transaction_call()