module sync_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 8
)(
    input  logic             clk,
    input  logic             rst_n,
    
    // Write Interface
    input  logic             wr_en,
    input  logic [WIDTH-1:0] din,
    output logic             full,
    
    // Read Interface
    input  logic             rd_en,
    output logic [WIDTH-1:0] dout,
    output logic             empty
);

    // For a DEPTH of 8, pointers need to count from 0 to 7 (needs 3 bits).
    logic [2:0] wr_ptr;
    logic [2:0] rd_ptr;
    
    // The counter needs to hold the number 8, so it needs 4 bits.
    logic [3:0] count;

    // The actual memory array (8 boxes, each 8 bits wide)
    logic [WIDTH-1:0] mem [0:DEPTH-1];

    // ---------------------------------------------------------
    // 1. Combinational Status Flags
    // ---------------------------------------------------------
    // These constantly check the counter without waiting for a clock
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // ---------------------------------------------------------
    // 2. Sequential Logic (Everything happens on the clock tick)
    // ---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        // --- Reset Logic ---
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;
        end else begin
            
            // --- Write Logic ---
            // If told to write, and we actually have room...
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;      // Put data into the memory box
                wr_ptr      <= wr_ptr + 1; // Move write pointer to the next box
            end
            
            // --- Read Logic ---
            // If told to read, and there is actually data to read...
            if (rd_en && !empty) begin
                dout   <= mem[rd_ptr];   // Take data out of the memory box
                rd_ptr <= rd_ptr + 1;      // Move read pointer to the next box
            end

            // --- Counter Logic ---
            // Figure out how many items are in the FIFO right now
            if ((wr_en && !full) && (rd_en && !empty)) begin
                // We wrote 1 item and read 1 item at the exact same time.
                // The total count stays exactly the same.
                count <= count;
            end 
            else if (wr_en && !full) begin
                // We only added an item, so the count goes up.
                count <= count + 1;
            end 
            else if (rd_en && !empty) begin
                // We only removed an item, so the count goes down.
                count <= count - 1;
            end
            
        end
    end

endmodule
