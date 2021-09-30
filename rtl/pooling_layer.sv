module pooling_layer
  #(
     parameter pooling_units = 32,
     parameter data_width = 8,
     parameter H = 32,
     parameter W = 32,
     parameter S = 2,
     parameter K = 2,
     parameter depth = 1,
     parameter H_P = (((H - K)/S) + 1),  // output size,
     parameter W_P = (((W - K)/S) + 1)   // output size
   )
   (
     input logic clk, nrst, ctrl_Pool, max_avg_ctrl,
     input logic [data_width-1:0] pooling_in [H-1:0] [(K*S)-1:0],
     output logic [data_width-1:0] pooling_out [H-1:0]
   );

  logic [data_width-1:0] data_in  [H-1:0] [(K*S)-1:0];
  logic [data_width-1:0] data_out [H-1:0];

  always_ff @(posedge clk, negedge nrst)
  begin: input_data_pipe
    if(!nrst)
      data_in <= '{default:0};
    else if(ctrl_Pool)
      data_in <=  pooling_in;
    else
      data_in <= data_in;
  end: input_data_pipe

  generate
    genvar i;

    for (i=0; i<H; i++)
      max_avg_pooling MP(
                        .in1(data_in[i][0]),
                        .in2(data_in[i][1]),
                        .in3(data_in[i][2]),
                        .in4(data_in[i][3]),
                        .en(ctrl_Pool),
                        .out(data_out[i])
                      );
  endgenerate

  always_ff @(posedge clk, negedge nrst)
  begin: out_data_pipe
    if(!nrst)
      pooling_out <= '{default:0};
    else
      pooling_out <= data_out;
  end: out_data_pipe

endmodule
