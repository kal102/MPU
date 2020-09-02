
module buffer_b #(parameter VAR_SIZE = 8, parameter MMU_SIZE = 10)
(
  output wire signed [(VAR_SIZE*MMU_SIZE-1):0] B1,
  input wire signed [(VAR_SIZE-1):0] A,
  input wire clk,
  input wire rst_n,
  input wire stop,
  input wire [1:0] cmd,
  input wire [4:0] buffer,
  input wire [7:0] dim_x_in,
  input wire [7:0] dim_y_in,
  output wire [7:0] dim_x,
  output wire [7:0] dim_y
  );
  
  buffer_b_4x #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer_b
  (
    .B1(B1),
    .A(A),
    .clk(clk),
    .rst_n(rst_n),
    .stop(stop),
    .cmd(cmd),
    .buffer(buffer),
    .dim_x_in(dim_x_in),
    .dim_y_in(dim_y_in),
    .dim_x_out(dim_x),
    .dim_y_out(dim_y)
    );
  
endmodule
