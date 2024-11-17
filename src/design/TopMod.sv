module MainModule(
    input logic clk,
    input logic rst, 
    input logic [3:0] row, 
    output logic [3:0] col,
    output logic [4:0] anodos,
    output logic [6:0] segmentos
);

    logic clk_div;
    logic [3:0] sync_row;
    logic [3:0] num;
    logic load_num;
    logic [7:0] num_A;
    logic [7:0] num_B;
    logic [7:0] num_o;
    logic signal_num;

    logic [15:0] num_Y;
    logic [15:0] bcd_Y;
    logic [1:0] q_LSB;
    /*mult_control_t mult_control;*/
    logic [15:0] num_display;

    logic load_A;
    logic load_B;
    logic load_add;
    logic shift_HQ_LQ_Q_1;
    logic add_sub;

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
 
    control #(.n(8)) ctrl (
        .clk(clk),
        .rst(rst),
        .signal_num(signal_num),
        .q_LSB(q_LSB),
        .load_A(load_A),
        .load_B(load_B),
        .load_add(load_add),
        .shift_HQ_LQ_Q_1(shift_HQ_LQ_Q_1),
        .add_sub(add_sub)
    );

    mult_with_no_fsm #( .n(8) ) Multiplicador (
        .clk(clk),
        .rst(rst),
        .a(num_A),
        .b(num_B),
        .load_A(load_A),
        .load_B(load_B),
        .load_add(load_add),
        .shift_HQ_LQ_Q_1(shift_HQ_LQ_Q_1),
        .add_sub(add_sub),
        .q_LSB(q_LSB),
        .y(num_Y)
    );

    bin_decimal Bin_BCD(
        .binario(num_Y),
        .bcd(bcd_Y)
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