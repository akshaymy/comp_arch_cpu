###
import argparse 

parser= argparse.ArgumentParser(description='Instruction Generation Script')
parser.add_argument('--instr_format', dest='instr_format', type=str, help='instr_format', required=True)
parser.add_argument('--instr_type', dest='instr_type', type=str, help='instr_type', required=True)
parser.add_argument('--src1', dest='src1', type=int, help='src_reg1', required=True)
parser.add_argument('--src2', dest='src2', type=int, help='src_reg2')
parser.add_argument('--dest', dest='dest', type=int, help='dest_reg')
parser.add_argument('--imem_file_path', dest='imem_file_path', type=str, help='imem_file_path')
parser.add_argument('--imm_value', dest='imm_value', type=int, help='immediate_values')


args=parser.parse_args()

def StrToHex (string):
    strTohex = hex(int(string,2))
    prefixRemove = strTohex[2:]
    padded_hex = '{:0>8}'.format(prefixRemove)
    return padded_hex.upper()

def instruction_length_Rtype (instr_type,src1,src2,dest):
    if instr_type == "ADD":
       i = "0000000"+ src2 + src1 + "000" + dest + "0110011"

    elif instr_type == "SUB":
       i = "0100000"+ src2 + src1 + "000" + dest + "0110011"

    elif instr_type == "SLL":
       i = "0000000"+ src2 + src1 + "001" + dest + "0110011"    

    elif instr_type == "SLT":
       i = "0000000"+ src2 + src1 + "010" + dest + "0110011"

    elif instr_type == "SLTU":
       i = "0000000"+ src2 + src1 + "011" + dest + "0110011"

    elif instr_type == "XOR":
       i = "0000000"+ src2 + src1 + "100" + dest + "0110011"

    elif instr_type == "SRL":
       i = "0000000"+ src2 + src1 + "101" + dest + "0110011"

    elif instr_type == "SRA":
       i = "0100000"+ src2 + src1 + "101" + dest + "0110011"

    elif instr_type == "OR":
       i = "0000000"+ src2 + src1 + "110" + dest + "0110011"

    elif instr_type == "AND":
       i = "0000000"+ src2 + src1 + "111" + dest + "0110011"

    else:
       return 3

    return i

def instruction_length_Itype (instr_type,src1,imm_feild,dest):
    if instr_type == "ADDI":
        i = imm_feild + src1 + "000" + dest + "0010011"

    elif instr_type == "SLTI":
        i = imm_feild + src1 + "010" + dest + "0010011"

    elif instr_type == "SLTUI":
        i = imm_feild + src1 + "011" + dest + "0010011"

    elif instr_type == "XORI":
        i = imm_feild + src1 + "100" + dest + "0010011"

    elif instr_type == "ORI":
        i = imm_feild + src1 + "110" + dest + "0010011"

    elif instr_type == "ANDI":
        i = imm_feild + src1 + "111" + dest + "0010011"

    elif instr_type == "SLLI":
        i = "0000000"+ imm_feild + src1 + "001" + dest + "0010011"    

    elif instr_type == "SRLI":
        i = "0000000"+ imm_feild + src1 + "101" + dest + "0010011"

    elif instr_type == "SRAI":
        i = "0100000"+ imm_feild + src1 + "101" + dest + "0010011"

    else:
       return 3

    return i

def instruction_length_lw (src1, imm_feild, dest):
    i = imm_feild + src1 + "010" + dest + "0000011"
    return i

def instruction_length_sw (src1, src2, imm_feild):
    i = imm_feild[0:7] + src2 + src1 + "010" + imm_feild[7:12] + "0100011"
    return i

def instruction_length_branch (instr_type, src1, src2, imm_feild):
    if instr_type == "BEQ":
        #print("11: "+ imm_feild[0])
        #print("4-9: "+ imm_feild[2:8]) #Only starting address matters and the ending array will be minus 1. [2 to 8-1]
        #print("0-3: "+ imm_feild[8:12])
        #print("10: "+ imm_feild[1])
        i = imm_feild[0] + imm_feild[2:8] + src2 + src1 + "000" + imm_feild[8:12] + imm_feild[1] + "1100011"
    elif instr_type == "BNE":
        i = imm_feild[0] + imm_feild[2:8] + src2 + src1 + "001" + imm_feild[8:12] + imm_feild[1] + "1100011"
    elif instr_type == "BLT":
        i = imm_feild[0] + imm_feild[2:8] + src2 + src1 + "100" + imm_feild[8:12] + imm_feild[1] + "1100011"
    elif instr_type == "BGE":
        i = imm_feild[0] + imm_feild[2:8] + src2 + src1 + "101" + imm_feild[8:12] + imm_feild[1] + "1100011"
    elif instr_type == "BLTU":
        i = imm_feild[0] + imm_feild[2:8] + src2 + src1 + "110" + imm_feild[8:12] + imm_feild[1] + "1100011"
    elif instr_type == "BGEU":
        i = imm_feild[0] + imm_feild[2:8] + src2 + src1 + "111" + imm_feild[8:12] + imm_feild[1] + "1100011"
    else:
        return 3

    return i

def decimalTobinary_5bit (decimal):
    binary = "{0:b}".format(decimal)
    padded_bin = '{:0>5}'.format(binary)
    return (padded_bin)

def decimalTobinary_12bit (decimal):
    binary = "{0:b}".format(decimal)
    padded_bin = '{:0>12}'.format(binary)
    return (padded_bin)

def twos_complement_12bit (value):
    absolute = abs(value)
    binary = "{0:b}".format(absolute)
    padded_bin = '{:0>12}'.format(binary)
    final_list=[]
    for c in padded_bin:
        if int(c) == 0:
            final_list.append(str(1))
        else:
            final_list.append(str(0))
    
    final_string=''.join(final_list)

    twos_complement = (int(final_string,2)) + 1
    twos_complement_bin = bin(twos_complement)[2:]
    
    return (twos_complement_bin)

def twos_complement_5bit (value):
    absolute = abs(value)
    binary = "{0:b}".format(absolute)
    padded_bin = '{:0>5}'.format(binary)
    final_list=[]
    for c in padded_bin:
        if int(c) == 0:
            final_list.append(str(1))
        else:
            final_list.append(str(0))
    
    final_string=''.join(final_list)

    twos_complement = (int(final_string,2)) + 1
    twos_complement_bin = bin(twos_complement)[2:]
    
    return (twos_complement_bin)

def imem_file (format_type, file_path, string):
    if format_type == "rtype":
        padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.dest) + "," + "x" + str(args.src1) + "," + "x" + str(args.src2) + '\n'
    elif format_type == "itype":
        padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.dest) + "," + str(args.imm_value) + "(" + "x" + str(args.src1) + ")" + '\n'
    elif format_type == "mem":
        if args.instr_type == "SW":
            padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.src2) + "," + str(args.imm_value) + "(" + "x" + str(args.src1) + ")" + '\n'
        elif args.instr_type == "LW":
            padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.dest) + "," + str(args.imm_value) + "(" + "x" + str(args.src1) + ")" + '\n'
    elif format_type == "branch":
        if args.instr_type == "BEQ":
            padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.src1) + "," + "x" + str(args.src2) + "," + str(args.imm_value) + '\n'
    
    with open(file_path, 'a') as fp:
        fp.write(padded_string)

if __name__ == "__main__":
#    if (args.imm_value >= 0):
#        args_imm_value = args.imm_value
#    else:
#        absolute = abs(args.imm_value)
#        binary = "{0:b}".format(absolute)
#        padded_bin = '{:0>5}'.format(binary)
#        final_list=[]
#        for c in padded_bin:
#            if int(c) == 0:
#                final_list.append(str(1))
#            else:
#                final_list.append(str(0))
#       
#        final_string=''.join(final_list)
#
#        twos_complement = (int(final_string,2)) + 1
#        twos_complement_bin = bin(twos_complement)[2:]
#        print(twos_complement_bin)
                
    if args.instr_format == "rtype":
        padded_src1 = decimalTobinary_5bit(args.src1)
        padded_src2 = decimalTobinary_5bit(args.src2)
        padded_dest = decimalTobinary_5bit(args.dest)
        final_output_in_string = instruction_length_Rtype(args.instr_type,padded_src1,padded_src2,padded_dest)
        if final_output_in_string != 3:
            final_output_in_hex = StrToHex(final_output_in_string)
            imem_file(args.instr_format,args.imem_file_path,final_output_in_hex)
        else:
            print("USAGE: Please Enter Correct Instruction KeyWord")
            exit ()

    elif args.instr_format == "itype":
        padded_src1 = decimalTobinary_5bit(args.src1)
        padded_dest = decimalTobinary_5bit(args.dest)
        
        if args.instr_type != "SLLI" and args.instr_type != "SRLI" and args.instr_type != "SRAI":
            if (args.imm_value >= 0):
                padded_imm = decimalTobinary_12bit(args.imm_value)
            else:
                padded_imm = twos_complement_12bit(args.imm_value)
        else:
            if (args.imm_value >= 0):
                padded_imm = decimalTobinary_5bit(args.imm_value)
            else:
                padded_imm = twos_complement_5bit(args.imm_value)
         
        final_output_in_string = instruction_length_Itype(args.instr_type,padded_src1,padded_imm,padded_dest)
        
        if final_output_in_string != 3:
            padded_imm = decimalTobinary_5bit(args.imm_value)
            final_output_in_hex = StrToHex(final_output_in_string)
            imem_file(args.instr_format,args.imem_file_path,final_output_in_hex)
        else:
            print("USAGE: Please Enter Correct Instruction KeyWord")
            exit ()

    elif args.instr_format == "mem":
        if (args.imm_value >= 0):
            padded_imm = decimalTobinary_12bit(args.imm_value)
        else:
            padded_imm = twos_complement_12bit(args.imm_value)

        padded_src1 = decimalTobinary_5bit(args.src1)
        
        if args.instr_type == "LW":
            padded_dest = decimalTobinary_5bit(args.dest)
            final_output_in_string = instruction_length_lw(padded_src1,padded_imm,padded_dest)
        
        elif args.instr_type == "SW":
            padded_src2 = decimalTobinary_5bit(args.src2)
            final_output_in_string = instruction_length_sw(padded_src1,padded_src2,padded_imm)

        final_output_in_hex = StrToHex(final_output_in_string)
        imem_file(args.instr_format,args.imem_file_path,final_output_in_hex)

    elif args.instr_format =="branch":
        padded_src1 = decimalTobinary_5bit(args.src1)
        padded_src2 = decimalTobinary_5bit(args.src2)
       
        #print("Padded_Src1: " + padded_src1)
        #print("Padded_Src2: " + padded_src2)

        if (args.imm_value >= 0):
            padded_imm = decimalTobinary_12bit(args.imm_value)
        else:
            padded_imm = twos_complement_12bit(args.imm_value)
        
        #print("Imm: " + padded_imm)
        final_output_in_string = instruction_length_branch(args.instr_type, padded_src1, padded_src2, padded_imm)

        #print("Final_Output_In_string: " + final_output_in_string)

        if final_output_in_string != 3:
            final_output_in_hex = StrToHex(final_output_in_string)
            imem_file(args.instr_format,args.imem_file_path,final_output_in_hex)
            #print("Final_Output_In_HEX: " + final_output_in_hex)
        else:
            print("USAGE: Please Enter Correct Instruction KeyWord")
            exit ()




