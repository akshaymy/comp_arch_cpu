//Verilog Code for Program Counter

module pc(

input wire clk,
input wire rst,
input wire [31:0] pc,
output reg [31:0] op_instr_addr
);

//reg rst_tracker;
//reg [31:0] pc;
//reg [31:0] next_pc;

always @(*) begin
	op_instr_addr = pc;	
end

endmodule
