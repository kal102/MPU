
module buffer_b_10x #(parameter VAR_SIZE = 8, parameter MMU_SIZE = 10)
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
        state_nxt = stop ? state : cmd;
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
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer4_B1;
  wire signed [(VAR_SIZE-1):0] buffer4_A;
  wire [(MMU_SIZE-1):0] buffer4_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer4
  (
    .B1(buffer4_B1),
    .A(buffer4_A),
    .address(row_pointer),
    .write(buffer4_write),
    .clk(clk)
    );
  
  assign buffer4_A = (buffer_pointer == 4 && state != STATE_CLEAR) ? A : 0;
  assign buffer4_write = (buffer_pointer == 4) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer5_B1;
  wire signed [(VAR_SIZE-1):0] buffer5_A;
  wire [(MMU_SIZE-1):0] buffer5_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer5
  (
    .B1(buffer5_B1),
    .A(buffer5_A),
    .address(row_pointer),
    .write(buffer5_write),
    .clk(clk)
    );
  
  assign buffer5_A = (buffer_pointer == 5 && state != STATE_CLEAR) ? A : 0;
  assign buffer5_write = (buffer_pointer == 5) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer6_B1;
  wire signed [(VAR_SIZE-1):0] buffer6_A;
  wire [(MMU_SIZE-1):0] buffer6_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer6
  (
    .B1(buffer6_B1),
    .A(buffer6_A),
    .address(row_pointer),
    .write(buffer6_write),
    .clk(clk)
    );
  
  assign buffer6_A = (buffer_pointer == 6 && state != STATE_CLEAR) ? A : 0;
  assign buffer6_write = (buffer_pointer == 6) ? write : 0;


  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer7_B1;
  wire signed [(VAR_SIZE-1):0] buffer7_A;
  wire [(MMU_SIZE-1):0] buffer7_write;

  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer7
  (
    .B1(buffer7_B1),
    .A(buffer7_A),
    .address(row_pointer),
    .write(buffer7_write),
    .clk(clk)
    );
  
  assign buffer7_A = (buffer_pointer == 7 && state != STATE_CLEAR) ? A : 0;
  assign buffer7_write = (buffer_pointer == 7) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer8_B1;
  wire signed [(VAR_SIZE-1):0] buffer8_A;
  wire [(MMU_SIZE-1):0] buffer8_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer8
  (
    .B1(buffer8_B1),
    .A(buffer8_A),
    .address(row_pointer),
    .write(buffer8_write),
    .clk(clk)
    );
  
  assign buffer8_A = (buffer_pointer == 8 && state != STATE_CLEAR) ? A : 0;
  assign buffer8_write = (buffer_pointer == 8) ? write : 0;
  
  
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] buffer9_B1;
  wire signed [(VAR_SIZE-1):0] buffer9_A;
  wire [(MMU_SIZE-1):0] buffer9_write;
  
  mem_1to2 #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer9
  (
    .B1(buffer9_B1),
    .A(buffer9_A),
    .address(row_pointer),
    .write(buffer9_write),
    .clk(clk)
    );

  assign buffer9_A = (buffer_pointer == 9 && state != STATE_CLEAR) ? A : 0;
  assign buffer9_write = (buffer_pointer == 9) ? write : 0;
  
  
  always @* begin
    if (state == STATE_SEND) begin
      case (buffer_pointer)
        0: B1 = buffer0_B1;
        1: B1 = buffer1_B1;
        2: B1 = buffer2_B1;
        3: B1 = buffer3_B1;
        4: B1 = buffer4_B1;
        5: B1 = buffer5_B1;
        6: B1 = buffer6_B1;
        7: B1 = buffer7_B1;
        8: B1 = buffer8_B1;
        9: B1 = buffer9_B1;
        default: B1 = 0;
      endcase
    end
    else B1 = 0;
  end
  

  reg [7:0] buffer0_dim_x, buffer0_dim_x_nxt, buffer0_dim_y, buffer0_dim_y_nxt;
  reg [7:0] buffer1_dim_x, buffer1_dim_x_nxt, buffer1_dim_y, buffer1_dim_y_nxt;
  reg [7:0] buffer2_dim_x, buffer2_dim_x_nxt, buffer2_dim_y, buffer2_dim_y_nxt;
  reg [7:0] buffer3_dim_x, buffer3_dim_x_nxt, buffer3_dim_y, buffer3_dim_y_nxt;
  reg [7:0] buffer4_dim_x, buffer4_dim_x_nxt, buffer4_dim_y, buffer4_dim_y_nxt;
  reg [7:0] buffer5_dim_x, buffer5_dim_x_nxt, buffer5_dim_y, buffer5_dim_y_nxt;
  reg [7:0] buffer6_dim_x, buffer6_dim_x_nxt, buffer6_dim_y, buffer6_dim_y_nxt;
  reg [7:0] buffer7_dim_x, buffer7_dim_x_nxt, buffer7_dim_y, buffer7_dim_y_nxt;
  reg [7:0] buffer8_dim_x, buffer8_dim_x_nxt, buffer8_dim_y, buffer8_dim_y_nxt;
  reg [7:0] buffer9_dim_x, buffer9_dim_x_nxt, buffer9_dim_y, buffer9_dim_y_nxt;
  
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
      buffer4_dim_x <= 0;
      buffer4_dim_y <= 0;
      buffer5_dim_x <= 0;
      buffer5_dim_y <= 0;
      buffer6_dim_x <= 0;
      buffer6_dim_y <= 0;
      buffer7_dim_x <= 0;
      buffer7_dim_y <= 0;
      buffer8_dim_x <= 0;
      buffer8_dim_y <= 0;
      buffer9_dim_x <= 0;
      buffer9_dim_y <= 0;
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
      buffer4_dim_x <= buffer4_dim_x_nxt;
      buffer4_dim_y <= buffer4_dim_y_nxt;
      buffer5_dim_x <= buffer5_dim_x_nxt;
      buffer5_dim_y <= buffer5_dim_y_nxt;
      buffer6_dim_x <= buffer6_dim_x_nxt;
      buffer6_dim_y <= buffer6_dim_y_nxt;
      buffer7_dim_x <= buffer7_dim_x_nxt;
      buffer7_dim_y <= buffer7_dim_y_nxt;
      buffer8_dim_x <= buffer8_dim_x_nxt;
      buffer8_dim_y <= buffer8_dim_y_nxt;
      buffer9_dim_x <= buffer9_dim_x_nxt;
      buffer9_dim_y <= buffer9_dim_y_nxt;     
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
    buffer4_dim_x_nxt = buffer4_dim_x;
    buffer4_dim_y_nxt = buffer4_dim_y;
    buffer5_dim_x_nxt = buffer5_dim_x;
    buffer5_dim_y_nxt = buffer5_dim_y;
    buffer6_dim_x_nxt = buffer6_dim_x;
    buffer6_dim_y_nxt = buffer6_dim_y;
    buffer7_dim_x_nxt = buffer7_dim_x;
    buffer7_dim_y_nxt = buffer7_dim_y;
    buffer8_dim_x_nxt = buffer8_dim_x;
    buffer8_dim_y_nxt = buffer8_dim_y;
    buffer9_dim_x_nxt = buffer9_dim_x;
    buffer9_dim_y_nxt = buffer9_dim_y; 
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
          4: begin
            buffer4_dim_x_nxt = dim_x_in; 
            buffer4_dim_y_nxt = dim_y_in;             
          end
          5: begin
            buffer5_dim_x_nxt = dim_x_in; 
            buffer5_dim_y_nxt = dim_y_in;             
          end
          6: begin
            buffer6_dim_x_nxt = dim_x_in; 
            buffer6_dim_y_nxt = dim_y_in;             
          end
          7: begin
            buffer7_dim_x_nxt = dim_x_in; 
            buffer7_dim_y_nxt = dim_y_in;             
          end
          8: begin
            buffer8_dim_x_nxt = dim_x_in; 
            buffer8_dim_y_nxt = dim_y_in;             
          end
          9: begin
            buffer9_dim_x_nxt = dim_x_in; 
            buffer9_dim_y_nxt = dim_y_in;             
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
          4: begin
            buffer4_dim_x_nxt = 0;
            buffer4_dim_y_nxt = 0;            
          end
          5: begin
            buffer5_dim_x_nxt = 0;
            buffer5_dim_y_nxt = 0;            
          end
          6: begin
            buffer6_dim_x_nxt = 0;
            buffer6_dim_y_nxt = 0;            
          end
          7: begin
            buffer7_dim_x_nxt = 0;
            buffer7_dim_y_nxt = 0;            
          end
          8: begin
            buffer8_dim_x_nxt = 0;
            buffer8_dim_y_nxt = 0;            
          end
          9: begin
            buffer9_dim_x_nxt = 0;
            buffer9_dim_y_nxt = 0;            
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

  always @(*) begin
    case (buffer)
      0: begin
        dim_x <= buffer0_dim_x;
        dim_y <= buffer0_dim_y;
      end
      1: begin
        dim_x <= buffer1_dim_x;
        dim_y <= buffer1_dim_y;
      end
      2: begin
        dim_x <= buffer2_dim_x;
        dim_y <= buffer2_dim_y;
      end
      3: begin
        dim_x <= buffer3_dim_x;
        dim_y <= buffer3_dim_y;
      end
      4: begin
        dim_x <= buffer4_dim_x;
        dim_y <= buffer4_dim_y;
      end
      5: begin
        dim_x <= buffer5_dim_x;
        dim_y <= buffer5_dim_y;
      end
      6: begin
        dim_x <= buffer6_dim_x;
        dim_y <= buffer6_dim_y;
      end
      7: begin
        dim_x <= buffer7_dim_x;
        dim_y <= buffer7_dim_y;
      end
      8: begin
        dim_x <= buffer8_dim_x;
        dim_y <= buffer8_dim_y;
      end
      9: begin
        dim_x <= buffer9_dim_x;
        dim_y <= buffer9_dim_y;
      end
    endcase
  end

endmodule
