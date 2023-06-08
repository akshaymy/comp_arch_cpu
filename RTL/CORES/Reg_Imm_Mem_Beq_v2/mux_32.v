//Verilog Module for 32 bit Mux Logic


module mux_32(
input wire [31:0] inp0,
input wire [31:0] inp1,
input wire sel,
output reg [31:0] out
);

always @(*) begin
	if (sel) 
		out = inp1;
	else
		out = inp0;
end
endmodule
