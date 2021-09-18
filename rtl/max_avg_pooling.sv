module max_avg_pooling 
#(
  parameter data_width = 8
)
(
  input logic [data_width-1:0] in1, in2, in3, in4,
  input logic en,
  output logic [data_width-1:0] max_out,
  output logic [data_width-1:0] avg_out
);

logic [data_width-1:0] max1, max2;

always_comb
  begin
    avg_out = '0;
    if (en) // max pooling
      begin
        if (in1[data_width-2:0] > in2[data_width-2:0])
          max1 = in1;
        else
          max1 = in2;
        
        if (in3[data_width-2:0] > in4[data_width-2:0])
          max2 = in3;
        else
          max2 = in4;
      end
    else  // avg pooling
      begin
        avg_out = (in1 + in2 + in3 + in4) >> 2;
      end
  end
  
assign max_out = (en) ? ((max1 > max2) ? max1 : max2) : 0;
  
endmodule
