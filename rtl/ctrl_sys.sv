module sys_ctrl (
input clk,
input w_ps,
input rst,
output reg ctrl_out,test
);

parameter s0 = 2'b00  ,
          s1 = 2'b01  ,
          s2 = 2'b10  ;  
          

logic [0:1] present,next;
logic[3:0]  x,y; 

always_ff @(posedge clk or negedge rst) 
	begin
		if(rst) begin present <= s0; y <= 4'b0; end
		else  begin  present <= next; y <= x; end 
	end


always_comb

	begin 
	 x = y;
	 next=s0;
		case(present) 
			s0: if(w_ps==1) begin next=s1; ctrl_out= 1;x = 4'b0; end
			    else     begin next=s0 ;x = 4'b0; end   
                                                     // load to weight
		        s1: if(w_ps==1 && x<4) begin  next=s1;  ctrl_out= 1;  x= y+ 1; test=1; end
                                       // load to partial_sum
			    else  begin  next=s2;  ctrl_out= 0; end 

			s2: if(w_ps==0) begin next=s2; ctrl_out= 0; end 
			    else next=s0;      				
		  endcase
	end



endmodule
