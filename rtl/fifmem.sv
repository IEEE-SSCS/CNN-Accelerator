parameter data=3;
parameter address=10;
parameter n=3;
parameter depth=15;
module memory (
output [data-1:0]rdata,
input  [data-1:0]wdata,
input winc ,wfull ,clk,rst,
input [address-1:0] waddr, 
input [address-1:0] raddr 
);


reg [data-1:0] mem [depth-1:0];
reg wclken;
assign wclken = winc &(~wfull);
assign rdata=mem[raddr];

always@(posedge clk or negedge rst) //always_ff

begin
if(rst)
begin
for (int i=0 ;i<depth-1 ;i++) begin mem[i]=0; end 
end
else if (wclken==1) mem[waddr]= wdata;

end



endmodule 
