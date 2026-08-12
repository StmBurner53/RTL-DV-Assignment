module tb_traffic_light;

    // 1. Declare Testbench Signals
    logic clk;
    logic rst_n;
    logic main_red, main_yellow, main_green;
    logic side_red, side_yellow, side_green;

    // 2. Instantiate the Device Under Test (DUT)
    // Overriding parameters here with the small smoke-test values
    traffic_light #(
        .T_MAIN_GREEN(4),
        .T_MAIN_YELLOW(2),
        .T_SIDE_GREEN(6),
        .T_SIDE_YELLOW(2)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .main_red(main_red),
        .main_yellow(main_yellow),
        .main_green(main_green),
        .side_red(side_red),
        .side_yellow(side_yellow),
        .side_green(side_green)
    );

    // 3. Clock Generation (10 time units period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 4. Stimulus and Simulation Control
    initial begin
        // Apply Reset
        rst_n = 0;
        #12; // Hold reset low for a little over one clock cycle
        rst_n = 1; // Release reset
        
        // Wait enough time to see one full loop of the FSM
        // Total cycle time = 4 + 2 + 6 + 2 = 14 cycles. 
        // 14 cycles * 10 time units = 140 time units. Run for 160 to see it loop back.
        #160; 
        
        $display("Smoke test complete.");
        $finish;
    end

    // 5. Cycle-by-Cycle Monitor
    // Trigger on negedge to read stable values after the posedge FSM updates
    always @(negedge clk) begin
        if (rst_n) begin
            $display("Time: %3t | State: %11s | Main (R Y G): %b %b %b | Side (R Y G): %b %b %b", 
                     $time, 
                     dut.state.name(), // Grabs the enum string name from inside the DUT
                     main_red, main_yellow, main_green, 
                     side_red, side_yellow, side_green);
        end
    end

endmodule
