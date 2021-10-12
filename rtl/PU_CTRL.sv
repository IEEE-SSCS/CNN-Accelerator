module PU_CTRL
  #(parameter pooling_units = 32,
    parameter H = 5)
   (
     input logic clk, nrst,
     input logic [2:0] pooling_inst, start_pool, array_dim,
     output logic in_pipe_en, out_pipe_en, max_avg, done,
     output logic [4:0] address [3:0]
   );

  enum logic [1:0] {start       = 2'b00,
                    data_adress = 2'b01,
                    pipe_ip     = 2'b10,
                    finish      = 2'b11} next_state, current_state;

  // inst   max/avg     |  pooling instruction
  //         1 / 0      |         01
  logic [2:0] inst;
  logic [4:0] temp_add [3:0];
  logic [3:0] current_count, next_count;

  always_ff @(posedge clk, negedge nrst)
  begin
    if(!nrst)
    begin
      current_state <= start;
      inst <= '0;
      current_count <= '0;
      temp_add <= '{default:5'h00};
    end
    else
    begin
      current_state <= next_state;
      current_count <= next_count;
      if(start_pool)
    	begin
        inst <= pooling_inst;
        temp_add <= address;
	    end
      else
        inst <= inst;
    end
  end


  // next state logic
  always_comb
  begin
    in_pipe_en  = 0;
    out_pipe_en = 0;
    next_state  = current_state;
    next_count  = current_count;
    address     = temp_add;

    unique case (current_state)
             start:
             begin
               if(start_pool)
               begin
                 next_count = '0;
                 next_state = data_adress;
               end
               else
               begin
                 next_count = '0;
                 next_state = current_state;
               end
             end

             data_adress:
             begin
               // here we will generate data addresses

               next_state = pipe_ip;
               if (current_count > 0)
               begin
                 out_pipe_en = 1;
                 case (current_count)
                   4'h1:
                   begin
                     address[0] = address[0] + 2;
                     address[2] = address[0] + array_dim;
                     if (array_dim == 3'h3) begin
                       address[1] = 5'd31;
                       address[3] = 5'd31;
                     end 
                     else begin
                     address[1] = address[0] + 1;
                     address[3] = address[0] + array_dim + 1;  
                     end
                   end


                   4'h2:
                   begin
                     case (array_dim)
                      3'h3:
                      begin
                        address[0] = address[0] + 4;
                        address[1] = address[0] + 1;
                        address[2] = 5'd31;
                        address[3] = 5'd31;
                      end

                      3'h4:
                      begin
                        address[0] = address[0] + 6;
                        address[1] = address[0] + 1;
                        address[2] = address[0] + array_dim;
                        address[3] = address[0] + array_dim + 1;
                      end


                      3'h5:
                      begin
                        address[0] = address[0] + 2;
                        address[1] = 5'd31;
                        address[2] = address[0] + array_dim;
                        address[3] = 5'd31;
                      end 
                    endcase
                   end


                   4'h3:
                   begin
                     case (array_dim)
                       3'h3:
                       begin
                        address[0] = address[0] + 2;
                        address[1] = 5'd31;
                        address[2] = 5'd31;
                        address[3] = 5'd31;
                       end
                       3'h4:
                       begin
                        address[0] = address[0] + 2;
                        address[1] = address[0] + 1;
                        address[2] = address[0] + array_dim;
                        address[3] = address[0] + array_dim + 1;
                       end

                       3'h5:
                       begin
                        address[0] = address[0] + 6;
                        address[1] = address[0] + 1;
                        address[2] = address[0] + array_dim;
                        address[3] = address[0] + array_dim + 1;
                        end
                     endcase
                   end


                   4'h4:
                   begin
                    address[0] = address[0] + 2;
                    address[1] = address[0] + 1;
                    address[2] = address[0] + array_dim;
                    address[3] = address[0] + array_dim + 1;
                   end


                   4'h5:
                   begin
                    address[0] = address[0] + 2;
                    address[1] = 5'd31;
                    address[2] = address[0] + array_dim;
                    address[3] = 5'd31;
                   end
                   4'h6:
                   begin
                    address[0] = address[0] + 6;
                    address[1] = address[0] + 1;
                    address[2] = 5'd31;
                    address[3] = 5'd31;
                   end
                   4'h7:
                   begin
                    address[0] = address[0] + 2;
                    address[1] = address[0] + 1;
                    address[2] = 5'd31;
                    address[3] = 5'd31;
                   end
                   4'h8:
                   begin
                    address[0] = address[0] + 2;
                    address[1] = 5'd31;
                    address[2] = 5'd31;
                    address[3] = 5'd31;
                   end
                 endcase
               end
               else
               begin
                 out_pipe_en = 0;
                 address[0] = 5'b0;
                 address[1] = address[0] + 1;
                 address[2] = address[0] + array_dim;
                 address[3] = address[0] + array_dim + 1;
               end
              end

             pipe_ip:
             begin
               in_pipe_en = 1;
               //next_count = current_count + 1;
               unique case (array_dim)
                 3'h3, 3'h4:
                   if (current_count == 4'h3)
                   begin
                     next_state = finish;
                     next_count = '0;
                   end
                   else
                   begin
                     next_state = data_adress;
                     next_count = current_count + 1;
                   end

                 3'h5:
                   if (current_count == 4'h8)
                   begin
                     next_state = finish;
                     next_count = '0;
                   end
                   else
                   begin
                     next_state = data_adress;
                     next_count = current_count + 1;
                   end
               endcase
             end

             finish:
             begin
               next_state = start;
               out_pipe_en = 0;
               in_pipe_en = 0;
               done = 1;
             end
             default:
             begin
               next_state = start;
               next_count = '0;
             end

           endcase
         end


endmodule

