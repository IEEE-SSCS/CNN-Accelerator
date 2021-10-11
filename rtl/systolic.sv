module PE
  #(parameter width=8)(
  input clk_in, nrst_in, ctrl_in,
  input [width-1:0] weight_in, feature_in, partial_sum_in,
  output [width-1:0] partial_sum_out, feature_out
  );
  
  wire [width-1:0] partial_sum_w; //output from addition operation
  wire [width-1:0] mul_w;         //output from multiplication operation
  reg  [width-1:0] weight_reg;    //saved weight in it
  
  
  assign feature_out = feature_in;
  assign partial_sum_out = (ctrl_in)?  weight_reg : partial_sum_w; //ctrl=0 : partial_sum_w
                                                                   //ctrl=1 : weight_reg
  
  //multiplication and addition 
  Mul u1(weight_reg,feature_in,mul_w);
  Add u2(partial_sum_in,mul_w,partial_sum_w);
                                                             
  always@(posedge clk_in, negedge nrst_in)
  begin
    if(!nrst_in)
      weight_reg <= 0;
    else
      weight_reg <= weight_in;
  end
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
module systolic_vector
  #(parameter width=8 , col = 3)(
  input [col-1:0]clk_in1, [col-1:0]nrst_in1, [col-1:0]ctrl_in1,[col-1:0][width-1:0] weight_input,[col-1:0][width-1:0] feature_input,
  output [width-1:0] vec_out , [col-1:0][width-1:0] feature_out1
  );

wire [col:0][width-1:0] sum_in; 
wire [col-1:0][width-1:0] sum_out;
reg first_sum = 8'b0;
wire [col-1:0][width-1:0] feature_output;

assign sum_out[col-1] = vec_out;
assign sum_in[0] = first_sum;
assign feature_out1 = feature_output;

genvar i;
generate
    for (i=0; i<=col-1; i=i+1) begin PE
         p1(
        .clk_in(clk_in1[i]),
        .nrst_in(nrst_in1[i]),
        .ctrl_in(ctrl_in1[i]),
        .weight_in(weight_input [i]),
        .feature_in(feature_input[i]),
        .partial_sum_in(sum_out[i]),
        .partial_sum_out(sum_in[i+1]),
        .feature_out(feature_out1[i])
    );
end 
endgenerate	 
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module systolic_array
  #(parameter width=8 , row=3 ,  col=3)(
  input [row*col-1:0]clk_in2, [row*col-1:0]nrst_in2, [row*col-1:0][col-1:0]ctrl_in2, [row*col-1:0][width-1:0] weight_input2 ,[row-1:0][width-1:0] feature_input2,
  output [row-1:0][width-1:0] sys_out 
  );

wire [row-1:0][width-1:0] out;
assign sys_out = out;
wire [row*col-1:0] [width-1:0]feature_wires;
genvar j;
genvar k;

generate
	for (j=0; j<=row-1; j=j+1) begin 
		for(k=0 ; k<= col-1 ; k++) begin
			systolic_vector p2(
        		.clk_in1(clk_in2[j+k]),
        		.nrst_in1(nrst_in2[j+k]),
       			.ctrl_in1(ctrl_in2[j+k]),
        		.weight_input(weight_input2 [j+k]),
        		.feature_input(feature_input2[k]),
        		.vec_out(out[j]),
        		.feature_out1(feature_wires[j+k])
		 );
		end
	end 
endgenerate
		 
endmodule


