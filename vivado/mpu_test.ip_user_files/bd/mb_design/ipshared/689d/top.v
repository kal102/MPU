
module top #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 24, parameter MMU_SIZE = 10, parameter FIFO_SIZE = 4)
(
  input  wire        clk,
  input  wire        rst_n,
  /* Input AXI Stream */
  input  wire [31:0] axis_in_tdata,
  input  wire        axis_in_tvalid,
  output wire        axis_in_tready,
  input  wire        axis_in_tlast, 
  /* Output AXI Stream */
  output wire [31:0] axis_out_tdata,
  output wire        axis_out_tvalid,
  input wire         axis_out_tready,
  output wire        axis_out_tlast
  );
  
  /* Input buffers signals */
  wire buffer_ab_stop;
  wire [(VAR_SIZE-1):0] buffer_a_data;
  wire [(VAR_SIZE-1):0] buffer_b_data;
  wire [4:0] buffer_a_idx;
  wire [4:0] buffer_b_idx;
  wire [7:0] dim_x_in;
  wire [7:0] dim_y_in;
  
  /* Controller signals */
  wire load;
  wire buffer_a_b;
  wire multiply;
  wire signed [(ACC_SIZE-1):0] bias;
  wire [7:0] activation;
  wire [7:0] pooling;
  wire mpu_ready;
  wire dim_error;
  wire data_available;
  wire tx_ready;
  
  /* Output buffers signals */
  wire buffer_c_stop;
  wire [(ACC_SIZE-1):0] buffer_c_data;
  wire [7:0] dim_x_out;
  wire [7:0] dim_y_out;
  
  /* Other signals */
  wire [7:0] rx_error;
  
  axis_rx #(.MMU_SIZE(MMU_SIZE)) m_axis_rx
  (
    .clk(clk),
    .rst_n(rst_n),
    /* Input AXI Stream */
    .tdata(axis_in_tdata[7:0]),
    .tvalid(axis_in_tvalid),
    .tready(axis_in_tready),
    .tlast(axis_in_tlast),
    /* Buffer signals */
    .buffer_stop(buffer_ab_stop),
    .buffer_a_data(buffer_a_data),
    .buffer_b_data(buffer_b_data),
    .buffer_a_idx(buffer_a_idx),
    .buffer_b_idx(buffer_b_idx),
    .dim_x(dim_x_in),
    .dim_y(dim_y_in),
    /* Controller signals */
    .load(load),
    .buffer_a_b(buffer_a_b),
    .multiply(multiply),
    .bias(bias),
    .activation(activation),
    .pooling(pooling),
    .mpu_ready(mpu_ready),
    /* Other signals */
    .rx_error(rx_error)
    );

  mpu #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE), .FIFO_SIZE(FIFO_SIZE)) m_mpu
  (
    .clk(clk),
    .rst_n(rst_n),
    /* Input buffers signals */
    .buffer_ab_stop(buffer_ab_stop),
    .buffer_a_data(buffer_a_data),
    .buffer_b_data(buffer_b_data),
    .buffer_a_idx(buffer_a_idx),
    .buffer_b_idx(buffer_b_idx),
    .dim_x_in(dim_x_in),
    .dim_y_in(dim_y_in),
    /* Controller signals */
    .load(load),
    .buffer_a_b(buffer_a_b),
    .multiply(multiply),
    .bias(bias),
    .activation(activation),
    .pooling(pooling),
    .mpu_ready(mpu_ready),
    .dim_error(dim_error),
    .data_available(data_available),
    .tx_ready(tx_ready),
    /* Output buffers signals */
    .buffer_c_stop(buffer_c_stop),
    .buffer_c_data(buffer_c_data),
    .dim_x_out(dim_x_out),
    .dim_y_out(dim_y_out)
    );

  axis_tx m_axis_tx
  (
    .clk(clk),
    .rst_n(rst_n),
    /* Output AXI Stream */
    .tdata(axis_out_tdata),
    .tvalid(axis_out_tvalid),
    .tready(axis_out_tready),
    .tlast(axis_out_tlast),
    /* Buffer signals */
    .buffer_c_stop(buffer_c_stop),
    .buffer_c_data(buffer_c_data),
    .dim_x(dim_x_out),
    .dim_y(dim_y_out),
    /* Other signals */
    .rx_error(rx_error),
    .dim_error(dim_error),
    .data_available(data_available),
    .tx_ready(tx_ready)
    );

endmodule
