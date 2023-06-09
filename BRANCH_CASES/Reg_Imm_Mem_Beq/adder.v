//Verilog Module for Adder Specifically for Conditional Branch

module adder (
	input wire [31:0] inp1,
	input wire [31:0] inp2,
	output reg [31:0] res
);

always @(*) begin
	res = inp1 + inp2;
end

endmodule
