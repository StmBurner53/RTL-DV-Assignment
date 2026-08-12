module traffic_light (
    input  logic clk,
    input  logic rst_n,
    input  logic i_timer_done,
    output logic o_start_timer,
    output logic [1:0] o_main_light,
    output logic [1:0] o_side_light
);

    // Light Color Encodings
    localparam logic [1:0] RED    = 2'b00;
    localparam logic [1:0] GREEN  = 2'b01;
    localparam logic [1:0] YELLOW = 2'b10;

    // State Encoding
    typedef enum logic [1:0] {
        S_MAIN_GREEN  = 2'b00,
        S_MAIN_YELLOW = 2'b01,
        S_SIDE_GREEN  = 2'b10,
        S_SIDE_YELLOW = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Sequential Block: State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_MAIN_GREEN; // Default FSM start
        end else if (i_timer_done) begin
            current_state <= next_state;
        end
    end

    // Combinational Block: Next State and Timer Trigger
    always_comb begin
        next_state = current_state;
        o_start_timer = 1'b0;
        
        if (i_timer_done) begin
            o_start_timer = 1'b1; // Pulse timer reset
            case (current_state)
                S_MAIN_GREEN:  next_state = S_MAIN_YELLOW;
                S_MAIN_YELLOW: next_state = S_SIDE_GREEN;
                S_SIDE_GREEN:  next_state = S_SIDE_YELLOW;
                S_SIDE_YELLOW: next_state = S_MAIN_GREEN;
                default:       next_state = S_MAIN_GREEN;
            endcase
        end
    end

    // Combinational Block: Output Logic (Safe-Red on Reset Override)
    always_comb begin
        if (!rst_n) begin
             o_main_light = RED;
             o_side_light = RED;
        end else begin
            // Default to RED unless explicitly overwritten
            o_main_light = RED;
            o_side_light = RED;
            
            case (current_state)
                S_MAIN_GREEN:  o_main_light = GREEN;
                S_MAIN_YELLOW: o_main_light = YELLOW;
                S_SIDE_GREEN:  o_side_light = GREEN;
                S_SIDE_YELLOW: o_side_light = YELLOW;
            endcase
        end
    end

endmodule