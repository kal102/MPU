
/* Ethernet frames decoder for TPU design */
/*       RAW ETHERNET FRAMES ONLY         */

module eth_rx #(parameter MMU_SIZE = 10)
(
    input  wire        clk,
    input  wire        rst_n,
    /* Input Avalon Stream */
    input  wire [7:0]  data,
    input  wire        valid,
    output wire        ready,
    input  wire [5:0]  error,
    input  wire        startofpacket,
    input  wire        endofpacket,
    /* Other RX signals */
    input  wire        dsav,
    input  wire [1:0]  mod,
    input  wire [3:0]  frm_type,
    input  wire        a_full,
    input  wire        a_empty,
    input  wire [17:0] err_stat,
    /* Buffer signals */
    output reg        buffer_stop,
    output reg [7:0]  buffer_a_data,
    output reg [7:0]  buffer_b_data,
    output reg [4:0]  buffer_a_idx,
    output reg [4:0]  buffer_b_idx,
    output reg [7:0]  dim_x,
    output reg [7:0]  dim_y,
    /* Controller signals */
    output reg        load,
    output reg        buffer_a_b,
    output reg        multiply,
    output reg signed [23:0] bias,
    output reg [7:0]  activation,
    output reg [7:0]  pooling,
    input wire 				mpu_ready,
    /* Other signals */
    output reg [47:0] host_mac,
    output reg [7:0]  rx_error
);

  /* FSM states */
  localparam [1:0] STATE_IDLE = 2'b00;
  localparam [1:0] STATE_HEADER = 2'b01;
  localparam [1:0] STATE_PAYLOAD = 2'b11;
  localparam [1:0] STATE_ERROR = 2'b10;

  /* Buffer commands */
  localparam BUFFER_A = 8'h0;
  localparam BUFFER_B = 8'h1;

  /* TPU commands */
  localparam [7:0] CMD_NONE = 8'h0;
  localparam [7:0] CMD_LOAD = 8'h1;
  localparam [7:0] CMD_MULTIPLY = 8'h2;

  /* RX errors */
  localparam [7:0] ERROR_NONE = 8'h0;
  localparam [7:0] ERROR_FRAME = 8'h1;
  localparam [7:0] ERROR_CMD = 8'h2;

  /* MAC default addresses */
  localparam [47:0] MAC_DEST_DEFAULT = 48'h5044332211EE;
  localparam [47:0] MAC_SRC_DEFAULT = 48'hDC0EA1F0573B;

  localparam MTU = 1500;
  localparam BUFFER_CNT = 4;

  /* MAC addresses and length */
  reg [47:0] mac_dest, mac_dest_nxt;
  reg [47:0] mac_src, mac_src_nxt;
  reg [15:0] length, length_nxt;

  /* FSM signals */
  reg [1:0] state, state_nxt;
  reg [15:0] frame_ptr, frame_ptr_nxt;
  reg [7:0] cmd, cmd_nxt;

  /* FSM variables and flags */
  reg wrong_data;

  /* Buffer signals */
  reg [7:0] buffer_a_data_nxt;
  reg [7:0] buffer_b_data_nxt;
  reg [7:0] buffer_a_b_nxt;
  reg [4:0] buffer_a_idx_nxt;
  reg [4:0] buffer_b_idx_nxt;

  /* TPU signals */
  reg load_nxt;
  reg multiply_nxt;
  reg [7:0] dim_x_nxt;
  reg [7:0] dim_y_nxt;
  reg signed [31:0] bias_nxt;
  reg [1:0] activation_nxt;
  reg pooling_nxt;

  /* Other signals */
  reg [47:0] host_mac_nxt;
  reg [7:0] rx_error_nxt;

  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      frame_ptr <= 1;
      cmd <= CMD_NONE;
      mac_dest <= MAC_DEST_DEFAULT;
      mac_src <= MAC_SRC_DEFAULT;
      length <= 16'b0;
      buffer_a_b <= BUFFER_A;
      buffer_a_data <= 8'h0;
      buffer_a_idx <= 5'b0;
      buffer_b_data <= 8'h0;
      buffer_b_idx <= 5'b0;
      load <= 1'b0;
      multiply <= 1'b0;
      dim_x <= 0;
      dim_y <= 0;
      bias <= 0;
      activation <= 1'b0;
      pooling <= 1'b0;
      host_mac <= MAC_SRC_DEFAULT;
      rx_error <= 8'h0;
    end
    else begin
      state <= state_nxt;
      frame_ptr <= frame_ptr_nxt;
      cmd <= cmd_nxt;
      mac_dest <= mac_dest_nxt;
      mac_src <= mac_src_nxt;
      length <= length_nxt;
      buffer_a_b <= buffer_a_b_nxt;
      buffer_a_data <= buffer_a_data_nxt;
      buffer_a_idx <= buffer_a_idx_nxt;
      buffer_b_data <= buffer_b_data_nxt;
      buffer_b_idx <= buffer_b_idx_nxt;
      load <= load_nxt;
      multiply <= multiply_nxt;
      dim_x <= dim_x_nxt;
      dim_y <= dim_y_nxt;
      bias <= bias_nxt[23:0];
      activation <= activation_nxt;
      pooling <= pooling_nxt;
      host_mac <= host_mac_nxt;
      rx_error <= rx_error_nxt;
    end
  end

  always @* begin
    /* Default values */
    state_nxt = state;
    frame_ptr_nxt = frame_ptr;
    cmd_nxt = cmd;
    wrong_data = 1'b0;
    mac_dest_nxt = mac_dest;
    mac_src_nxt = mac_src;
    length_nxt = length;
    buffer_stop = 1'b0;
    buffer_a_b_nxt = buffer_a_b;
    buffer_a_data_nxt = buffer_a_data;
    buffer_a_idx_nxt = buffer_a_idx;
    buffer_b_data_nxt = buffer_b_data;
    buffer_b_idx_nxt = buffer_b_idx;
    load_nxt = 1'b0;
    multiply_nxt = 1'b0;
    dim_x_nxt = dim_x;
    dim_y_nxt = dim_y;
    bias_nxt = bias;
    activation_nxt = activation;
    pooling_nxt = pooling;
    host_mac_nxt = host_mac;
    rx_error_nxt = rx_error;
    /* State machine */
    case (state)
      STATE_IDLE: begin
        if (startofpacket && !endofpacket && valid && !error && ready) begin
          state_nxt = STATE_HEADER;
          frame_ptr_nxt = 2;
          mac_dest_nxt[47:40] = data;
        end
      end
      STATE_HEADER: begin
        if (valid && !error) begin
          case (frame_ptr)
            2: mac_dest_nxt[39:32] = data;
            3: mac_dest_nxt[31:24] = data;
            4: mac_dest_nxt[23:16] = data;
            5: mac_dest_nxt[15:8] = data;
            6: mac_dest_nxt[7:0] = data;
            7: mac_src_nxt[47:40] = data;
            8: mac_src_nxt[39:32] = data;
            9: mac_src_nxt[31:24] = data;
            10: mac_src_nxt[23:16] = data;
            11: mac_src_nxt[15:8] = data;
            12: mac_src_nxt[7:0] = data;
            13: length_nxt[15:8] = data;
            14: length_nxt[7:0] = data;
          endcase
          if (endofpacket) begin
            state_nxt = STATE_ERROR;
            rx_error_nxt = ERROR_FRAME;
          end
          else if (frame_ptr == 14) begin
            state_nxt = (length_nxt <= MTU) ? STATE_PAYLOAD : STATE_ERROR;
            frame_ptr_nxt = ready ? frame_ptr + 1 : frame_ptr;
            host_mac_nxt = mac_src;
          end
          else begin
            state_nxt = state;
            frame_ptr_nxt = ready ? frame_ptr + 1 : frame_ptr;
          end
        end
        else if (!valid) begin
          state_nxt = state;
          frame_ptr_nxt = frame_ptr;
        end
        else begin
          state_nxt = STATE_ERROR;
          rx_error_nxt = ERROR_FRAME;
        end
      end
      STATE_PAYLOAD: begin
        if (valid && !error) begin
          /* RAW ETHERNET FRAMES ONLY */
          case (frame_ptr)
            15: begin
              /* Command */
              if (data > CMD_MULTIPLY)
                wrong_data = 1'b1;
              else
                cmd_nxt = data;
            end
            16: begin
              /* Buffer A or B */
              if (cmd == CMD_LOAD) begin
                if (data != BUFFER_A && data != BUFFER_B)
                  wrong_data = 1'b1;
                else
                  buffer_a_b_nxt = data;
              end
            end
            17: begin
              /* Buffer A index */
              if (cmd != CMD_NONE) begin
                if (data < BUFFER_CNT) begin
                  buffer_a_idx_nxt = data;
                end
                else
                  wrong_data = 1'b1;
              end
            end
            18: begin
              /* Buffer B index */
              if (cmd != CMD_NONE) begin
                if (data < BUFFER_CNT) begin
                  buffer_b_idx_nxt = data;
                end
                else
                  wrong_data = 1'b1;
              end
            end
            19: begin
              /* Row size */
              if (cmd == CMD_LOAD) begin
                dim_x_nxt = data;
                if (dim_x_nxt > MMU_SIZE)
                  wrong_data = 1'b1;
              end
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[31:24] = data;
            end
            20: begin
              /* Column size */
              if (cmd == CMD_LOAD) begin
                dim_y_nxt = data;
                if (dim_y_nxt > MMU_SIZE)
                  wrong_data = 1'b1;
                else
                  load_nxt = 1'b1;
              end
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[23:16] = data;
            end
            21: begin
              /* Empty cycle for MMU controller operations */
              if (cmd == CMD_LOAD)
                ;
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[15:8] = data;
            end
            22: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = data;
                else
                  buffer_b_data_nxt = data;
              end
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[7:0] = data;
            end
            23: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = data;
                else
                  buffer_b_data_nxt = data;
              end
              /* Activation */
              else if (cmd == CMD_MULTIPLY) begin
                if (data > 8'h1)
                  wrong_data = 1'b1;
                else
                  activation_nxt = data[0];
              end
            end
            24: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = data;
                else
                  buffer_b_data_nxt = data;
              end
              /* Pooling */
              if (cmd == CMD_MULTIPLY) begin
                if (data > 8'h1)
                  wrong_data = 1'b1;
                else begin
                  multiply_nxt = 1'b1;
                  pooling_nxt = data[0];
                end
              end
            end
            default: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = data;
                else
                  buffer_b_data_nxt = data;
              end
            end
          endcase
          if (wrong_data) begin
            state_nxt = STATE_ERROR;
            rx_error_nxt = ERROR_CMD;
            wrong_data = 1'b0;
          end
          else if (frame_ptr > 1514) begin
            state_nxt = STATE_ERROR;
            rx_error_nxt = ERROR_FRAME;
            wrong_data = 1'b0;
          end
          else if (endofpacket) begin
            state_nxt = STATE_IDLE;
            frame_ptr_nxt = 1;
          end
          else begin
            state_nxt = state;
            frame_ptr_nxt = ready ? frame_ptr + 1 : frame_ptr;
          end
        end
        else if (!valid) begin
          state_nxt = state;
          frame_ptr_nxt = frame_ptr;
          buffer_stop = 1'b1;
        end
        else begin
          state_nxt = STATE_ERROR;
          rx_error_nxt = ERROR_FRAME;
        end
      end
      STATE_ERROR: begin
	      if (endofpacket) begin
	        state_nxt = STATE_IDLE;
	        frame_ptr_nxt = 1;
	        cmd_nxt = CMD_NONE;
          dim_x_nxt = 0;
          dim_y_nxt = 0;
	      end
	      else
		    	state_nxt = state;
          rx_error_nxt = ERROR_NONE;
      end
    endcase
  end

  assign ready = mpu_ready;

endmodule
