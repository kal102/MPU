
// TODO: MMU controller operations list
// 1. Wait for multiply signal
// 2. Read input matrices dimensions
// 3. Check if dimensions are compatible ? Calculate output matrix dimensions : Assert dimensions error signal
// 4. Set bias
// 5. Load matrices from input buffers, perform multiplication
// 6. Shift result matrix out of MMU
// 7. Perform activation or pooling if necessary
// 8. Put data in fifo

module mmu_controller #(parameter ACC_SIZE = 24, parameter MMU_SIZE = 10)
(
  input wire clk,
  input wire rst_n,
  /* Rx signals */
  input wire load,
  input wire buffer_a_b,
  input wire multiply,
  input wire signed [(ACC_SIZE-1):0] bias_in,
  input wire [7:0] activation_in,
  input wire [7:0] pooling_in,
  output reg mpu_ready,
  /* Input buffers signals */
  output reg [1:0] buffer_a_cmd,
  output reg [1:0] buffer_b_cmd,
  input wire [7:0] dim_x_a,
  input wire [7:0] dim_y_a,
  input wire [7:0] dim_x_b,
  input wire [7:0] dim_y_b,  
  /* MMU signals */
  output wire shift,
  output reg clear,
  /* Activation/Pooling signals */
  output wire signed [(ACC_SIZE-1):0] bias_ctrl,
  output wire [1:0] activation_ctrl,
  output wire       padding_ctrl,
  output wire [1:0] pooling_ctrl,
  output wire [7:0]  dim_x_ctrl,
  output wire [7:0]  dim_y_ctrl,
  /* FIFO signals */
  input wire fifo_almst_full,
  output wire fifo_wr,
  output reg [7:0] dim_x_fifo,
  output reg [7:0] dim_y_fifo, 
  output reg fifo_dim_wr,
  /* Tx signals */
  output reg dim_error
  );

  localparam [1:0] STATE_IDLE = 2'b00;
  localparam [1:0] STATE_PREP = 2'b01;
  localparam [1:0] STATE_SIGNAL_GEN = 2'b11;
  localparam [1:0] STATE_WAIT = 2'b10;

  localparam BUFFER_A = 1'b0;
  localparam BUFFER_B = 1'b1;
  localparam [1:0] BUFFER_NONE = 2'b00;
  localparam [1:0] BUFFER_LOAD = 2'b01;
  localparam [1:0] BUFFER_SEND = 2'b10;
  localparam [1:0] BUFFER_CLEAR = 2'b11;

  localparam [1:0] ACTIVATION_NONE = 2'b00;
  localparam [1:0] ACTIVATION_RELU = 2'b01;

  localparam [1:0] POOLING_NONE = 2'b00;
  localparam [1:0] POOLING_MAX = 2'b01;

  reg [1:0] state, state_nxt;
  reg [15:0] cycle_counter, cycle_counter_nxt;

  reg shift_gen, shift_nxt;
  reg clear_nxt;
	reg signed [(ACC_SIZE-1):0] bias_gen, bias_nxt;
  reg [1:0] activation_gen, activation_nxt;
  reg padding_gen, padding_nxt;
	reg [1:0] pooling_gen, pooling_nxt;
  reg fifo_wr_gen, fifo_wr_nxt;
  reg fifo_dim_wr_nxt;
  reg mpu_ready_nxt, dim_error_nxt;

  reg [1:0] buffer_a_cmd_nxt, buffer_b_cmd_nxt;
  reg [7:0] dim_x_gen, dim_x_nxt;
  reg [7:0] dim_y_gen, dim_y_nxt;
  reg [7:0] dim_x_fifo_nxt, dim_y_fifo_nxt;

  /* TODO: This delays should depend on matrix size for better throughput */
  delay #(.DELAY(3*MMU_SIZE+2), .WIDTH(ACC_SIZE)) m_delay_bias (.out(bias_ctrl), .in(bias_gen), .clk(clk), .rst_n(rst_n));
  delay #(.DELAY(2*MMU_SIZE+3), .WIDTH(1)) m_delay_shift (.out(shift), .in(shift_gen), .clk(clk), .rst_n(rst_n));
	delay #(.DELAY(3*MMU_SIZE+2), .WIDTH(2)) m_delay_activation (.out(activation_ctrl), .in(activation_gen), .clk(clk), .rst_n(rst_n));
  delay #(.DELAY(3*MMU_SIZE+3), .WIDTH(1)) m_delay_padding (.out(padding_ctrl), .in(padding_gen), .clk(clk), .rst_n(rst_n));
	delay #(.DELAY(3*MMU_SIZE+5), .WIDTH(2)) m_delay_pooling (.out(pooling_ctrl), .in(pooling_gen), .clk(clk), .rst_n(rst_n));
  delay #(.DELAY(2*MMU_SIZE+3), .WIDTH(8)) m_delay_dim_x (.out(dim_x_ctrl), .in(dim_x_gen), .clk(clk), .rst_n(rst_n));
  delay #(.DELAY(2*MMU_SIZE+3), .WIDTH(8)) m_delay_dim_y (.out(dim_y_ctrl), .in(dim_y_gen), .clk(clk), .rst_n(rst_n));
  delay #(.DELAY(3*MMU_SIZE+6), .WIDTH(1)) m_delay_fifo_wr (.out(fifo_wr), .in(fifo_wr_gen), .clk(clk), .rst_n(rst_n));

  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      cycle_counter <= 0;
      shift_gen <= 1'b0;
      clear <= 1'b0;
      dim_x_gen <= 0;
      dim_y_gen <= 0;
	    bias_gen <= 0;
      activation_gen <= ACTIVATION_NONE;
      padding_gen <= 1'b0;
      pooling_gen <= POOLING_NONE;
      fifo_wr_gen <= 1'b0;
      dim_x_fifo <= 0;
      dim_y_fifo <= 0;
      fifo_dim_wr <= 1'b0;
      mpu_ready <= 1'b1;
      buffer_a_cmd <= BUFFER_NONE;
      buffer_b_cmd <= BUFFER_NONE;
      dim_error <= 1'b0;
    end
    else begin
      state <= state_nxt;
      cycle_counter <= cycle_counter_nxt;
      shift_gen <= shift_nxt;
      clear <= clear_nxt;
      dim_x_gen <= dim_x_nxt;
      dim_y_gen <= dim_y_nxt;
	    bias_gen <= bias_nxt;
      activation_gen <= activation_nxt;
      padding_gen <= padding_nxt;
      pooling_gen <= pooling_nxt;
      fifo_wr_gen <= fifo_wr_nxt;
      dim_x_fifo <= dim_x_fifo_nxt;
      dim_y_fifo <= dim_y_fifo_nxt;
      fifo_dim_wr <= fifo_dim_wr_nxt;
      mpu_ready <= mpu_ready_nxt;
      buffer_a_cmd <= buffer_a_cmd_nxt;
      buffer_b_cmd <= buffer_b_cmd_nxt;
      dim_error <= dim_error_nxt;
    end
  end

  always @* begin
	  mpu_ready_nxt = mpu_ready;
    shift_nxt = 1'b0;
    clear_nxt = 1'b0;
    dim_x_nxt = dim_x_gen;
    dim_y_nxt = dim_y_gen;
	  bias_nxt = bias_gen;
    activation_nxt = ACTIVATION_NONE;
    padding_nxt = 1'b0;
    pooling_nxt = POOLING_NONE;
    fifo_wr_nxt = 1'b0;
    dim_x_fifo_nxt = dim_x_fifo;
    dim_y_fifo_nxt = dim_y_fifo;
    fifo_dim_wr_nxt = 1'b0;
    buffer_a_cmd_nxt = BUFFER_NONE;
    buffer_b_cmd_nxt = BUFFER_NONE;
    dim_error_nxt = 1'b0;
    case (state)
      STATE_IDLE: begin
        if (load) begin
          state_nxt = STATE_IDLE;
          cycle_counter_nxt = 0;
          mpu_ready_nxt = 1'b1;
          if (buffer_a_b == BUFFER_A)
            buffer_a_cmd_nxt = BUFFER_LOAD;
          else
            buffer_b_cmd_nxt = BUFFER_LOAD;
        end
        else if (multiply) begin
          state_nxt = STATE_PREP;
          cycle_counter_nxt = 0;
          mpu_ready_nxt = 1'b0;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter;
          mpu_ready_nxt = 1'b1;
        end
      end
      STATE_PREP: begin
        if ((dim_y_a == dim_x_b) && (dim_x_a > 0) && (dim_y_a > 0) && (dim_y_b > 0)) begin
          if (!fifo_almst_full) begin
            state_nxt = STATE_SIGNAL_GEN;
            cycle_counter_nxt = 0;
            mpu_ready_nxt = 1'b0;
            shift_nxt = 1'b1;
            activation_nxt = activation_in;
            padding_nxt = 1'b1;
            pooling_nxt = pooling_in;
            dim_x_nxt = dim_x_a;
            dim_y_nxt = dim_y_b;
            fifo_wr_nxt = (pooling_nxt && dim_x_a == MMU_SIZE && dim_x_a[0] == 1'b1) ? 1'b1 : 1'b0;
            dim_x_fifo_nxt = pooling_nxt ? ((dim_x_a >> 1) + dim_x_a[0]) : dim_x_a;
            dim_y_fifo_nxt = pooling_nxt ? ((dim_y_b >> 1) + dim_y_b[0]) : dim_y_b;
            fifo_dim_wr_nxt = 1'b1;
  	        bias_nxt = bias_in;
            clear_nxt = !shift;
            buffer_a_cmd_nxt = BUFFER_SEND;
            buffer_b_cmd_nxt = BUFFER_SEND;
          end
          else begin
            state_nxt = state;
            cycle_counter_nxt = 0;
            mpu_ready_nxt = 1'b0;        
          end
        end
        else begin
          state_nxt = STATE_IDLE;
          cycle_counter_nxt = 0;
          mpu_ready_nxt = 1'b1;
          dim_error_nxt = 1'b1;
        end
      end
      STATE_SIGNAL_GEN: begin
        if (cycle_counter == MMU_SIZE) begin
          state_nxt = STATE_WAIT;
          cycle_counter_nxt = cycle_counter + 1;
          mpu_ready_nxt = 1'b1;
          shift_nxt = 1'b0;
          activation_nxt = 2'b0;
          padding_nxt = 1'b0;
          pooling_nxt = 2'b0;
          fifo_wr_nxt = 1'b0;
        end
        else if (cycle_counter == (MMU_SIZE - 1)) begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter + 1;
          mpu_ready_nxt = 1'b0;
          shift_nxt = 1'b0;
          activation_nxt = 2'b0;
          padding_nxt = 1'b0;
          pooling_nxt = pooling_gen;
          fifo_wr_nxt = pooling_gen ? (!fifo_wr_gen) : 1'b1;
        end
        else if ((pooling_gen & dim_x_gen[0] == 1'b1 & cycle_counter >= (MMU_SIZE - dim_x_gen - 1))
          || (cycle_counter >= (MMU_SIZE - dim_x_gen))) begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter + 1;
          mpu_ready_nxt = 1'b0;
          shift_nxt = 1'b1;
          activation_nxt = activation_gen;
          padding_nxt = padding_gen;
          pooling_nxt = pooling_gen;
          fifo_wr_nxt = pooling_gen ? (!fifo_wr_gen) : 1'b1;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter + 1;
          mpu_ready_nxt = 1'b0;
          shift_nxt = 1'b1;
          activation_nxt = activation_gen;
          padding_nxt = padding_gen;
          pooling_nxt = pooling_gen;
          fifo_wr_nxt = 1'b0;
        end
      end
      STATE_WAIT: begin
        if (load) begin
          state_nxt = STATE_WAIT;
          cycle_counter_nxt = 0;
          mpu_ready_nxt = 1'b1;
          if (buffer_a_b == BUFFER_A)
            buffer_a_cmd_nxt = BUFFER_LOAD;
          else
            buffer_b_cmd_nxt = BUFFER_LOAD;
        end
        else if (shift) begin
          state_nxt = mpu_ready ? STATE_IDLE : STATE_PREP;
          cycle_counter_nxt = 0;
          mpu_ready_nxt = mpu_ready;
        end
        else begin
          state_nxt = state;
          cycle_counter_nxt = cycle_counter + 1;
          mpu_ready_nxt = multiply ? 1'b0 : mpu_ready;
        end
      end
    endcase
  end

endmodule
