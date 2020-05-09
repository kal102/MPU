// 2_to_1_st_mux.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

module st_mux_2_to_1 (
		input  wire        clk,                            //        clock.clk
		input  wire        reset,                          //             .reset
		input  wire [7:0]  avs_control_port_address,       // control_port.address
		input  wire        avs_control_port_read,          //             .read
		output reg	[31:0] avs_control_port_readdata,      //             .readdata
		input  wire        avs_control_port_write,         //             .write
		input  wire [31:0] avs_control_port_writedata,     //             .writedata
		output wire        avs_control_port_waitrequest,   //             .waitrequest
		input  wire [31:0] asi_sink0_data,                //        sink0.data
		output wire        asi_sink0_ready,               //             .ready
		input  wire        asi_sink0_valid,               //             .valid
		input  wire        asi_sink0_error,               //             .error
		input  wire        asi_sink0_startofpacket,       //             .startofpacket
		input  wire        asi_sink0_endofpacket,         //             .endofpacket
		input  wire [1:0]  asi_sink0_empty,               //             .empty
		input  wire [31:0] asi_sink1_data,                //        sink1.data
		output wire        asi_sink1_ready,               //             .ready
		input  wire        asi_sink1_valid,               //             .valid
		input  wire        asi_sink1_error,               //             .error
		input  wire        asi_sink1_startofpacket,       //             .startofpacket
		input  wire        asi_sink1_endofpacket,         //             .endofpacket
		input  wire [1:0]  asi_sink1_empty,               //             .empty
		output wire [31:0] aso_source_data,                //       source.data
		input  wire        aso_source_ready,               //             .ready
		output wire        aso_source_valid,               //             .valid
		output wire        aso_source_error,               //             .error
		output wire        aso_source_startofpacket,       //             .startofpacket
		output wire        aso_source_endofpacket,         //             .endofpacket
		output wire [1:0]  aso_source_empty                //             .empty
	);

reg	sel;

always @ (posedge clk or posedge reset)
	begin
		if (reset)
			sel <= 1'b0;
		else if (avs_control_port_write & avs_control_port_address == 32'h0)
			sel <= avs_control_port_writedata[0];
	end
	
always @ (posedge clk or posedge reset)
	begin
	if (reset) begin
		avs_control_port_readdata<=1'b0;
		end
		else if (avs_control_port_read)
		begin
			case (avs_control_port_address)
				32'h0: avs_control_port_readdata = sel;
				default: avs_control_port_readdata = 32'h0;
			endcase
		end
	end
	
st_mux st_mux_0 (
	.data0x	({asi_sink0_data, asi_sink0_valid, asi_sink0_error, asi_sink0_startofpacket, asi_sink0_endofpacket, asi_sink0_empty}),
	.data1x	({asi_sink1_data, asi_sink1_valid, asi_sink1_error, asi_sink1_startofpacket, asi_sink1_endofpacket, asi_sink1_empty}),
	.sel	(sel),
	.result	({aso_source_data, aso_source_valid, aso_source_error, aso_source_startofpacket, aso_source_endofpacket, aso_source_empty})
);

assign asi_sink0_ready = aso_source_ready; 
assign asi_sink1_ready = aso_source_ready;

endmodule
