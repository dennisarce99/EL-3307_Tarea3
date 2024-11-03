module Numeros (
    input logic clk,
    input logic rst,
    input logic [3:0] num,
    input logic load_num,
    output logic [15:0] num_o,
    output logic [15:0] num_mult 
    output logic signal_num;
    //senal de LISTO
);

    reg [1:0] state, next_state;
    reg [15:0] num_parcial;

    parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
    parameter enter = 4'b1011, delete - 4'b1100;
    
    always_ff @(clk) begin
        if (rst) begin
            state <= s0;
        end
        else if (load_num) begin
            state <= next_state;
        end
    end

    always_comb begin
        num_o = 0;
        case (state)
            s0: begin
                num_parcial = 0;
                num_mult = 0;
                signal_num = 0;
                if (load_num) begin
                   state = s1; 
                end
                else begin
                    state = s0;
                end
            end

            s1: begin
                if (num == enter or num == delete) begin
                    state = s0;
                end
                else begin
                    num_parcial[3:0] = num;
                    if (load_num) begin
                        state = s2;
                    end
                end
            end

            s2: begin
                if (num == enter) begin
                    num_o = num_parcial;
                    num_mult = num_parcial;
                    signal_num = 1'b1;
                    state = s0;
                end
                else (num == delete) begin
                    num_parcial = {0, num_parcial[15:4]};
                    state = s0;
                end
                else begin
                    num_parcial = {num_parcial[11:0], num};
                    if (load_num) begin
                        state = s3;
                    end
                end
            end

            s3: begin
                if (num == enter) begin
                    num_o = num_parcial;
                    num_mult = num_parcial[7:4]*4'b1010 + num_parcial[3:0];
                    signal_num = 1'b1;
                    state = s0;
                end
                else (num == delete) begin
                    num_parcial = {0, num_parcial[15:4]};
                    state = s1;
                end
                else begin
                    num_parcial = 0;
                    state = s0;
                end
            end

            default: begin state = s0; end
        endcase
    end

endmodule