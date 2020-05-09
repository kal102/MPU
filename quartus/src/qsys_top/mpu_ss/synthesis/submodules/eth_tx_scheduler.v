
module eth_tx_scheduler
(
  input wire clk,
  input wire rst_n,
  input wire [7:0] rx_error,
  input wire dim_error,
  input wire data_available,
  input wire read,
  output wire [2:0] frame,
  output wire frame_available
  );

  /* Frame types */
  localparam [2:0] FRAME_NONE = 3'b000;
  localparam [2:0] FRAME_DATA = 3'b001;
  localparam [2:0] FRAME_ERR_DIM = 3'b011;
  localparam [2:0] FRAME_ERR_CMD = 3'b010;
  localparam [2:0] FRAME_ERR_FRAME = 3'b110;

  /* RX errors */
  localparam [7:0] ERROR_NONE = 8'h0;
  localparam [7:0] ERROR_FRAME = 8'h1;
  localparam [7:0] ERROR_CMD = 8'h2;

  reg [7:0] data_cnt, data_cnt_nxt;
  reg [7:0] dim_cnt, dim_cnt_nxt;
  reg [7:0] cmd_cnt, cmd_cnt_nxt;
  reg [7:0] frame_cnt, frame_cnt_nxt;

  reg [2:0] frame_fifo, frame_fifo_nxt;
  reg write, write_nxt;
  wire empty;
 
  FIFO_v #(.ADDR_W(5), .DATA_W(3), .BUFF_L(20), .ALMST_F(1), .ALMST_E(1)) m_fifo_frame
  (
    .data_out(frame),
    .data_count(),
    .empty(empty),
    .full(),
    .almst_empty(),
    .almst_full(),
    .err(),
    .data_in(frame_fifo),
    .wr_en(write),
    .rd_en(read),
    .n_reset(rst_n),
    .clk(clk)
    );  

  always @(posedge clk) begin
    if (!rst_n) begin
      frame_fifo <= FRAME_NONE;
      write <= 1'b0;
      data_cnt <= 0;
      dim_cnt <= 0;
      cmd_cnt <= 0;
      frame_cnt <= 0;
    end
    else begin
      frame_fifo <= frame_fifo_nxt;
      write <= write_nxt;
      data_cnt <= data_cnt_nxt;
      dim_cnt <= dim_cnt_nxt;
      cmd_cnt <= cmd_cnt_nxt;
      frame_cnt <= frame_cnt_nxt;
    end
  end

  always @* begin
    frame_fifo_nxt = FRAME_NONE;
    write_nxt = 1'b0;
    data_cnt_nxt = data_available ? (data_cnt + 1) : data_cnt;
    dim_cnt_nxt = dim_error ? (dim_cnt + 1) : dim_cnt;
    cmd_cnt_nxt = (rx_error == ERROR_CMD) ? (cmd_cnt + 1) : cmd_cnt;
    frame_cnt_nxt = (rx_error == ERROR_FRAME) ? (frame_cnt + 1) : frame_cnt;
    if (data_cnt) begin
      frame_fifo_nxt = FRAME_DATA;
      write_nxt = 1'b1;
      data_cnt_nxt = data_cnt_nxt - 1;
    end
    else if (dim_cnt) begin
      frame_fifo_nxt = FRAME_ERR_DIM;
      write_nxt = 1'b1;
      dim_cnt_nxt = dim_cnt_nxt - 1;
    end
    else if (cmd_cnt) begin
      frame_fifo_nxt = FRAME_ERR_CMD;
      write_nxt = 1'b1;
      cmd_cnt_nxt = cmd_cnt_nxt - 1;
    end
    else if (frame_cnt) begin
      frame_fifo_nxt = FRAME_ERR_FRAME;
      write_nxt = 1'b1;
      frame_cnt_nxt = frame_cnt_nxt - 1;
    end
  end
  
  assign frame_available = !empty;

endmodule