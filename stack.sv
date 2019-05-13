
module Stack( input  [7:0] d_in  ,
              input  push,
                     pop,
              output [7:0] d_out ) ;
                    
              reg [7:0] mem [0:1023];
              reg [9:0] addr = 0 ;
              assign d_out = mem[addr] ;
              always @(posedge push , posedge pop) begin
                
                if ( push ) begin
                  addr = addr + 1 ;
                  mem[addr] = d_in ;
                end
                
                if ( pop ) addr = addr - 1 ;
              end
              
              initial begin
                for (integer i = 0 ; i < 1024 ; i = i + 1)
                  mem[i] <= 16'd0 ;
              end
endmodule