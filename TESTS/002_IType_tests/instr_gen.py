###
import argparse 

parser= argparse.ArgumentParser(description='Instruction Generation Script')
parser.add_argument('--instr_format', dest='instr_format', type=str, help='instr_format', required=True)
parser.add_argument('--instr_type', dest='instr_type', type=str, help='instr_type', required=True)
parser.add_argument('--src1', dest='src1', type=int, help='src_reg1', required=True)
parser.add_argument('--src2', dest='src2', type=int, help='src_reg2')
parser.add_argument('--dest', dest='dest', type=int, help='dest_reg', required=True)
parser.add_argument('--imem_file_path', dest='imem_file_path', type=str, help='imem_file_path')
parser.add_argument('--rf_values_path', dest='rf_values_path', type=str, help='rf_values_path')
parser.add_argument('--imm_value', dest='imm_value', type=int, help='immediate_values')


args=parser.parse_args()

def StrToHex (string):
    strTohex = hex(int(string,2))
    prefixRemove = strTohex[2:]
    padded_hex = '{:0>8}'.format(prefixRemove)
    return padded_hex.upper()

#def expected_result (instr_type,src1,src2,dest):
#    if instr_type == "ADD":
#        ex_res = hex(int(src1,16) + int(src2, 16))[2:]
#        padded_ex_res='{:0>8}'.format(ex_res)
#        string_to_write = "Register" + " " + str(dest) + ":" + str(padded_ex_res)
#    return string_to_write

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


def decimalTobinary_5bit (decimal):
    binary = "{0:b}".format(decimal)
    padded_bin = '{:0>5}'.format(binary)
    return (padded_bin)

def decimalTobinary_12bit (decimal):
    binary = "{0:b}".format(decimal)
    padded_bin = '{:0>12}'.format(binary)
    return (padded_bin)

def imem_file (format_type, file_path, string):
    if format_type == "rtype":
        padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.dest) + "," + "x" + str(args.src1) + "," + "x" + str(args.src2) + '\n'
    elif format_type == "itype":
        padded_string= string +" "+ "//" + args.instr_type + " " + "x" + str(args.dest) + "," + "x" + str(args.src1) + "," + str(args.imm_value) + '\n'

    with open(file_path, 'a') as fp:
        fp.write(padded_string)

def read_rf_file_src1(file_path,src1):
    fp=open(file_path,'r')
    lines=fp.readlines()
    return lines[src1]

def read_rf_file_src2(file_path,src2):
    fp=open(file_path,'r')
    lines=fp.readlines()
    return lines[src2]

def expected_rf_val_file(string):
    filename='rf_exp.dump'
    fp=open(filename, 'w')
    fp.write(string)

if __name__ == "__main__":

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
        #print(type(args.imm_value))
        if args.instr_type != "SLLI" and args.instr_type != "SRLI" and args.instr_type != "SRAI":
            padded_imm = decimalTobinary_12bit(args.imm_value)
        else:
            padded_imm = decimalTobinary_5bit(args.imm_value)
         
        final_output_in_string = instruction_length_Itype(args.instr_type,padded_src1,padded_imm,padded_dest)
        #print(final_output_in_string)
        if final_output_in_string != 3:
            final_output_in_hex = StrToHex(final_output_in_string)
            imem_file(args.instr_format,args.imem_file_path,final_output_in_hex)
        else:
            print("USAGE: Please Enter Correct Instruction KeyWord")
            exit ()

#### Expected Result ####
    #rf_src1_val= read_rf_file_src1(args.rf_values_path,args.src1)
    #rf_src2_val= read_rf_file_src2(args.rf_values_path,args.src2)

    #expected_in_string = expected_result(args.instr_type,rf_src1_val,rf_src2_val,args.dest)
    #expected_rf_val_file(expected_in_string)

