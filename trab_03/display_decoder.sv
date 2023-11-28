module display_decoder 
(
    input  logic [3:0] bcd_i,
    output logic [6:0] seg_o
);

    always_comb begin
        case (bcd_i)
            4'h0: seg_o = 7'b1111110;
            4'h1: seg_o = 7'b0110000;
            4'h2: seg_o = 7'b1101101;
            4'h3: seg_o = 7'b1111001;
            4'h4: seg_o = 7'b0110011;
            4'h5: seg_o = 7'b1011011;
            4'h6: seg_o = 7'b1011111;
            4'h7: seg_o = 7'b1110000;
            4'h8: seg_o = 7'b1111111;
            4'h9: seg_o = 7'b1111011;
            4'hA: seg_o = 7'b1110111;
            4'hB: seg_o = 7'b0011111;
            4'hC: seg_o = 7'b1001110;
            4'hD: seg_o = 7'b0111101;
            4'hE: seg_o = 7'b1001111;
            4'hF: seg_o = 7'b1010111; //É PRA SER UM "K"
        endcase
    end

endmodule
