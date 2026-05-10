#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Filename: SPIExample.py
Author: Michal Brejcha
Date: 2026-05-07
Version: 1.0
Description: Ukázka SPI komunikace pro předmět PPS - program je určen pro RPI3
"""

import spidev

class SPIExample:
    """
    Objekt ukázkového příkladu SPI komunikace
    """
    def __init__(self):
        """
        Nastavení SPI komunikace
        """
        self.__dev = spidev.SpiDev()
        self.__dev.open(bus=0, device=1)
        self.__dev.max_speed_hz = 100000

    def __del__(self):
        """
        Uzavření komunikace
        """
        if self.__dev is not None:
            self.__dev.close()

    def transaction_call(self):
        int_list = list(b'B1B13PPS\n')
        response = self.__dev.xfer2(int_list)
        print("Přijata zpráva: {0}".format(bytes(response).decode('ascii')))


if __name__ == '__main__':
    obj = SPIExample()
    obj.transaction_call()
