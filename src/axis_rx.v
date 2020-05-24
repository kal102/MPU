
module axis_rx #(parameter MMU_SIZE = 10)
(
    input  wire        clk,
    input  wire        rst_n,
    /* Input AXI Stream */
    input  wire [7:0]  tdata,
    input  wire        tvalid,
    output wire        tready,
    input  wire        tlast,
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
    input wire        mpu_ready,
    /* Other signals */
    output reg [7:0]  rx_error
);

  /* FSM states */
  localparam [1:0] STATE_IDLE = 2'b00;
  localparam [1:0] STATE_RX = 2'b01;
  localparam [1:0] STATE_ERROR = 2'b11;

  /* Buffer commands */
  localparam BUFFER_A = 8'h0;
  localparam BUFFER_B = 8'h1;

  /* TPU commands */
  localparam [7:0] CMD_NONE = 8'h0;
  localparam [7:0] CMD_LOAD = 8'h1;
  localparam [7:0] CMD_MULTIPLY = 8'h2;

  /* RX errors */
  localparam [7:0] ERROR_NONE = 8'h0;
  localparam [7:0] ERROR_CMD = 8'h1;
  
  localparam BUFFER_CNT = 4;

  /* FSM signals */
  reg [1:0] state, state_nxt;
  reg [15:0] ptr, ptr_nxt;
  reg [7:0] cmd, cmd_nxt;

  /* FSM variables and flags */
  reg wrong_data;

  /* Buffer signals */
  reg [7:0] buffer_a_data_nxt;
  reg [7:0] buffer_b_data_nxt;
  reg       buffer_a_b_nxt;
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
  reg [7:0] rx_error_nxt;

  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      ptr <= 0;
      cmd <= CMD_NONE;
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
      rx_error <= 8'h0;
    end
    else begin
      state <= state_nxt;
      ptr <= ptr_nxt;
      cmd <= cmd_nxt;
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
      rx_error <= rx_error_nxt;
    end
  end

  always @* begin
    /* Default values */
    state_nxt = state;
    ptr_nxt = ptr;
    cmd_nxt = cmd;
    wrong_data = 1'b0;
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
    rx_error_nxt = rx_error;
    /* State machine */
    case (state)
      STATE_IDLE: begin
        if (!tlast && tvalid && tready) begin
          /* Command */
          if (tdata > CMD_MULTIPLY) begin
            state_nxt = STATE_ERROR;
            rx_error_nxt = ERROR_CMD;
          end
          else begin
            state_nxt = STATE_RX;
            ptr_nxt = 2;
            cmd_nxt = tdata;
          end
        end
      end
      STATE_RX: begin
        if (tvalid) begin
          case (ptr)
            2: begin
              /* Buffer A or B */
              if (cmd == CMD_LOAD) begin
                if (tdata != BUFFER_A && tdata != BUFFER_B)
                  wrong_data = 1'b1;
                else
                  buffer_a_b_nxt = tdata;
              end
            end
            3: begin
              /* Buffer A index */
              if (cmd != CMD_NONE) begin
                if (tdata < BUFFER_CNT) begin
                  buffer_a_idx_nxt = tdata;
                end
                else
                  wrong_data = 1'b1;
              end
            end
            4: begin
              /* Buffer B index */
              if (cmd != CMD_NONE) begin
                if (tdata < BUFFER_CNT) begin
                  buffer_b_idx_nxt = tdata;
                end
                else
                  wrong_data = 1'b1;
              end
            end
            5: begin
              /* Row size */
              if (cmd == CMD_LOAD) begin
                dim_x_nxt = tdata;
                if (dim_x_nxt > MMU_SIZE)
                  wrong_data = 1'b1;
              end
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[31:24] = tdata;
            end
            6: begin
              /* Column size */
              if (cmd == CMD_LOAD) begin
                dim_y_nxt = tdata;
                if (dim_y_nxt > MMU_SIZE)
                  wrong_data = 1'b1;
                else
                  load_nxt = 1'b1;
              end
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[23:16] = tdata;
            end
            7: begin
              /* Empty cycle for MMU controller operations */
              if (cmd == CMD_LOAD)
                ;
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[15:8] = tdata;
            end
            8: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = tdata;
                else
                  buffer_b_data_nxt = tdata;
              end
              /* Bias */
              else if (cmd == CMD_MULTIPLY)
                bias_nxt[7:0] = tdata;
            end
            9: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = tdata;
                else
                  buffer_b_data_nxt = tdata;
              end
              /* Activation */
              else if (cmd == CMD_MULTIPLY) begin
                if (tdata > 8'h1)
                  wrong_data = 1'b1;
                else
                  activation_nxt = tdata[0];
              end
            end
            10: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = tdata;
                else
                  buffer_b_data_nxt = tdata;
              end
              /* Pooling */
              if (cmd == CMD_MULTIPLY) begin
                if (tdata > 8'h1)
                  wrong_data = 1'b1;
                else begin
                  multiply_nxt = 1'b1;
                  pooling_nxt = tdata[0];
                end
              end
            end
            default: begin
              /* Loading data */
              if (cmd == CMD_LOAD) begin
                if (buffer_a_b == BUFFER_A)
                  buffer_a_data_nxt = tdata;
                else
                  buffer_b_data_nxt = tdata;
              end
            end
          endcase
          if (wrong_data) begin
            state_nxt = STATE_ERROR;
            rx_error_nxt = ERROR_CMD;
            wrong_data = 1'b0;
          end
          else if (tlast) begin
            state_nxt = STATE_IDLE;
            ptr_nxt = 1;
          end
          else begin
            state_nxt = state;
            ptr_nxt = tready ? ptr + 1 : ptr;
          end
        end
        else begin
          state_nxt = state;
          ptr_nxt = ptr;
          buffer_stop = 1'b1;
        end
      end
      STATE_ERROR: begin
        if (tlast) begin
          state_nxt = STATE_IDLE;
          ptr_nxt = 1;
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

  assign tready = mpu_ready;

endmodule

