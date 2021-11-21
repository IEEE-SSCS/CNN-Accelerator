module sys_ctrl (
input clk,
input w_ps,
input rst,
output reg ctrl_out,exit
);

parameter s0 = 2'b00  ,
          s1 = 2'b01  ,
          s2 = 2'b10  ;  
          

logic [0:1] present,next;
logic  x,y; 

always @(posedge clk or negedge rst) 
	begin
		if(rst) present <= s0;
		else  begin  present <= next; x <= y; end 
	end


always @( present , w_ps )

	begin 
	 y = x;
		next=s0;
		case(present) 
			s0: if(w_ps==1) begin next=s1; ctrl_out= 1; x=0; end
			    else     begin next=s0 ; y=0; end   
                                                     // load to weight
		    s1: if(w_ps==1 && y<32) begin  next=s1;  ctrl_out= 1;  y= x + 1;  end
                                       // load to partial_sum
			    else  begin  next=s2;  ctrl_out= 0; end 

			s2: if(w_ps==0) begin next=s2; ctrl_out= 0; end 
			    else next=s0;      				
		  endcase
	end



endmodule
