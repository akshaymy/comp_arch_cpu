//Top Module which instantiate Memory Modules and Processor 

module SoC (
	//General Inputs
	input wire clk,
	input wire rst
);

wire [31:0] instr_addr_from_proc; 


wire [31:0] instr_from_imem;
wire instr_valid_from_imem;

//Instantiation of Processor and IMEM

processor_v1 processor_v1_0 (
	.clk(clk), 
	.rst(rst), 
	.ip_instr_from_imem(instr_from_imem), 
	.ip_instr_valid(instr_valid_from_imem), 
	.op_instr_addr_from_proc(instr_addr_from_proc)
);

imem imem_0 (
.ip_instr_addr_from_proc(instr_addr_from_proc), 
.op_instr_from_imem(instr_from_imem), 
.op_instr_valid(instr_valid_from_imem)
);

endmodule
