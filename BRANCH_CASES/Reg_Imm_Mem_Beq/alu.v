//Verilog Code for ALU

module alu(

input wire [31:0] read_data1,
input wire [31:0] read_data2,
input wire [2:0] funct3,
input wire [6:0] funct7,
output reg [31:0] result
);

always @(*) begin: ALU_Block
	case (funct3)
		3'b000 :
		begin	
			if (funct7 != 7'b0100000)
				result = read_data1 + read_data2;   //ADD
			else
				result = read_data1 - read_data2;   //SUB 
		end
		3'b001 : result = read_data1 << read_data2;  //Shift Logical Left
		3'b010 : 				     //Set Less Than		
			if (read_data1 < read_data2) begin
				result = 1;
			end
			else begin 
				result = 0;
			end
		3'b011 :				     //S.L.T.Unsigned
 			if (read_data1 < read_data2) begin
				result = 1;
			end
			else begin 
				result = 0;
			end
		3'b100 : result = (read_data1 ^ read_data2); //XOR
		3'b101 :
		begin
			if (funct7 != 7'b0100000) 	
				result = read_data1 >> read_data2;  //Shift Right Logical
			else
				result = read_data1 >>> read_data2; //Shift Right Arithmetic
		end	
		3'b110 : result = read_data1 | read_data2;  //OR
		3'b111 : result = read_data1 & read_data2;  //AND
		default: result = 'b0;
	endcase
	
end
endmodule			
