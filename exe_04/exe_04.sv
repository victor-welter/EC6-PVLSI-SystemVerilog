module exe_04
(
    input logic clk_i,
	input logic rst_ni,

    input logic btn_n_i,
	
    output logic[3:0] led_n_o
);
	logic btn;
	logic btnPressed = 1'b0;
	logic [3:0] led;

    assign btn = ~btn_n_i;
    assign led_n_o = ~led;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            led <= '0;
        end else begin
            if(btn) begin
                if(!btnPressed) begin
                    led <= led + 1'b1;
                    btnPressed <= 1'b1;
                end
            end else begin
                btnPressed <= 1'b0;
            end
        end
    end

endmodule