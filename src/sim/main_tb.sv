`timescale 1ns/1ps

module MainTB;

    logic clk, rst;
    logic [3:0] row, col;
    logic [4:0] anodos;
    logic [6:0] segmentos;
 
    MainModule MainTop(
        .clk(clk),
        .rst(rst),
        .row(row),
        .col(col),
        .anodos(anodos),
        .segmentos(segmentos)
        );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        row = 4'b0000;
        #100
        row = 4'b0010;
        #270
        row = 4'b0000;
        #100
        row = 4'b0100;
        #270
        row = 4'b0000;
        #100
        row = 4'b0100;
        #270
        row = 4'b0000;
        
        #100
        row = 4'b0100;
        #270
        row = 4'b0000;
        #100
        row = 4'b1000;
        #270
        row = 4'b0000;
        #100
        row = 4'b0001;
        #270
        row = 4'b0000;
        
        #300
        $finish;
    end

    initial begin
        $monitor("Display=%b, Segmentos=%b, Col=%b, Row=%b", anodos, segmentos, col, row);
    end

    initial begin
        $dumpfile("MainTB.vcd");
        $dumpvars(0, MainTB);
    end
    
endmodule