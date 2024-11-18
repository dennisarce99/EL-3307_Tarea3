module Teclado (
    input logic rst,
    input logic clk_div,
    input logic [3:0] sync_row,
    output logic [3:0] col,
    output logic [3:0] num,
    output logic load_num
);

    reg [5:0] state, next_state;
    reg sum_row;

    parameter state0 = 6'b000001, state1 = 6'b000010, state2 = 6'b000100;
    parameter state3 = 6'b001000, state4 = 6'b010000, state5 = 6'b100000;

    always @(sync_row or col) begin
        case ({sync_row, col})
            {4'b0001, 4'b0001}: num = 4'b0000; //0
            {4'b0001, 4'b0010}: num = 4'b0001; //1
            {4'b0001, 4'b0100}: num = 4'b0010; //2
            {4'b0001, 4'b1000}: num = 4'b0011; //3
            {4'b0010, 4'b0001}: num = 4'b0100; //4
            {4'b0010, 4'b0010}: num = 4'b0101; //5
            {4'b0010, 4'b0100}: num = 4'b0110; //6
            {4'b0010, 4'b1000}: num = 4'b0111; //7
            {4'b0100, 4'b0001}: num = 4'b1000; //8
            {4'b0100, 4'b0010}: num = 4'b1001; //9
            {4'b0100, 4'b0100}: num = 4'b1010; //A - Signo Negativo
            {4'b0100, 4'b1000}: num = 4'b1011; //B - Intro
            {4'b1000, 4'b0001}: num = 4'b1100; //C - Borrar
            //{4'b1000, 4'b0010}: num = 4'b1101; //D
            //{4'b1000, 4'b0100}: num = 4'b1110; //#
            //{4'b1000, 4'b1000}: num = 4'b1111; //*
            default: num = 4'b0000;
        endcase
    end

    always_ff @(posedge clk_div) begin
        if (rst) begin
            state <= state0;
        end
        else begin
            state <= next_state;
        end
    end

    always @ (state or sync_row) begin
        next_state = state;
        col = 4'b1111;
        sum_row = sync_row[3] || sync_row[2] || sync_row[1] || sync_row[0];
        load_num = 1'b0;
        case (state)
            state0:
                begin
                    col = 4'b1111;
                    load_num = 1'b0;
                    if (sum_row) begin
                        next_state = state1;
                    end
                    else begin
                        next_state = state0;
                    end
                end
                
            state1:
                begin
                    col = 4'b0001;
                    if (sync_row) begin
                        next_state = state5;
                        load_num = 1'b1;
                    end
                    else begin
                        next_state = state2;
                    end
                end
                
            state2:
                begin
                    col = 4'b0010;
                    if (sync_row) begin
                        next_state = state5;
                        load_num = 1'b1;
                    end
                    else begin
                        next_state = state3;
                    end
                end
                
            state3:
                begin
                    col = 4'b0100;
                    if (sync_row) begin
                        next_state = state5;
                        load_num = 1'b1;
                    end
                    else begin
                        next_state = state4;
                    end
                end

            state4:
                begin
                    col = 4'b1000;
                    if (sync_row) begin
                        next_state = state5;
                        load_num = 1'b1;
                    end
                    else begin
                        next_state = state0;
                    end
                end

            state5:
                begin
                    col = 4'b1111;
                    load_num = 1'b0;
                    if (sync_row==0) begin
                        next_state = state0;
                    end
                    else begin
                        next_state = state1;
                    end
                end
                
            default: next_state = state0;    
        endcase
    end

endmodule