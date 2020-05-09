
`ifndef MATRIX_SVH_
`define MATRIX_SVH_

package matrix_pkg;

  class matrix #(parameter int VAR_SIZE, MAX_X = 100, MAX_Y = 100);
  
    rand logic signed [(VAR_SIZE-1):0] matrix [(MAX_X-1):0][(MAX_Y-1):0];
    string name;
    int x, y;
    local int i, j;
  
    //constraint c {foreach(matrix[i,j]) -10 < matrix[i][j] < 10;}
  
    function new(string matrix_name, int x = MAX_X, int y = MAX_Y);
      name = matrix_name;
      this.x = x;
      this.y = y;
      for (i = 0; i < MAX_X; i = i + 1) begin
        for (j = 0; j < MAX_Y; j = j + 1) begin
          matrix[i][j] = 0;
        end
      end
    endfunction : new
    
    extern task initialize;
    extern task clear;
    extern task print;
    
  endclass : matrix
  
  task matrix::initialize();
      
    integer i, j;
    
    for (i = 0; i < x; i = i + 1) begin
      for (j = 0; j < y; j = j + 1) begin
        matrix[i][j] = $random;
      end
    end
      
  endtask : initialize
  
  task matrix::clear();
      
    integer i, j;
    
    for (i = 0; i < x; i = i + 1) begin
      for (j = 0; j < y; j = j + 1) begin
        matrix[i][j] = 0;
      end
    end
      
  endtask : clear  
  
  task matrix::print;
    
    integer i, j;
    
    $display(name, ":");
    for (i = 0; i < x; i = i + 1) begin
      $write("|");
      for (j = 0; j < y; j = j + 1) begin
        $write(matrix[i][j], " ");
      end
      $display("|");
    end
    $display();
    
  endtask : print

endpackage : matrix_pkg

`endif //MATRIX_SVH_
