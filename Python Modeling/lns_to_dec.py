
def lns_to_decimal(lns_value):
    """
    Convert a Logarithmic Number System (LNS) representation back to decimal.
    The LNS value is represented as a 16-bit string:
    - 1 bit for sign
    - 15 bits for the 2's complement fixed-point exponent (5 bits integer, 10 bits fraction)

    Args:
        lns_value (str): A 16-bit string representing the LNS value

    Returns:
        float: The decimal value corresponding to the LNS representation
    """
    # Validate input
    if len(lns_value) != 16:
        raise ValueError("LNS value must be a 16-bit string")

    # Extract the sign bit (first bit)
    sign_bit = int(lns_value[0])

    # Extract the exponent bits (remaining 15 bits)
    exponent_bits = lns_value[1:]

    # Convert exponent bits to a list of integers
    exponent_bits_list = [int(bit) for bit in exponent_bits]

    # Check if the exponent is in two's complement negative form (MSB = 1)
    is_negative_exponent = exponent_bits_list[0] == 1

    if is_negative_exponent:
        # Convert from two's complement back to a positive representation
        # Find the first 1 from the right
        found_first_one = False
        for i in range(len(exponent_bits_list)-1, -1, -1):
            if found_first_one:
                exponent_bits_list[i] = 1 - exponent_bits_list[i]  # Invert bits
            elif exponent_bits_list[i] == 1:
                found_first_one = True  # Found the first 1, keep it and set flag

    # Separate integer and fraction parts (5 bits integer, 10 bits fraction)
    integer_bits = exponent_bits_list[:5]
    fraction_bits = exponent_bits_list[5:]

    # Convert integer part to decimal
    integer_value = 0
    for i in range(5):
        integer_value += integer_bits[i] * pow(2, 4-i)

    # Convert fraction part to decimal
    fraction_value = 0
    for i in range(10):
        fraction_value += fraction_bits[i] * pow(2, -(i+1))

    # Combine integer and fraction parts to get the exponent value
    exponent_value = integer_value + fraction_value

    # If the original exponent was negative, negate the value
    if is_negative_exponent:
        exponent_value = -exponent_value

    # Calculate the actual decimal value using the exponent (2^exponent)
    decimal_value = pow(2, exponent_value)

    # Apply the sign
    if sign_bit == 1:
        decimal_value = -decimal_value

    return decimal_value


print(lns_to_decimal('0001111100100000'))

