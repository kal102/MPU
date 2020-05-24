
module delay #(parameter DELAY = 1, parameter WIDTH = 1) 
(
  output wire [(WIDTH-1):0] out,
  input wire [(WIDTH-1):0] in,
  input wire clk,
  input wire rst_n
);

  generate
    genvar i;
    
    for (i = 0; i < DELAY; i = i + 1) begin : register
      reg [(WIDTH-1):0] b;
      wire [(WIDTH-1):0] a;
      
      always @(posedge clk) begin
        if (!rst_n)
          register[i].b <= 0;
        else
          register[i].b <= register[i].a;
      end
      
      if (i > 0)
        assign register[i].a = register[i-1].b;
      else
        assign register[i].a = in;
    end
    
    assign out = register[DELAY-1].b;
    
  endgenerate

endmodule
