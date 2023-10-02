module trab_01_copy 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_inc_n_i,
    input  logic btn_dec_n_i,
    input  logic btn_start_n_i,
    input  logic btn_stop_n_i,

    output logic [21:0] cmp_freq_n_o,
    output logic buzzer_n_o,
    output logic [3:0] led_n_o
);

    logic [3:0] led;
    assign led_n_o = ~led;

    logic btn_inc;
    logic btn_dec;
    logic btn_start;
    logic btn_stop;
    assign btn_inc = ~btn_inc_n_i;
    assign btn_dec = ~btn_dec_n_i;
    assign btn_start = ~btn_start_n_i;
    assign btn_stop = ~btn_stop_n_i;

    logic pressed_inc;
    logic pressed_dec;
    logic pressed_start;
    logic pressed_stop;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            /* Lógica do reset */
            led <= '0;
            pressed_inc <= 1'b0;
            pressed_dec <= 1'b0;
            pressed_start <= 1'b0;
            pressed_stop <= 1'b0;
        end
        else begin
            /* Lógica síncrona */
            pressed_inc <= btn_inc; 
            pressed_dec <= btn_dec; 
            pressed_start <= btn_start; 
            pressed_stop <= btn_stop; 

            /* Botão foi pressionado, mas não estava pressionado anteriormente */
            if (btn_inc && !pressed_inc) begin
                led <= led + 1'b1;
            end else if (btn_dec && !pressed_dec) begin
                led <= led - 1'b1;
            end

            /* Botão de frequência foi pressionado */
            case(led_n_o) 
                4'b0000: begin
                    cmp_freq_n_o <= 22'd250000;
                end
                4'b0001: begin
                    cmp_freq_n_o <= 22'd225000;
                end
                4'b0010: begin
                    cmp_freq_n_o <= 22'd200000;
                end
                4'b0011: begin
                    cmp_freq_n_o <= 22'd175000;
                end
                4'b0100: begin
                    cmp_freq_n_o <= 22'd150000;
                end
                4'b0101: begin
                    cmp_freq_n_o <= 22'd125000;
                end
                4'b0110: begin
                    cmp_freq_n_o <= 22'd100000;
                end
                4'b0111: begin
                    cmp_freq_n_o <= 22'd75000;
                end
                4'b1000: begin
                    cmp_freq_n_o <= 22'd50000;
                end
                4'b1001: begin
                    cmp_freq_n_o <= 22'd25000;
                end
                4'b1010: begin
                    cmp_freq_n_o <= 22'd10000;
                end
                4'b1011: begin
                    cmp_freq_n_o <= 22'd5000;
                end
                4'b1100: begin
                    cmp_freq_n_o <= 22'd4500;
                end
                4'b1101: begin
                    cmp_freq_n_o <= 22'd3500;
                end
                4'b1110: begin
                    cmp_freq_n_o <= 22'd3000;
                end
                4'b1111: begin
                    cmp_freq_n_o <= 22'd2500;
                end
                default: begin
                    cmp_freq_n_o <= 22'd250000;
                end
            endcase

            /* Botão silenciador foi pressionado */
            if (btn_start && !pressed_start) begin
                buzzer_n_o <= 1'b1;
                pressed_stop <= 1'b0;
            end else if(btn_stop && !pressed_stop)begin
                buzzer_n_o <= 1'b0;
                pressed_start <= 1'b0;
            end
        end
    end

endmodule
