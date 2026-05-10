#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Filename: ascii_driver.py
Author: Michal Brejcha
Date: 2026-05-07
Version: 1.0
Description: Ukázka komunikace s prostředím ControlWeb
"""

import serial

class AsciiDriver:
    """
    Objekt ukázkového příkladu sériové komunikace
    """
    def __init__(self):
        """
        Nastavení sériové komunikace
        """
        self.__dev = serial.Serial(port='/dev/serial0',
                                   baudrate=115200,
                                   parity=serial.PARITY_NONE,
                                   stopbits=serial.STOPBITS_ONE,
                                   timeout=2)
        self.__bytes_cnt = 0

    def __del__(self):
        """
        Uzavření komunikace
        """
        if self.__dev is not None and self.__dev.is_open:
            self.__dev.close()

    def transaction_call(self):
        response = self.__dev.readline()
        if len(response) > 0:
            print(response)
            if response == b'LED0H\n':
                print("Green ---> Blue [XX]")
                self.__dev.write(b'LED1H\n')
                self.__dev.flush()
            else:
                print("Green ---> Blue [  ]")
                self.__dev.write(b'LED1L\n')
                self.__dev.flush()

if __name__ == '__main__':
    obj = AsciiDriver()

    while True:
        obj.transaction_call()
