module FrecDivider (
  input logic clk,
  output logic clk_div
);

    reg [26:0] cont = 27'd0;

    always @(posedge clk) begin
        cont <= (cont >= 27'd269) ? 0:(cont+27'd1);
    end

    assign clk_div = (cont == 269) ? 1'b1:1'b0;

endmodule