def add_binary_strings(bin1, bin2, operation):
    """
    Performs addition or subtraction on two 16-bit binary strings based on the operation parameter.

    Parameters:
    - bin1 (str): First 16-bit binary string.
    - bin2 (str): Second 16-bit binary string.
    - operation (str): "add" for addition, "sub" for subtraction.

    Returns:
    - str: A 16-bit binary string representing the result.

    Raises:
    - ValueError: If inputs are not 16-bit binary strings or if operation is invalid.
    """
    # Validate that both inputs are 16-bit binary strings
    if len(bin1) != 16 or len(bin2) != 16 or not all(c in '01' for c in bin1 + bin2):
        raise ValueError("Both inputs must be 16-bit binary strings containing only '0' or '1'")

    # Validate the operation parameter
    if operation not in ["add", "sub"]:
        raise ValueError("Operation must be 'add' or 'sub'")

    # Convert binary strings to integers
    num1 = int(bin1, 2)
    num2 = int(bin2, 2)

    # Perform the specified operation
    if operation == "add":
        # Addition with overflow handling (modulo 2^16)
        result = (num1 + num2) % (1 << 16)
    elif operation == "sub":
        # Subtraction with underflow handling (2's complement for negatives)
        result = num1 - num2
        if result < 0:
            result = (1 << 16) + result  # Convert negative result to 16-bit 2's complement

    # Convert result to a 16-bit binary string
    binary_result = bin(result)[2:]  # Remove '0b' prefix
    return binary_result.zfill(16)   # Pad with leading zeros to ensure 16 bits

