module buzzer_control 
(
    input  logic clk_i,
    input  logic rst_n_i,

    input logic [3:0] led_n_i,

    output logic [21:0] cmp_freq_o,
    output logic [4:0][3:0] freq_bcd_o
);
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            cmp_freq_o <= 22'd250000;
            freq_bcd_o <= '0;
        end
        else begin
            // Lógica para definir cmp_freq_o e freq_bcd_o baseado em led_n_i
            // frequencia = 50.000.000 / (cmp_freq_o * 2)
            case(led_n_i) 
                4'b0000: begin
                    cmp_freq_o <= 22'd250000;
                    freq_bcd_o <= 20'b0000_0000_0001_0000_0000; //0100
                end
                4'b0001: begin
                    cmp_freq_o <= 22'd225000;
                    freq_bcd_o <= 20'b0000_0000_0001_0001_0001; //0111
                end
                4'b0010: begin
                    cmp_freq_o <= 22'd200000;
                    freq_bcd_o <= 20'b0000_0000_0001_0010_0101; //0125
                end
                4'b0011: begin
                    cmp_freq_o <= 22'd175000;
                    freq_bcd_o <= 20'b0000_0000_0001_0100_0010; //0142
                end
                4'b0100: begin
                    cmp_freq_o <= 22'd150000;
                    freq_bcd_o <= 20'b0000_0000_0001_0110_0110; //0166
                end
                4'b0101: begin
                    cmp_freq_o <= 22'd125000;
                    freq_bcd_o <= 20'b0000_0000_0010_0000_0000; //0200
                end
                4'b0110: begin
                    cmp_freq_o <= 22'd100000;
                    freq_bcd_o <= 20'b0000_0000_0010_0101_0000; //0250
                end
                4'b0111: begin
                    cmp_freq_o <= 22'd75000;
                    freq_bcd_o <= 20'b0000_0000_0011_0011_0011; //0333
                end
                4'b1000: begin
                    cmp_freq_o <= 22'd50000;
                    freq_bcd_o <= 20'b0000_0000_0101_0000_0000; //0500
                end
                4'b1001: begin
                    cmp_freq_o <= 22'd25000;
                    freq_bcd_o <= 20'b0000_0001_0000_0000_0000; //1000
                end
                4'b1010: begin
                    cmp_freq_o <= 22'd10000;
                    freq_bcd_o <= 20'b0000_0010_0101_0000_0000; //2500
                end
                4'b1011: begin
                    cmp_freq_o <= 22'd5000;
                    freq_bcd_o <= 20'b0000_0101_0000_0000_0000; //5000
                end
                4'b1100: begin
                    cmp_freq_o <= 22'd4500;
                    freq_bcd_o <= 20'b0000_0101_0101_0101_0101; //5555
                end
                4'b1101: begin
                    cmp_freq_o <= 22'd3500;
                    freq_bcd_o <= 20'b0000_0111_0001_0100_0010; //7142
                end
                4'b1110: begin
                    cmp_freq_o <= 22'd3000;
                    freq_bcd_o <= 20'b0000_1000_0001_0011_0011; //8333
                end
                4'b1111: begin
                    cmp_freq_o <= 22'd2500;
                    freq_bcd_o <= 20'b0001_0000_0000_0000_0000; //10.000
                end
                default: begin
                    cmp_freq_o <= 22'd250000;
                    freq_bcd_o <= 20'b0000_0000_0001_0000_0000; 
                end
            endcase
        end
    end
endmodule