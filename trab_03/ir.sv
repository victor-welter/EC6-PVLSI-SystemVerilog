module ir
(
    input  logic       clk_i,
    input  logic       rst_n_i,

    input  logic       ir_i,

    output logic       irq_o,
    output logic [7:0] command_o
);

////////////////////////////////////////////////////////////////////////////////
// Sinais globais
////////////////////////////////////////////////////////////////////////////////
    logic [4:0]  data_cnt;

////////////////////////////////////////////////////////////////////////////////
// Registrador da entrada do IR para obter o estado passado e detectar bordas
////////////////////////////////////////////////////////////////////////////////

    logic ir_r;
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            ir_r <= 1'b0;
        end
        else begin
            ir_r <= ir_i;
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Temporizador
////////////////////////////////////////////////////////////////////////////////

    /* Contar no máximo até 9 ms */
    /* Minha frequência é 50 MHz */
    /* O período é 1 / f = 20 ns */
    /* 9 ms / 20 ns = 450.000    */
    /* log2 (450.000) é 19       */
    /* Logo, precisamos 19 bits  */
    logic [18:0] counter;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            counter <= '0;
        end
        else begin
            counter <= counter + 1'b1;

            if (ir_r != ir_i)
                counter <= '0;
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Máquina de estados
////////////////////////////////////////////////////////////////////////////////

    typedef enum logic [4:0] {
        IDLE       = 5'b00001,
        LEAD_9MS   = 5'b00010,
        LEAD_4_5MS = 5'b00100,
        DATA       = 5'b01000,
        TRANSMIT   = 5'b10000
    } fsm_t;

    fsm_t state;
    fsm_t next_state;

    always_comb begin
        case (state)
            IDLE:       
                next_state = (ir_r && !ir_i) ? LEAD_9MS : IDLE;
            LEAD_9MS: begin
                if (ir_i) begin /* Não precisa detectar borda pois vem para o estado quando acontece a transição */
                    if (counter > 19'd400000 && counter < 19'd500000)
                        next_state = LEAD_4_5MS;
                    else
                        next_state = IDLE;
                end
                else begin
                    next_state = LEAD_9MS;
                end
            end
            LEAD_4_5MS: begin
                if (!ir_i) begin /* Não precisa detectar borda pois vem para o estado quando acontece a transição */
                    if (counter > 19'd200000 && counter < 19'd250000)
                        next_state = DATA;
                    else
                        next_state = IDLE;
                end
                else begin
                    next_state = LEAD_4_5MS;
                end
            end
            DATA:
                next_state = (
                    ir_r && !ir_i /* Borda de descida */
                    && data_cnt == '1
                )
                ? TRANSMIT
                : DATA;
            TRANSMIT:   
                next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end


////////////////////////////////////////////////////////////////////////////////
// Recepção de dados
////////////////////////////////////////////////////////////////////////////////

    logic [31:0] data;
    logic error;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            data <= '0;
            data_cnt <= '0;
            error <= 1'b0;
        end
        else begin
            if (state == DATA) begin        /* Enquanto recebe dados */
                if (ir_r && !ir_i) begin    /* Toda borda de descida */
                    if (counter > 19'd70000 && counter < 19'd90000) begin /* Entre 1.4 ms a 1.8 ms */
                        data[0] <= 1'b1;
                    end
                    else if (counter > 19'd15000 && counter < 19'd35000) begin /* Entre 300 us a 700 us */
                        data[0] <= 1'b0;
                    end
                    else begin
                        error <= 1'b1;
                    end
                    data[31:1] <= data[30:0]; /* Shift ou deslocamento */
                    data_cnt <= data_cnt + 1'b1;
                end
            end
            else if (state == IDLE) begin
                error  <= 1'b0;
                data_cnt <= '0;
            end
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Transmissão de dados
////////////////////////////////////////////////////////////////////////////////

    assign command_o = data[15:8];

    /* Poderia também verificar o endereço (bits 31:16) */
    /* Poderia também verificar command se é o inverso de !command dos bits 7:0 */
    assign irq_o = (state == TRANSMIT && !error);

endmodule
