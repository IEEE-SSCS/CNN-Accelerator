module output_buffer_tb();

  // declarations
  parameter data_width = 8,
            width = 4;

  localparam T = 20; // clk period
  logic clk, nrst;
  logic Wr_ctrl [width-1:0];
  logic [data_width-1:0] in [width-1:0];
  logic [4:0] add_1 [width-1:0];
  logic [4:0] add_2 [width-1:0];
  logic [4:0] add_3 [width-1:0];
  logic [4:0] add_4 [width-1:0];
  logic [4:0] add_in [width-1:0];
  logic [data_width-1:0] out1 [width-1:0];
  logic [data_width-1:0] out2 [width-1:0];
  logic [data_width-1:0] out3 [width-1:0];
  logic [data_width-1:0] out4 [width-1:0];
  
  // dut instantiation
  output_buffer dut (.*);

  // clk
  always
    begin
      clk = 1'b1;
      #(T/2);
      clk = 1'b0;
      #(T/2);
    end

  // rst
  initial
    begin
      nrst = 1'b0;
      #(T/2);
      nrst = 1'b1;
    end

  // stimulus
  initial
    begin
      // initial inputs
	    Wr_ctrl= '{default:1'b0};
	    in= '{default:8'h00};
    	add_1 = '{default:5'h00};
	    add_2 = '{default:5'h00};
	    add_3 = '{default:5'h00};
	    add_4 = '{default:5'h00};
	    add_in = '{default:5'h00};
 
      #23

      // writing 1
	    Wr_ctrl= '{1'd1, 1'd1, 1'd1, 1'd1};
	    in= '{8'd1, 8'd5, 8'd6, 8'd7};
    	add_1 = '{default:5'h00};
	    add_2 = '{default:5'h00};
	    add_3 = '{default:5'h00};
	    add_4 = '{default:5'h00};
	    add_in = '{5'd1, 8'd5, 8'd6, 8'd7};
	
      #23

      // writing 2
	    Wr_ctrl= '{1'd1, 1'd1, 1'd1, 1'd1};
	    in= '{8'd2, 8'd6, 8'd7, 8'd0};
    	add_1 = '{default:5'h00};
	    add_2 = '{default:5'h00};
	    add_3 = '{default:5'h00};
	    add_4 = '{default:5'h00};
	    add_in = '{5'd0, 8'd4, 8'd5, 8'd6};
	
      #23

      // writing 3
	    Wr_ctrl= '{1'd1, 1'd1, 1'd1, 1'd1};
	    in= '{8'd3, 8'd4, 8'd0, 8'd1};
    	add_1 = '{default:5'h00};
	    add_2 = '{default:5'h00};
	    add_3 = '{default:5'h00};
	    add_4 = '{default:5'h00};
	    add_in = '{5'd31, 8'd3, 8'd4, 8'd5};
	
      #23

      // writing 4
	    Wr_ctrl= '{1'd1, 1'd1, 1'd1, 1'd1};
	    in= '{8'd4, 8'd5, 8'd1, 8'd2};
    	add_1 = '{default:5'h00};
	    add_2 = '{default:5'h00};
	    add_3 = '{default:5'h00};
	    add_4 = '{default:5'h00};
	    add_in = '{5'd30, 8'd2, 8'd3, 8'd4};

      #23

      // reading
	    Wr_ctrl= '{default:1'b0};
	    in= '{8'd5, 8'd6, 8'd7, 8'd8};
    	add_1 = '{5'd1, 8'd5, 8'd6, 8'd7};
	    add_2 ='{5'd0, 8'd4, 8'd5, 8'd6};
	    add_3 = '{5'd31, 8'd3, 8'd4, 8'd5};
	    add_4 = '{5'd30, 8'd2, 8'd3, 8'd4};
	    add_in = '{5'd29, 8'd1, 8'd2, 8'd3};
	

      $monitor("out1= %p,,out2= %p,,out3= %p,,out4= %p", out1,out2,out3,out4);
  end
endmodule