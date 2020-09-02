
module mem_2to2 #(parameter VAR_SIZE = 32, parameter MMU_SIZE = 10)
(
  output reg signed [(VAR_SIZE*MMU_SIZE-1):0] B1,
  input wire signed [(VAR_SIZE*MMU_SIZE-1):0] A1,
  input wire [7:0] address,
  input wire write,
  input wire clk
);

  reg signed [(VAR_SIZE-1):0] A [0:(MMU_SIZE-1)];
  wire signed [(VAR_SIZE-1):0] B [0:(MMU_SIZE-1)];
  integer a, b;
  integer c, d;

  generate
    genvar i;
    
    for (i = 0; i < MMU_SIZE; i = i + 1) begin : ram
      
      single_port_ram #(.ADDR_WIDTH($clog2(MMU_SIZE)), .DATA_WIDTH(VAR_SIZE)) m_ram 
      (
        .data(A[i]),
        .addr(address[($clog2(MMU_SIZE)-1):0]),
        .we(write),
        .clk(clk),
        .q(B[i])
        );
      
    end
    
  endgenerate

  /* Convert 1D input array to 2D */
  always @(*) begin
    b = 0;
    for (a = 0; a < MMU_SIZE; a = a + 1) begin
      A[a] = A1[(b * VAR_SIZE)+:VAR_SIZE];
      b = b + 1;
    end
  end

  /* Convert 2D output array to 1D */
  always @(*) begin
    d = 0;
    for (c = 0; c < MMU_SIZE; c = c + 1) begin
      B1[(d * VAR_SIZE)+:VAR_SIZE] = B[c];
      d = d + 1;
    end
  end

endmodule

