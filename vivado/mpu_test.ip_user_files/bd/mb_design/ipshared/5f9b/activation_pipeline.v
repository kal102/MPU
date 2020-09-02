
module activation_pipeline #(parameter ACC_SIZE = 32, parameter MMU_SIZE = 4)
(
  output reg signed [(ACC_SIZE*MMU_SIZE-1):0] B1,
  input wire signed [(ACC_SIZE*MMU_SIZE-1):0] A1,
  input wire clk,
  input wire rst_n,
  input wire [1:0] activation,
  input wire signed [(ACC_SIZE-1):0] bias
);

  localparam ACTIVATION_NONE = 2'b00;
  localparam ACTIVATION_RELU = 2'b01;

  reg signed [(ACC_SIZE-1):0] B [0:(MMU_SIZE-1)];
  reg signed [(ACC_SIZE-1):0] B_nxt [0:(MMU_SIZE-1)];
  reg signed [(ACC_SIZE-1):0] A [0:(MMU_SIZE-1)];
  integer a, b, c, d;
  integer i;

  always @(posedge clk) begin
    if (!rst_n) begin
      for (i = 0; i < MMU_SIZE; i = i + 1)
        B[i] <= 0;
    end
    else begin
      for (i = 0; i < MMU_SIZE; i = i + 1)
        B[i] <= B_nxt[i];
    end
  end
  
  always @* begin
    if (activation == ACTIVATION_RELU) begin
      for (i = 0; i < MMU_SIZE; i = i + 1)
        B_nxt[i] = (A[i] >= 0) ? A[i] : 0;
    end
    else begin
      for (i = 0; i < MMU_SIZE; i = i + 1)
        B_nxt[i] = A[i];
    end
  end

  /* Convert 1D input arrays to 2D */
  always @(*) begin
    b = 0;
    for (a = 0; a < MMU_SIZE; a = a + 1) begin
      A[a] = A1[(b * ACC_SIZE)+:ACC_SIZE] + bias;
      b = b + 1;
    end
  end
  
  /* Convert 2D output array to 1D */
  always @(*) begin
    d = 0;
    for (c = 0; c < MMU_SIZE; c = c + 1) begin
      B1[(d * ACC_SIZE)+:ACC_SIZE] = B[c];
      d = d + 1;
    end
  end  

endmodule
