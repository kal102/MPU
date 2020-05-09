
`ifndef MVC_SH_
`define MVC_SH_

`include "matrix.svh"

/* Matrix-Vector Converter */
package mvc_pkg;

  import matrix_pkg::*;

  class mvc #(parameter int VAR_SIZE, MATRIX_SIZE, MMU_SIZE);

    localparam VECTOR_SIZE = VAR_SIZE * MMU_SIZE * MMU_SIZE;

    extern static task matrix_to_vector(ref matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) m, ref logic signed [(VECTOR_SIZE-1):0] v);
    extern static task vector_to_matrix(ref matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) m, ref logic signed [(VECTOR_SIZE-1):0] v);

  endclass : mvc

  task mvc::matrix_to_vector(ref matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) m, ref logic signed [(VECTOR_SIZE-1):0] v);

    automatic int i, j, k;
    
    k = 0;
    for (i = 0; i < MMU_SIZE; i = i + 1) begin
      for (j = 0; j < MMU_SIZE; j = j + 1) begin
        if ((i < MATRIX_SIZE) && (j < MATRIX_SIZE))
          v[(k * VAR_SIZE)+:VAR_SIZE] = m.matrix[i][j];
        else
          v[(k * VAR_SIZE)+:VAR_SIZE] = 0;
        k = k + 1;
      end
    end

  endtask : matrix_to_vector
  
  task mvc::vector_to_matrix(ref matrix #(VAR_SIZE, MATRIX_SIZE, MATRIX_SIZE) m, ref logic signed [(VECTOR_SIZE-1):0] v);
    
    automatic int i, j, k;
    
    k = 0;
    for (i = 0; i < MMU_SIZE; i = i + 1) begin
      for (j = 0; j < MMU_SIZE; j = j + 1) begin
        if ((i < MATRIX_SIZE) && (j < MATRIX_SIZE))
          m.matrix[i][j] = v[(k * VAR_SIZE)+:VAR_SIZE];
        k = k + 1;
      end
    end
    
  endtask : vector_to_matrix

endpackage : mvc_pkg

`endif //MVC_SH_
