module PU_CTRL
  #(parameter pooling_units = 32,
    parameter H = 5)
   (
     input logic clk, nrst,
     input logic [2:0] pooling_inst, start_pool, array_dim,
     output logic in_pipe_en, out_pipe_en, max_avg, done,
     output logic [4:0] address [pooling_units-1:0]
   );

  enum logic [1:0] {start       = 2'b00,
                    data_adress = 2'b01,
                    pipe_ip     = 2'b10,
                    finish      = 2'b11} next_state, current_state;

  // inst   max/avg     |  pooling instruction
  //         1 / 0      |         01
  logic [2:0] inst, current_count, next_count;

  always_ff @(posedge clk, negedge nrst)
  begin
    if(!nrst)
    begin
      current_state <= start;
      inst <= '0;
      current_count <= '0;
    end
    else
    begin
      current_state <= next_state;
      current_count <= next_count;
      if(start_pool)
        inst <= pooling_inst;
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
                 out_pipe_en = 1;
               else
                 out_pipe_en = 0;
             end

             pipe_ip:
             begin
               in_pipe_en = 1;
               //next_count = current_count + 1;
               unique case (array_dim)
                 3'h3, 3'h4:
                   if (current_count == 3'h3)
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
                   if (current_count == 3'h8)
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

