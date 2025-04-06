
def decimal_to_bin (decimal_value):

    # check if i will need to 2's complement the answer at the end
    twos_comp = 1 if decimal_value < 0 else 0

    # extract the integer and fraction parts to convert each one alone
    abs_value = abs(decimal_value)
    integer_part = int(abs_value)
    fraction_part = abs_value - integer_part


    # assume all are zeros in the start
    integer_bits  =  [0]  *  5           # 5 bits for integer
    fraction_bits =  [0]  * 10           # 10 bits for fraction


    ########### Generating Integer Bits #############
    # i start from 4 to 0
    for i in reversed(range(5)):         # moving from MSB(2^4) weight to LSB(2^0)
        weight = pow(2,i)                # current index weight
        remaining = integer_part - weight

        if remaining >= 0:
            integer_bits[4-i] = 1        # MSB is index [0] in the array / LSB is [4]
            integer_part = remaining
            #print(integer_bits)


    ############ Generating Fraction Bits ##############
    # i start from 0 to 9
    for i in range(10):                  # moving from MSB(2^-1) to LSB(2^-10)
        weight = pow(2,-(i+1))           # weights starts from -1 no 0 in fraction
        remaining = fraction_part - weight

        if remaining >= 0:
            fraction_bits[i] = 1       # MSB is index [0] in the array / LSB is [9]
            fraction_part = remaining
            #print(fraction_bits)


    ########### 2's Complementing #############
    all_bits = integer_bits + fraction_bits

    if twos_comp == 1:
        found_first_one = False
        for i in reversed(range(len(all_bits))):

            if found_first_one:
                all_bits[i] = 1 - all_bits[i]   # Invert bits after finding the first 1

            elif all_bits[i] == 1:
                found_first_one = True          # Found the first 1, keep it and set flag


    #print(f"Unsigned Integer Bits: {integer_bits}")
    #print(f"Unsigned Fraction Bits: {fraction_bits}")
    # We are DONE
    return all_bits



#print(decimal_to_bin(-9.828))   # testing


