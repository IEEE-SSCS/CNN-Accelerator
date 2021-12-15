module pooling_layer
  #(
     parameter pooling_units = 32,
     parameter data_width = 8,
     parameter S = 2,
     parameter K = 2
   )
   (
     input logic clk, nrst, ctrl_pool, in_pipe_en, out_pipe_en,
     input logic [data_width-1:0] pooling_in [pooling_units-1:0] [(K*S)-1:0],
     output logic [data_width-1:0] pooling_out [pooling_units-1:0]
   );

  logic [data_width-1:0] data_in  [pooling_units-1:0] [(K*S)-1:0];
  logic [data_width-1:0] data_out [pooling_units-1:0];

  always_ff @(posedge clk, negedge nrst)
  begin: input_data_pipe
    if(!nrst)
      data_in <= '{default:0};
    else if(in_pipe_en)
      data_in <=  pooling_in;
    else
      data_in <= data_in;
  end: input_data_pipe

  generate
    genvar i;

    for (i=0; i<pooling_units; i++)
      max_avg_pooling MP(
                        .in1(data_in[i][0]),
                        .in2(data_in[i][1]),
                        .in3(data_in[i][2]),
                        .in4(data_in[i][3]),
                        .en(ctrl_pool),
                        .out(data_out[i])
                      );
  endgenerate

  always_ff @(posedge clk, negedge nrst)
  begin: out_data_pipe
    if(!nrst)
      pooling_out <= '{default:0};
    else if (out_pipe_en)
      pooling_out <= data_out;
    else
      pooling_out <= pooling_out;
  end: out_data_pipe

endmodule
