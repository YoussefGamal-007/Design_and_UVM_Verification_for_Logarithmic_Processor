from dec_to_lns import decimal_to_lns

def phi_rom():
    entries = 2 ** 14
    rom_phi_plus  =  [0] *  (entries + 1)
    rom_phi_minus =  [0] *  (entries + 1)

    step = pow(2,-10)

    for address in range(entries + 1):

        # d = ly - lx
        d = -16 + (address * step)
        two_d = 2 ** d
        rom_phi_plus[16384 - address] = decimal_to_lns(1 + two_d)

        if (two_d == 1):
            rom_phi_minus[0] = decimal_to_lns(pow(2,-16))           # log(1-1) ## error
        else:
            rom_phi_minus[16384 - address] = decimal_to_lns(1 - two_d)

    return rom_phi_plus , rom_phi_minus

    # if(0 <= address <= 100):
    #     print(f"\nd >> {d}")
    #     print(address)
    #     print(f"d in binary >> {decimal_to_bin(d)}")
    #     print(f"PHI- >> {rom_phi_minus[16384 - address]}")
    #     print(f"PHI+ >> {rom_phi_plus[16384 - address]}\n")


def export_rom_data():
    """
    Generate ROM data and export it to text files for use with SystemVerilog $readmemb
    """
    # Generate the ROM data
    rom_phi_plus, rom_phi_minus = phi_rom()

    # Export phi_plus ROM to text file
    with open('rom_phi_plus.txt', 'w') as f:
        for value in rom_phi_plus:
            # Ensure value is a string - if it's not already
            if not isinstance(value, str):
                value = ''.join(map(str, value))
            f.write(f"{value}\n")

    # Export phi_minus ROM to text file
    with open('rom_phi_minus.txt', 'w') as f:
        for value in rom_phi_minus:
            # Ensure value is a string - if it's not already
            if not isinstance(value, str):
                value = ''.join(map(str, value))
            f.write(f"{value}\n")

    print(f"Successfully exported {len(rom_phi_plus)} entries to rom_phi_plus.txt")
    print(f"Successfully exported {len(rom_phi_minus)} entries to rom_phi_minus.txt")

export_rom_data()
