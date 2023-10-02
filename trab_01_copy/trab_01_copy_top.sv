module trab_01_copy_top 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_inc_n_i,
    input  logic btn_dec_n_i,
    input  logic btn_start_n_i,
    input  logic btn_stop_n_i,

    output logic [3:0] led_n_o,
    output logic buzzer_o
);

    logic btn_inc_n_sync;
    logic btn_dec_n_sync;
    logic btn_start_n_sync;
    logic btn_stop_n_sync;

    synchronizer sync_btn_inc(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_inc_n_i),
        .sync_o(btn_inc_n_sync)
    );

    synchronizer sync_btn_dec(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_dec_n_i),
        .sync_o(btn_dec_n_sync)
    );

    synchronizer sync_btn_start(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_start_n_i),
        .sync_o(btn_start_n_sync)
    );
    
    synchronizer sync_btn_stop(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_stop_n_i),
        .sync_o(btn_stop_n_sync)
    );

    logic btn_inc_n_sync_deb;
    logic btn_dec_n_sync_deb;
    logic btn_start_n_sync_deb;
    logic btn_stop_n_sync_deb;

    debouncer #(22) deb_inc(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_inc_n_sync),
        .debounce_o(btn_inc_n_sync_deb)
    );

    debouncer #(22) deb_dec(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_dec_n_sync),
        .debounce_o(btn_dec_n_sync_deb)
    );

    debouncer #(22) deb_start(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_start_n_sync),
        .debounce_o(btn_start_n_sync_deb)
    );

    debouncer #(22) deb_stop(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_stop_n_sync),
        .debounce_o(btn_stop_n_sync_deb)
    );

    logic buzzer_en;
    logic [21:0] cmp_freq;

    trab_01_copy exe(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .btn_inc_n_i(btn_inc_n_sync_deb),
        .btn_dec_n_i(btn_dec_n_sync_deb),
        .btn_start_n_i(btn_start_n_sync_deb),
        .btn_stop_n_i(btn_stop_n_sync_deb),
        .cmp_freq_n_o(cmp_freq),
        .buzzer_n_o(buzzer_en),
        .led_n_o(led_n_o)
    );

    buzzer bubu(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .en_i(buzzer_en),
        .cmp_i(cmp_freq),
        .buzzer_o(buzzer_o)
    );

endmodule
