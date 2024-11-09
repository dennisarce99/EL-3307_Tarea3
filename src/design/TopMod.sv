module MainModule(
    input logic clk,
    input logic rst, 
    input logic [3:0] row, 
    output logic [3:0] col,
    output logic [3:0] anodos,
    output logic [6:0] segmentos
);

    logic [1:0] cont;
    logic clk_div;
    logic [3:0] sync_row;
    logic [3:0] num;
    logic [1:0] load_num;
    logic [15:0] num_A;
    logic [15:0] num_B;
    logic signal_num;

    logic [15:0] num_Y;
    logic [15:0] bcd_Y;
    logic Q_LSB;
    mult_control_t mult_control;

    logic [15:0] num_display;

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

    Numeros Multiplicandos (
        .clk(clk),
        .rst(rst),
        .num(num),
        .load_num(load_num),
        .num_o(num_o),
        .num_A(num_A),
        .num_B(num_B),
        .signal_num(signal_num)
    );
 

    mult_with_no_fsm Multiplicador #(.N(8)) (
        .clk(clk),
        .rst(rst),
        .A(num_A),
        .B(num_B),
        .mult_control(mult_control),
        .Q_LSB(Q_LSB),
        .Y(num_Y)
    );

    bin_decimal Bin_BCD(
        .binario(num_Y),
        .bcd(bcd_Y),
    );

    assign num_display = (signal_num == 0) ? num_o:bcd_Y;

    display Segmentos7(
        .clk(clk),
        .clk_div(clk_div),
        .load_num(load_num),
        .num(num_display),
        .anodos(anodos),
        .segmentos(segmentos)
    );

endmodule