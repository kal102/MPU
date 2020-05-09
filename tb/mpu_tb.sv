
`timescale 1ns/100ps

`include "mpu_macros.svh"
`include "mpu_frame.svh"
`include "matrix.svh"

module mpu_tb;

  import mpu_macros_pkg::*;
  import mpu_frame_pkg::*;
  import matrix_pkg::*;

  localparam int ITER = 50;

  typedef mpu_frame mpu_frames_t[$];

  logic clk, rst_n;

  logic [7:0] rx_data;
  logic       rx_valid;
  logic [5:0] rx_error;
  logic       rx_startofpacket;
  logic       rx_endofpacket;
  logic       rx_dsav;

  logic       buffer_ab_stop;
  logic [7:0] buffer_a_data;
  logic [7:0] buffer_b_data;
  logic [4:0] buffer_a_idx;
  logic [4:0] buffer_b_idx;
  logic [7:0] dim_x_in, dim_y_in;

  logic load;
  logic buffer_a_b;
  logic multiply;
  logic signed [23:0] bias;
  logic [7:0] activation, pooling;
  logic mpu_ready;

  logic [47:0] host_mac;
  logic [7:0] recv_error;

  eth_rx #(.MMU_SIZE(MMU_SIZE)) m_eth_rx (
    .clk(clk),
    .rst_n(rst_n),
    /* Input Avalon Stream */
    .data(rx_data),
    .valid(rx_valid),
    .ready(rx_ready),
    .error(rx_error),
    .startofpacket(rx_startofpacket),
    .endofpacket(rx_endofpacket),
    /* Other RX signals */
    .dsav(rx_dsav),
    .mod(),
    .frm_type(),
    .a_full(),
    .a_empty(),
    .err_stat(),
    /* Buffer signals */
    .buffer_stop(buffer_ab_stop),
    .buffer_a_data(buffer_a_data),
    .buffer_b_data(buffer_b_data),
    .buffer_a_idx(buffer_a_idx),
    .buffer_b_idx(buffer_b_idx),
    .dim_x(dim_x_in),
    .dim_y(dim_y_in),
    /* Controller signals */
    .load(load),
    .buffer_a_b(buffer_a_b),
    .multiply(multiply),
    .bias(bias),
    .activation(activation),
    .pooling(pooling),
    .mpu_ready(mpu_ready),
    /* Other signals */
    .host_mac(host_mac),
    .rx_error(recv_error)
    );

	logic buffer_c_stop;
  logic [ACC_SIZE-1:0] buffer_c_data;
  logic [7:0] dim_x_out, dim_y_out;

  logic dim_error, data_available, transmiter_ready;

  mpu #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE), .FIFO_SIZE(3)) m_mpu (
    .clk(clk),
    .rst_n(rst_n),
    /* Input buffers signals */
    .buffer_ab_stop(buffer_ab_stop),
    .buffer_a_data(buffer_a_data),
    .buffer_b_data(buffer_b_data),
    .buffer_a_idx(buffer_a_idx),
    .buffer_b_idx(buffer_b_idx),
    .dim_x_in(dim_x_in),
    .dim_y_in(dim_y_in),
    /* Controller signals */
    .load(load),
    .buffer_a_b(buffer_a_b),
    .multiply(multiply),
    .bias(bias),
    .activation(activation),
    .pooling(pooling),
    .mpu_ready(mpu_ready),
    .dim_error(dim_error),
    .data_available(data_available),
    .tx_ready(transmiter_ready),
    /* Output buffers signals */
    .buffer_c_stop(buffer_c_stop),
    .buffer_c_data(buffer_c_data),
    .dim_x_out(dim_x_out),
    .dim_y_out(dim_y_out)
    );

  logic [31:0] tx_data;
  logic        tx_valid;
  logic        tx_error;
  logic        tx_startofpacket;
  logic        tx_endofpacket;
  logic        tx_ready;

  eth_tx m_eth_tx (
    .clk(clk),
    .rst_n(rst_n),
    /* Output Avalon Stream */
    .data(tx_data),
    .startofpacket(tx_startofpacket),
    .endofpacket(tx_endofpacket),
    .ready(tx_ready),
    .wren(tx_valid),
    .error(tx_error),
    /* Other TX signals */
    .crc_fwd(),
    .mod(),
    .septy(1'b0),
    .uflow(1'b0),
    .a_full(1'b0),
    .a_empty(1'b0),
    /* Buffer signals */
    .buffer_c_stop(buffer_c_stop),
    .buffer_c_data(buffer_c_data),
    .dim_x(dim_x_out),
    .dim_y(dim_y_out),
    /* Other signals */
    .host_mac(host_mac),
    .rx_error(recv_error),
    .dim_error(dim_error),
    .data_available(data_available),
    .tx_ready(transmiter_ready)
    );


  int iter, passed;

  initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    rx_data = 8'h0;
    rx_valid = 1'b0;
    rx_error = 6'h0;
    rx_startofpacket = 1'b0;
    rx_endofpacket = 1'b0;
    rx_dsav = 1'b0;
    tx_ready = 1'b1;
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

  initial repeat (3*ITER*MMU_SIZE*MMU_SIZE*MMU_SIZE) clk = #1 !clk;
  

  task receive_frame(output mpu_frame frame);
    
    frame = new();
    while (tx_startofpacket != 1'b1)
      @(posedge clk);
    while (!tx_error) begin
      if (tx_valid) begin
        frame.put_new_octet(tx_data[31:24]);
        frame.put_new_octet(tx_data[23:16]);
        frame.put_new_octet(tx_data[15:8]);
        frame.put_new_octet(tx_data[7:0]);
      end
      if (tx_endofpacket)
        break;
      @(posedge clk);
    end
    
  endtask : receive_frame

  task send_frame(input mpu_frame frame);

    automatic int frame_size;

    rst_n = 1'b1;
    rx_dsav = 1'b1;
    @(posedge clk);
    frame_size = frame.get_nr_of_octets();
    for(int i = 0; i < frame_size; i++) begin
      while (rx_ready != 1'b1)
        @(posedge clk);
      rx_data = frame.get_first_octet();
      rx_valid = 1'b1;
      rx_error = 6'b0;
      rx_startofpacket = (i == 0) ? 1'b1 : 1'b0;
      rx_endofpacket = (i == (frame_size-1)) ? 1'b1 : 1'b0;
      rx_dsav = (i < 2) ? 1'b1 : 1'b0;
      @(posedge clk);
      rx_valid = 1'b0;
      rx_endofpacket = 1'b0;
    end

  endtask : send_frame

  task receive_frames(output mpu_frames_t frames, input int timeout = 3*MMU_SIZE*MMU_SIZE);
    
    automatic mpu_frame frame;
    
    frames = {};
    fork begin
      fork
        begin
          forever begin
            receive_frame(frame);
            frames.push_back(frame);
          end
        end
        begin
          repeat(timeout) @(posedge clk);
        end
      join_any
      disable fork;
    end join
    
  endtask : receive_frames

  task send_frames(input mpu_frames_t frames);

    automatic mpu_frame frame;

    while (frames.size > 0) begin
      frame = frames.pop_front();
      send_frame(frame);
      @(posedge clk);
    end

  endtask : send_frames

  function mpu_frames_t pack_matrix_into_frames(matrix #(VAR_SIZE, MMU_SIZE, MMU_SIZE) data, logic [7:0] buffer_ab, logic[7:0] buffer_idx);

    automatic mpu_frames_t frames;
    automatic mpu_frame frame;
    automatic mac_addr_t frame_mac;
    automatic cmd_rx_t frame_cmd;
    automatic payload_t frame_data;
    automatic int i, j;

    frame_mac.dest = MAC_MPU;
    frame_mac.src = MAC_HOST;
    
    frame_cmd.cmd = CMD_LOAD;
    frame_cmd.buffer = buffer_ab;
    frame_cmd.dim_x = data.x;
    frame_cmd.dim_y = data.y;
    if (buffer_ab == BUFFER_A) begin
      frame_cmd.buffer_a_idx = buffer_idx;
      frame_cmd.buffer_b_idx = 0;
    end
    else begin
      frame_cmd.buffer_a_idx = 0;
      frame_cmd.buffer_b_idx = buffer_idx;
    end

    frame = new();
    frame.set_addresses(frame_mac);
    frame.set_command(frame_cmd);
    for (j = 0; j < data.y; j++) begin
      for (i = 0; i < data.x; i++) begin
        if (frame_data.size() == (1499 - frame.command_length - 1)) begin
          frame.set_payload(frame_data);
          frames.push_back(frame);
          frame = new();
          frame.set_addresses(frame_mac);
          frame_data = {};
        end
        frame_data.push_back(data.matrix[i][j]);
      end
    end
    frame.set_payload(frame_data);
    frames.push_back(frame);

    return frames;

  endfunction : pack_matrix_into_frames

  function mpu_frame pack_multiplication_frame(logic[7:0] buffer_a_idx, logic[7:0] buffer_b_idx, logic [31:0] bias = 0,
    logic [7:0] activation = 0, logic [7:0] pooling = 0);

    automatic mpu_frame frame;
    automatic mac_addr_t frame_mac;
    automatic cmd_rx_t frame_cmd;

    frame_mac.dest = MAC_MPU;
    frame_mac.src = MAC_HOST;
    
    frame_cmd.cmd = CMD_MULTIPLY;
    frame_cmd.buffer = 0;
    frame_cmd.buffer_a_idx = buffer_a_idx;
    frame_cmd.buffer_b_idx = buffer_b_idx;
    frame_cmd.dim_x = 0;
    frame_cmd.dim_y = 0;
    frame_cmd.bias = bias;
    frame_cmd.activation = activation;
    frame_cmd.pooling = pooling;
    
    frame = new();
    frame.set_addresses(frame_mac);
    frame.set_command(frame_cmd);

    return frame;

  endfunction : pack_multiplication_frame

  function matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) unpack_result_frames(mpu_frames_t frames);
    
    automatic matrix #(ACC_SIZE, MMU_SIZE+1, MMU_SIZE+1) data;
    automatic mpu_frame frame;
    automatic mac_addr_t frame_mac;
    automatic length_t frame_len;
    automatic cmd_tx_t frame_cmd;
    automatic payload_t frame_data;
    automatic logic [31:0] nr;
    automatic int i, j;
    automatic int fr;
    
    data = new("data");
    i = 0;
    j = 0;
    
    for (fr = 0; frames.size() > 0; fr++) begin
      frame = frames.pop_front();
      frame_mac = frame.get_addresses();
      if (frame_mac.dest == MAC_HOST && frame_mac.src == MAC_MPU) begin
        frame_len = frame.get_length();
        frame_cmd = frame.get_command();
        if (frame_cmd.frame == FRAME_DATA) begin
          frame_data = frame.get_payload();
          while (frame_data.size() > 0) begin
            nr[31:24] = frame_data.pop_front();
            nr[23:16] = frame_data.pop_front();
            nr[15:8] = frame_data.pop_front();
            nr[7:0] = frame_data.pop_front();
            data.matrix[i][j] = nr[(ACC_SIZE-1):0];
            if (i == (frame_cmd.dim_x - 1) && j == (frame_cmd.dim_y - 1)) begin
              i++;
              j++;
              break;
            end
            else if (i == (frame_cmd.dim_x - 1)) begin
              i = 0;
              j++;
            end
            else begin
              i++;
            end
          end
        end
        else if (frame_cmd.frame == FRAME_ERR_DIM) begin
          $display("Dimensions error frame received!");
          $display;
          data.x = i;
          data.y = j;
          return data;          
        end
        else if (frame_cmd.frame == FRAME_ERR_CMD) begin
          $display("Command error frame received!");
          $display;
          data.x = i;
          data.y = j;
          return data; 
        end
        else if (frame_cmd.frame == FRAME_ERR_FRAME) begin
          $display("Frame error frame received!");
          $display;
          data.x = i;
          data.y = j;
          return data; 
        end
        else begin
          $display("Unrecognized frame received!");
          $display;
          data.x = i;
          data.y = j;
          return data;
        end
      end
      else begin
        $display("Frame with different MAC addresses received!");
        $display;
      end
    end
    data.x = i;
    data.y = j;
    return data;
    
  endfunction : unpack_result_frames

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
    
    automatic mpu_frames_t frames;
    automatic mpu_frame frame;
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
    
    frames = pack_matrix_into_frames(A, BUFFER_A, buffer_a);
    send_frames(frames);
    frames = pack_matrix_into_frames(B, BUFFER_B, buffer_b);
    send_frames(frames);
    @(posedge clk);
    frame = pack_multiplication_frame(buffer_a, buffer_b, bias, activation, pooling);
    send_frame(frame);
    @(posedge clk);
    
    C_predicted = multiply_matrices(A, B, bias, activation, pooling);
    C_predicted.name = "C_predicted";
    C_predicted.print();
    
    receive_frames(frames);
    C_received = unpack_result_frames(frames);
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

endmodule : mpu_tb
