
parameter n=3;
//-------------------------bin2gray---------------------------------------
function [n-1:0] gnext;
         input [n-1:0] bnext;
         int i;
     begin
       gnext[n-1]=bnext[n-1];
          for ( i=n-1; i>=0; i-- )
            begin
              gnext[i-1]=bnext[i]^bnext[i-1] ;
             end
       end
 endfunction 
//-------------------------gray2binary---------------------------------------
function [n-1:0] bin;
      input [n-1:0] ptr;
      int i;
         begin
bin[n-1]=ptr[n-1];
   for ( i=n-1; i>=0; i-- )
     begin
   bin[i-1]=bin[i]^ptr[i-1] ;
     end
end
 endfunction 



module counter1 (
input inc,
input eOf,
input clck ,rst,
output reg [n-1:0] ptr,
output  reg addrmsb 
);



reg [n-1:0] bnext;
reg [n-1:0] gnext1;
reg msbnext;



assign bnext = bin(ptr)+ (inc&~eOf);


assign gnext1= gnext(bnext);
assign msbnext = gnext1[n-1] ^ gnext1[n-2];



always@(posedge clck or negedge rst) //always_ff

begin 

if(rst)
begin
 ptr=0;
 addrmsb=0;
end
else 
begin
  ptr=gnext1;
   addrmsb=msbnext; 

end 


end

endmodule 