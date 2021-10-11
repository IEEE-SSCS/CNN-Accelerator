module pointer #(
    parameter ReadWrite = 1,
    parameter CounterStyle = 1,
    parameter Address = 3
)(
    input logic clk_i, nrst_i,
    input logic inc_i,

    input logic [Address : 0] synced_pointer_i,

    output logic full_empty_o,
    output logic [Address-1 : 0] address_o,
    output logic [Address   : 0] pointer_o
);
    if (CounterStyle == 1) begin
        counter_1 #(
            .Width           (Address)
        ) u_counter_1 (
            .clk_i           (clk_i),
            .nrst_i          (nrst_i),
            .inc_i           (inc_i),
            .full_empty_i    (full_empty_o),
            .bin_count_o     (address_o),
            .gray_count_o    (pointer_o[Address-1 : 0]),
            .msb_o           (pointer_o[Address])
        );
    end else begin
        //-----------------------------
        // Counter Style Two
        //-----------------------------
    end

    if (ReadWrite == 1) begin//Read pointer
        logic empty;
        assign empty = pointer_o == synced_pointer_i;

        always_ff @(posedge clk_i, negedge nrst_i)
            if (!nrst_i) full_empty_o <= 1;
            else full_empty_o <= empty;

    end else begin  //Write pointer
        logic full;
        assign full = (pointer_o [Address : Address-1] != synced_pointer_i [Address : Address-1]) &
                    (pointer_o [Address-2 : 0] == synced_pointer_i [Address-2 : 0]);

        always_ff @(posedge clk_i or negedge nrst_i)
            if (!nrst_i) full_empty_o <= 0;
            else full_empty_o <= full;
    end
endmodule : pointer
