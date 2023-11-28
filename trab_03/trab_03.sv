module trab_03 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic btn_inc_n_i,
    input  logic btn_dec_n_i,
    input  logic btn_buz_n_i,
    
    input  logic ir_i,
    
    output logic [3:0] led_n_o,
    output logic buzzer_o,

    output logic [3:0] disp_en_n_o,
    output logic [7:0] segment_n_o
);
    logic btn_inc_n_sync;
    logic btn_dec_n_sync;
    logic btn_buz_n_sync;

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

    synchronizer sync_btn_buz(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(btn_buz_n_i),
        .sync_o(btn_buz_n_sync)
    );

    logic btn_inc_n_sync_deb;
    logic btn_dec_n_sync_deb;
    logic btn_buz_n_sync_deb;

    logic ir_sync;

    synchronizer sync_ir(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .async_i(ir_i),
        .sync_o(ir_sync)
    );

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

    debouncer #(22) deb_buz(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .bounce_i(btn_buz_n_sync),
        .debounce_o(btn_buz_n_sync_deb)
    );

    logic irq;
    logic [7:0] command;

    ir ir_n(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .ir_i(ir_sync),
        .irq_o(irq),
        .command_o(command)
    );

    logic [3:0] led;
    logic buzzer_en;
    
    led_control ledControl(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .btn_inc_n_i(btn_inc_n_sync_deb),
        .btn_dec_n_i(btn_dec_n_sync_deb),
        .btn_buz_n_i(btn_buz_n_sync_deb),
        .irq_i(irq),
        .led_i(led),
        .command_i(command),
        .buzzer_en_o(buzzer_en),
        .led_o(led)
    );

    logic [21:0] cmp_freq;
    logic [4:0][3:0] freq_bcd;

    buzzer_control buzzerControl(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .led_n_i(led),
        .cmp_freq_o(cmp_freq),
        .freq_bcd_o(freq_bcd)
    );

    buzzer buzina(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .en_i(buzzer_en),
        .cmp_i(cmp_freq),
        .buzzer_o(buzzer_o)
    );

    display_control display(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .freq_bcd_n_i(freq_bcd),
        .disp_en_n_o(disp_en_n_o),
        .segment_n_o(segment_n_o)
    );

    assign led_n_o = ~led;

endmodule
