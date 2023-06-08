//Verilog code for the Decoder- to generate control signals.

module decoder(

input wire [31:0] ip_instr_from_imem,
input wire ip_instr_valid,
output reg reg_write,
output reg [2:0] alu_op_code,
output reg [6:0] funct
);

always @(*) begin:decoder_block

	if (ip_instr_valid) begin
		//Since initially it is all reg_write instruction, I have set it to 1
		reg_write=1'b1; 
		//Opcode
		alu_op_code=ip_instr_from_imem[14:12];
		//Functionality
		funct=ip_instr_from_imem[31:25];
	end
end
endmodule	
