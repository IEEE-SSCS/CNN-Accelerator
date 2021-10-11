module fifo #(
    parameter Width = 8,
    parameter Depth = 8,
    localparam Address = $clog2(Depth)
)(
    input logic r_clk_i,    //read domain clock
    input logic w_clk_i,    //write domain clock

    input logic r_nrst_i,   //read domain reset
    input logic w_nrst_i,   //write domain reset

    input logic read_i,
    input logic write_i,

    input logic  [Width-1 : 0] w_data_i,

    output logic [Width-1 : 0] r_data_o,
    output logic               full_flag_o,
    output logic               empty_flag_o
);

    logic [Address-1 : 0] write_address;
    logic [Address-1 : 0] read_address; 

    logic [Address : 0] write_pointer;
    logic [Address : 0] read_pointer;
    logic [Address : 0] synced_write_pointer;
    logic [Address : 0] synced_read_pointer;

    fifomem #(
        .DWidth    (Width),
        .Depth     (Depth)
    ) mem (
        .clk_i     (w_clk_i),
        .w_en_i    (write_i),

        .w_data_i  (w_data_i),
        .w_addr_i  (write_address),

        .r_addr_i   (read_address),
        .r_data_o   (r_data_o)
    );

    pointer #(
        .ReadWrite           (1),
        .CounterStyle        (1),
        .Address             (Address)
    ) read_ctr (
        .clk_i               (r_clk_i),
        .nrst_i              (r_nrst_i),
        .inc_i               (read_i),
        .synced_pointer_i    (synced_write_pointer),
        .full_empty_o        (empty_flag_o),
        .address_o           (read_address),
        .pointer_o           (read_pointer)
    );

    pointer #(
        .ReadWrite           (0),
        .CounterStyle        (1),
        .Address             (Address)
    ) Write_cttr (
        .clk_i               (w_clk_i),
        .nrst_i              (w_nrst_i),
        .inc_i               (write_i),
        .synced_pointer_i    (synced_read_pointer),
        .full_empty_o        (full_flag_o),
        .address_o           (write_address),
        .pointer_o           (write_pointer)
    );

    sync #(
        .Width     (Address + 1)
    ) read_to_write (
        .clk_i     (w_clk_i),
        .nrst_i    (w_nrst_i),
        .input_i   (read_pointer),
        .output_o  (synced_read_pointer)
    );

    sync #(
        .Width     (Address + 1)
    ) write_to_read (
        .clk_i     (r_clk_i),
        .nrst_i    (r_nrst_i),
        .input_i   (write_pointer),
        .output_o  (synced_write_pointer)
    );


endmodule