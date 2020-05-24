
`timescale 1ns/100ps

`include "mpu_macros.svh"
`include "mpu_stream.svh"
`include "matrix.svh"

module top_tb;

  import mpu_macros_pkg::*;
  import mpu_stream_pkg::*;
  import matrix_pkg::*;

  localparam int ITER = 50;

  logic clk, rst_n;
  
  logic [31:0] axis_in_tdata;
  logic        axis_in_tvalid;
  logic        axis_in_tready;
  logic        axis_in_tlast;

  logic [31:0] axis_out_tdata;
  logic        axis_out_tvalid;
  logic        axis_out_tready;
  logic        axis_out_tlast;

  top #(.VAR_SIZE(8), .ACC_SIZE(24), .MMU_SIZE(10), .FIFO_SIZE(3)) m_top (
    .clk(clk),
    .rst_n(rst_n),
    /* Input AXI Stream */
    .axis_in_tdata(axis_in_tdata),
    .axis_in_tvalid(axis_in_tvalid),
    .axis_in_tready(axis_in_tready),
    .axis_in_tlast(axis_in_tlast), 
    /* Output AXI Stream */
    .axis_out_tdata(axis_out_tdata),
    .axis_out_tvalid(axis_out_tvalid),
    .axis_out_tready(axis_out_tready),
    .axis_out_tlast(axis_out_tlast)
    );

  int iter, passed;

  initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    axis_in_tdata = 32'h0;
    axis_in_tvalid = 1'b0;
    axis_in_tlast = 1'b0;
    axis_out_tready = 1'b1;
    @(posedge clk);
    rst_n = 1'b1;
    $display;
    passed = 0;
    for (iter = 1; iter <= ITER; iter++) begin
      $display("Iteration: %0d\n", iter);
      test_mpu();
    end
    $display("Passed: %0d/%0d (%0d%%)", passed, ITER, (passed * 100) / ITER);
    $display;
    $stop;
    $finish;
  end

  initial repeat (1000000000) clk = #1 !clk;
  

  task send(input mpu_stream stream);
    
    automatic int length;
    
    length = stream.get_nr_of_bytes();
    for(int i = 0; i < length; i++) begin
      while (axis_in_tready != 1'b1)
        @(posedge clk);
      axis_in_tdata = stream.get_byte();
      axis_in_tvalid = 1'b1;
      axis_in_tlast = (i == (length - 1)) ? 1'b1 : 1'b0;
      @(posedge clk);
    end
    axis_in_tdata = 32'b0;
    axis_in_tvalid = 1'b0;
    axis_in_tlast = 1'b0;
    
  endtask : send

  task receive(output mpu_stream stream);
   
    stream = new();
    while (!axis_out_tlast) begin
      if (axis_out_tvalid) begin
        stream.put_byte(axis_out_tdata[31:24]);
        stream.put_byte(axis_out_tdata[23:16]);
        stream.put_byte(axis_out_tdata[15:8]);
        stream.put_byte(axis_out_tdata[7:0]);
      end
      @(posedge clk);
    end
    stream.put_byte(axis_out_tdata[31:24]);
    stream.put_byte(axis_out_tdata[23:16]);
    stream.put_byte(axis_out_tdata[15:8]);
    stream.put_byte(axis_out_tdata[7:0]);

  endtask : receive

  function mpu_stream matrix_to_stream(matrix #(VAR_SIZE, MMU_SIZE, MMU_SIZE) mtx, logic [7:0] buffer_ab, logic[7:0] buffer_idx);

    automatic mpu_stream stream;
    automatic cmd_rx_t cmd;
    automatic data_t data;
    automatic int i, j;
    
    cmd.cmd = CMD_LOAD;
    cmd.buffer = buffer_ab;
    cmd.dim_x = mtx.x;
    cmd.dim_y = mtx.y;
    if (buffer_ab == BUFFER_A) begin
      cmd.buffer_a_idx = buffer_idx;
      cmd.buffer_b_idx = 0;
    end
    else begin
      cmd.buffer_a_idx = 0;
      cmd.buffer_b_idx = buffer_idx;
    end

    stream = new();
    stream.set_command(cmd);
    for (j = 0; j < mtx.y; j++) begin
      for (i = 0; i < mtx.x; i++) begin
        data.push_back(mtx.matrix[i][j]);
      end
    end
    stream.set_data(data);

    return stream;

  endfunction : matrix_to_stream

  function mpu_stream multiplication_stream(logic[7:0] buffer_a_idx, logic[7:0] buffer_b_idx, logic [31:0] bias = 0,
    logic [7:0] activation = 0, logic [7:0] pooling = 0);

    automatic mpu_stream stream;
    automatic cmd_rx_t cmd;
    
    cmd.cmd = CMD_MULTIPLY;
    cmd.buffer = 0;
    cmd.buffer_a_idx = buffer_a_idx;
    cmd.buffer_b_idx = buffer_b_idx;
    cmd.dim_x = 0;
    cmd.dim_y = 0;
    cmd.bias = bias;
    cmd.activation = activation;
    cmd.pooling = pooling;
    
    stream = new();
    stream.set_command(cmd);

    return stream;

  endfunction : multiplication_stream

 function matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) stream_to_matrix(mpu_stream stream);
    
    automatic matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) mtx;
    automatic cmd_tx_t cmd;
    automatic data_t data;
    automatic logic [31:0] nr;
    automatic int i, j;
    
    mtx = new("mtx");
    i = 0;
    j = 0;
    
    cmd = stream.get_command();
    if (cmd.error == STREAM_DATA) begin
      data = stream.get_data();
      while (data.size() > 0) begin
        nr[31:24] = data.pop_front();
        nr[23:16] = data.pop_front();
        nr[15:8] = data.pop_front();
        nr[7:0] = data.pop_front();
        mtx.matrix[i][j] = nr[(ACC_SIZE-1):0];
        if (i == (cmd.dim_x - 1) && j == (cmd.dim_y - 1)) begin
          i++;
          j++;
          break;
        end
        else if (i == (cmd.dim_x - 1)) begin
          i = 0;
          j++;
        end
        else begin
          i++;
        end
      end
    end
    else if (cmd.error == STREAM_ERR_DIM) begin
      $display("Dimensions error received!");
      $display;        
    end
    else if (cmd.error == STREAM_ERR_CMD) begin
      $display("Command error received!");
      $display;
    end
    else begin
      $display("Unrecognized stream received!");
      $display;
    end
    mtx.x = i;
    mtx.y = j;
    return mtx;
    
  endfunction : stream_to_matrix

  function matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) multiply_matrices(matrix #(VAR_SIZE, MMU_SIZE, MMU_SIZE) A,
    matrix #(VAR_SIZE, MMU_SIZE, MMU_SIZE) B, int bias, byte activation, byte pooling);
    
    automatic matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) C;
    automatic matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) C_pool;
    automatic int i, j, k;

    if (A.y != B.x) begin
      $display("Matrices are not aligned for multiplication. A.y = %d B.x = %d", A.y, B.x);
      C = new("C", 0, 0);
    end
    
    C = new("C", A.x, B.y);
    for (i = 0; i < C.x; i = i + 1) begin
      for (j = 0; j < C.y; j = j + 1) begin
        C.matrix[i][j] = bias;
        for (k = 0; k < B.x; k = k + 1) begin
            C.matrix[i][j] = C.matrix[i][j] + A.matrix[i][k] * B.matrix[k][j];
        end
        if (activation == ACTIVATION_RELU) begin
          C.matrix[i][j] = (C.matrix[i][j] >= 0) ? C.matrix[i][j] : 0;
        end
      end
    end
    
    /* Matrix copy with zero padding */
    if (pooling == POOLING_MAX) begin
      C_pool = new("C", C.x, C.y);
      C_pool.x = C_pool.x / 2 + C_pool.x % 2;
      C_pool.y = C_pool.y / 2 + C_pool.y % 2;
      for (i = 0; i < C_pool.x; i = i + 1) begin
        for (j = 0; j < C_pool.y; j = j + 1) begin
          C_pool.matrix[i][j] = C.matrix[2*i][2*j];
          C_pool.matrix[i][j] = (C.matrix[2*i+1][2*j] > C_pool.matrix[i][j]) ? C.matrix[2*i+1][2*j] : C_pool.matrix[i][j];
          C_pool.matrix[i][j] = (C.matrix[2*i+1][2*j+1] > C_pool.matrix[i][j]) ? C.matrix[2*i+1][2*j+1] : C_pool.matrix[i][j];
          C_pool.matrix[i][j] = (C.matrix[2*i][2*j+1] > C_pool.matrix[i][j]) ? C.matrix[2*i][2*j+1] : C_pool.matrix[i][j];
        end
      end
      return C_pool;
    end
        
    return C;
    
  endfunction : multiply_matrices

  task test_mpu();

    automatic mpu_stream stream;
    automatic matrix #(VAR_SIZE, MMU_SIZE, MMU_SIZE) A;
    automatic matrix #(VAR_SIZE, MMU_SIZE, MMU_SIZE) B;
    automatic matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) C_predicted;
    automatic matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) C_received;
    automatic int Ax, Ay, Bx, By;
    automatic int buffer_a, buffer_b;
    automatic int bias;
    automatic byte activation, pooling;
    
    buffer_a = $urandom_range(0, BUFFER_CNT-1);
    buffer_b = $urandom_range(0, BUFFER_CNT-1);
    bias = $urandom_range(18,0) - 9;
    activation = $urandom_range(ACTIVATION_NONE, ACTIVATION_RELU);
    pooling = $urandom_range(POOLING_NONE, POOLING_MAX);
    
    $display("buffer_a = %0d", buffer_a);
    $display("buffer_b = %0d", buffer_a);
    $display("bias = %0d", bias);
    $display("activation = %0x", activation);
    $display("pooling = %0x", pooling);    
    $display;
    
    Ax = $urandom_range(1, MATRIX_SIZE);
    Ay = $urandom_range(1, MATRIX_SIZE);
    Bx = Ay;
    By = $urandom_range(1, MATRIX_SIZE);
    
    A = new("A", Ax, Ay);
    A.initialize();
    A.print();
    B = new("B", Bx, By);
    B.initialize();
    B.print();
    
    stream = matrix_to_stream(A, BUFFER_A, buffer_a);
    send(stream);
    stream = matrix_to_stream(B, BUFFER_B, buffer_b);
    send(stream);
    @(posedge clk);
    stream = multiplication_stream(buffer_a, buffer_b, bias, activation, pooling);
    send(stream);
    @(posedge clk);
    
    C_predicted = multiply_matrices(A, B, bias, activation, pooling);
    C_predicted.name = "C_predicted";
    C_predicted.print();
    
    receive(stream);
    C_received = stream_to_matrix(stream);
    C_received.name = "C_received";
    
    if (C_received.x != 0 && C_received.y != 0) begin
      C_received.print();
      if (C_received.matrix === C_predicted.matrix) begin
        $display("Received matrices are equal!");
        passed++;
      end
      else begin
        $display("Whoops, it looks like something went wrong...");
      end
    end
    $display;
    $display("----------------------------------------------------\n");

  endtask : test_mpu

endmodule : top_tb

