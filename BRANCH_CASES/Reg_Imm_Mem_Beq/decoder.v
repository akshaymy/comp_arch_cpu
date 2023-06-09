//Verilog code for the Decoder- to generate control signals.

module decoder(

input wire [31:0] ip_instr_from_imem,
input wire ip_instr_valid,
output reg reg_write,
output reg [2:0] funct3,
output reg [6:0] funct7,
output reg alu_src_from_imem,
output reg mem_read,
output reg mem_write,
output reg mem_to_reg,
output reg [31:0] imem_sign_ext,
output reg beq,
output reg bne,
output reg blt,
output reg bge
);

always @(*) begin:decoder_block
	if (ip_instr_valid) begin
		case (ip_instr_from_imem[6:0]) 
			7'b0110011: //R-type Instruction 
			begin
				reg_write=1'b1;
			        alu_src_from_imem = 1'b0;	
				//3bit-Opcode
				funct3=ip_instr_from_imem[14:12];
				//7bit-Functionality
				funct7=ip_instr_from_imem[31:25];
				mem_read = 1'b0;
				mem_write = 1'b0;
				mem_to_reg = 1'b0;
			 	imem_sign_ext = 32'b0;

				beq = 1'b0;
				bne = 1'b0;
				blt = 1'b0;
				bge = 1'b0;
			end

			7'b0010011: //Immediate Type Instruction
			begin
				alu_src_from_imem = 1'b1;
				reg_write = 1'b1;
				//3bit-Opcode
				funct3 = ip_instr_from_imem[14:12];	
				//7bit-Functionality
				funct7 = ip_instr_from_imem[31:25];
				mem_read = 1'b0;
				mem_write = 1'b0;
				mem_to_reg = 1'b0;
				if ((funct3 != 3'b001) && (funct3 != 3'b101))
					imem_sign_ext = {{20{ip_instr_from_imem[31]}}, ip_instr_from_imem[31:20]};
				else
					imem_sign_ext = {{20{1'b0}}, {7{1'b0}}, ip_instr_from_imem[24:20]};

				beq = 1'b0;
				bne = 1'b0;
				blt = 1'b0;
				bge = 1'b0;
			end

			7'b0000011: //Load Word
			begin
				alu_src_from_imem = 1'b1;
				reg_write = 1'b1;
				//funct3 = ip_instr_from_imem[14:12];
				funct3 = 3'b000;
				funct7 = 7'b0;
				mem_read = 1'b1;
				mem_write = 1'b0;
				mem_to_reg = 1'b1;
				imem_sign_ext = {{20{ip_instr_from_imem[31]}}, ip_instr_from_imem[31:20]};

				beq = 1'b0;
				bne = 1'b0;
				blt = 1'b0;
				bge = 1'b0;
			end

			7'b0100011: //Store Word
			begin
				alu_src_from_imem = 1'b1;
				reg_write = 1'b0;
				//funct3 = ip_instr_from_imem[14:12];
				funct3 = 3'b000;
				funct7 = 7'b0;
				mem_read = 1'b0;
				mem_write = 1'b1;
				mem_to_reg = 1'bx;
				imem_sign_ext = {{20{ip_instr_from_imem[31]}}, ip_instr_from_imem[31:25], ip_instr_from_imem[11:7]};

				beq = 1'b0;
				bne = 1'b0;
				blt = 1'b0;
				bge = 1'b0;
			end

			7'b1100011: //Controlled Branches
			begin
				alu_src_from_imem = 1'b0;
				reg_write = 1'b0;
				funct3 = 3'b000;
				funct7 = 7'b0100000;
				mem_read = 1'b0;
				mem_write = 1'b0;
				mem_to_reg = 1'bx;
				imem_sign_ext = {{20{ip_instr_from_imem[31]}}, ip_instr_from_imem[7], ip_instr_from_imem[30:25], ip_instr_from_imem[11:8], 1'b0};
				
				case (ip_instr_from_imem[14:12])
					3'b000:
					begin
						beq = 1'b1;
						bne = 1'b0;
						blt = 1'b0;
						bge = 1'b0;
					end

					3'b001:
					begin
						beq = 1'b0;
						bne = 1'b1;
						blt = 1'b0;
						bge = 1'b0;
					end

					3'b100:
					begin
						beq = 1'b0;
						bne = 1'b0;
						blt = 1'b1;
						bge = 1'b0;
					end
					
					3'b101:
					begin
						beq = 1'b0;
						bne = 1'b0;
						blt = 1'b0;
						bge = 1'b1;
					end
				endcase						
			end
		endcase
	end

end
endmodule	
