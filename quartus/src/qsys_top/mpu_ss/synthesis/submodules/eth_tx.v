
module eth_tx
(
  input wire clk,
  input wire rst_n,
  /* Output Avalon Stream */
  output reg [31:0] data,
  output reg        startofpacket,
  output reg        endofpacket,
  input wire        ready,
  output reg        wren,
  output wire       error,
  /* Other TX signals */
  output wire       crc_fwd,
  output wire [1:0] mod,
  input wire        septy,
  input wire        uflow,
  input wire        a_full,
  input wire        a_empty,
  /* Buffer signals */
  output wire				buffer_c_stop,
  input wire [23:0] buffer_c_data,
  input wire [7:0]  dim_x,
  input wire [7:0]  dim_y,
  /* Other signals */
  input wire [47:0] host_mac,
  input wire [7:0]  rx_error,
  input wire        dim_error,
  input wire        data_available,
  output reg        tx_ready
  );

  /* FSM states */
  localparam [1:0] STATE_IDLE = 2'b00;
  localparam [1:0] STATE_HEADER = 2'b01;
  localparam [1:0] STATE_PAYLOAD = 2'b11;
  localparam [1:0] STATE_ERROR = 2'b10;

  /* Frame types */
  localparam [2:0] FRAME_NONE = 3'b000;
  localparam [2:0] FRAME_DATA = 3'b001;
  localparam [2:0] FRAME_ERR_DIM = 3'b011;
  localparam [2:0] FRAME_ERR_CMD = 3'b010;
  localparam [2:0] FRAME_ERR_FRAME = 3'b110;

  /* MAC default addresses */
  localparam [47:0] MAC_DEST_DEFAULT = 48'hDC0EA1F0573B;
  localparam [47:0] MAC_SRC_DEFAULT = 48'h5044332211EE;
  
  localparam [15:0] MTU = 1500;
	localparam [7:0] INTERFRAME_CYCLES = 10;

  reg [1:0] state, state_nxt;
  reg [15:0] frame_ptr, frame_ptr_nxt;
  reg [15:0] data_cnt, data_cnt_nxt;
  reg stopped, stopped_nxt;
	reg [7:0] interframe_gap, interframe_gap_nxt;

  reg read, read_nxt;
  wire [2:0] frame;
  wire frame_available;
  reg tx_ready_nxt;

  reg [31:0] data_nxt;
  reg startofpacket_nxt, endofpacket_nxt;
  reg wren_nxt;

  reg [15:0] length, length_nxt;

  eth_tx_scheduler m_eth_tx_scheduler
  (
    .clk(clk),
    .rst_n(rst_n),
    .rx_error(rx_error),
    .dim_error(dim_error),
    .data_available(data_available),
    .read(read),
    .frame(frame),
    .frame_available(frame_available)
    );
  
  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      frame_ptr <= 0;
      data_cnt <= 0;
      stopped <= 1'b0;
	    interframe_gap <= 0;
      length <= 16'h0;
      read <= 1'b0;
      data <= 0;
      startofpacket <= 1'b0;
      endofpacket <= 1'b0;
      wren <= 1'b0;
      tx_ready <= 1'b0;
    end
    else begin
      state <= state_nxt;
      frame_ptr <= frame_ptr_nxt;
      data_cnt <= data_cnt_nxt;
      stopped <= stopped_nxt;
	    interframe_gap <= interframe_gap_nxt;
      length <= length_nxt;
      read <= read_nxt;
      data <= data_nxt;
      startofpacket <= startofpacket_nxt;
      endofpacket <= endofpacket_nxt;
      wren <= wren_nxt;
      tx_ready <= tx_ready_nxt;
    end
  end
  
  always @* begin
    state_nxt = state;
    frame_ptr_nxt = frame_ptr;
    data_cnt_nxt = data_cnt;
    stopped_nxt = stopped;
	  interframe_gap_nxt = interframe_gap;
    length_nxt = length;
    read_nxt = 1'b0;
    data_nxt = data;
    startofpacket_nxt = 1'b0;
    endofpacket_nxt = 1'b0;
    wren_nxt = 1'b0;
    tx_ready_nxt = 1'b0;
    case(state)
      STATE_IDLE: begin
        if (ready && (frame_available || stopped) && (interframe_gap >= (INTERFRAME_CYCLES - 1))) begin
          state_nxt = STATE_HEADER;
          frame_ptr_nxt = 0;
          read_nxt = stopped ? 1'b0 : 1'b1;
	        interframe_gap_nxt = 0;
        end
        else
	        interframe_gap_nxt = interframe_gap + 1;
      end
      STATE_HEADER: begin
        if (ready) begin
          case (frame_ptr)
            0: begin
              data_nxt = host_mac[47:16];
              startofpacket_nxt = 1'b1;
            end
            1: begin
              data_nxt = {host_mac[15:0], MAC_SRC_DEFAULT[47:32]};
              data_cnt_nxt = stopped ? data_cnt : (dim_x * dim_y);
              tx_ready_nxt = (frame == FRAME_DATA && !stopped) ? 1'b1 : 1'b0;
            end
            2: begin
              data_nxt = MAC_SRC_DEFAULT[31:0];
              stopped_nxt = 1'b0;
              if (frame == FRAME_DATA)
                length_nxt = (1 + data_cnt) > (MTU >> 2) ? (MTU >> 2) : (1 + data_cnt);
              else
                length_nxt = 1;
            end
            3: begin
              data_nxt = {(length << 2) + 2, 13'b0, frame};
              state_nxt = (frame == FRAME_DATA) ? STATE_PAYLOAD : STATE_ERROR;
            end
          endcase
          frame_ptr_nxt = frame_ptr + 1;
        end
        wren_nxt = 1'b1;
      end
      STATE_PAYLOAD: begin
        if (ready) begin
          case (frame_ptr)
            4: begin
              data_nxt = {8'h0, dim_x, 8'h0, dim_y};
              frame_ptr_nxt = frame_ptr + 1;
            end
            default: begin
              data_nxt = buffer_c_data[23] ? {8'hff, buffer_c_data} : {8'h00, buffer_c_data};
              frame_ptr_nxt = frame_ptr + 1;
              data_cnt_nxt = data_cnt - 1;
            end
          endcase
          if ((frame_ptr == (4 + length - 1)) || ((frame_ptr > 4) && (data_cnt == 1))) begin
            state_nxt = STATE_IDLE;
            frame_ptr_nxt = 0;
            endofpacket_nxt = 1'b1;
          end
          else if ((frame_ptr == (4 + length - 3))) begin
            stopped_nxt = (data_cnt > 3) ? 1'b1 : 1'b0;
          end
        end
        wren_nxt = 1'b1;
      end
      STATE_ERROR: begin
        if (ready) begin
          state_nxt = STATE_IDLE;
          frame_ptr_nxt = 0;
          data_nxt = 0;
          endofpacket_nxt = 1'b1;
        end
        wren_nxt = 1'b1;
      end
    endcase
  end
  
  assign buffer_c_stop = stopped;
  
  assign error = 1'b0;
  assign crc_fwd = 1'b0;
  assign mod = 2'b00;
  
endmodule
