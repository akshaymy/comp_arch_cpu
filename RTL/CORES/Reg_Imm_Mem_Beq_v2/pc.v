//Verilog Code for Program Counter

module pc(

input wire clk,
input wire rst,
output reg [31:0] op_instr_addr
);

//reg rst_tracker;
reg [31:0] pc;
reg [31:0] next_pc;

always @(posedge clk) begin: PC_Block
	//rst_tracker <= rst;
	
	if (rst) begin
		pc <= 0;
	end
	else begin
		pc <= next_pc;
	end
end

always @(*) begin
	op_instr_addr = pc;	
	next_pc = pc + 32'h4;
end

endmodule
