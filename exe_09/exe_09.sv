module exe_09 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_n_i,

    output logic       dig_o,
    output logic [3:0] led_n_o,
    output logic [6:0] display_n_o
);

    logic [3:0] led;
    assign led_n_o = ~led;

    logic btn;
    assign btn = ~btn_n_i;

    logic pressed;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            /* Lógica do reset */
            led <= '0;
            pressed <= 1'b0;
        end
        else begin
            /* Lógica síncrona */
            pressed <= btn; /* Ocorre com 1 ciclo de atraso */

            /* Botão foi pressionado, mas não estava pressionado anteriormente */
            if (btn && !pressed) begin
                led <= led + 1'b1;
            end
        end
    end

    logic [6:0] display;
    assign display_n_o = ~display;

    DisplayDecoder decoder (
        .bcd_i (led),
        .seg_o (display)
    );

    assign dig_o = 1'b0;

endmodule
