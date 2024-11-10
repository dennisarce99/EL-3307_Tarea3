module Numeros (
    input logic clk,
    input logic rst,
    input logic [3:0] num,
    input logic load_num,

    output logic [15:0] num_o,
    output logic [15:0] num_A, num_B,
    output logic signal_num
);

    reg [2:0] state, next_state;
    reg [15:0] num_parcial;

    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011; 
    parameter s4 = 3'b100, s5 = 3'b101, s6 = 3'b110;
    parameter enter = 4'b1011, delete = 4'b1100;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= s0;
        end
        else if (load_num) begin
            state <= next_state;
        end
    end

    always_comb begin
        num_o = 0;
        num_parcial = 0;
        signal_num = 0;
        num_A = 0;
        num_B = 0;
        case (state)
            s0: begin
                num_o = 0;
                num_parcial = 0;
                signal_num = 0;
                if (load_num) begin
                    if (num == enter) begin
                        num_A = 0;
                        next_state = s3;
                    end
                    else if (num == delete) begin
                        next_state = s0;
                    end
                    else begin
                        num_o = num;
                        num_parcial = num;
                        next_state = s1;
                    end
                end
                else begin
                    next_state = s0;
                end
            end

            s1: begin
                if (load_num) begin
                    if (num == enter) begin
                        num_A = num_parcial;
                        next_state = s3;
                    end
                    else if (num == delete) begin
                        num_o = 0;
                        num_parcial = 0;
                        next_state = s0;
                    end
                    else begin
                        num_o = {num_parcial[15:4], num};
                        num_parcial = num_parcial*4'b1010 + num;
                        next_state = s2;
                    end
                end
                else begin
                    next_state = s1;
                end
            end

            s2: begin
                if (load_num) begin
                    if (num == enter) begin
                        num_A = num_parcial;
                        next_state = s3;
                    end
                    else if (num == delete) begin
                        num_o = {0, num_o};
                        num_parcial = num_o;
                        next_state = s1;
                    end
                    else begin
                        next_state = s2;
                    end
                end
                else begin
                    next_state = s2;
                end
            end

            s3: begin
                if (load_num) begin
                    if (num == enter) begin
                        num_B = 0;
                        next_state = s6;
                        signal_num = 1;
                    end
                    else if (num == delete) begin
                        next_state = s3;
                    end
                    else begin
                        num_o = num;
                        num_parcial = num;
                        next_state = s4;
                    end
                end
                else begin
                    next_state = s3;
                end
            end

            s4: begin
                if (load_num) begin
                    if (num == enter) begin
                        num_B = num_parcial;
                        next_state = s6;
                        signal_num = 1;
                    end
                    else if (num == delete) begin
                        num_o = 0;
                        num_parcial = 0;
                        next_state = s3;
                    end
                    else begin
                        num_o = {num_parcial[15:4], num};
                        num_parcial = num_parcial*4'b1010 + num;
                        next_state = s5;
                    end
                end
                else begin
                    next_state = s4;
                end
            end

            s5: begin
                if (load_num) begin
                    if (num == enter) begin
                        num_B = num_parcial;
                        next_state = s6;
                        signal_num = 1;
                    end
                    else if (num == delete) begin
                        num_o = {0, num_o};
                        num_parcial = num_o;
                        next_state = s4;
                    end
                    else begin
                        next_state = s5;
                    end
                end
                else begin
                    next_state = s5;
                end
            end

            s6: begin
                if (load_num) begin
                    if (num == enter) begin
                        signal_num = 0;
                        next_state = s0;
                    end
                    else begin
                        next_state = s6;
                    end
                end
                else begin
                    next_state = s6;
                end
            end

            default: begin
                next_state = s0;
                num_o = 0;
                num_parcial = 0;
                signal_num = 0;
                num_A = 0;
                num_B = 0;
            end

        endcase
    end

endmodule