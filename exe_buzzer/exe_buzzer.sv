module exe_buzzer
(
    input  logic        clk_i,
    input  logic        rst_n_i,

    output logic        buzzer_o
);
    logic [21:0] counter; /* Max for 20 Hz */

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            counter <= '0;
            buzzer_o <= 1'b0;
        end
        else begin
            counter <= counter + 1'b1;
            if (counter == 22'd125000) begin /* 20 Hz */
                counter <= '0;
                buzzer_o <= ~buzzer_o;
            end
        end
    end

endmodule
