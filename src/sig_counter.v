
module sig_counter #(parameter WIDTH = 1, parameter EDGE = 0)
(
	input wire clk,
	input wire rst_n,
	input wire [(WIDTH-1):0] sig,
	output reg [7:0] cnt
	);
	
	reg [(WIDTH-1):0] sig_last;
	reg [7:0] cnt_nxt;
	
	always @(posedge clk) begin
		if (!rst_n) begin
			sig_last <= 0;
			cnt <= 0;
		end
		else begin
			sig_last <= sig;
			cnt <= cnt_nxt;
		end
	end
	
	always @* begin
		if (!EDGE) begin
			if (sig && !sig_last)
				cnt_nxt = cnt + 1;
			else
				cnt_nxt = cnt;
		end
		else begin
			if (!sig && sig_last)
				cnt_nxt = cnt + 1;
			else
				cnt_nxt = cnt;
		end
	end
	
endmodule
