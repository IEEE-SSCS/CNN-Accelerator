module pooling_layer_tb();

  // declarations
  parameter data_width = 8,
            pooling_units = 4,
            K = 2,
            S = 2;

  localparam T = 20; // clk period
  logic clk, nrst, ctrl_pool, start_pool;

  logic [data_width-1:0] pooling_in [pooling_units-1:0] [(K*S)-1:0];
  logic [data_width-1:0] pooling_out [pooling_units-1:0];

  // dut instantiation

  pooling_layer #(.pooling_units(4)) dut (.*);

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
    ctrl_pool = 1'b1;
    start_pool = 1'b0;
    pooling_in = '{default:8'h00};
    @(posedge nrst);
    @(negedge clk);

    // test max pooling
    ctrl_pool = 1'b1;
    start_pool = 1'b1;
    pooling_in = '{'{8'd1, 8'd5, 8'd6, 8'd7},
                   '{8'd2, 8'd1, 8'd8, 8'd9},
                   '{8'd3, 8'd1, 8'd2, 8'd4},
                   '{8'd4, 8'd5 ,8'd0 ,8'd1}};

    repeat(3) @(negedge clk);
    if (pooling_out[3] != 8'd7)
      $display("first MP faild");

    else if (pooling_out[2] != 8'd9)
      $display("second MP faild");

    else if (pooling_out[1] != 8'd4)
      $display("third MP faild");

    else if (pooling_out[0] != 8'd5)
      $display("fourth MP faild");
    else
      $display("max pooling pass %p", pooling_out);

    ctrl_pool = 1'b0;
    repeat(3) @(negedge clk);
    if (pooling_out[3] != 8'd4)
      $display("first AP faild");

    else if (pooling_out[2] != 8'd5)
      $display("second AP faild");

    else if (pooling_out[1] != 8'd2)
      $display("third AP faild");

    else if (pooling_out[0] != 8'd2)
      $display("fourth AP faild");
    else
      $display("average pooling pass %p", pooling_out);
    $stop;

  end

endmodule
