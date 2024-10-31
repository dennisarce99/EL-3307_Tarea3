module display (
    input logic clk,
    input logic clk_div,
    input logic [1:0] load_num,
    input logic [3:0] num,
    output logic [3:0] anodos,
    output logic [6:0] segmentos
);

    reg [1:0] select=0;
    reg [3:0] digito=0;

    always_ff @(posedge clk) begin
        select <= select + 1'b1;
    end

    always_ff @(posedge clk_div) begin
        if (load_num==1) begin
            digito <= num;
        end
    end

    //controla activar un display a la vez
    always_comb begin
        case (select) // traduce c/d numero BCD al 7seg correspondiente
            2'b00: begin
                anodos = 4'b0001; // Activar display 1
            end
            2'b01: begin
                anodos = 4'b0010; // Activar display 2
            end
            2'b10: begin
                anodos = 4'b0100; // Activar display 3
            end
            2'b11: begin 
                anodos = 4'b1000; // Activar display 4
            end
            default: begin
                anodos = 4'b0001;
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