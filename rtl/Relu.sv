module Relu #(parameter width = 8)( 
input logic  [width-1:0] in  ,   
output logic [width-1:0] out 
);

assign out  =   ( in[width-1] == 0 ) ? in  : 0  ;

endmodule 
