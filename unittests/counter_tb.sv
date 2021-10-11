module counter_tb;
    timeunit 10ns;
    timeprecision 1ns;

    localparam Size = 3;

    logic clk_tb, nrst_tb, inc_tb, flag_tb;

    logic [Size-1 : 0] binary;
    logic [Size-1 : 0] gray;
    logic msb;

    initial begin
        clk_tb = 0;
        forever #1 clk_tb = ~clk_tb;
    end

    initial begin
        nrst_tb = 0;
        inc_tb  = 1;
        flag_tb = 0;
        #1
        nrst_tb = 1;
    end

    
    counter_1 #(
    .Width           (Size)
    ) counter_dut(
    .clk_i           (clk_tb),
    .nrst_i          (nrst_tb),
    .inc_i           (inc_tb),
    .full_empty_i    (flag_tb),

    .bin_count_o     (binary),
    .gray_count_o    (gray),
    .msb_o           (msb)
    );

    initial $monitor("%t, DEC: %d, BINARY: %b, GRAY: %b, ", $time, binary, binary, {msb,gray});
    
endmodule