module Mul
  #(parameter width=8)(
  input [width-1:0] a, b,
  output [width-1:0] c
  );
  
  reg [(2*width)-1:0] mul;  //to hold the full value
  
  assign mul = a*b;
 
  assign c = mul[11:4];     //taking only the middle 8bits
  
endmodule
