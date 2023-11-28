module display_mux
#(
    parameter SEG_CNT   = 4,
    parameter FPGA_FREQ = 50_000_000
)
(
    input  logic                        clk_i,
    input  logic                        rst_n_i,

    input  logic [(SEG_CNT - 1):0]      en_i,
    input  logic [(SEG_CNT - 1):0][7:0] seg_i,

    output logic [(SEG_CNT - 1):0]      dig_o,
    output logic                  [7:0] seg_o
);

    localparam DESIRED_FREQ = 1_000 * SEG_CNT;
    localparam DIVIDER_FREQ = FPGA_FREQ / DESIRED_FREQ;

    /* Geração do sinal de timer */
    logic [($clog2(DIVIDER_FREQ) - 1):0] timer;
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            timer <= '0;
        end 
        else begin
            if (timer == DIVIDER_FREQ)
                timer <= '0;
            else
                timer <= timer + 1'b1;
        end
    end

    /* Multiplexação dos displays */
    logic [($clog2(SEG_CNT) - 1):0] active;
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            active <= '0;
        end
        else begin
            if (timer == '0) begin
                if (active == (SEG_CNT - 1))
                    active <= '0;
                else
                    active <= active + 1'b1;
            end
        end
    end

    /* Qual segmento vai para a saída */
    assign seg_o = seg_i[active];

    /* Qual dígito de segmento está ativo (aceso) */
    logic [(SEG_CNT - 1):0] dig;
    always_comb begin
        dig         = '0;
        dig[active] = 1'b1;
    end

    assign dig_o = (dig & en_i);

endmodule
