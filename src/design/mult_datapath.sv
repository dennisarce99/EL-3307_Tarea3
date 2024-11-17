/*typedef struct {
    logic load_A ;
    logic load_B ;
    logic load_add ;
    logic shift_HQ_LQ_Q_1 ;
    logic add_sub ;
} mult_control_t ;*/

module mult_with_no_fsm #(
    parameter n = 8
    ) (
    input logic clk ,
    input logic rst ,
    input logic [n-1:0] a,
    input logic [n-1:0] b,
    //input mult_control_t mult_control ,
    input logic load_A,
    input logic load_B,
    input logic load_add,
    input logic shift_HQ_LQ_Q_1,
    input logic add_sub,
    output logic [1:0] q_LSB,
    output logic [2*n-1:0] y
) ;


logic [n-1:0] m;
logic [n-1:0] adder_sub_out ;
logic [2*n: 0 ] shift ;
logic [n-1:0] hq;
logic [n-1:0] lq;
logic q_1;

//reg_M
always_ff@ (posedge clk , posedge rst ) begin
    if ( rst )
        m <='b0 ;
    else
        m <= (/*mult_control.*/load_A) ? a : m;
    end

// adder / sub
always_comb begin
    if (/*mult_control.*/add_sub )
        adder_sub_out = m + hq;
    else
        adder_sub_out = m - hq;
    end
// shift registers
always_comb begin
    y = {hq,lq} ;
    hq = shift[2*n:n+1];
    lq = shift[n:1] ;
    q_1 = shift[0] ;
    q_LSB = {lq[0] ,q_1} ;
end


always_ff@ (posedge clk , posedge rst ) begin
    if ( rst )
        shift <= 'b0 ;
    else if (/*mult_control.*/shift_HQ_LQ_Q_1)
        // arithmetic shift
        shift <= $signed (shift)>>>1;
         else begin
            if ( /*mult_control.*/load_B )
                shift [n:1] <= b;
            if ( /*mult_control.*/load_add )
                shift [2*n:n+1] <= adder_sub_out ;
        end
    end


endmodule