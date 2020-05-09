
module mmu_beh #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 32, parameter MMU_SIZE = 4)
(
  output reg signed [(ACC_SIZE*MMU_SIZE*MMU_SIZE-1):0] C1,
  input wire signed [(VAR_SIZE*MMU_SIZE*MMU_SIZE-1):0] A1,
  input wire signed [(VAR_SIZE*MMU_SIZE*MMU_SIZE-1):0] B1,
  input wire clk,
  input wire rst_n,
  input wire signed [(ACC_SIZE-1):0] bias
);
  
  reg signed [(ACC_SIZE-1):0] C [0:(MMU_SIZE-1)][0:(MMU_SIZE-1)];
  reg signed [(VAR_SIZE-1):0] A [0:(MMU_SIZE-1)][0:(MMU_SIZE-1)];
  reg signed [(VAR_SIZE-1):0] B [0:(MMU_SIZE-1)][0:(MMU_SIZE-1)];
	
  reg signed [(ACC_SIZE-1):0] C_nxt [0:(MMU_SIZE-1)][0:(MMU_SIZE-1)];
  integer x, y;
  integer a, b, c, d, e, f, i, j, k;
  
  always @(posedge clk) begin
    if (!rst_n) begin
    for (x = 0; x < MMU_SIZE; x = x + 1) begin
	      for (y = 0; y < MMU_SIZE; y = y + 1) begin
	        C[x][y] <= 0;
	      end
	    end
	  end
	  else begin
	    for (x = 0; x < MMU_SIZE; x = x + 1) begin
	      for (y = 0; y < MMU_SIZE; y = y + 1) begin
	        C[x][y] <= #(4+5*MMU_SIZE) C_nxt[x][y];
	      end
	    end
    end
  end
  
  /* Multiply matrices */
  always @(*) begin
    for (i = 0; i < MMU_SIZE; i = i + 1) begin
      for (j = 0; j < MMU_SIZE; j = j + 1) begin
        C_nxt[i][j] = bias;
      	for (k = 0; k < MMU_SIZE; k = k + 1) begin
        		C_nxt[i][j] = C_nxt[i][j] + A[i][k] * B[k][j];
		    end
      end
    end
  end
  
  /* Convert 1D input arrays to 3D */
  always @(*) begin
    c = 0;
    for (a = 0; a < MMU_SIZE; a = a + 1) begin
      for (b = 0; b < MMU_SIZE; b = b + 1) begin
        A[a][b] = A1[(c * VAR_SIZE)+:VAR_SIZE];
        B[a][b] = B1[(c * VAR_SIZE)+:VAR_SIZE];
        c = c + 1;
      end
    end
  end
  
  /* Convert 3D output array to 1D */
  always @(*) begin
    f = 0;
    for (d = 0; d < MMU_SIZE; d = d + 1) begin
      for (e = 0; e < MMU_SIZE; e = e + 1) begin
        C1[(f * ACC_SIZE)+:ACC_SIZE] = C[d][e];
        f = f + 1;
      end
    end
  end
  
endmodule
