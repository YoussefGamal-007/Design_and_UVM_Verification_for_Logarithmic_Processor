from dec_to_lns import decimal_to_lns
from lns_to_dec import lns_to_decimal
from add_binary import add_binary_strings

def mult_div_log():

    x = float(input("Enter First Operand X: "))
    y = float(input("Enter second Operand Y: "))
    operation = input("Enter the Operation [mult / div]: ")
    operation = operation.lower().strip()


    # we need to calculate log2(x)
    logx = decimal_to_lns(x)
    print(logx)

    # we need to calculate log2(y)
    logy = decimal_to_lns(y)
    print(logy)


    # we need to choose the right ROM first
    if operation == "mult" :
        result = add_binary_strings(logx , logy , 'add')
        print(result)
        print(lns_to_decimal(result))

    elif operation == "div":
        result = add_binary_strings(logx , logy , 'sub')
        print(result)
        print(lns_to_decimal(result))


mult_div_log()
