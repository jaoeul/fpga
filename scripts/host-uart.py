#!/usr/bin/env python3

import time

from pylibftdi import Device, Driver, INTERFACE_B

if __name__ == "__main__":
    with Device(mode="b", interface_select=INTERFACE_B) as dev:
    #with Device(mode="b") as dev:
        dev.baudrate = 115200

        i = 0
        while True:
            print("> ", end="")
            tx = input().encode("UTF-8")
            if tx == b"q":
                exit(0)

            dev.write(tx)
            print(f"Wrote: {tx}")
            i += 1
