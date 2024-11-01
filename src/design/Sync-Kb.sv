module Sincronizador (
    input logic clk_div,
    input logic rst,
    input logic [3:0] row,
    output logic [3:0] sync_row
);
    
    reg [3:0] val;

    always_ff @(posedge clk_div) begin
        if (rst) begin
            val <= 0;
            sync_row <= 0;
        end
        else begin
            val <= row;
            sync_row <= val;
        end
    end

endmodule