module col2img#
    (parameter  data_width = 8 
     parameter in_vec_size =28 )(
    input logic clk, 
    input logic nrst , 
    output logic [data_width-1:0] out_img [in_vec_size-1:0][in_vec_size-1:0] ,
    input logic in_valid  , 
    input logic [data_width:0] cols [(in_vec_size^2)-1:0] 
    );
  

    always_comb begin

        if(nrst)
            begin
            generate genvar i , j ;
                for (i=0 , i < in_vec_size , i = i+1 ) ;
                    begin
                        for (j=0 , j < in_vec_size , j = i+1 ) ;
                            begin
                                out_img[i][j]= cols[i*in_vec_size+j] ;  
                                 
                            end
                    end
                    
            endgenerate      

           end     
        else begin
           out_img=0; 
        end

    end
