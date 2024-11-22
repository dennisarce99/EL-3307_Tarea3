module FrecDivider (
  input logic clk,
  output logic clk_div
);

  reg [27:0] cont = 28'd0;
  parameter div = 28'd27000;
  
  always @(posedge clk) begin
    if (cont >= (div-28'd1)) begin cont <= 0; end
    else begin cont <= cont+28'd1; end
  end

  assign clk_div = (cont<div/2) ? 1'b1:1'b0;

endmodule