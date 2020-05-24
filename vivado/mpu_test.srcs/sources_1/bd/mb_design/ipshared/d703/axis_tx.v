
module axis_tx
(
  input wire clk,
  input wire rst_n,
  /* Output AXI Stream */
  output reg [31:0] tdata,
  output reg        tvalid,
  input wire        tready,
  output reg        tlast,
  /* Buffer signals */
  output wire       buffer_c_stop,
  input wire [23:0] buffer_c_data,
  input wire [7:0]  dim_x,
  input wire [7:0]  dim_y,
  /* Other signals */
  input wire [7:0]  rx_error,
  input wire        dim_error,
  input wire        data_available,
  output reg        tx_ready
  );

  /* FSM states */
  localparam [1:0] STATE_IDLE = 2'b00;
  localparam [1:0] STATE_PREP = 2'b01;
  localparam [1:0] STATE_TX = 2'b11;
  localparam [1:0] STATE_ERROR = 2'b10;

  /* CMD types */
  localparam [1:0] CMD_NONE = 2'b00;
  localparam [1:0] CMD_DATA = 2'b01;
  localparam [1:0] CMD_ERR_DIM = 2'b11;
  localparam [1:0] CMD_ERR_CMD = 2'b10;

  reg [1:0] state, state_nxt;
  reg signed [15:0] ptr, ptr_nxt;

  reg read, read_nxt;
  wire [1:0] cmd;
  wire cmd_available;
  reg tx_ready_nxt;

  reg [31:0] tdata_nxt;
  reg tvalid_nxt, tlast_nxt;

  axis_tx_scheduler m_axis_tx_scheduler
  (
    .clk(clk),
    .rst_n(rst_n),
    .rx_error(rx_error),
    .dim_error(dim_error),
    .data_available(data_available),
    .read(read),
    .cmd(cmd),
    .cmd_available(cmd_available)
    );
  
  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      ptr <= 0;
      read <= 1'b0;
      tdata <= 0;
      tvalid <= 1'b0;
      tlast <= 1'b0;
      tx_ready <= 1'b0;
    end
    else begin
      state <= state_nxt;
      ptr <= ptr_nxt;
      read <= read_nxt;
      tdata <= tdata_nxt;
      tlast <= tlast_nxt;
      tx_ready <= tx_ready_nxt;
    end
  end
  
  always @* begin
    state_nxt = state;
    ptr_nxt = ptr;
    read_nxt = 1'b0;
    tdata_nxt = tdata;
    tvalid_nxt = 1'b0;
    tlast_nxt = 1'b0;
    tx_ready_nxt = 1'b0;
    case(state)
      STATE_IDLE: begin
        if (tready && cmd_available) begin
          state_nxt = STATE_PREP;
          ptr_nxt = -3;
          read_nxt = 1'b1;
        end
      end
      STATE_PREP: begin
        if (tready) begin
          case (ptr)
            -2: tx_ready_nxt = (cmd == CMD_DATA) ? 1'b1 : 1'b0;
             0: state_nxt = STATE_TX;
          endcase
          ptr_nxt = ptr + 1;
        end
      end
      STATE_TX: begin
        if (tready) begin
          case (ptr)
            1: begin
              tdata_nxt = {30'h0, cmd};
              state_nxt = (cmd == CMD_DATA) ? state : STATE_ERROR;
            end
            2: begin
              tdata_nxt = {8'h0, dim_x, 8'h0, dim_y};
              ptr_nxt = ptr + 1;
            end
            default: begin
              tdata_nxt = buffer_c_data[23] ? {8'hff, buffer_c_data} : {8'h00, buffer_c_data};
              ptr_nxt = ptr + 1;
            end
          endcase
          if (ptr == (2 + dim_x * dim_y)) begin
            state_nxt = STATE_IDLE;
            ptr_nxt = -4;
            tvalid_nxt = 1'b0;
            tlast_nxt = 1'b1;
          end
          else begin
            tvalid_nxt = 1'b1;
          end
        end
      end
      STATE_ERROR: begin
        if (tready) begin
          state_nxt = STATE_IDLE;
          ptr_nxt = -4;
          tdata_nxt = 0;
          tlast_nxt = 1'b1;
        end
      end
    endcase
  end
  
  assign buffer_c_stop = 1'b0;
  
endmodule

