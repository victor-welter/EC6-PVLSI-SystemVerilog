module exe_01
(
    input logic clk_i,
	input logic rst_ni,

	input logic p_i,

	output logic r_o
);

    typedef enum logic [3:0] {
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000
    } state_t;

    state_t state;
    state_t next_state;

    always_comb begin  
        case (state)
            A: begin
                if (p_i == 1'b1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (p_i == 1'b1) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
            end 
            C: begin
                if (p_i == 1'b1) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end
            D: begin
                if (p_i == 1'b1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            default: begin
				next_state = A;
            end
        endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 1'b0) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    assign r_o = (state == D ? 1'b1 : 1'b0);

endmodule