module led_control 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_inc_n_i,
    input  logic btn_dec_n_i,
    input  logic btn_buz_n_i,

    input irq_i,
    input  [3:0] led_i,
    input  [7:0] command_i,

    output logic buzzer_en_o,
    output logic [3:0] led_o
);
    logic btn_inc;
    logic btn_dec;
    logic btn_buz;
    assign btn_inc = ~btn_inc_n_i;
    assign btn_dec = ~btn_dec_n_i;
    assign btn_buz = ~btn_buz_n_i;

    logic pressed_inc;
    logic pressed_dec;
    logic pressed_buz;

    logic [3:0] digit;

    always_comb begin
        case(command_i)
            8'h68: digit = 4'd0; // Botão 0
            8'h30: digit = 4'd1; // Botão 1
            8'h18: digit = 4'd2; // Botão 2
            8'h7A: digit = 4'd3; // Botão 3
            8'h10: digit = 4'd4; // Botão 4
            8'h38: digit = 4'd5; // Botão 5
            8'h5A: digit = 4'd6; // Botão 6
            8'h42: digit = 4'd7; // Botão 7
            8'h4A: digit = 4'd8; // Botão 8
            8'h52: digit = 4'd9; // Botão 9
            8'hA8: digit = led_i; // Botão +
            8'hE0: digit = led_i; // Botão -
            8'h90: digit = led_i; // Botão EQ
            default: digit = '0; // Outros botões
        endcase
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            /* Lógica do reset */
            pressed_inc <= 1'b0;
            pressed_dec <= 1'b0;
            pressed_buz <= 1'b0;
        end else begin
            /* Lógica síncrona */
            pressed_inc <= btn_inc; 
            pressed_dec <= btn_dec; 
            pressed_buz <= btn_buz; 

            // Operaçoes de soma, subtração e habilita buzzer
            // Operaçoes de soma
            if (((command_i == 8'hA8 && irq_i) || (btn_inc && !pressed_inc)) && (led_i != 4'b1111)) begin
                led_o <= led_i + 1'b1;
            // Operação de subtração
            end else if (((command_i == 8'hE0 && irq_i)  || (btn_dec && !pressed_dec)) && (led_i != 4'b0000)) begin
                led_o <= led_i - 1'b1;
            // Outras operações
            end else if(irq_i) begin 
                led_o <= digit;
            end

            // Habilita o buzzer
            if((command_i == 8'h90 && irq_i) || (btn_buz && !pressed_buz)) begin
                buzzer_en_o <= !buzzer_en_o;
            end 
        end
    end
endmodule
