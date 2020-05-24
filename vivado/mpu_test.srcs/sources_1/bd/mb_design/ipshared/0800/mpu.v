
module mpu #(parameter VAR_SIZE = 8, parameter ACC_SIZE = 24, parameter MMU_SIZE = 10, parameter FIFO_SIZE = 4)
(
  input wire clk,
  input wire rst_n,
  /* Input buffers signals */
  input wire buffer_ab_stop,
  input wire [(VAR_SIZE-1):0] buffer_a_data,
  input wire [(VAR_SIZE-1):0] buffer_b_data,
  input wire [4:0] buffer_a_idx,
  input wire [4:0] buffer_b_idx,
  input wire [7:0] dim_x_in,
  input wire [7:0] dim_y_in,
  /* Controller signals */
  input wire load,
  input wire buffer_a_b,
  input wire multiply,
  input wire signed [(ACC_SIZE-1):0] bias,
  input wire [7:0] activation,
  input wire [7:0] pooling,
  output wire mpu_ready,
  output wire dim_error,
  output wire data_available,
  input wire tx_ready,
  /* Output buffers signals */
  input wire 	buffer_c_stop,
  output wire [(ACC_SIZE-1):0] buffer_c_data,
  output wire [7:0] dim_x_out,
  output wire [7:0] dim_y_out
);

  wire signed [(VAR_SIZE*MMU_SIZE-1):0] A1_setup, B1_setup;
  wire [1:0] buffer_a_cmd, buffer_b_cmd;
  wire [7:0] dim_x_a, dim_x_b;
  wire [7:0] dim_y_a, dim_y_b;

  buffer_a #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer_a
  (
    .B1(A1_setup),
    .A(buffer_a_data),
    .clk(clk),
    .rst_n(rst_n),
    .stop(buffer_ab_stop),
    .cmd(buffer_a_cmd),
    .buffer(buffer_a_idx),
    .dim_x_in(dim_x_in),
    .dim_y_in(dim_y_in),
    .dim_x(dim_x_a),
    .dim_y(dim_y_a)
    );

  buffer_b #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer_b
  (
    .B1(B1_setup),
    .A(buffer_b_data),
    .clk(clk),
    .rst_n(rst_n),
    .stop(buffer_ab_stop),
    .cmd(buffer_b_cmd),
    .buffer(buffer_b_idx),
    .dim_x_in(dim_x_in),
    .dim_y_in(dim_y_in),
    .dim_x(dim_x_b),
    .dim_y(dim_y_b)
    );

  wire shift, clear;
  wire signed [(ACC_SIZE-1):0] bias_ctrl;
  wire [1:0] activation_ctrl;
  wire padding_ctrl;
  wire [1:0] pooling_ctrl;
  wire [7:0] dim_x_ctrl, dim_y_ctrl;

  wire fifo_almst_full, fifo_wr;
  wire [7:0] dim_x_fifo_in, dim_y_fifo_in;
  wire fifo_dim_wr;

  mmu_controller #(.ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_controller (
    .clk(clk),
    .rst_n(rst_n),
    /* Rx signals */
    .load(load),
    .buffer_a_b(buffer_a_b),
    .multiply(multiply),
    .bias_in(bias),
    .activation_in(activation),
    .pooling_in(pooling),
    .mpu_ready(mpu_ready),
    /* Buffers signals */
    .buffer_a_cmd(buffer_a_cmd),
    .buffer_b_cmd(buffer_b_cmd),
    .dim_x_a(dim_x_a),
    .dim_y_a(dim_y_a),
    .dim_x_b(dim_x_b),
    .dim_y_b(dim_y_b),
    /* MMU signals */
    .shift(shift),
    .clear(clear),
    /* Activation/Pooling signals */
    .bias_ctrl(bias_ctrl),
    .activation_ctrl(activation_ctrl),
    .padding_ctrl(padding_ctrl),
    .pooling_ctrl(pooling_ctrl),
    .dim_x_ctrl(dim_x_ctrl),
    .dim_y_ctrl(dim_y_ctrl),
    /* FIFO signals */
    .fifo_almst_full(fifo_almst_full),
    .fifo_wr(fifo_wr),
    .dim_x_fifo(dim_x_fifo_in),
    .dim_y_fifo(dim_y_fifo_in),
    .fifo_dim_wr(fifo_dim_wr),
    /* Tx signals */
    .dim_error(dim_error)
    );

  wire signed [(VAR_SIZE*MMU_SIZE-1):0] A1_str;
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] B1_str;

  mmu_setup #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_a_setup
  (
    .B1(A1_str),
    .A1(A1_setup),
    .clk(clk),
    .rst_n(rst_n)
    );
  
  mmu_setup #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_b_setup
  (
    .B1(B1_str),
    .A1(B1_setup),
    .clk(clk),
    .rst_n(rst_n)
    );

  wire signed [(ACC_SIZE*MMU_SIZE-1):0] C1_str;

  mmu_str #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_str
  (
    .C1(C1_str),
    .A1(A1_str),
    .B1(B1_str),
    .clk(clk),
    .shift(shift),
    .clear(clear)
    );

  wire signed [(ACC_SIZE*MMU_SIZE-1):0] C1_setup;

  mmu_setup #(.VAR_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE), .REVERSED(1)) m_mmu_c_setup
  (
    .B1(C1_setup),
    .A1(C1_str),
    .clk(clk),
    .rst_n(rst_n)
    );

  wire signed [(ACC_SIZE*MMU_SIZE-1):0] C1_activation;

  activation_pipeline #(.ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_activation_pipeline
  (
    .B1(C1_activation),
    .A1(C1_setup),
    .clk(clk),
    .rst_n(rst_n),
    .activation(activation_ctrl),
    .bias(bias_ctrl)
    );

  wire signed [(ACC_SIZE*(MMU_SIZE+1)-1):0] C1_padding; 

  padding_pipeline #(.ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_padding_pipeline
  (
    .B1(C1_padding),
    .A1(C1_activation),
    .clk(clk),
    .rst_n(rst_n),
    .padding(padding_ctrl),
    .dim_x(dim_x_ctrl),
    .dim_y(dim_y_ctrl)
    );  

  wire signed [(ACC_SIZE*MMU_SIZE-1):0] C1_pooling; 

  pooling_pipeline #(.ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_pooling_pipeline
  (
    .B1(C1_pooling),
    .A1(C1_padding),
    .clk(clk),
    .rst_n(rst_n),
    .pooling(pooling_ctrl)
    );

  wire fifo_empty;
  wire fifo_rd, fifo_dim_rd;
  wire [7:0] dim_x_fifo_out, dim_y_fifo_out;
  wire [1:0] buffer_c_cmd;
  wire [7:0] dim_x_c, dim_y_c;

  out_controller #(.MMU_SIZE(MMU_SIZE)) m_out_controller (
    .clk(clk),
    .rst_n(rst_n),
    /* FIFO signals */
    .fifo_empty(fifo_empty),
    .fifo_wr(fifo_wr),
    .fifo_rd(fifo_rd),
    .fifo_dim_rd(fifo_dim_rd),
    .dim_x_fifo(dim_x_fifo_out),
    .dim_y_fifo(dim_y_fifo_out),
    /* Output buffer signals */
    .buffer_c_cmd(buffer_c_cmd),
    .dim_x_c(dim_x_c),
    .dim_y_c(dim_y_c),
    /* Tx signals */
    .data_available(data_available),
    .tx_ready(tx_ready),
    .stopped(buffer_c_stop)
    );

  wire signed [(ACC_SIZE*MMU_SIZE-1):0] C1_fifo;

  FIFO_v #(.ADDR_W($clog2(FIFO_SIZE*MMU_SIZE)), .DATA_W(ACC_SIZE*MMU_SIZE), .BUFF_L(FIFO_SIZE*MMU_SIZE), .ALMST_F(MMU_SIZE), .ALMST_E(MMU_SIZE)) m_fifo_v
  (
    .data_out(C1_fifo),
    .data_count(),
    .empty(fifo_empty),
    .full(),
    .almst_empty(),
    .almst_full(fifo_almst_full),
    .err(),
    .data_in(C1_pooling),
    .wr_en(fifo_wr),
    .rd_en(fifo_rd),
    .n_reset(rst_n),
    .clk(clk)
    );

  FIFO_v #(.ADDR_W($clog2(MMU_SIZE)), .DATA_W(8), .BUFF_L(MMU_SIZE), .ALMST_F(1), .ALMST_E(1)) m_fifo_dim_x
  (
    .data_out(dim_x_fifo_out),
    .data_count(),
    .empty(),
    .full(),
    .almst_empty(),
    .almst_full(),
    .err(),
    .data_in(dim_x_fifo_in),
    .wr_en(fifo_dim_wr),
    .rd_en(fifo_dim_rd),
    .n_reset(rst_n),
    .clk(clk)
    );  

  FIFO_v #(.ADDR_W($clog2(MMU_SIZE)), .DATA_W(8), .BUFF_L(MMU_SIZE), .ALMST_F(1), .ALMST_E(1)) m_fifo_dim_y
  (
    .data_out(dim_y_fifo_out),
    .data_count(),
    .empty(),
    .full(),
    .almst_empty(),
    .almst_full(),
    .err(),
    .data_in(dim_y_fifo_in),
    .wr_en(fifo_dim_wr),
    .rd_en(fifo_dim_rd),
    .n_reset(rst_n),
    .clk(clk)
    );  

  buffer_c #(.ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer_c
  (
    .B(buffer_c_data),
    .A1(C1_fifo),
    .clk(clk),
    .rst_n(rst_n),
    .stop(buffer_c_stop),
    .cmd(buffer_c_cmd),
    .dim_x_in(dim_x_c),
    .dim_y_in(dim_y_c),
    .dim_x(dim_x_out),
    .dim_y(dim_y_out)
    );

endmodule
