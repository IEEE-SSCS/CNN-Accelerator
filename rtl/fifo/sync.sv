
parameter n=3;
module synchronizers (
input rst,clk,
output reg [n:0]wq2_rptr,
input [n:0]rptr
);

logic [n:0]signal;
always@(posedge clk ,negedge rst)//always_ff
begin

if (rst) 
begin 
wq2_rptr=0;
signal=0;
end
else
begin  
wq2_rptr=signal;
signal=rptr;
end 

end 



endmodule 
