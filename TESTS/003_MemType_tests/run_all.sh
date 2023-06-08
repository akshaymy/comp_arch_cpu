rm jnk.fill

python3 instr_gen.py --instr_format rtype --instr_type ADD --src1 4 --src2 8 --dest 3 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type ADD --src1 1 --src2 2 --dest 2 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type ADD --src1 2 --src2 3 --dest 8 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type SLL --src1 11 --src2 12 --dest 10 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type SLL --src1 13 --src2 14 --dest 15 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type SLT --src1 16 --src2 17 --dest 18 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type XOR --src1 20 --src2 19 --dest 21 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type OR --src1 21 --src2 22 --dest 23 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type AND --src1 23 --src2 24 --dest 25 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type SUB --src1 27 --src2 28 --dest 29 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format rtype --instr_type SUB --src1 28 --src2 29 --dest 30 --imem_file_path jnk.fill

python3 instr_gen.py --instr_format itype --instr_type ADDI --src1 4 --imm_value 5 --dest 6 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format itype --instr_type ADDI --src1 6 --imm_value 10 --dest 7 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format itype --instr_type SLTI --src1 7 --imm_value 50 --dest 8 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format itype --instr_type SLTI --src1 7 --imm_value 20 --dest 8 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format itype --instr_type XORI --src1 7 --imm_value 0 --dest 8 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format itype --instr_type ORI --src1 7 --imm_value 0 --dest 9 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format itype --instr_type ANDI --src1 7 --imm_value 0 --dest 10 --imem_file_path jnk.fill

python3 instr_gen.py --instr_format mem --instr_type LW --src1 10 --imm_value 12 --dest 10 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format mem --instr_type SW --src1 0 --src2 14 --imm_value 12 --imem_file_path jnk.fill
python3 instr_gen.py --instr_format mem --instr_type SW --src1 0 --src2 21 --imm_value 16 --imem_file_path jnk.fill
