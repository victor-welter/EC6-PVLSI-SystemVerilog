module synchronizer (
    input logic clk_i,
    input logic rst_ni,

    input logic async_i,

    output logic sync_o
);

	logic ff;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            ff <= 1'b0;
            sync_o <= 1'b0;
        end else begin
            ff <= async_i;
            sync_o <= ff;
        end
    end

endmodule