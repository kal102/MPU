
module mmu_str #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 24, parameter MMU_SIZE = 10)
(
  output reg signed [(ACC_SIZE*MMU_SIZE-1):0] C1,
  input wire signed [(VAR_SIZE*MMU_SIZE-1):0] A1,
  input wire signed [(VAR_SIZE*MMU_SIZE-1):0] B1,
  input wire clk,
  input wire shift,
  input wire clear
);
  
  wire signed [(ACC_SIZE-1):0] C [0:(MMU_SIZE-1)];
  reg signed [(VAR_SIZE-1):0] A [0:(MMU_SIZE-1)];
  reg signed [(VAR_SIZE-1):0] B [0:(MMU_SIZE-1)];
  integer d, e;
  integer f, g;
  
  generate
    genvar i, j;
    for (i = 0; i < MMU_SIZE; i = i + 1) begin : x
      for (j = 0; j < MMU_SIZE; j = j + 1) begin : y
        
        wire signed [(VAR_SIZE-1):0] a_in, a_out;
        wire signed [(VAR_SIZE-1):0] b_in, b_out;
        wire signed [(ACC_SIZE-1):0] c_in, c_out;
        wire signed shift_in, shift_out;
        wire signed clear_in, clear_out;
        
        mac_cell #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE)) m_cell
        (
          .a_out(x[i].y[j].a_out),
          .b_out(x[i].y[j].b_out),
          .c_out(x[i].y[j].c_out),
          .shift_out(x[i].y[j].shift_out),
          .clear_out(x[i].y[j].clear_out),
          .a_in(x[i].y[j].a_in),
          .b_in(x[i].y[j].b_in),
          .c_in(x[i].y[j].c_in),
          .clk(clk),
          .shift_in(x[i].y[j].shift_in),
          .clear_in(x[i].y[j].clear_in)
        );
        
        if (i > 0)
          assign x[i].y[j].b_in = x[i-1].y[j].b_out;
        else
          assign x[i].y[j].b_in = B[j];
        
        if (j > 0)
          assign x[i].y[j].a_in = x[i].y[j-1].a_out;
        else
          assign x[i].y[j].a_in = A[i];
        
        if (i == (MMU_SIZE-1)) begin
          assign C[j] = x[i].y[j].c_out;
          assign x[i].y[j].c_in = x[i-1].y[j].c_out;
        end
        else if (i > 0)
          assign x[i].y[j].c_in = x[i-1].y[j].c_out;
        else
          assign x[i].y[j].c_in = 0;
        
        if (j > 0)
          assign x[i].y[j].shift_in = x[i].y[j-1].shift_out;
        else
          assign x[i].y[j].shift_in = shift;

        if (j > 0)
          assign x[i].y[j].clear_in = x[i].y[j-1].clear_out;
        else if (i > 0)
          assign x[i].y[j].clear_in = x[i-1].y[j].clear_out;
        else
          assign x[i].y[j].clear_in = clear;

      end
    end
  endgenerate
  
  /* Convert 1D input arrays to 2D */
  always @(*) begin
    e = 0;
    for (d = 0; d < MMU_SIZE; d = d + 1) begin
      A[d] = A1[(e * VAR_SIZE)+:VAR_SIZE];
      B[d] = B1[(e * VAR_SIZE)+:VAR_SIZE];
      e = e + 1;
    end
  end
  
  /* Convert 2D output array to 1D */
  always @(*) begin
    f = 0;
    for (g = 0; g < MMU_SIZE; g = g + 1) begin
      C1[(f * ACC_SIZE)+:ACC_SIZE] = C[g];
      f = f + 1;
    end
  end
  
endmodule