module synchronizer
(
    input  logic clk_i,
    input  logic rst_n_i,

    input  logic async_i,

    output logic sync_o
);
    logic ff;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            /* Reset assíncrono */
            ff <= 1'b0;
            sync_o <= 1'b0;
        end
        else begin
            /* Lógica sincrona */
            ff <= async_i;
            sync_o <= ff;
        end
    end

endmodule
