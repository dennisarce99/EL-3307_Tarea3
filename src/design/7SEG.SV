module display (
    input logic clk,
    input logic clk_div,
    input logic load_num,
    input logic [15:0] num,
    output logic [4:0] anodos,
    output logic [6:0] segmentos
);

    reg [2:0] select, next_select;
    reg [3:0] digito, next_digito;

    parameter sel0 = 3'b000, sel1 = 3'b001, sel2 = 3'b010, sel3 = 3'b011, sel4 = 3'b100;

    always_ff @(posedge clk) begin
        select <= next_select;
        digito <= next_digito;
    end

    //controla activar un display a la vez
    always @ (posedge clk) begin
        case (select) // traduce c/d numero BCD al 7seg correspondiente
            sel0: begin
                anodos = 5'b00001; // Activar display 1
                next_select = sel1;
                next_digito = num[3:0];
            end

            sel1: begin
                anodos = 5'b00010; // Activar display 2
                next_select = sel2;
                next_digito = num[7:4];
            end

            sel2: begin
                anodos = 5'b00100; // Activar display 3
                next_select = sel3;
                next_digito = num[11:8];
            end

            sel3: begin 
                anodos = 5'b01000; // Activar display 4
                next_select = sel4;
                next_digito = num[15:12];
            end
            
            sel4: begin
                anodos = 5'b10000;
                next_select = sel0;
                next_digito = 4'b0000;
            end

            default: begin
                anodos = 5'b00000;
                next_select = sel0;
                next_digito = num[3:0];
            end
        endcase  
    end

    // controla el segmentos de acuerdo con el digito BCD
    always_comb begin
        case(digito)
            4'd0: segmentos = 7'b0111111; // 0
            4'd1: segmentos = 7'b0000110; // 1
            4'd2: segmentos = 7'b1011011; // 2
            4'd3: segmentos = 7'b1001111; // 3
            4'd4: segmentos = 7'b1100110; // 4
            4'd5: segmentos = 7'b1101101; // 5
            4'd6: segmentos = 7'b1111101; // 6
            4'd7: segmentos = 7'b0000111; // 7
            4'd8: segmentos = 7'b1111111; // 8
            4'd9: segmentos = 7'b1101111; // 9
            default: segmentos = 7'b1111111; // Desactiva los segmentos
        endcase
    end

endmodule