
module axis_tx_scheduler
(
  input wire clk,
  input wire rst_n,
  input wire [7:0] rx_error,
  input wire dim_error,
  input wire data_available,
  input wire read,
  output wire [1:0] cmd,
  output wire cmd_available
  );

  /* CMD types */
  localparam [1:0] CMD_NONE = 2'b00;
  localparam [1:0] CMD_DATA = 2'b01;
  localparam [1:0] CMD_ERR_DIM = 2'b11;
  localparam [1:0] CMD_ERR_CMD = 2'b10;

  /* RX errors */
  localparam [7:0] ERROR_NONE = 8'h0;
  localparam [7:0] ERROR_CMD = 8'h1;

  reg [7:0] data_cnt, data_cnt_nxt;
  reg [7:0] dim_cnt, dim_cnt_nxt;
  reg [7:0] cmd_cnt, cmd_cnt_nxt;

  reg [2:0] cmd_fifo, cmd_fifo_nxt;
  reg write, write_nxt;
  wire empty;
 
  FIFO_v #(.ADDR_W(5), .DATA_W(2), .BUFF_L(20), .ALMST_F(1), .ALMST_E(1)) m_fifo_cmd
  (
    .data_out(cmd),
    .data_count(),
    .empty(empty),
    .full(),
    .almst_empty(),
    .almst_full(),
    .err(),
    .data_in(cmd_fifo),
    .wr_en(write),
    .rd_en(read),
    .n_reset(rst_n),
    .clk(clk)
    );  

  always @(posedge clk) begin
    if (!rst_n) begin
      cmd_fifo <= CMD_NONE;
      write <= 1'b0;
      data_cnt <= 0;
      dim_cnt <= 0;
      cmd_cnt <= 0;
    end
    else begin
      cmd_fifo <= cmd_fifo_nxt;
      write <= write_nxt;
      data_cnt <= data_cnt_nxt;
      dim_cnt <= dim_cnt_nxt;
      cmd_cnt <= cmd_cnt_nxt;
    end
  end

  always @* begin
    cmd_fifo_nxt = CMD_NONE;
    write_nxt = 1'b0;
    data_cnt_nxt = data_available ? (data_cnt + 1) : data_cnt;
    dim_cnt_nxt = dim_error ? (dim_cnt + 1) : dim_cnt;
    cmd_cnt_nxt = (rx_error == ERROR_CMD) ? (cmd_cnt + 1) : cmd_cnt;
    if (data_cnt) begin
      cmd_fifo_nxt = CMD_DATA;
      write_nxt = 1'b1;
      data_cnt_nxt = data_cnt_nxt - 1;
    end
    else if (dim_cnt) begin
      cmd_fifo_nxt = CMD_ERR_DIM;
      write_nxt = 1'b1;
      dim_cnt_nxt = dim_cnt_nxt - 1;
    end
    else if (cmd_cnt) begin
      cmd_fifo_nxt = CMD_ERR_CMD;
      write_nxt = 1'b1;
      cmd_cnt_nxt = cmd_cnt_nxt - 1;
    end
  end
  
  assign cmd_available = !empty;

endmodule
