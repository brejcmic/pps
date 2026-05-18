#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Filename: modbus_tcp_ukazka.py
Author: Michal Brejcha
Date: 2026-05-18
Version: 1.0
Description: Ukázka serveru modbus TCP
"""

import random
import threading
import time

from pymodbus.server import StartTcpServer
from pymodbus.datastore import (
    ModbusSequentialDataBlock,
    ModbusSlaveContext,
    ModbusServerContext,
)

# Založení paměťového prostoru
store = ModbusSlaveContext(
    co=ModbusSequentialDataBlock(0, [False, False, False, False, False]),
    di=ModbusSequentialDataBlock(0, [True, True, False, False, True]),
    hr=ModbusSequentialDataBlock(0, [100, 200, 300, 400, 500]),
    ir=ModbusSequentialDataBlock(0, [10, 20, 30, 40, 50]),
)

# registrace obsahu
context = ModbusServerContext(slaves=store, single=True)

# vlákno náhodného nastavení vstupů
def update_inputs():
    while True:
        slave = context[0]

        # Discrete Inputs, funkce 02
        di = [random.choice([False, True]) for _ in range(5)]
        slave.setValues(2, 0, di)

        # Input Registers, funkce 04
        ir = [random.randint(0, 1000) for _ in range(5)]
        slave.setValues(4, 0, ir)

        print("DI:", di, "IR:", ir)
        time.sleep(4)


# start vlákna nastavování vstupů
threading.Thread(target=update_inputs, daemon=True).start()


# start vlákna modbus serveru
StartTcpServer(
    context=context,
    address=("127.0.0.1", 502),
)