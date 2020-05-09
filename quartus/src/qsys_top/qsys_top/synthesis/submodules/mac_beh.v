
module mac_beh #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 32)
(
	output reg signed [(ACC_SIZE-1):0] acc,
	input wire signed [(VAR_SIZE-1):0] a,
	input wire signed [(VAR_SIZE-1):0] b,
  input wire signed [(ACC_SIZE-1):0] bias,
	input wire clk,
	input wire rst_n
);

	wire signed [(ACC_SIZE-1):0] ab;
	wire signed [(ACC_SIZE-1):0] acc_nxt;

	always @(posedge clk)
	begin
		if (!rst_n)
			acc <= bias;
		else
			acc <= acc_nxt;
	end
	
	assign ab = a * b;
	assign acc_nxt = ab + acc;

endmodule
