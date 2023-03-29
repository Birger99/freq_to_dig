module dff (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif
    input d,
    input clk,
    input rstn,
    output reg q,
    output qn);

   always @ (posedge clk or negedge rstn)
      if (!rstn)
         q <= 1;
      else  
         q <= d;

   assign qn = ~q;
endmodule

module ref_count (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif
    input clk,
    input clear,
    output done);
   
   wire  q0;
   wire  qn0;
   wire  q1;
   wire  qn1;
   wire  q2;
   wire  qn2;
   wire  q3;
   wire  qn3;
   wire  q4;
   wire  qn4;
   wire  q5;
   wire  qn5;
   wire  q6;
   wire  qn6;
   wire  q7;
   wire  qn7;
   
   
   dff   dff0 ( .d (qn0), 
                .clk (clk),
                .rstn (clear),
                .q (q0),
                .qn (qn0));

   dff   dff1 ( .d (qn1), 
                .clk (q0),
                .rstn (clear),
                .q (q1),
                .qn (qn1));

   dff   dff2 ( .d (qn2), 
                .clk (q1),
                .rstn (clear),
                .q (q2),
                .qn (qn2));

   dff   dff3 ( .d (qn3), 
                .clk (q2),
                .rstn (clear),
                .q (q3),
                .qn (qn3));
                
   dff   dff4 ( .d (qn4),  
                .clk (q3),  
                .rstn (clear),  
                .q (q4),  
                .qn (qn4));
                
   dff   dff5 ( .d (qn5),  
                .clk (q4),  
                .rstn (clear),  
                .q (q5),  
                .qn (qn5));
                
   dff   dff6 ( .d (qn6),  
                .clk (q5),  
                .rstn (clear),  
                .q (q6),  
                .qn (qn6));  
                
   dff   dff7 ( .d (qn7),  
                .clk (q6),  
                .rstn (clear),  
                .q (q7),  
                .qn (qn7)); 

   assign done = qn7;

endmodule

module PTAT_count (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif
    input clk,
    input clear,
    output [11:0] out);

    wire  q0;
    wire  qn0;
    wire  q1;
    wire  qn1;
    wire  q2;
    wire  qn2;
    wire  q3;
    wire  qn3;
    wire  q4;
    wire  qn4;
    wire  q5;
    wire  qn5;
    wire  q6;
    wire  qn6;
    wire  q7;
    wire  qn7;
    wire  q8;
    wire  qn8;
    wire  q9;
    wire  qn9;
    wire  q10;
    wire  qn10;
    wire  q11;
    wire  qn11;
   
   
   dff   dff0 ( .d (qn0), 
                .clk (clk),
                .rstn (clear),
                .q (q0),
                .qn (qn0));

   dff   dff1 ( .d (qn1), 
                .clk (q0),
                .rstn (clear),
                .q (q1),
                .qn (qn1));

   dff   dff2 ( .d (qn2), 
                .clk (q1),
                .rstn (clear),
                .q (q2),
                .qn (qn2));

   dff   dff3 ( .d (qn3), 
                .clk (q2),
                .rstn (clear),
                .q (q3),
                .qn (qn3));
                
   dff   dff4 ( .d (qn4),  
                .clk (q3),  
                .rstn (clear),  
                .q (q4),  
                .qn (qn4));
                
   dff   dff5 ( .d (qn5),  
                .clk (q4),  
                .rstn (clear),  
                .q (q5),  
                .qn (qn5));
                
   dff   dff6 ( .d (qn6),  
                .clk (q5),  
                .rstn (clear),  
                .q (q6),  
                .qn (qn6));  
                
   dff   dff7 ( .d (qn7),  
                .clk (q6),  
                .rstn (clear),  
                .q (q7),  
                .qn (qn7));

    dff   dff8 ( .d (qn8),  
                .clk (q7),  
                .rstn (clear),  
                .q (q8),  
                .qn (qn8));

    dff   dff9 ( .d (qn9),  
                .clk (q8),  
                .rstn (clear),  
                .q (q9),  
                .qn (qn9));

    dff   dff10 ( .d (qn10),  
                .clk (q9),  
                .rstn (clear),  
                .q (q10),  
                .qn (qn10));

    dff   dff11 ( .d (qn11),  
                .clk (q10),  
                .rstn (clear),  
                .q (q11),  
                .qn (qn11)); 

   assign out = {qn11, qn10, qn9, qn8, qn7, qn6, qn5, qn4, qn3, qn2, qn1, qn0};

endmodule


module freq_to_dig (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif
    input F_REF,
    input start,
    output [11:0] out_d,
    output [12:0] io_oeb,
    output done);

    wire  int_F_PTAT;
    wire int_done;
    
    wire [11:0] data;

    and a1(int_F_REF, F_REF, !int_done); 
    and a2(int_F_PTAT, F_REF, !int_done);

    PTAT_count PTAT_count_inst ( .clk (int_F_PTAT),
                                .clear (start),
                                .out (data[11:0]));

    ref_count ref_count_inst ( .clk (int_F_REF), 
                               .clear (start),
                               .done (int_done));


    assign out_d = data[11:0];
    assign done = int_done;
    assign io_oeb = 13'b0000000000000;

endmodule