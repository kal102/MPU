
`include "matrix.svh"
`include "vc.svh"

module buffer_tb;

  import matrix_pkg::*;
  import vc_pkg::*;

  localparam VAR_SIZE = 8;
  localparam MMU_SIZE = 10;
  localparam MATRIX_SIZE = 5;
  localparam VECTOR_SIZE = MATRIX_SIZE;

  localparam CMD_NONE = 2'b00;
  localparam CMD_LOAD = 2'b01;
  localparam CMD_SEND = 2'b10;
  localparam CMD_CLEAR = 2'b11;

  logic signed [(VAR_SIZE-1):0] A1;
  logic signed [(VAR_SIZE*MMU_SIZE-1):0] B1;
  logic clk, rst_n;
  logic [1:0] cmd;
  logic [4:0] buffer;

  matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) A;
  matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) B;
  logic signed [(VAR_SIZE-1):0] B_column [(VECTOR_SIZE-1):0];
  int i, j;

  vc #(VAR_SIZE, VECTOR_SIZE, MMU_SIZE) m_vc;

  buffer_a #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_buffer_a
  (
    .B1(B1),
    .A(A1),
    .clk(clk),
    .rst_n(rst_n),
    .cmd(cmd),
    .stop(1'b0),
    .buffer(buffer),
    .dim_x_in(MATRIX_SIZE),
    .dim_y_in(MATRIX_SIZE),
    .dim_x(),
    .dim_y()
  );

  /* Test for buffer_input */
  initial begin

    /* Initialize */
    clk = 0;
    rst_n = 0;
    cmd = CMD_NONE;
    buffer = 0;
    if (MATRIX_SIZE > MMU_SIZE) begin
      $display("Matrices are too big for selected MMU size!");
      $finish;
    end
    A = new("A");
    B = new("B");
    A.initialize();
    A.print();
    A1 = '{default:0};
    @(posedge clk);

    /* Send test data */
    rst_n = 1;
    cmd = CMD_LOAD;
    buffer = $urandom_range(9, 0);
    @(posedge clk);
    cmd = CMD_NONE;
    for (i = 0; i < MATRIX_SIZE; i++) begin
      for (j = 0; j < MATRIX_SIZE; j++) begin
        A1 = A.matrix[j][i];
        if (j < (MATRIX_SIZE - 1))
          @(posedge clk);
      end
      @(posedge clk);
    end

    /* Receive test data */
    cmd = CMD_SEND;
    @(posedge clk);
    cmd = CMD_NONE;
    repeat(1) @(posedge clk);
    for (i = 0; i < MATRIX_SIZE; i++) begin
      m_vc.vector_unflatten(.v(B_column), .vf(B1));
      for (j = 0; j < MATRIX_SIZE; j ++) begin
        B.matrix[j][i] = B_column[j];
      end
      @(posedge clk);
    end
    B.print();

    /* Compare data */
    if (A.matrix === B.matrix)
      $display("Received matrices are equal! :)");
    else
      $display("Whoops, it looks like something went wrong");
    $display;

    /* Clear buffer */
    cmd = CMD_CLEAR;
    repeat(MMU_SIZE) @(posedge clk);
    cmd = CMD_SEND;
    @(posedge clk);
    cmd = CMD_NONE;
    repeat(2) @(posedge clk);
    for (i = 0; i < MATRIX_SIZE; i++) begin
      m_vc.vector_unflatten(.v(B_column), .vf(B1));
      for (j = 0; j < MATRIX_SIZE; j ++) begin
        B.matrix[j][i] = B_column[j];
      end
      @(posedge clk);
    end
    A.clear();
    B.print();

    /* Compare data */
    if (A.matrix === B.matrix)
      $display("Matrix was cleared properly");
    else
      $display("Matrix was not cleared properly");
    $display;
  end

  initial repeat (1000) clk = #1 !clk;

endmodule
