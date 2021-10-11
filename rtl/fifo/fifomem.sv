module fifomem #(
    parameter DWidth  = 8,
    parameter Depth   = 8, 
    localparam AWidth = $clog2(Depth) 
)(
    input  logic clk_i, w_en_i,

    input  logic [DWidth-1 : 0] w_data_i,
    input  logic [AWidth-1 : 0] w_addr_i, 
    input  logic [AWidth-1 : 0] r_addr_i, 

    output logic [DWidth-1:0] r_data_o
);

    //localparam Depth = 2**AWidth;

    logic [DWidth-1 : 0] mem [Depth];

    assign r_data_o = mem[r_addr_i];

    always_ff @(posedge clk_i) begin
        if (w_en_i) mem[w_addr_i] <= w_data_i;
    end
endmodule : fifomem
