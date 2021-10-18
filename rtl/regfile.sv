module Register_File
  #(
     parameter data_width = 8
   )
  (
    input logic clk, nrst, Wr_ctrl, en,
    input logic [data_width-1:0] in,
    input logic [4:0] add_1, add_2, add_3, add_4, add_in, //address bus
    output logic [data_width-1:0] out1, out2, out3, out4
  );
  logic [data_width-1:0] registers [31:0];

  assign out1 = registers[add_1];
  assign out2 = registers[add_2];
  assign out3 = registers[add_3];
  assign out4 = registers[add_4];

  always_ff @ (posedge clk, negedge nrst) 
  begin
    case (en)
      0: registers[add_in] <= registers[add_in];
      1: begin
          if (!nrst)
            begin
            for (int i = 0; i < 32; i = i + 1)
            registers[i] <= 32'h0;      // clear register file
            end
		      else
          begin
          registers[add_in] <= ((add_1 != 0 && add_2 != 0 && add_3 != 0 && add_4 != 0) && Wr_ctrl) ? in : registers[add_in];
          end
        end
    endcase
  end
endmodule

