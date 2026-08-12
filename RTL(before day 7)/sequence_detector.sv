module seq_detect_1011 (
	input  logic clk,
	input  logic rst_n,
	input  logic din,
	output logic detected
);
 
	typedef enum logic [2:0] {
    	IDLE  = 3'b000,
    	S1	= 3'b001,
    	S10   = 3'b010,
    	S101  = 3'b011,
    	S1011 = 3'b100
	} state_t;
 
	state_t current_state, next_state;
 
	// Block 1: State Register (Memory)
	always_ff @(posedge clk or negedge rst_n) begin
    	if (!rst_n) begin
        	current_state <= IDLE;
    	end else begin
        	current_state <= next_state;
    	end
	end
 
	// Block 2: Next-State and Output Logic (Combinational)
	always_comb begin
    	// Default assignments to prevent latches
    	next_state = current_state;
    	detected   = 1'b0;
 
    	case (current_state)
        	IDLE: begin
            	if (din == 1'b1) next_state = S1;
        	end
        	S1: begin
            	if (din == 1'b0) next_state = S10;
            	else         	next_state = S1;
        	end
        	S10: begin
            	if (din == 1'b1) next_state = S101;
            	else         	next_state = IDLE;
        	end
        	S101: begin
            	if (din == 1'b1) next_state = S1011;
            	else         	next_state = S10;
        	end
        	S1011: begin
            	detected = 1'b1;
            	if (din == 1'b1) next_state = S1;
            	else         	next_state = S10;
        	end
        	default: begin
            	next_state = IDLE;
        	end
    	endcase
	end
endmodule
