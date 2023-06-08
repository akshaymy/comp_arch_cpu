//Verilog Code for ALU

module alu(

input wire [31:0] read_data1,
input wire [31:0] read_data2,
input wire [2:0] alu_op_code,
input wire [6:0] funct,
output reg [31:0] result
);

always @(*) begin: ALU_Block
	if (funct == 'b0) begin
		case (alu_op_code)
			3'b000 : result = read_data1 + read_data2;   //ADD
			3'b001 : result = read_data1 << read_data2;  //SLL
			3'b010 : 				     //SLT		
				if (read_data1 < read_data2) begin
					result = 1;
				end
				else begin 
					result = 0;
				end
			3'b011 :				     //SLTU
 				if (read_data1 < read_data2) begin
					result = 1;
				end
				else begin 
					result = 0;
				end
			3'b100 : result = (read_data1 ^ read_data2); //XOR
			3'b101 : result = read_data1 >> read_data2;  //SRH
			3'b110 : result = read_data1 | read_data2;  //OR
			3'b111 : result = read_data1 & read_data2;  //AND
			default: result = 'b0;
		endcase
	end
	else begin
		case (alu_op_code) 
			3'b000 : result = read_data1 - read_data2;   //SUB
			3'b101 : result = read_data2 >>> read_data2; //SRA
			default: result = 'b0;
		endcase
	end
end
endmodule			
