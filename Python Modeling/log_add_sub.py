from dec_to_lns import decimal_to_lns
from lns_to_dec import lns_to_decimal
from add_binary import add_binary_strings
from phi_ROM import phi_rom
import math


def add_sub_log():  # |x| >= |y| this is an assumption

    x = float(input("Enter First Operand X: "))
    y = float(input("Enter second Operand Y: "))
    operation = input("Enter the Operation [add / sub]: ")
    operation = operation.lower().strip()

    step = pow(2,-10)
    entries = 2 ** 14
    rom_phi_plus  =  [0] *  (entries + 1)
    rom_phi_minus =  [0] *  (entries + 1)

    rom_phi_plus , rom_phi_minus = phi_rom()

    # we need to calculate log2(x)
    logx = decimal_to_lns(x)
    print(logx)

    # we need to get the right address >> ( ly - lx = -16 + [{16384-A} * step] )
    temp = math.log2(abs(y)) - math.log2(abs(x))
    temp = temp + 16
    temp = temp / step
    A = int(16384 - temp)
    print(A)

    # we need to choose the right ROM first
    if operation == "add" :
        result = add_binary_strings(logx , rom_phi_plus[A] , 'add')
        print(result)
        print(lns_to_decimal(result))

    elif operation == "sub":
        result = add_binary_strings(logx , rom_phi_minus[A] , 'add')
        print(rom_phi_minus[A])
        print(lns_to_decimal(rom_phi_minus[A]))
        print(result)
        print(lns_to_decimal(result))



add_sub_log()
