
`include "src/mmu_beh.v"
`include "matrix.svh"
`include "mvc.svh"
`include "vc.svh"

module mmu_tb;
  
  import matrix_pkg::*;
  import mvc_pkg::*;
  import vc_pkg::*;
  
  localparam ITERATIONS = 5;
  localparam VAR_SIZE = 8;
  localparam ACC_SIZE = 32;
  localparam [7:0] MATRIX_SIZE = 10;
  localparam [7:0] MMU_SIZE = 10;
  localparam VECTOR_SIZE = MATRIX_SIZE;
  
  matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) A;
  matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) B;
  logic clk, rst_n, shift, clear;
  
  matrix #(ACC_SIZE, MATRIX_SIZE, MATRIX_SIZE) C_beh;
  mvc #(VAR_SIZE, MATRIX_SIZE, MMU_SIZE) m_mvc_in;
  mvc #(ACC_SIZE, MATRIX_SIZE, MMU_SIZE) m_mvc_out;
  logic signed [(VAR_SIZE*MMU_SIZE*MMU_SIZE-1):0] A1_beh, B1_beh;
  logic signed [(ACC_SIZE*MMU_SIZE*MMU_SIZE-1):0] C1_beh;
  
  mmu_beh #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_beh (.A1(A1_beh), .B1(B1_beh), .C1(C1_beh), .clk(clk), .rst_n(rst_n), .bias(0));
  
  matrix #(ACC_SIZE, MATRIX_SIZE, MATRIX_SIZE) C_str;
  vc #(VAR_SIZE, VECTOR_SIZE, MMU_SIZE) m_vc_in;
  vc #(ACC_SIZE, VECTOR_SIZE, MMU_SIZE) m_vc_out;
  logic signed [(VAR_SIZE*MMU_SIZE-1):0] A1_str, B1_str;
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] A1_setup;
  wire signed [(VAR_SIZE*MMU_SIZE-1):0] B1_setup;
  wire signed [(ACC_SIZE*MMU_SIZE-1):0] C1_setup;
  logic signed [(ACC_SIZE*MMU_SIZE-1):0] C1_str;
  
  mmu_setup #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_a_setup (.B1(A1_setup), .A1(A1_str), .clk(clk), .rst_n(rst_n));
  mmu_setup #(.VAR_SIZE(VAR_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_b_setup (.B1(B1_setup), .A1(B1_str), .clk(clk), .rst_n(rst_n));
  mmu_str #(.VAR_SIZE(VAR_SIZE), .ACC_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE)) m_mmu_str (.C1(C1_setup), .A1(A1_setup), .B1(B1_setup), .clk(clk), .shift(shift), .clear(clear));
  mmu_setup #(.VAR_SIZE(ACC_SIZE), .MMU_SIZE(MMU_SIZE), .REVERSED(1)) m_mmu_c_setup (.B1(C1_str), .A1(C1_setup), .clk(clk), .rst_n(rst_n));
  
  logic signed [(VAR_SIZE-1):0] A_column [(VECTOR_SIZE-1):0];
  logic signed [(VAR_SIZE-1):0] B_row [(VECTOR_SIZE-1):0];
  logic signed [(ACC_SIZE-1):0] C_row [(VECTOR_SIZE-1):0];
  int i, j;
	int n;
  
  initial begin
    clk = 0;
  	rst_n = 0;
    shift = 0;
    clear = 0;
    if (MATRIX_SIZE > MMU_SIZE) begin
      $display("Matrices are too big for selected MMU size!");
      $finish;
    end
    A = new("A");
    B = new("B");
    C_beh = new("C_beh");
    C_str = new("C_str");
    generate_matrices();
    A1_str = '{default:0};
    B1_str = '{default:0};
    @(posedge clk);
    rst_n = 1;
    clear = 1;
    for (n = 0; n < ITERATIONS; n++) begin
      @(posedge clk);
      clear = 0;
      send_matrices();
      @(posedge clk);                       // Time needed by setup module
	    repeat(MATRIX_SIZE) @(posedge clk);	  // Time needed for calculations
	  	shift = 1;
      @(posedge clk);                       // New data can be now inserted (critical wait)
      repeat(MMU_SIZE-1) @(posedge clk);    // Duration of the shift signal should be at least MMU_SIZE
      shift = 0;
    end
  end
  
  always @(posedge shift) fork
    begin
  		repeat(MMU_SIZE) @(posedge clk);	// Time needed for data shifting
  		collect_matrix();
    end
  join_none
  
  initial repeat (1000) clk = #1 !clk;

  task generate_matrices();
    
    A.initialize();
    B.initialize();
    A.print();
    B.print();
    
  endtask : generate_matrices

  task send_matrices();
	  
	  int i, j;
	  
	  m_mvc_in.matrix_to_vector(.v(A1_beh), .m(A));
	  m_mvc_in.matrix_to_vector(.v(B1_beh), .m(B));
	  for (i = 0; i < MATRIX_SIZE; i++) begin
	    for (j = 0; j < MATRIX_SIZE; j ++) begin
	      A_column[j] = A.matrix[j][i];
	      B_row[j] = B.matrix[i][j];
	    end
	    m_vc_in.vector_flatten(.v(A_column), .vf(A1_str));
	    m_vc_in.vector_flatten(.v(B_row), .vf(B1_str));
	    @(posedge clk);
	  end
	  A1_str = '{default:0};
	  B1_str = '{default:0};
	    
  endtask : send_matrices

  task collect_matrix();
	  
	  int i, j;
	  
		for (i = (MMU_SIZE - 1); i >= 0; i--) begin
		  m_vc_out.vector_unflatten(.v(C_row), .vf(C1_str));
		  for (j = 0; j < MATRIX_SIZE; j++) begin
		    C_str.matrix[i][j] = C_row[j];
      end
      @(posedge clk);
		end
		m_mvc_out.vector_to_matrix(.m(C_beh), .v(C1_beh));
		C_beh.print();
		C_str.print();
		if (C_beh.matrix === C_str.matrix)
		  $display("Received matrices are equal! :)");
		else
		  $display("Whoops, it looks like something went wrong");
		$display;
	  
  endtask : collect_matrix

endmodule
