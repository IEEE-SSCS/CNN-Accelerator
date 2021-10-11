module fifo_tb;
    timeunit 1ns;

    localparam Width = 8;

    logic r_clk_i;    //read domain clock
    logic w_clk_i;    //write domain clock
    logic r_nrst_i;   //read domain reset
    logic w_nrst_i;   //write domain reset
    logic read_i;
    logic write_i;
    logic [Width-1 : 0] w_data_i;
    logic [Width-1 : 0] r_data_o;
    logic               full_flag_o;
    logic               empty_flag_o;

    fifo #(
        .Width      (8),
        .Depth      (8)
    ) fifo_dut (
        .r_clk_i        (r_clk_i),   
        .w_clk_i        (w_clk_i),   
        .r_nrst_i       (r_nrst_i),   
        .w_nrst_i       (w_nrst_i),   
        .read_i         (read_i),
        .write_i        (write_i),
        .w_data_i       (w_data_i),
        .r_data_o       (r_data_o),
        .full_flag_o    (full_flag_o),
        .empty_flag_o   (empty_flag_o)
    );

    initial begin
        r_clk_i = 0;
        w_clk_i = 0;

        forever begin
            #1 
            r_clk_i = ~r_clk_i;
            w_clk_i = ~w_clk_i; 
        end
    end

    initial begin
        r_nrst_i = 0;
        w_nrst_i = 0;
        
        #1

        w_nrst_i = 1;
        r_nrst_i = 1;
    end

    initial begin
        w_data_i = 200;
        read_i = 0;
        write_i = 1;
        #100
        write_i = 0;
        read_i = 1;
    end
endmodule
