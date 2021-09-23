module Add
  #(parameter width=8)(
  input [width-1:0] a, b,
  output [width-1:0] c
  );
  
  assign c = a+b;
  
endmodule
