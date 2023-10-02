module exe_07 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic en_i,
    input  logic btn_n_i,

    output logic [3:0] led_n_o
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
            if (btn && !pressed && en_i) begin
                led <= led + 1'b1;
            end
        end
    end

endmodule
