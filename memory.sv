module Memory( input clk ,
               input write_enable,
               input [4:0] address,
               input [7:0] write_data,
               output[7:0] read_data ) ;
            reg [4:0] mem[7:0] ;
            always @(negedge clk) begin
              if (write_enable)
                mem[address] <= write_data ;
            end
            assign read_data = mem[address] ;
            initial begin
              for (integer i = 0 ; i < 1024 ; i = i + 1)
                mem[i] <= 16'd0 ;
            end
endmodule
