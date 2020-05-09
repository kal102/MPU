
`ifndef VC_SH_
`define VC_SH_

/* Vector converter */
package vc_pkg;
  
  class vc #(parameter int VAR_SIZE, VECTOR_SIZE, MMU_SIZE);
    
    extern static task vector_flatten(ref logic signed [(VAR_SIZE-1):0] v [(VECTOR_SIZE-1):0], ref logic signed [(VAR_SIZE*MMU_SIZE-1):0] vf);
    extern static task vector_unflatten(ref logic signed [(VAR_SIZE-1):0] v [(VECTOR_SIZE-1):0], ref logic signed [(VAR_SIZE*MMU_SIZE-1):0] vf);
    
  endclass : vc
  
  task vc::vector_flatten(ref logic signed [(VAR_SIZE-1):0] v [(VECTOR_SIZE-1):0], ref logic signed [(VAR_SIZE*MMU_SIZE-1):0] vf);
    
      automatic int i, j;
    
      j = 0;
      for (i = 0; i < MMU_SIZE; i = i + 1) begin
        if (i < VECTOR_SIZE)
          vf[(j * VAR_SIZE)+:VAR_SIZE] = v[i];
        else
          vf[(j * VAR_SIZE)+:VAR_SIZE] = 0;
        j = j + 1;
      end
      
  endtask : vector_flatten
  
  task vc:: vector_unflatten(ref logic signed [(VAR_SIZE-1):0] v [(VECTOR_SIZE-1):0], ref logic signed [(VAR_SIZE*MMU_SIZE-1):0] vf);
      
      automatic int i, j;
    
      j = 0;
      for (i = 0; i < VECTOR_SIZE; i = i + 1) begin
        v[i] = vf[(j * VAR_SIZE)+:VAR_SIZE];
        j = j + 1;
      end
      
  endtask : vector_unflatten
  
endpackage : vc_pkg

`endif
