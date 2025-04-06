from dec_to_lns import decimal_to_lns
from lns_to_dec import lns_to_decimal

def pow_sqrt_log():

    x = float(input("Enter First Operand X: "))
    y = float(input("Enter second Operand Y: "))
    operation = input("Enter the Operation [pow / sqrt]: ")
    operation = operation.lower().strip()


    # we need to calculate log2(x)
    logx = decimal_to_lns(x)
    print(logx)

    # we need to calculate log2(y)
    logy = decimal_to_lns(y)
    print(logy)


    # in power by 2 >> shift left by 0
    if operation == "pow" :
        powx = logx[0] + logx[2:16] + '0'      # [2:16] == (from index 2 till 15, inclusive)
        powy = logy[0] + logy[2:16] + '0'
        print(f"{powx} -------- {powy}")
        print(f"{lns_to_decimal(powx)} -------- {lns_to_decimal(powy)}")

    elif operation == "sqrt":
        sqrtx = logx[0] + '0' + logx[1:15]        #[1:15] == (from index 1 till 14, inclusive)
        sqrty = logy[0] + '0' + logy[1:15]        # shift right by 0
        print(f"{sqrtx} , {sqrty}")
        print(f"{lns_to_decimal(sqrtx)} -------- {lns_to_decimal(sqrty)}")


pow_sqrt_log()
