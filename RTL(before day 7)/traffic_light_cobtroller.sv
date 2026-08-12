module traffic_light #(
    parameter int T_MAIN_GREEN  = 4,
    parameter int T_MAIN_YELLOW = 2,
    parameter int T_SIDE_GREEN  = 6,
    parameter int T_SIDE_YELLOW = 2
)(
    input  logic clk,
    input  logic rst_n,
    
    // Six individual light outputs
    output logic main_red,
    output logic main_yellow,
    output logic main_green,
    output logic side_red,
    output logic side_yellow,
    output logic side_green
);

    // FSM State Encoding
    typedef enum logic [1:0] {
        MAIN_GREEN  = 2'b00,
        MAIN_YELLOW = 2'b01,
        SIDE_GREEN  = 2'b10,
        SIDE_YELLOW = 2'b11
    } state_t;

    state_t state, next_state;
    logic [7:0] counter; 

    // ---------------------------------------------------------
    // 1. Output Logic (Continuous Assignments)
    // ---------------------------------------------------------
    // A light is ON (1) only when the condition is true. 
    // Otherwise, it is forced to OFF (0).
    
    assign main_green  = (state == MAIN_GREEN);
    assign main_yellow = (state == MAIN_YELLOW);
    assign main_red    = (state == SIDE_GREEN) || (state == SIDE_YELLOW);

    assign side_green  = (state == SIDE_GREEN);
    assign side_yellow = (state == SIDE_YELLOW);
    assign side_red    = (state == MAIN_GREEN) || (state == MAIN_YELLOW);

    // ---------------------------------------------------------
    // 2. Next-State Logic (Combinational)
    // ---------------------------------------------------------
    always_comb begin
        // Default assignment for next_state
        next_state = state;

        case (state)
            MAIN_GREEN:  next_state = MAIN_YELLOW;
            MAIN_YELLOW: next_state = SIDE_GREEN;
            SIDE_GREEN:  next_state = SIDE_YELLOW;
            SIDE_YELLOW: next_state = MAIN_GREEN;
        endcase
    end

    // ---------------------------------------------------------
    // 3. State Register and Down-Counter (Sequential)
    // ---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= MAIN_GREEN;
            counter <= T_MAIN_GREEN - 1; 
        end else begin
            if (counter == 0) begin
                state <= next_state;
                
                case (next_state)
                    MAIN_GREEN:  counter <= T_MAIN_GREEN - 1;
                    MAIN_YELLOW: counter <= T_MAIN_YELLOW - 1;
                    SIDE_GREEN:  counter <= T_SIDE_GREEN - 1;
                    SIDE_YELLOW: counter <= T_SIDE_YELLOW - 1;
                endcase
            end else begin
                counter <= counter - 1;
            end
        end
    end

endmodule
