module MainModule(
    input logic clk,
    input logic rst, 
    input logic [3:0] row, 
    output logic [3:0] col,
    output logic [3:0] anodos,
    output logic [6:0] segmentos
);

    logic clk_div;
    logic [3:0] sync_row;
    logic [3:0] num;
    logic [1:0] load_num;

    FrecDivider Frec(
        .clk(clk),
        .clk_div(clk_div)
    );

    Sincronizador Sync(
        .clk_div(clk_div),
        .rst(rst),
        .row(row),
        .sync_row(sync_row)
    );

    Teclado Keypad(
        .rst(rst),
        .clk_div(clk_div),
        .sync_row(sync_row),
        .col(col),
        .num(num),
        .load_num(load_num)
    );

    display Segmentos7(
        .clk(clk),
        .clk_div(clk_div),
        .load_num(load_num),
        .num(num),
        .anodos(anodos),
        .segmentos(segmentos)
    );

endmodule