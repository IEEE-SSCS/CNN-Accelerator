module img2col#(parameter  data_width = 8 )(
    input logic clk, 
    input logic nrst , 
    input logic [2:0] k , 
    input logic stride ,
    input logic [data_width-1:0] img [4:0][4:0] ,
    input logic in_valid  , 
    output logic [data_width-1 : 0 ] out_cols [31:0] 
    
    );
    
  

    always_comb begin

        if(nrst)
            begin
            generate genvar i , j ;
                for (i=0 , i < 5 , i = i+1 ) ;
                    begin
                        for (j=0 , j < 5 , j = i+1 ) ;
                            begin
                                out_cols[i*5+j] = img[i][j] ;  
                                 
                            end
                    end
                    
            endgenerate      

           end     
        else begin
            // the output will bel zero 
        end

    end








endmodule
