module exe_05_top 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_n_i,

    output logic [3:0] led_n_o
);

    logic btn_n_sync;
    logic btn_n_sync_deb;

    synchronizer sync_btn(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_n_i),
        .sync_o(btn_n_sync)
    );

    debouncer #(22) deb1(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_n_sync),
        .debounce_o(btn_n_sync_deb)
    );
    
    exe_5 exe(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .btn_n_i(btn_n_sync_deb),
        .led_n_o(led_n_o)
    );

endmodule
