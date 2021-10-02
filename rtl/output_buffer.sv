module output_buffer
  #(
    parameter width = 32, data_width = 8
  )
  (
    input logic clk, nrst,
    input logic Wr_ctrl [width-1:0],
    input logic [data_width-1:0] in [width-1:0],
    input logic [4:0] add_1 [width-1:0],
    input logic [4:0] add_2 [width-1:0],
    input logic [4:0] add_3 [width-1:0],
    input logic [4:0] add_4 [width-1:0],
    input logic [4:0] add_in [width-1:0],
    output logic [data_width-1:0] out1 [width-1:0],
    output logic [data_width-1:0] out2 [width-1:0],
    output logic [data_width-1:0] out3 [width-1:0],
    output logic [data_width-1:0] out4 [width-1:0]
  );

  generate
    genvar i;

    for (i=0; i<width; i=i+1)
      Register_File RF(
                        .clk(clk), .nrst(nrst),
                        .Wr_ctrl(Wr_ctrl[i]),
                        .in(in[i]),
                        .add_1(add_1[i]),
                        .add_2(add_2[i]),
                        .add_3(add_3[i]),
                        .add_4(add_4[i]),
                        .add_in(add_in[i]),
                        .out1(out1[i]),
                        .out2(out2[i]),
                        .out3(out3[i]),
                        .out4(out4[i])
                      );
  endgenerate
endmodule 