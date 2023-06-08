// Feb 10, 2023
// Verilog Code for Register File

module regfile( 

input wire [4:0] reg_src1,
input wire [4:0] reg_src2,
input wire [4:0] reg_dest,
input wire [31:0] write_back,
input wire clk,
input wire rst,
input wire write_en,
output reg [31:0] read_data1,
output reg [31:0] read_data2
);

//32 Registers of each 32 bit
reg [31:0] mem[31:0];

//Reading from register file is harmless so no need of the control signal

always @(*) begin
	read_data1=mem[reg_src1];
	read_data2=mem[reg_src2];
end

always @(posedge clk ) begin: register_file_block
	if (write_en) begin
		mem[reg_dest] <= write_back;
	end
	
	//0th Register always holds value 0's
	mem[0] <= 'b0;
end


//always @(posedge clk or posedge rst) begin: register_file_block
//	if (rst) begin
//		mem <= 'b0;
//	end
//	else begin
//	 	if (write_en) begin
//			mem[reg_dst] <= write_back;
//		end
//	end
//	//0th Register always holds value 0's
//	mem[0] <= 'b0;
//end

endmodule
