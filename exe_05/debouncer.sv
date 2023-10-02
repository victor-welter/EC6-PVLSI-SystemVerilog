module debouncer
#(
    parameter NBITS = 22
)
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic bounce_i,

    output logic debounce_o
);

    logic [NBITS - 1:0] counter;   /* 2^22 * 20 ns = 83.88 ms */

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            debounce_o <= 1'b0;
            counter <= '0;
        end
        else begin
            if (counter == '0) begin
                if (debounce_o != bounce_i) begin
                    debounce_o <= bounce_i;
                    counter <= {{NBITS - 1{1'b0}}, 1'b1};
                end
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule
