module sync #(parameter Width = 3)(
    input  logic clk_i, nrst_i,

    input  logic [Width-1 : 0] input_i,
    output logic [Width-1 : 0] output_o
);

    logic [Width-1 : 0] input2;

    always_ff @(posedge clk_i ,negedge nrst_i) begin
        if (!nrst_i) {output_o, input2} <= 0;
        else {input2, output_o} <= {input_i, input2}; 
    end 
endmodule 
