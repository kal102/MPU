
module pooling_pipeline #(parameter ACC_SIZE = 32, parameter MMU_SIZE = 4)
(
  output reg signed [(ACC_SIZE*MMU_SIZE-1):0] B1,
  input wire signed [(ACC_SIZE*(MMU_SIZE+1)-1):0] A1,
  input wire clk,
  input wire rst_n,
  input wire [1:0] pooling
);

  localparam POOLING_NONE = 2'b00;
  localparam POOLING_MAX = 2'b01;

  reg signed [(ACC_SIZE-1):0] B     [0:(MMU_SIZE-1)];
  reg signed [(ACC_SIZE-1):0] B_nxt [0:(MMU_SIZE-1)];
  
  wire signed [(ACC_SIZE-1):0] A_max  [0:(MMU_SIZE-1)];
  reg signed  [(ACC_SIZE-1):0] A_out  [0:(MMU_SIZE-1)];
  reg signed  [(ACC_SIZE-1):0] A_row1 [0:MMU_SIZE];
  reg signed  [(ACC_SIZE-1):0] A_row2 [0:MMU_SIZE];
  
  integer a, b, c, d;
  integer i;
  
  generate
    genvar n;
    for (n = 0; n < (MMU_SIZE / 2 + MMU_SIZE % 2); n = n + 1) begin : x
        
      pooling_max #(ACC_SIZE) m_pooling_max
      (
        .out(A_max[n]),
        .in_0(A_row1[2*n]),
        .in_1(A_row1[2*n+1]),
        .in_2(A_row2[2*n]),
        .in_3(A_row2[2*n+1]),
        .clk(clk),
        .rst_n(rst_n)
        );
        
    end
  endgenerate
  
  always @(posedge clk) begin
    if (!rst_n) begin
      for (i = 0; i <= MMU_SIZE; i = i + 1) begin
        if (i != MMU_SIZE) begin
          B[i] <= 0;
          A_out[i] <= 0;
        end
        A_row1[i] <= 0;
      end
    end
    else begin
      for (i = 0; i <= MMU_SIZE; i = i + 1) begin
        if (i != MMU_SIZE) begin
          B[i] <= B_nxt[i];
          A_out[i] <= A_row1[i];
        end
        A_row1[i] <= A_row2[i];
      end
    end
  end
  
  always @* begin
    for (i = 0; i < MMU_SIZE; i = i + 1) begin
      if (pooling == POOLING_MAX)
        B_nxt[i] = (i < ((MMU_SIZE / 2) + (MMU_SIZE % 2))) ? A_max[i] : 0;
      else
        B_nxt[i] = A_out[i];
    end
  end
  
  /* Convert 1D input arrays to 2D */
  always @(*) begin
    b = 0;
    for (a = 0; a <= MMU_SIZE; a = a + 1) begin
      A_row2[a] = A1[(b * ACC_SIZE)+:ACC_SIZE];
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
