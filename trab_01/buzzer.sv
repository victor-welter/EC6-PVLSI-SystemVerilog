module buzzer
(
    input  logic        clk_i,
    input  logic        rst_n_i,
    input  logic        en_i,
    input  logic [21:0] cmp_i,

    output logic        buzzer_o
);
    logic        buzz;
    logic [21:0] cmp;
    logic [21:0] counter; /* Max for 20 Hz */

    assign buzzer_o = buzz & en_i;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            cmp <= '0;
        end
        else begin
            cmp <= cmp_i;
        end
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            counter <= '0;
            buzz <= 1'b0;
        end
        else begin
            counter <= counter + 1'b1;
            if (counter == cmp) begin /* 200 Hz */
                counter <= '0;
                buzz <= ~buzz;
            end
        end
    end

endmodule
