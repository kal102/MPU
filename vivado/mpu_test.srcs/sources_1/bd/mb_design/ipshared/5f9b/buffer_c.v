
module buffer_c #(parameter ACC_SIZE = 32, parameter MMU_SIZE = 4)
(
  output wire signed [(ACC_SIZE-1):0] B,
  input wire signed [(ACC_SIZE*MMU_SIZE-1):0] A1,
  input wire clk,
  input wire rst_n,
  input wire stop,
  input wire [1:0] cmd,
  input wire [7:0] dim_x_in,
  input wire [7:0] dim_y_in,
  output wire [7:0] dim_x,
  output wire [7:0] dim_y
);

  localparam STATE_IDLE = 2'b00;
  localparam STATE_LOAD = 2'b01;
  localparam STATE_SEND = 2'b10;
  localparam STATE_CLEAR = 2'b11;

  localparam CMD_NONE = 2'b00;
  localparam CMD_LOAD = 2'b01;
  localparam CMD_SEND = 2'b10;
  localparam CMD_CLEAR = 2'b11;

  reg signed [(ACC_SIZE-1):0] B2 [0:(MMU_SIZE-1)];
  wire signed [(ACC_SIZE*MMU_SIZE-1):0] B1;
  integer a, b;

  reg [1:0] state, state_nxt;
  reg [7:0] column_pointer, column_pointer_nxt;
  reg [7:0] row_pointer, row_pointer_nxt;
  reg write;
  
  reg [7:0] column_pointer_last;

  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      column_pointer <= 0;
      row_pointer <= 0;
      column_pointer_last <= 0;
    end
    else begin
      state <= state_nxt;
      column_pointer <= stop ? column_pointer : column_pointer_nxt;
      row_pointer <= row_pointer_nxt;
      column_pointer_last <= column_pointer;
    end
  end

  always @* begin
    case (state)
      STATE_IDLE: begin
        state_nxt = stop ? state : cmd;
        column_pointer_nxt = 0;
        if (cmd == CMD_LOAD)
          row_pointer_nxt = dim_x_in ? (dim_x_in - 1) : 0;
        else
          row_pointer_nxt = 0;
      end
      STATE_LOAD: begin
        if (row_pointer == 0) begin
          state_nxt = STATE_IDLE;
          column_pointer_nxt = 0;
          row_pointer_nxt = 0;
        end
        else begin
          state_nxt = state;
          column_pointer_nxt = 0;
          row_pointer_nxt = row_pointer - 1;
        end
      end
      STATE_SEND: begin
        if (stop) begin
          state_nxt = (cmd == CMD_CLEAR) ? STATE_CLEAR : state;
          row_pointer_nxt = row_pointer;
          column_pointer_nxt = column_pointer;
        end
        else begin
          if (row_pointer >= (dim_x - 1) && column_pointer >= (dim_y - 1)) begin
            state_nxt = STATE_IDLE;
            row_pointer_nxt = 0;
            column_pointer_nxt = 0;
          end
          else if (row_pointer >= (dim_x - 1)) begin
            state_nxt = state;
            row_pointer_nxt = 0;
            column_pointer_nxt = column_pointer + 1;
          end
          else begin
            state_nxt = state;
            row_pointer_nxt = row_pointer + 1;
            column_pointer_nxt = column_pointer;
          end
        end
      end
      STATE_CLEAR: begin
        state_nxt = STATE_IDLE;
        column_pointer_nxt = 0;
        row_pointer_nxt = 0;
      end
    endcase
  end

  always @* begin
    case(state)
      STATE_IDLE:  write = 1'b0;
      STATE_LOAD:  write = 1'b1;
      STATE_SEND:  write = 1'b0;
      STATE_CLEAR: write = 1'b1;
    endcase
  end


  wire signed [(ACC_SIZE*MMU_SIZE-1):0] buffer0_B1;
  wire signed [(ACC_SIZE*MMU_SIZE-1):0] buffer0_A1;
  wire buffer0_write;
  
  mem_2to2 #(.VAR_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer0
  (
    .B1(buffer0_B1),
    .A1(buffer0_A1),
    .address(row_pointer),
    .write(buffer0_write),
    .clk(clk)
    );
  
  assign buffer0_A1 = (state != STATE_CLEAR) ? A1 : 0;
  assign buffer0_write = write;
  
  
  assign B1 = buffer0_B1;
  assign B = B2[column_pointer_last];


  reg [7:0] buffer0_dim_x, buffer0_dim_x_nxt, buffer0_dim_y, buffer0_dim_y_nxt;

  always @(posedge clk) begin
    if (!rst_n) begin
      buffer0_dim_x <= 0;
      buffer0_dim_y <= 0;
    end
    else begin
      buffer0_dim_x <= buffer0_dim_x_nxt;
      buffer0_dim_y <= buffer0_dim_y_nxt;
    end
  end

  always @* begin
    buffer0_dim_x_nxt = buffer0_dim_x;
    buffer0_dim_y_nxt = buffer0_dim_y;
    if (state == STATE_IDLE) begin
      if (state_nxt == STATE_LOAD) begin
        buffer0_dim_x_nxt = dim_x_in;
        buffer0_dim_y_nxt = dim_y_in;
      end
      else if (state_nxt == STATE_CLEAR) begin
        buffer0_dim_x_nxt = 0;
        buffer0_dim_y_nxt = 0;
      end
    end
  end

  assign dim_x = buffer0_dim_x;
  assign dim_y = buffer0_dim_y;


  /* Convert 1D input array to 2D */
  always @(*) begin
    b = 0;
    for (a = 0; a < MMU_SIZE; a = a + 1) begin
      B2[a] = B1[(b * ACC_SIZE)+:ACC_SIZE];
      b = b + 1;
    end
  end

endmodule
