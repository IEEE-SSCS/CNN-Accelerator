module counter_1 #(parameter Width = 3)(
    input logic clk_i, nrst_i,
    input logic inc_i, full_empty_i,
    
    output logic [Width-1 : 0] bin_count_o,
    output logic [Width-1 : 0] gray_count_o,
    output logic msb_o
);

    logic [Width : 0] bnext;
    logic [Width : 0] gnext;
    
    logic [Width : 0] bin;
    
    logic             msbnext;

    logic [Width : 0] bin_count_q;
    logic [Width : 0] gray_count_q;
    logic             msb_q;

    assign bnext   = bin + (inc_i & !full_empty_i);
    assign msbnext = gnext[Width] ^ gnext[Width-1];
    
    //------------------------------------------------
    // Gray To Binary Conversion
    //------------------------------------------------
    always_comb begin
        bin[Width] = gray_count_q[Width];
        for (int i = Width; i >= 0; i--) begin
            bin[i-1] = bin[i] ^ gray_count_q[i-1];
        end
    end

    //------------------------------------------------
    // Binary To Gray Conversion
    //------------------------------------------------
    always_comb begin
        gnext[Width] = bnext[Width];
        for (int i = Width; i >= 0; i--)begin
              gnext[i-1] = bnext[i] ^ bnext[i-1];
        end
    end
    
    //------------------------------------------------
    // Registers
    //------------------------------------------------
    always_ff @(posedge clk_i, negedge nrst_i) begin
        if(!nrst_i) begin
            msb_q        <= 0;
            gray_count_q <= 0; 
            bin_count_q  <= 0;
        end else begin
            bin_count_q  <= bnext;
            gray_count_q <= gnext;
            msb_q        <= msbnext;
        end
    end

    assign bin_count_o  = bin_count_q[Width-1 : 0];
    assign gray_count_o = {msb_q, gray_count_q[Width-2:0]};
    assign msb_o        = gray_count_q[Width];
endmodule 
