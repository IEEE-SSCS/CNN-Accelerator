module PE
  #(parameter width=8)(
  input clk_in, nrst_in, ctrl_in,
  input [width-1:0] weight_in, feature_in, partial_sum_in,
  output [width-1:0] partial_sum_out, feature_out
  );
  
  wire [width-1:0] partial_sum_w; //output from addition operation
  wire [width-1:0] mul_w;         //output from multiplication operation
  reg  [width-1:0] weight_reg;    //saved weight in it
  
  
  assign feature_out = feature_in;
  assign partial_sum_out = (ctrl_in)? weight_reg : partial_sum_w; //ctrl=0 : partial_sum_w
                                                                  //ctrl=1 : weight_reg
  
  //multiplication and addition 
  Mul u1(weight_reg,feature_in,mul_w);
  Add u2(partial_sum_in,mul_w,partial_sum_w);
                                                             
  always@(posedge clk_in, negedge nrst_in)
  begin
    if(!nrst_in)
      weight_reg <= 0;
    else
      weight_reg <= weight_in;
  end
endmodule
  
