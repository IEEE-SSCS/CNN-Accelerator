module max_avg_pooling
  #(
     parameter data_width = 8
   )
   (
     input logic [data_width-1:0] in1, in2, in3, in4,
     input logic en,
     output logic [data_width-1:0] out
   );

  logic [data_width-1:0] max1, max2, avg_out;

  always_comb
  begin
    avg_out = '0;
    if (en) // max pooling
    begin
      if (in1 > in2)
        max1 = in1;
      else
        max1 = in2;

      if (in3 > in4)
        max2 = in3;
      else
        max2 = in4;
    end
    else  // avg pooling
    begin
      avg_out = (in1 + in2 + in3 + in4) >> 2;
    end
  end

  assign out = (en) ? ((max1 > max2) ? max1 : max2) : avg_out;

endmodule
