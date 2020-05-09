
module mmu_setup #(parameter VAR_SIZE = 8, parameter MMU_SIZE = 4, parameter REVERSED = 0)
(
  output reg signed [(VAR_SIZE*MMU_SIZE-1):0] B1,
  input wire signed [(VAR_SIZE*MMU_SIZE-1):0] A1,
  input wire clk,
  input wire rst_n
);
  
  wire signed [(VAR_SIZE-1):0] B [0:(MMU_SIZE-1)];
  reg signed [(VAR_SIZE-1):0] A [0:(MMU_SIZE-1)];
  integer a, b, c, d;
  
  generate
    genvar i, j;
    
    if (!REVERSED) begin
      
      for (i = 0; i < MMU_SIZE; i = i + 1) begin : x
        for (j = 0; j < (i + 1); j = j + 1) begin : y
          
          wire signed [(VAR_SIZE-1):0] in;
          reg signed [(VAR_SIZE-1):0] out;
          
          always @(posedge clk) begin
            if (!rst_n)
              out <= 0;
            else
              out <= in;
          end
          
          if (j > 0)
            assign x[i].y[j].in = x[i].y[j-1].out;
          else
            assign x[i].y[j].in = A[i];
          
          if (j == i)
            assign B[i] = x[i].y[j].out;
        end
      end
    end
    else begin
      assign B[MMU_SIZE-1] = A[MMU_SIZE-1];
      
      for (i = 0; i < MMU_SIZE; i = i + 1) begin : x
        for (j = 0; j < (MMU_SIZE-i-1); j = j + 1) begin : y
          
          wire signed [(VAR_SIZE-1):0] in;
          reg signed [(VAR_SIZE-1):0] out;
          
          always @(posedge clk) begin
            if (!rst_n)
              out <= 0;
            else
              out <= in;
          end
          
          if (j > 0)
            assign x[i].y[j].in = x[i].y[j-1].out;
          else
            assign x[i].y[j].in = A[i];
          
          if (j == (MMU_SIZE-i-2))
            assign B[i] = x[i].y[j].out;
        end
      end      
    end
    
  endgenerate
  
  /* Convert 1D input arrays to 2D */
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