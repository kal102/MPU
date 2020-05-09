
//TODO: Output controller operations
// 1. Wait for data write to fifo
// 2. Read matrix dimensions from fifo
// 3. Load matrix output matrix into output buffer
// 4. Wait for tx_ready signal assertion
// 5. Send output matrix to transmitter

module out_controller #(parameter MMU_SIZE = 10)
(
  input wire clk,
  input wire rst_n,
  /* FIFO signals */
  input wire fifo_empty,
  input wire fifo_wr,
  output reg fifo_rd,
  output reg fifo_dim_rd,
  input wire [7:0] dim_x_fifo,
  input wire [7:0] dim_y_fifo,
  /* Output buffer signals */
  output reg [1:0]  buffer_c_cmd,
  output wire [7:0] dim_x_c,
  output wire [7:0] dim_y_c,
  /* Tx signals */
  output reg data_available,
  input wire tx_ready,
  input wire stopped
  );

  localparam [2:0] STATE_IDLE    = 3'b000;
  localparam [2:0] STATE_DIM     = 3'b001;
  localparam [2:0] STATE_LOADING = 3'b011;
  localparam [2:0] STATE_WAITING = 3'b010;
  localparam [2:0] STATE_SENDING = 3'b110;

  localparam [1:0] BUFFER_NONE = 2'b00;
  localparam [1:0] BUFFER_LOAD = 2'b01;
  localparam [1:0] BUFFER_SEND = 2'b10;
  localparam [1:0] BUFFER_CLEAR = 2'b11;

  reg [2:0] state, state_nxt;
  reg [15:0] cycle_counter, cycle_counter_nxt;
  reg fifo_wr_last;
  reg fifo_rd_nxt, fifo_dim_rd_nxt;
  
  reg [1:0] buffer_c_cmd_nxt;
  reg data_available_nxt;

  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      cycle_counter <= 0;
      fifo_wr_last <= 1'b0;
      fifo_rd <= 1'b0;
      fifo_dim_rd <= 1'b0;
      buffer_c_cmd <= BUFFER_NONE;
      data_available <= 1'b0;
    end
    else begin
      state <= state_nxt;
      cycle_counter <= cycle_counter_nxt;
      fifo_wr_last <= fifo_wr;
      fifo_rd <= fifo_rd_nxt;
      fifo_dim_rd <= fifo_dim_rd_nxt;
      buffer_c_cmd <= buffer_c_cmd_nxt;
      data_available <= data_available_nxt;
    end
  end

  always @* begin
    fifo_rd_nxt = 1'b0;
    fifo_dim_rd_nxt = 1'b0;
    buffer_c_cmd_nxt = BUFFER_NONE;
    data_available_nxt = 1'b0;
    case (state)
      STATE_IDLE: begin
        if (fifo_empty || fifo_wr || fifo_wr_last) begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter;
        end
        else begin
          state_nxt = STATE_DIM;
          cycle_counter_nxt = 0;
          fifo_dim_rd_nxt = 1'b1;
        end
      end
      STATE_DIM: begin
        if (cycle_counter >= 1) begin
          state_nxt = STATE_LOADING;
          cycle_counter_nxt = 0;
          fifo_rd_nxt = 1'b1;
          buffer_c_cmd_nxt = BUFFER_LOAD;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter + 1;
        end
      end
      STATE_LOADING: begin
        if (cycle_counter >= (dim_x_fifo - 1)) begin
          state_nxt = STATE_WAITING;
          cycle_counter_nxt = cycle_counter;
          data_available_nxt = 1'b1;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter + 1;
          fifo_rd_nxt = 1'b1;
        end
      end
      STATE_WAITING: begin
        if (tx_ready) begin
          state_nxt = STATE_SENDING;
          cycle_counter_nxt = 0;
          buffer_c_cmd_nxt = BUFFER_SEND;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter;
        end
      end
      STATE_SENDING: begin
        if (cycle_counter >= (dim_x_fifo * dim_y_fifo - 1)) begin
          state_nxt = STATE_IDLE;
          cycle_counter_nxt = 0;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = stopped ? cycle_counter : (cycle_counter + 1);
        end
      end
    endcase
  end

  assign dim_x_c = dim_x_fifo;
  assign dim_y_c = dim_y_fifo;

endmodule
