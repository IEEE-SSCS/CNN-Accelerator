module Register_File
  #(
     parameter data_width = 8
   )
  (
    input logic clk, nrst, Wr_ctrl,
    input logic [data_width-1:0] in,
    input logic [4:0] add_1, add_2, add_3, add_4, add_in, //address bus
    output logic [data_width-1:0] out1, out2, out3, out4
  );
  logic [data_width-1:0] registers [31:0];

  assign out1 = registers[add_1];
  assign out2 = registers[add_2];
  assign out3 = registers[add_3];
  assign out4 = registers[add_4];

  always @ (posedge clk, negedge nrst) 
  begin
  registers[add_in] = (Wr_ctrl) ? in : registers[add_in];
  end
endmodule