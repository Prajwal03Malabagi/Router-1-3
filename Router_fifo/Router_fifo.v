module router_fifo(clk,resetn,wr_en,rd_en,soft_reset,lfd_state,data_in,empty,data_out,full);
  input clk,resetn,wr_en,rd_en,soft_reset,lfd_state;
  input [7:0]data_in;
  output empty,full;
  output reg[7:0]data_out;
  
  reg [8:0]mem[15:0];
  reg [3:0]wr_ptr,rd_ptr;
  reg [4:0]count;
  integer i;
  
  always@(posedge clk,negedge resetn)
    begin
      if(!resetn)
        begin
          for(i=0;i<=15;i=i+1)
            mem[i]<=0;
          wr_ptr<=4'b0;
          rd_ptr<=4'b0;
          count<=4'b0;
          data_out<=8'b0;
        end
      else 
        begin
          if(soft_reset)
             begin
               for(i=0;i<=15;i=i+1)
                  mem[i]<=0;
                wr_ptr<=4'b0;
                rd_ptr<=4'b0;
                count<=5'b0;
                data_out<=8'b0;
      		  end
              
          if(wr_en && !full)
        	begin
              if(lfd_state)
                begin
                  mem[wr_ptr][8]<=1;
                  mem[wr_ptr][7:0]<=data_in;
                  wr_ptr<=wr_ptr+1;
                  count<=count+1;
                end
              else
                begin
                  mem[wr_ptr][8]<=0;
                  mem[wr_ptr][7:0]<=data_in;
                  wr_ptr<=wr_ptr+1;
                  count<=count+1;
                end
            end
                      
          if(rd_en && !empty)
            begin
              data_out<=mem[rd_ptr][7:0];
              rd_ptr<=rd_ptr+1;
              count<=count-1;
            end
         end
    end
    assign full=(count==15);
    assign empty=(count==0);
                      
endmodule
          
          
        
