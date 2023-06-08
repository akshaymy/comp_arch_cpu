//Verilog Code for single cycle processor- Only R-Type Instruction

module processor_v1(

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
wire [31:0] op_data_from_proc;

//wires to and from Decoder Module
wire alu_src_from_imem;
wire [2:0] funct3;
wire [6:0] funct7;
wire op_data_wr;

//wire op_instr_addr_from_proc;
wire [31:0] ip_instr_addr_from_pc;

// intermediate signals wrt immediate instr
reg [31:0] imem_sign_ext;
wire [31:0] read_data_from_mux;

always @(*) begin
	op_instr_addr_from_proc = ip_instr_addr_from_pc;
	//Sign Extending the 12bit immediate field
	if (alu_src_from_imem) begin
		if ((funct3 != 3'b001) && (funct3 != 3'b101))
			imem_sign_ext = {{20{ip_instr_from_imem[31]}}, ip_instr_from_imem[31:20]};
		else
			imem_sign_ext = {{20{1'b0}}, {7{1'b0}}, ip_instr_from_imem[24:20]};
	end
	else
		imem_sign_ext = 32'b0;

end

decoder dec_0 (
.ip_instr_from_imem(ip_instr_from_imem),  
.funct3(funct3), //control signal for ALU
.funct7(funct7), //control signal for ALU
.ip_instr_valid(ip_instr_valid), //instr is valid or not
.reg_write(op_data_wr), //register wrtie instr or not
.alu_src_from_imem(alu_src_from_imem) //reading either from reg_file or immediate data
);

alu alu_0 (
.read_data1(read_data1), //read data1 
.read_data2(read_data_from_mux), //read data either from reg_file or immediate
.funct3(funct3), 
.funct7(funct7), 
.result(op_data_from_proc) //final result from ALU
);

mux_32 mux_32_0 (
.inp0(read_data2),
.inp1(imem_sign_ext),
.sel(alu_src_from_imem),
.out(read_data_from_mux)
);

regfile regfile_0 (
.reg_src1(ip_instr_from_imem[19:15]), //reg_source 1
.reg_src2(ip_instr_from_imem[24:20]), //reg_source 2
.reg_dest(ip_instr_from_imem[11:7]),  //reg_dest
.write_back(op_data_from_proc), //data to be written
.clk(clk), 
.rst(rst), 
.write_en(op_data_wr), //to write into reg_file if its a reg_write instr
.read_data1(read_data1), //data from reg_source1
.read_data2(read_data2) //data from reg_source2
);

pc pc_0 (
.clk(clk), 
.rst(rst), 
.op_instr_addr(ip_instr_addr_from_pc)
);


endmodule

