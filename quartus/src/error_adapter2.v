// loopback.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

module error_adapter2 #(
		parameter data_width = 32;
		parameter in_error_width = 6;
		parameter out_error_width = 1;
		parameter empty_width = 2
	) (
		input          						clk,                   // clock.clk
		input          						reset_n,               //      .reset
		input		[data_width-1:0] 		asi_in_data,           //    in.data
		output reg        					asi_in_ready,          //      .ready
		input          						asi_in_valid,          //      .valid
		input   	[in_error_width-1:0]  	asi_in_error,          //      .error
		input          						asi_in_startofpacket,  //      .startofpacket
		input          						asi_in_endofpacket,    //      .endofpacket
		input   	[empty_width-1:0]  		asi_in_empty,          //      .empty
		output reg 	[data_width-1:0] 		aso_out_data,          //   out.data
		input          						aso_out_ready,         //      .ready
		output reg        					aso_out_valid,         //      .valid
		output reg 	[out_error_width-1:0]	aso_out_error,         //      .error
		output reg        					aso_out_startofpacket, //      .startofpacket
		output reg        					aso_out_endofpacket,   //      .endofpacket
		output reg 	[empty_width-1:0]  		aso_out_empty          //      .empty
	);
	
   // ---------------------------------------------------------------------
   //| Pass-through Mapping
   // ---------------------------------------------------------------------
   always @* begin
      asi_in_ready = aso_out_ready;
      aso_out_valid = asi_in_valid;
      aso_out_data = asi_in_data;
      aso_out_startofpacket = asi_in_startofpacket;
      aso_out_endofpacket = asi_in_endofpacket;
	  aso_out_empty = asi_in_empty;

   end

   // ---------------------------------------------------------------------
   //| Error Mapping
   // ---------------------------------------------------------------------
   always @* begin
      aso_out_error = asi_in_error[0];
   end
	

endmodule
