
module buffer_b_4x #(parameter VAR_SIZE = 8, parameter MMU_SIZE = 10)
(
  output reg signed [(VAR_SIZE*MMU_SIZE-1):0] B1,
  input wire signed [(VAR_SIZE-1):0] A,
  input wire clk,
  input wire rst_n,
  input wire stop,
  input wire [1:0] cmd,
  input wire [4:0] buffer,
  input wire [7:0] dim_x_in,
  input wire [7:0] dim_y_in,
  output reg [7:0] dim_x_out,
  output reg [7:0] dim_y_out
);

  localparam STATE_IDLE = 2'b00;
  localparam STATE_LOAD = 2'b01;
  localparam STATE_SEND = 2'b10;
  localparam STATE_CLEAR = 2'b11;
  
  localparam CMD_NONE = 2'b00;
  localparam CMD_LOAD = 2'b01;
  localparam CMD_SEND = 2'b10;
  localparam CMD_CLEAR = 2'b11;

  reg [1:0] state, state_nxt;
  reg [3:0] buffer_pointer, buffer_pointer_nxt;
  reg [7:0] row_pointer, row_pointer_nxt;
  reg [7:0] column_pointer, column_pointer_nxt;
  reg [(MMU_SIZE-1):0] write;
  reg [7:0] dim_x;
  reg [7:0] dim_y;

  always @(posedge clk) begin
    if (!rst_n) begin
      state <= STATE_IDLE;
      buffer_pointer <= 0;
      row_pointer <= 0;
      column_pointer <= 0;
    end
    else if (stop) begin
      state <= (cmd == CMD_CLEAR) ? STATE_CLEAR : state_nxt;
      buffer_pointer <= buffer_pointer_nxt;
      row_pointer <= row_pointer;
      column_pointer <= column_pointer;
    end
    else begin
      state <= state_nxt;
      buffer_pointer <= buffer_pointer_nxt;
      row_pointer <= row_pointer_nxt;
      column_pointer <= column_pointer_nxt;
    end
  end

  always @* begin
    case (state)
      STATE_IDLE: begin
        state_nxt = cmd;
        if (cmd == CMD_NONE)
          buffer_pointer_nxt = buffer_pointer;
        else
          buffer_pointer_nxt = buffer;
        row_pointer_nxt = (state_nxt == STATE_SEND) ? 1 : 0;
        column_pointer_nxt = 0;
      end
      STATE_LOAD: begin
        if (row_pointer >= (dim_x - 1) && column_pointer >= (dim_y - 1)) begin
          state_nxt = STATE_IDLE;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = 0;
          column_pointer_nxt = 0;
        end
        else if (row_pointer >= (dim_x - 1)) begin
          state_nxt = state;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = 0;
          column_pointer_nxt = column_pointer + 1;
        end
        else begin
          state_nxt = state;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = row_pointer + 1;
          column_pointer_nxt = column_pointer;          
        end
      end
      STATE_SEND: begin
        if (row_pointer >= dim_x) begin
          state_nxt = STATE_IDLE;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = 0;
          column_pointer_nxt = column_pointer;
        end
        else begin
          state_nxt = state;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = row_pointer + 1;
          column_pointer_nxt = column_pointer;
        end
      end
      STATE_CLEAR: begin
        if (row_pointer >= (MMU_SIZE - 1)) begin
          state_nxt = STATE_IDLE;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = 0;
          column_pointer_nxt = column_pointer;
        end
        else begin
          state_nxt = state;
          buffer_pointer_nxt = buffer_pointer;
          row_pointer_nxt = row_pointer + 1;
          column_pointer_nxt = column_pointer;
        end
      end
    endcase
  end
  
  always @* begin
    case(state)
      STATE_IDLE:  write = 0;
      STATE_LOAD:  write = stop ? 0 : (1 << column_pointer);
      STATE_SEND:  write = 0;
      STATE_CLEAR: write = -1;
    endcase
  end
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer0_B1;
  wire signed [(VAR_SIZE-1):0] buffer0_A;
  wire [(MMU_SIZE-1):0] buffer0_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer0
  (
    .B1(buffer0_B1),
    .A(buffer0_A),
    .address(row_pointer),
    .write(buffer0_write),
    .clk(clk)
    );
  
  assign buffer0_A = (buffer_pointer == 0 && state != STATE_CLEAR) ? A : 0;
  assign buffer0_write = (buffer_pointer == 0) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer1_B1;
  wire signed [(VAR_SIZE-1):0] buffer1_A;
  wire [(MMU_SIZE-1):0] buffer1_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer1
  (
    .B1(buffer1_B1),
    .A(buffer1_A),
    .address(row_pointer),
    .write(buffer1_write),
    .clk(clk)
    );
  
  assign buffer1_A = (buffer_pointer == 1 && state != STATE_CLEAR) ? A : 0;
  assign buffer1_write = (buffer_pointer == 1) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer2_B1;
  wire signed [(VAR_SIZE-1):0] buffer2_A;
  wire [(MMU_SIZE-1):0] buffer2_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer2
  (
    .B1(buffer2_B1),
    .A(buffer2_A),
    .address(row_pointer),
    .write(buffer2_write),
    .clk(clk)
    );
  
  assign buffer2_A = (buffer_pointer == 2 && state != STATE_CLEAR) ? A : 0;
  assign buffer2_write = (buffer_pointer == 2) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer3_B1;
  wire signed [(VAR_SIZE-1):0] buffer3_A;
  wire [(MMU_SIZE-1):0] buffer3_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer3
  (
    .B1(buffer3_B1),
    .A(buffer3_A),
    .address(row_pointer),
    .write(buffer3_write),
    .clk(clk)
    );
  
  assign buffer3_A = (buffer_pointer == 3 && state != STATE_CLEAR) ? A : 0;
  assign buffer3_write = (buffer_pointer == 3) ? write : 0;
  
  
  always @* begin
    if (state == STATE_SEND) begin
      case (buffer_pointer)
        0: B1 = buffer0_B1;
        1: B1 = buffer1_B1;
        2: B1 = buffer2_B1;
        3: B1 = buffer3_B1;
        default: B1 = 0;
      endcase
    end
    else B1 = 0;
  end
  

  reg [7:0] buffer0_dim_x, buffer0_dim_x_nxt, buffer0_dim_y, buffer0_dim_y_nxt;
  reg [7:0] buffer1_dim_x, buffer1_dim_x_nxt, buffer1_dim_y, buffer1_dim_y_nxt;
  reg [7:0] buffer2_dim_x, buffer2_dim_x_nxt, buffer2_dim_y, buffer2_dim_y_nxt;
  reg [7:0] buffer3_dim_x, buffer3_dim_x_nxt, buffer3_dim_y, buffer3_dim_y_nxt;
  
  always @(posedge clk) begin
    if (!rst_n) begin
      buffer0_dim_x <= 0;
      buffer0_dim_y <= 0;
      buffer1_dim_x <= 0;
      buffer1_dim_y <= 0;
      buffer2_dim_x <= 0;
      buffer2_dim_y <= 0;
      buffer3_dim_x <= 0;
      buffer3_dim_y <= 0;
    end
    else begin
      buffer0_dim_x <= buffer0_dim_x_nxt;
      buffer0_dim_y <= buffer0_dim_y_nxt;
      buffer1_dim_x <= buffer1_dim_x_nxt;
      buffer1_dim_y <= buffer1_dim_y_nxt;
      buffer2_dim_x <= buffer2_dim_x_nxt;
      buffer2_dim_y <= buffer2_dim_y_nxt;
      buffer3_dim_x <= buffer3_dim_x_nxt;
      buffer3_dim_y <= buffer3_dim_y_nxt;    
    end
  end

  always @* begin
    buffer0_dim_x_nxt = buffer0_dim_x;
    buffer0_dim_y_nxt = buffer0_dim_y;
    buffer1_dim_x_nxt = buffer1_dim_x;
    buffer1_dim_y_nxt = buffer1_dim_y;
    buffer2_dim_x_nxt = buffer2_dim_x;
    buffer2_dim_y_nxt = buffer2_dim_y;
    buffer3_dim_x_nxt = buffer3_dim_x;
    buffer3_dim_y_nxt = buffer3_dim_y;
    if (state == STATE_IDLE) begin
      if (state_nxt == STATE_LOAD) begin
        case(buffer)
          0: begin
            buffer0_dim_x_nxt = dim_x_in;
            buffer0_dim_y_nxt = dim_y_in;
          end
          1: begin
            buffer1_dim_x_nxt = dim_x_in; 
            buffer1_dim_y_nxt = dim_y_in;             
          end
          2: begin
            buffer2_dim_x_nxt = dim_x_in; 
            buffer2_dim_y_nxt = dim_y_in;             
          end
          3: begin
            buffer3_dim_x_nxt = dim_x_in; 
            buffer3_dim_y_nxt = dim_y_in;            
          end
        endcase
      end
      else if (state_nxt == STATE_CLEAR) begin
        case(buffer)
          0: begin
            buffer0_dim_x_nxt = 0;
            buffer0_dim_y_nxt = 0;
          end
          1: begin
            buffer1_dim_x_nxt = 0;
            buffer1_dim_y_nxt = 0;            
          end
          2: begin
            buffer2_dim_x_nxt = 0;
            buffer2_dim_y_nxt = 0;            
          end
          3: begin
            buffer3_dim_x_nxt = 0;
            buffer3_dim_y_nxt = 0;            
          end
        endcase    
      end
    end
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      dim_x_out <= 0;
      dim_y_out <= 0;
    end
    else begin
      dim_x_out <= dim_x;
      dim_y_out <= dim_y;      
    end
  end

  always @* begin
    case (buffer)
      0: begin
        dim_x = buffer0_dim_x;
        dim_y = buffer0_dim_y;
      end
      1: begin
        dim_x = buffer1_dim_x;
        dim_y = buffer1_dim_y;
      end
      2: begin
        dim_x = buffer2_dim_x;
        dim_y = buffer2_dim_y;
      end
      3: begin
        dim_x = buffer3_dim_x;
        dim_y = buffer3_dim_y;
      end
    endcase
  end

endmodule
