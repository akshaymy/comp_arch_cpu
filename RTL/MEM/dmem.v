//Verilog Code for Data Memory

module dmem (
	input wire clk,
	input wire ip_mem_read,
	input wire ip_mem_write,

	input wire [31:0] ip_mem_addr,
	input wire [31:0] ip_mem_data,

	output reg [31:0] op_mem_out,
	output reg  op_mem_data_valid
);

//Actual Data Memory
reg [31:0] mem[31:0];

always @(*) begin : dmem_read_block
	if (ip_mem_read) begin
		op_mem_out = mem[ip_mem_addr[31:2]];
		op_mem_data_valid = 1'b1;
	end
end

always @(posedge clk) begin : dmem_write_block
	if (ip_mem_write) begin
		mem[ip_mem_addr[31:2]] <= ip_mem_data;
	end
end

endmodule
