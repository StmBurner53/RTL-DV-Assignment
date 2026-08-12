module seq_detector (
    input  logic clk,
    input  logic rst_n,
    input  logic i_valid,
    input  logic i_bit,
    output logic o_match
);

    // State Encoding
    typedef enum logic [2:0] {
        S_IDLE = 3'b000,
        S_1    = 3'b001,
        S_10   = 3'b010,
        S_101  = 3'b011,
        S_1011 = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Sequential Block: State transitions with active-low async reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_IDLE;
        end else if (i_valid) begin
            current_state <= next_state;
        end
    end

    // Combinational Block: Next State logic handling overlaps
    always_comb begin
        next_state = current_state; // Default hold

        case (current_state)
            S_IDLE: next_state = i_bit ? S_1    : S_IDLE;
            S_1:    next_state = i_bit ? S_1    : S_10;
            S_10:   next_state = i_bit ? S_101  : S_IDLE;
            S_101:  next_state = i_bit ? S_1011 : S_10;
            S_1011: next_state = i_bit ? S_1    : S_10;
            default: next_state = S_IDLE;
        endcase
    end

    // Combinational Block: Output logic
    // Match asserts only when in S_1011 state
    assign o_match = (current_state == S_1011);

endmodule