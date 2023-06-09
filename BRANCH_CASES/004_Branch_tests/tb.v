//Verilog Code for testing the Processor

//TestBench- Inputs and Outputs which you are giving and viewing respectively.
//Also to facilitate instantiation between two or more instants of module
//(Primarly taking and giving values between instanted modules)

`timescale 1ns/1ps

module tb;

reg clk;
reg rst;

//Clock
always #5 clk = ~clk;

//To count number of clocks
integer clock;

//To open the reg file and to dump data into it
integer reg_file_contents;
integer mem_file_contents;
integer i;

initial begin

	//Dumping values into VCD using system_task for plotting signals
	$dumpfile("wave.vcd");

	//Dumping all the top level signal of the test bench- scope:0 
	$dumpvars(0, tb);
	
	//Storing the values from imem file to imem memory
	$readmemh("imem.fill", SoC_0.imem_0.mem);
	$readmemh("dmem.fill", SoC_0.processor_v1_0.dmem_0.mem);
	$readmemh("rf.fill", SoC_0.processor_v1_0.regfile_0.mem);
	
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
	wait(SoC_0.instr_from_imem == 32'b0);
	$display("The program completed in the %d clock cycles", clock);

	////Draining pipeline
	//repeat(5) @(negedge clk);

	//Dump all the content in the registers into the file with dump
	//extenstion
	reg_file_contents=$fopen("rf_values.dump");

	for(i=0; i<32 ; i=i+1) begin
		$fdisplay(reg_file_contents,"Register %d : %h", i, SoC_0.processor_v1_0.regfile_0.mem[i]);
	end
	$fclose(reg_file_contents);

	mem_file_contents=$fopen("dmem_values.dump");

	for(i=0; i<32; i=i+1) begin
		$fdisplay(mem_file_contents,"Memory %d : %h", i, SoC_0.processor_v1_0.dmem_0.mem[i]);
	end
	$fclose(mem_file_contents);

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
	#10000
	$display("Test timeout, there should be infinite loop!!! Please check");
	$finish;
end

//Instantiation of SoC

SoC SoC_0 (
	.clk(clk),
	.rst(rst)
);

endmodule
