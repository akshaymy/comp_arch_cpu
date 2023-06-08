//Verilog Code for testing the Processor

//TestBench- Inputs and Outputs which you are giving and viewing respectively.
//Also to facilitate instantiation between two or more instants of module
//(Primarly taking and giving values between instanted modules)

`timescale 1ns/1ps

module tb;

reg clk;
reg rst;
wire [31:0] instr_addr_from_proc; 


wire [31:0] instr_from_imem;
wire instr_valid_from_imem;

//Clock
always #5 clk = ~clk;

//To count number of clocks
integer clock;

//To open the reg file and to dump data into it
integer reg_file_contents;
integer i;

initial begin

	//Dumping values into VCD using system_task for plotting signals
	$dumpfile("wave.vcd");

	//Dumping all the top level signal of the test bench- scope:0 
	$dumpvars(0, tb);
	
	//Storing the values from imem file to imem memory
	$readmemh("imem.fill", imem_0.mem);
	$readmemh("rf.fill", processor_v1_0.regfile_0.mem);
	
	//Resetting the Values
	clk <= 0;
	rst <= 1;
	clock <= 0;

	//After 5 negedge make reset 0
	@(negedge clk);

	repeat(5) begin 
		@(negedge clk);
	end
	
	rst <= 0;

	//Once the reset is 0, the program will run and by fetching the
	//instruction all 32 bit 0 indicated the end of the program.
	wait(instr_from_imem == 32'b0);
	$display("The program completed in the %d clock cycles", clock);

	////Draining pipeline
	//repeat(5) @(negedge clk);

	//Dump all the content in the registers into the file with dump
	//extenstion
	reg_file_contents=$fopen("rf_values.dump");

	for(i=0; i<32 ; i=i+1) begin
		$fdisplay(reg_file_contents,"Register %d : %h", i, processor_v1_0.regfile_0.mem[i]);
	end
	$fclose(reg_file_contents);
	$finish;
end

always @(posedge clk) begin
	if (rst) begin
		clock <= 0;
	end
	else begin
		clock <= clock + 1;
	end
end

//To avoid infinte loops
initial begin
	#1000
	$display("Test timeout, there should be infinite loop!!! Please check");
	$finish;
end

//Instantiation of IMEM and Processor

imem imem_0 (
.ip_instr_addr_from_proc(instr_addr_from_proc), 
.op_instr_from_imem(instr_from_imem), 
.op_instr_valid(instr_valid_from_imem)
);

processor_v1 processor_v1_0 (
.clk(clk), 
.rst(rst), 
.ip_instr_from_imem(instr_from_imem), 
.ip_instr_valid(instr_valid_from_imem), 
.op_instr_addr_from_proc(instr_addr_from_proc)
);

endmodule
