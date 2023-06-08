//Verilog code for the Decoder- to generate control signals.

module decoder(

input wire [31:0] ip_instr_from_imem,
input wire ip_instr_valid,
output reg reg_write,
output reg [2:0] funct3,
output reg [6:0] funct7,
output reg alu_src_from_imem
);

always @(*) begin:decoder_block
	if (ip_instr_valid) begin
		case (ip_instr_from_imem[6:0]) 
			7'b0110011:
			begin
				reg_write=1'b1;
			        alu_src_from_imem = 1'b0;	
				//3bit-Opcode
				funct3=ip_instr_from_imem[14:12];
				//7bit-Functionality
				funct7=ip_instr_from_imem[31:25];
			end

			7'b0010011:
			begin
				alu_src_from_imem = 1'b1;
				reg_write = 1'b1;
				//3bit-Opcode
				funct3= ip_instr_from_imem[14:12];	
				//7bit-Functionality
				funct7= ip_instr_from_imem[31:25];
			end
		endcase
	end

end
endmodule	
