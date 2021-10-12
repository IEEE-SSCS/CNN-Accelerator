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
int x =0;
always @(posedge clk or negedge rst) 
	begin
		if(rst) present <= s0;
		else   present <= next;
	end


always @( present , w_ps )

	begin 
		next=s0;
		case(present) 
		 
			s0: if(w_ps==1)  next=s0;
			    else     begin next=s1; ctrl_out= 1; end

		        s1: if(w_ps==1) begin  next=s2;  ctrl_out= 0; end
			    else        begin  next=s1;  ctrl_out= 1; end 

			s2: if(w_ps==0) begin next=s1; x=x+1; ctrl_out= 1; end 
			    else if (x==32)   exit=1;  
		  endcase
		

	end



endmodule 
