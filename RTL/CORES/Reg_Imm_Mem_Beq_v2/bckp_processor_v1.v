//Verilog Code for single cycle processor

module bckp_processor_v1(

//General inputs
input wire clk,
input wire rst,

//Inputs and Outputs from imem 
input wire [31:0] ip_instr_from_imem,
input wire ip_instr_valid,
output reg [31:0] op_instr_addr_from_proc

);

wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] alu_output;
wire [31:0] wb_data;

//wires to and from Decoder Module
wire alu_src_from_imem;
wire [2:0] funct3;
wire [6:0] funct7;
wire op_data_wr;
wire mem_read_en;
wire mem_write_en;
wire mem_to_reg_en;
wire [31:0] imem_sign_ext;

wire [31:0] mem_out;
wire mem_out_valid;

//wire op_instr_addr_from_proc;
wire [31:0] ip_instr_addr_from_pc;

// intermediate signals wrt immediate instr
wire [31:0] read_data_from_mux;

reg [31:0] pc;
reg [31:0] next_pc;

always @(posedge clk) begin
	if (rst) begin
		pc <= 0;
	end
	else begin
		pc <= next_pc;
	end
end

always @(*) begin
	next_pc = pc + 32'h4;
	op_instr_addr_from_proc = pc;
end

decoder dec_0 (
	.ip_instr_from_imem(ip_instr_from_imem),  
	.funct3(funct3), //control signal for ALU
	.funct7(funct7), //control signal for ALU
	.ip_instr_valid(ip_instr_valid), //instr is valid or not
	.reg_write(op_data_wr), //register wrtie instr or not
	.alu_src_from_imem(alu_src_from_imem), //reading either from reg_file or immediate data
	.mem_read(mem_read_en),
	.mem_write(mem_write_en),
	.mem_to_reg(mem_to_reg_en),
	.imem_sign_ext(imem_sign_ext)
);

alu alu_0 (
	.read_data1(read_data1), //read data1 
	.read_data2(read_data_from_mux), //read data either from reg_file or immediate
	.funct3(funct3), 
	.funct7(funct7), 
	.result(alu_output) //final result from ALU
);

dmem dmem_0 (
	.clk(clk),
	.ip_mem_read(mem_read_en),
	.ip_mem_write(mem_write_en),
	.ip_mem_addr(alu_output),
	.ip_mem_data(read_data2),
	.op_mem_out(mem_out),
	.op_mem_data_valid(mem_out_valid)
);

mux_32 mux_32_0 (
	.inp0(read_data2),
	.inp1(imem_sign_ext),
	.sel(alu_src_from_imem),
	.out(read_data_from_mux)
);

mux_32 mux_32_1 (
	.inp0(alu_output),
	.inp1(mem_out),
	.sel(mem_to_reg_en),
	.out(wb_data)
);

regfile regfile_0 (
	.reg_src1(ip_instr_from_imem[19:15]), //reg_source 1
	.reg_src2(ip_instr_from_imem[24:20]), //reg_source 2
	.reg_dest(ip_instr_from_imem[11:7]),  //reg_dest
	.write_back(wb_data), //data to be written
	.clk(clk), 
	.rst(rst), 
	.write_en(op_data_wr), //to write into reg_file if its a reg_write instr
	.read_data1(read_data1), //data from reg_source1
	.read_data2(read_data2) //data from reg_source2
);

endmodule


