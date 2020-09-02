
module mem_1to2 #(parameter VAR_SIZE = 8, parameter MMU_SIZE = 10)
(
	output reg signed [(VAR_SIZE*MMU_SIZE-1):0] B1,
	input wire signed [(VAR_SIZE-1):0] A,
	input wire [7:0] address,
	input wire [(MMU_SIZE-1):0] write,
	input wire clk
);

	wire signed [(VAR_SIZE-1):0] B [0:(MMU_SIZE-1)];
	integer c, d;

	generate
		genvar i;
		
		for (i = 0; i < MMU_SIZE; i = i + 1) begin : ram
			
			single_port_ram #(.ADDR_WIDTH($clog2(MMU_SIZE)), .DATA_WIDTH(VAR_SIZE)) m_ram 
			(
				.data(A),
				.addr(address[($clog2(MMU_SIZE)-1):0]),
				.we(write[i]),
				.clk(clk),
				.q(B[i])
				);
			
		end
		
	endgenerate

  /* Convert 2D output array to 1D */
  always @(*) begin
    d = 0;
    for (c = 0; c < MMU_SIZE; c = c + 1) begin
      B1[(d * VAR_SIZE)+:VAR_SIZE] = B[c];
      d = d + 1;
    end
  end

endmodule
