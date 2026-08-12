module sync_fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 16
) (
    input  logic clk,
    input  logic rst_n,
    input  logic i_wren,
    input  logic [DATA_WIDTH-1:0] i_wdata,
    input  logic i_rden,
    output logic [DATA_WIDTH-1:0] o_rdata,
    output logic o_full,
    output logic o_empty
);

    // Internal parameter for pointer widths based on DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Memory array and pointers
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr;
    
    // Count needs to go up to DEPTH (e.g., 0 to 16 requires 5 bits)
    logic [$clog2(DEPTH+1)-1:0] count;

    logic write_valid;
    logic read_valid;

    // Combinational flags
    assign o_full  = (count == DEPTH);
    assign o_empty = (count == 0);

    // Read/Write Validation Logic
    // Corner Case: If full, write is only valid if a read is simultaneously freeing a spot
    assign read_valid  = i_rden && !o_empty;
    assign write_valid = i_wren && (!o_full || i_rden);

    // Sequential Block: Counters and Pointers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
            count  <= '0;
        end else begin
            // Count Update Logic
            case ({write_valid, read_valid})
                2'b10: count <= count + 1; // Write only
                2'b01: count <= count - 1; // Read only
                2'b11: count <= count;     // Simultaneous R/W: Count holds steady
                2'b00: count <= count;     // No operation
            endcase

            // Write Pointer Update (with wrap-around)
            if (write_valid) begin
                wr_ptr <= (wr_ptr == DEPTH - 1) ? '0 : wr_ptr + 1;
            end

            // Read Pointer Update (with wrap-around)
            if (read_valid) begin
                rd_ptr <= (rd_ptr == DEPTH - 1) ? '0 : rd_ptr + 1;
            end
        end
    end

    // Sequential Block: Memory Write
    always_ff @(posedge clk) begin
        if (write_valid) begin
            mem[wr_ptr] <= i_wdata;
        end
    end

    // Sequential Block: Memory Read (1 cycle latency)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_rdata <= '0;
        end else if (read_valid) begin
            o_rdata <= mem[rd_ptr];
        end
    end

endmodule