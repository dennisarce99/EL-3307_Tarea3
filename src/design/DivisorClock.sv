module FrecDivider (
  input logic clk,
  output logic clk_div
);

    reg [26:0] cont = 0;

    always @(posedge clk) begin
        cont <= (cont >= 269) ? 0:(cont+1);
    end

    assign clk_div = (cont == 269) ? 1'b1:1'b0;

endmodule