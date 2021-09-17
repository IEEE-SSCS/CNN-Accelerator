module Relu #(parameter width)( 
input logic  [width:0] in  ,   
output logic [width:0] out 
);

assign out  =   ( in[width] == 0 ) ? in  : 0  ;

endmodule 