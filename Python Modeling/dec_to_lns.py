from dec_to_bin import decimal_to_bin
import math

def decimal_to_lns(decimal_value):

    sign = []
    sign.append( (1 if decimal_value < 0 else 0) )

    abs_value = abs(decimal_value)
    log_value = math.log2(abs_value)
    exponent = decimal_to_bin(log_value)

    logarithmic_bits = sign + exponent
   # logarithmic_bits.append(sign , exponent)

    formated_output = ''.join(map(str,logarithmic_bits))

    #print(f"Sign Bit: {sign}")
    return formated_output


print (decimal_to_lns(-10))

