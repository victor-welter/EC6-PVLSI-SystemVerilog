module testbench();
    localparam  CLK_PERIOD = 20;

	logic clk;
	always #(CLK_PERIOD/2) clk = ~clk;

	logic rst_n;

    logic p;
    logic r;

    exe_01 exe(
        .clk_i(clk),
        .rst_ni(rst_n),
        .p_i(p),
        .r_o(r)
    );

	initial begin
        rst_n <= 1'b0;
        p <= 1'b0;
        #(CLK_PERIOD*3) rst_n <= 1'b1;

        repeat(10) begin
            #(CLK_PERIOD) p <= ~p;
        end
	end

endmodule
