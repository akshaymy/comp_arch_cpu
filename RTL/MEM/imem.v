//Verilog code for Instruction Memory

module imem(

input wire [31:0] ip_instr_addr_from_proc,
output reg [31:0] op_instr_from_imem,
output reg op_instr_valid
);

//Memory to hold the instructions

reg [31:0] mem[31:0];

//Reading instruction is harmless and it doesn't need any control signal
always @(*) begin: imem_block
	op_instr_from_imem= mem[ip_instr_addr_from_proc [31:2]];
	op_instr_valid =1'b1;
end

endmodule

	
