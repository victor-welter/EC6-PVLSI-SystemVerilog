module display_control 
(
    input  logic clk_i,
    input  logic rst_n_i,
    input  logic [4:0][3:0] freq_bcd_n_i, 

    output logic [3:0] disp_en_n_o,
    output logic [7:0] segment_n_o
);

    logic [3:0] digit;
    assign disp_en_n_o = ~digit;

    logic [7:0] segment;
    assign segment_n_o = ~segment;

    logic [3:0][7:0] bcds;
    logic [3:0] enable;

    logic [3:0] counters [0:3];

    display_mux mux (
        .clk_i   (clk_i  ),
        .rst_n_i (rst_n_i),
        .en_i    (enable ),
        .seg_i   (bcds   ),
        .dig_o   (digit  ),
        .seg_o   (segment)
    );

    logic [3:0] uni;
    logic [3:0] dec;
    logic [3:0] cen;
    logic [3:0] mil;

    /* Lógica para processar freq_bcd_n_i e atualizar os contadores e o display */
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            // Reinicie contadores e outros sinais de controle
            uni <= '0;
            dec <= '0;
            cen <= '0;
            mil <= '0;
        end
        else begin
            if((freq_bcd_n_i[4] != '0) || (freq_bcd_n_i[3] != '0)) begin
                mil <= freq_bcd_n_i[4];
                cen <= freq_bcd_n_i[3];
                dec <= freq_bcd_n_i[2];
                uni <= '1;
            end else begin
                mil <= freq_bcd_n_i[3];
                cen <= freq_bcd_n_i[2];
                dec <= freq_bcd_n_i[1];
                uni <= freq_bcd_n_i[0];
            end
        end
    end

    /* Conversão de binário para BCD */
    display_decoder uni_decoder (
        .bcd_i(uni),
        .seg_o(bcds[0][7:1])
    );
    assign bcds[0][0] = 1'b0;

    display_decoder dec_decoder (
        .bcd_i(dec),
        .seg_o(bcds[1][7:1])
    );
    assign bcds[1][0] = 1'b0;

    display_decoder cen_decoder (
        .bcd_i(cen),
        .seg_o(bcds[2][7:1])
    );
    assign bcds[2][0] = (uni == '1);

    display_decoder mil_decoder (
        .bcd_i(mil),
        .seg_o(bcds[3][7:1])
    );
    assign bcds[3][0] = 1'b0; 

    assign enable[3] = (mil != '0);
    assign enable[2] = 1'b1;
    assign enable[1] = 1'b1;
    assign enable[0] = 1'b1;

endmodule
