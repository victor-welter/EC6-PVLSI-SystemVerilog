module exe_06_top 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_n_i,

    output logic [3:0] led_n_o,
    output logic buzzer_o
);

    logic btn_n_sync;

    synchronizer sync_btn(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_n_i),
        .sync_o(btn_n_sync)
    );

    logic btn_n_sync_deb;

    debouncer #(22) deb1(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_n_sync),
        .debounce_o(btn_n_sync_deb)
    );
    
    exe_06 exe(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .btn_n_i(btn_n_sync_deb),
        .led_n_o(led_n_o)
    );

    logic buzzer_en;
    assign buzzer_en = (led_n_o == '0);

    logic [21:0] cmp_freq;
    assign cmp_freq = 22'd125000;

    buzzer bubu(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .en_i(buzzer_en),
        .cmp_i(cmp_freq),
        .buzzer_o(buzzer_o)
    );

endmodule
