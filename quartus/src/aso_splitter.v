// aso_splitter.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

module aso_splitter (
		input  wire        clk,                       // clock_st.clk
		input  wire        reset,                     //         .reset
		input  wire [31:0] asi_sink_data,             //     sink.data
		output wire        asi_sink_ready,            //         .ready
		input  wire        asi_sink_valid,            //         .valid
		input  wire [5:0]  asi_sink_error,            //         .error
		input  wire        asi_sink_startofpacket,    //         .startofpacket
		input  wire        asi_sink_endofpacket,      //         .endofpacket
		input  wire [1:0]  asi_sink_empty,            //         .empty
		output wire [31:0] aso_source0_data,          //  source0.data
		input  wire        aso_source0_ready,         //         .ready
		output wire        aso_source0_valid,         //         .valid
		output wire [5:0]  aso_source0_error,         //         .error
		output wire        aso_source0_startofpacket, //         .startofpacket
		output wire        aso_source0_endofpacket,   //         .endofpacket
		output wire [1:0]  aso_source0_empty,         //         .empty
		output wire [31:0] aso_source1_data,          //  source1.data
		input  wire        aso_source1_ready,         //         .ready
		output wire        aso_source1_valid,         //         .valid
		output wire [5:0]  aso_source1_error,         //         .error
		output wire        aso_source1_startofpacket, //         .startofpacket
		output wire        aso_source1_endofpacket,   //         .endofpacket
		output wire [1:0]  aso_source1_empty          //         .empty
	);

	assign asi_sink_ready = aso_source0_ready | aso_source1_ready;

	assign aso_source0_data = asi_sink_data;

	assign aso_source0_valid = asi_sink_valid;

	assign aso_source0_error = asi_sink_error;

	assign aso_source0_startofpacket = asi_sink_startofpacket;

	assign aso_source0_endofpacket = asi_sink_endofpacket;

	assign aso_source0_empty = asi_sink_empty;

	assign aso_source1_data = asi_sink_data;

	assign aso_source1_valid = asi_sink_valid;

	assign aso_source1_error = asi_sink_error;

	assign aso_source1_startofpacket = asi_sink_startofpacket;

	assign aso_source1_endofpacket = asi_sink_endofpacket;

	assign aso_source1_empty = asi_sink_empty;

endmodule
