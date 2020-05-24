
module padding_pipeline #(parameter ACC_SIZE = 32, parameter MMU_SIZE = 4)
(
  output reg signed [(ACC_SIZE*(MMU_SIZE+1)-1):0] B1,
  input wire signed [(ACC_SIZE*MMU_SIZE-1):0] A1,
  input wire clk,
  input wire rst_n,
  input wire padding,
  input wire [7:0] dim_x,
  input wire [7:0] dim_y
);

  reg signed [(ACC_SIZE-1):0] B [0:MMU_SIZE];
  reg signed [(ACC_SIZE-1):0] A [0:(MMU_SIZE-1)];
 
  reg signed [(ACC_SIZE-1):0] B_nxt [0:MMU_SIZE];
  
  reg [7:0] row, row_nxt;
  integer a, b, c, d;
  integer i;
  
  always @(posedge clk) begin
    if (!rst_n) begin
      for (i = 0; i <= MMU_SIZE; i = i + 1) begin
        B[i] <= 0;
      end
    end
    else begin
      for (i = 0; i <= MMU_SIZE; i = i + 1) begin
        B[i] <= B_nxt[i];
      end
    end
  end
  
  always @* begin
    for (i = 0; i < MMU_SIZE; i = i + 1) begin
      /* Use zero padding for correct pooling */
      B_nxt[i] = (row < dim_x && i < dim_y) ? A[i] : 0;
    end
    B_nxt[MMU_SIZE] = 0;
  end
  
  always @(posedge clk) begin
    if (!rst_n)
      row <= 0;
    else
      row <= row_nxt;
  end
  
  always @* begin
    if (padding)
      row_nxt = (row > 0) ? row - 1 : 0;
    else
      row_nxt = MMU_SIZE - 1; 
  end
  
  /* Convert 1D input arrays to 2D */
  always @(*) begin
    b = 0;
    for (a = 0; a < MMU_SIZE; a = a + 1) begin
      A[a] = A1[(b * ACC_SIZE)+:ACC_SIZE];
      b = b + 1;
    end
  end
  
  /* Convert 2D output array to 1D */
  always @(*) begin
    d = 0;
    for (c = 0; c <= MMU_SIZE; c = c + 1) begin
      B1[(d * ACC_SIZE)+:ACC_SIZE] = B[c];
      d = d + 1;
    end
  end  

endmodule

