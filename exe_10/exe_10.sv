module exe_10 
(
    input  logic clk_i,
    input  logic rst_n_i,

    output logic [3:0] disp_en_n_o,
    output logic [7:0] segment_n_o
);

    logic [3:0] digit;
    assign disp_en_n_o = ~digit;

    logic [7:0] segment;
    assign segment_n_o = ~segment;

    logic [3:0][7:0] bcds;

    logic [3:0] enable;

    DisplayMux
    mux (
        .clk_i   (clk_i  ),
        .rst_n_i (rst_n_i),
        .en_i    (enable ),
        .seg_i   (bcds   ),
        .dig_o   (digit  ),
        .seg_o   (segment)
    );

    /* Contador de décimos de segundo */
    parameter FPGA_FREQ = 50_000_000;
    parameter DECI_DIV  = FPGA_FREQ / 10;

    logic [($clog2(DECI_DIV) - 1):0] timer;
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            timer <= 1'b1;
        end
        else begin
            timer <= timer + 1'b1;
            if (timer == DECI_DIV)
                timer <= '0;
        end
    end

    /* Contador de décimos de segundo, segundo, dezenas de segundo, e centenas de segundo */
    logic [3:0] deci;
    logic [3:0] seconds;
    logic [3:0] tens;
    logic [3:0] hundreds;
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            deci     <= '0;
            seconds  <= '0;
            tens     <= '0;
            hundreds <= '0;
        end
        else begin
            if (timer == '0) begin
                deci <= deci + 1'b1;
                if (deci == 4'h9) begin
                    deci <= '0;
                    seconds <= seconds + 1'b1;
                    if (seconds == 4'h9) begin
                        seconds <= '0;
                        tens <= tens + 1'b1;
                        if (tens == 4'h9) begin
                            tens <= '0;
                            hundreds <= hundreds + 1'b1;
                            if (hundreds == 4'h9) begin
                                hundreds <= '0;
                            end
                        end
                    end
                end
            end
        end
    end
    
    /* Conversão de binário para BCD */
    DisplayDecoder
    dec_deci (
        .bcd_i(deci),
        .seg_o(bcds[0][7:1])
    );
    assign bcds[0][0] = 1'b0;

    DisplayDecoder
    dec_seconds (
        .bcd_i(seconds),
        .seg_o(bcds[1][7:1])
    );
    assign bcds[1][0] = 1'b1;

    DisplayDecoder
    dec_tens (
        .bcd_i(tens),
        .seg_o(bcds[2][7:1])
    );
    assign bcds[2][0] = 1'b0;

    DisplayDecoder
    dec_hundreds (
        .bcd_i(hundreds),
        .seg_o(bcds[3][7:1])
    );
    assign bcds[3][0] = 1'b0;

    assign enable[3] = (hundreds != '0);
    assign enable[2] = (tens != '0) || enable[3];
    assign enable[1] = 1'b1;
    assign enable[0] = 1'b1;
    
endmodule
