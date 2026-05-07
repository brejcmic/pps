#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Filename: SerialExample.py
Author: Michal Brejcha
Date: 2026-05-07
Version: 1.0
Description: Ukázka sériové komunikace pro předmět PPS - program je určen pro RPI3
"""

import serial

class SerialExample:
    """
    Objekt ukázkového příkladu sériové komunikace
    """
    def __init__(self):
        """
        Nastavení sériové komunikace
        """
        self.__dev = serial.Serial(port='/dev/serial0',
                                   baudrate=115200,
                                   parity=serial.PARITY_EVEN,
                                   stopbits=serial.STOPBITS_ONE,
                                   timeout=2)
        self.__bytes_cnt = 0

    def transaction_call(self):
        self.__bytes_cnt = self.__dev.write(b'B1B13PPS\n')
        self.__dev.flush()
        response = self.__dev.read(size=self.__bytes_cnt)
        print("Přijata zpráva: {0}".format(response))


if __name__ == '__main__':
    obj = SerialExample()
    obj.transaction_call()