//Verilog Code for single cycle processor- Only R-Type Instruction

module processor_v1(

//General inputs
input wire clk,
input wire rst,

//Inputs and Outputs from imem 
input wire [31:0] ip_instr_from_imem,
input wire ip_instr_valid,
output reg [31:0] op_instr_addr_from_proc

);

wire [31:0] read_data1;
wire [31:0] read_data2;
wire [2:0] alu_op_code;
wire [6:0] funct;
wire [31:0] op_data_from_proc;
wire op_data_wr;

//wire op_instr_addr_from_proc;
wire [31:0] ip_instr_addr_from_pc;

always @(*) begin
	op_instr_addr_from_proc = ip_instr_addr_from_pc;
end

decoder dec_0 (
.ip_instr_from_imem(ip_instr_from_imem), 
.alu_op_code(alu_op_code), 
.funct(funct), 
.ip_instr_valid(ip_instr_valid), 
.reg_write(op_data_wr)
);

alu alu_0 (
.read_data1(read_data1), 
.read_data2(read_data2), 
.alu_op_code(alu_op_code), 
.funct(funct), 
.result(op_data_from_proc)
);

regfile regfile_0 (
.reg_src1(ip_instr_from_imem[19:15]), 
.reg_src2(ip_instr_from_imem[24:20]), 
.reg_dest(ip_instr_from_imem[11:7]), 
.write_back(op_data_from_proc), 
.clk(clk), 
.rst(rst), 
.write_en(op_data_wr), 
.read_data1(read_data1), 
.read_data2(read_data2)
);

pc pc_0 (
.clk(clk), 
.rst(rst), 
.op_instr_addr(ip_instr_addr_from_pc)
);


endmodule

