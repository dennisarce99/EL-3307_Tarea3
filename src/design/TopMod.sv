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
    logic [15:0] num_A, bcd_A;
    logic [15:0] num_B, bcd_B;
    logic num_Y, bcd_Y;
    mult_control_t mult_control;

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


    Numeros NumeroA(
        .clk(clk),
        .rst(rst),
        .num(num),
        .load_num(load_num),
        .num_o(num_A)
        );

    bin_decimal BCD_A(
        .binario(num_A),
        .bcd(bcd_A)
    );

    Numeros NumeroB(
        .clk(clk),
        .rst(rst),
        .num(num),
        .load_num(load_num),
        .num_o(num_B)
        );

    bin_decimal BCD_B(
        .binario(num_B),
        .bcd(bcd_B)
    );
    
    
    mult_with_no_fsm Multiplicador #(.N(8)) (
        .clk(clk),
        .rst(rst),
        .A(bcd_A),
        .B(bcd_B),
        .mult_control(mult_control),
        .Q_LSB(),
        .Y(bcd_Y)
    );

    /*display Segmentos7(
        .clk(clk),
        .clk_div(clk_div),
        .load_num(load_num),
        .num(num),
        .anodos(anodos),
        .segmentos(segmentos)
    );*/

endmodule