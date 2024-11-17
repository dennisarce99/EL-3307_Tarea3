/*typedef struct {
    logic load_A ;
    logic load_B ;
    logic load_add ;
    logic shift_HQ_LQ_Q_1 ;
    logic add_sub ;
} mult_control_t ;*/

module control #(
    parameter n = 8
    ) (
    input logic clk,
    input logic rst,
    input logic signal_num,
    input logic [1:0] q_LSB,
    //output mult_control_t mult_control
    output logic load_A,
    output logic load_B,
    output logic load_add,
    output logic shift_HQ_LQ_Q_1,
    output logic add_sub
    );

    reg [6:0] state, next_state;
    reg [2:0] cont;
    reg [1:0] z;

    parameter idle = 7'b0000001, init = 7'b0000010, sel0 = 7'b0000100; 
    parameter sum = 7'b0001000, res = 7'b0010000, shift = 7'b0100000, sel1 = 7'b1000000;

    always_ff @(posedge clk) begin
        if (rst) begin
            cont <= 3'b111;
            state <= idle;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;        
        cont = 3'b111; 
        load_A = 1'b0;
        load_B = 1'b0;
        load_add = 1'b0;
        shift_HQ_LQ_Q_1 = 1'b0;
        add_sub = 1'b0;
        z = 1'b0;
        case (state)
            idle: begin
                if (signal_num) begin
                    next_state = init;
                end
                else begin
                    next_state = idle;
                end
            end

            init: begin
                cont = 3'b111;
                /*mult_control.*/load_A = 1'b1;
                /*mult_control.*/load_B = 1'b1;
                /*mult_control.*/load_add = 0;
                /*mult_control.*/shift_HQ_LQ_Q_1 = 0;
                /*mult_control.*/add_sub = 0;
                next_state = sel0;
            end

            sel0: begin
                cont = 3'b111;
                /*mult_control.*/load_A = 0;
                /*mult_control.*/load_B = 0;
                /*mult_control.*/load_add = 0;
                /*mult_control.*/shift_HQ_LQ_Q_1 = 1'b1;
                /*mult_control.*/add_sub = 0;
                if (q_LSB[0] == q_LSB[1]) begin
                    next_state = shift;
                end
                else if (q_LSB[0]) begin
                    next_state = sum;
                end
                else if (q_LSB[1]) begin
                    next_state = res;
                end
            end

            sum: begin
                cont = 3'b111;
                /*mult_control.*/load_A = 0;
                /*mult_control.*/load_B = 0;
                /*mult_control.*/load_add = 1'b1;
                /*mult_control.*/shift_HQ_LQ_Q_1 = 0;
                /*mult_control.*/add_sub = 1'b1;
                next_state = shift;
            end

            res: begin
                cont = 3'b111;
                /*mult_control.*/load_A = 0;
                /*mult_control.*/load_B = 0;
                /*mult_control.*/load_add = 1'b1;
                /*mult_control.*/shift_HQ_LQ_Q_1 = 0;
                /*mult_control.*/add_sub = 0;
                next_state = shift;
            end

            shift: begin
                cont = cont - 1'b1;
                if (cont == 3'b000) begin
                    z = 1'b1;
                end
                else begin
                    z = 1'b0;
                end
                next_state = sel1;
            end

            sel1: begin
                if (z) begin
                    next_state = idle;
                end
                else begin
                    next_state = sel0;
                end
            end

            default: begin
                cont = 3'b111;
                /*mult_control.*/load_A = 0;
                /*mult_control.*/load_B = 0;
                /*mult_control.*/load_add = 0;
                /*mult_control.*/shift_HQ_LQ_Q_1 = 0;
                /*mult_control.*/add_sub = 0;
                next_state = idle;
                z = 1'b0;
            end
        endcase
    end

endmodule