module smoke_tb;
 
	logic clk, rst_n, din, detected;
 
	// Instantiate DUT
	seq_detect_1011 dut (
    	.clk(clk),
    	.rst_n(rst_n),
    	.din(din),
    	.detected(detected)
	);
 
	// Clock generation (10 time units per cycle)
	initial begin
    	clk = 0;
    	forever #5 clk = ~clk;
	end
 
	// Monitor testbench signals (Inputs and Output)
	initial begin
    	$monitor("Time=%0t, rst_n=%b, din=%b, detected=%b", $time, rst_n, din, detected);
	end
 
	// Stimulus
	initial begin
    	// Initialize and Reset
    	din = 0;
    	rst_n = 0;
    	#15; // Hold reset
    	rst_n = 1;
 
    	// Drive sequence: 1 1 0 1 0 1 1
    	// Driving inputs on the negative edge avoids setup/hold race conditions
    	@(negedge clk) din = 1; // Cycle 1
    	@(negedge clk) din = 1; // Cycle 2
    	@(negedge clk) din = 0; // Cycle 3
    	@(negedge clk) din = 1; // Cycle 4
    	@(negedge clk) din = 0; // Cycle 5
    	@(negedge clk) din = 1; // Cycle 6
    	@(negedge clk) din = 1; // Cycle 7
    	
    	// Wait for Moore output to register
    	@(negedge clk);     	// Cycle 8 (Prediction: detected = 1)
    	@(negedge clk) din = 0;
    	
    	#20 $finish;
	end
 
endmodule
