////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
//
// Purpose:	Memory cell with separate section write enable, read first,
//			read result stays same until next read request is complete
//
////////////////////////////////////////////////////////////////////////////////

module armleo_mem_1rwm (clk, address, read, readdata, write, writeenable, writedata);
	parameter DEPTH_LOG2 = 7;
	parameter WIDTH = 32;
	parameter GRANULITY = 8;
	localparam ENABLE_WIDTH = WIDTH/GRANULITY;

	input wire clk;

    input wire [DEPTH_LOG2-1:0] address;
    input wire read;
    output wire [WIDTH-1:0] readdata;

	input wire write;
	input wire [WIDTH/GRANULITY-1:0] writeenable;
	input wire [WIDTH-1:0] writedata;

`ifdef SIMULATION
	initial begin
		if((WIDTH % GRANULITY) != 0) begin
			$display("Width is not divisible by granulity");
			$fatal;
		end
	end
`endif

genvar i;
generate for(i = 0; i < WIDTH; i = i + GRANULITY) begin : mem_generate_for
	armleo_mem_1rw #(DEPTH_LOG2, GRANULITY) realstorage(
		.clk(clk),
		
		.address(address),

		.read(read),
		.readdata(readdata[i + GRANULITY - 1 : i]),

		.write(write & writeenable[i/GRANULITY]),
		.writedata(writedata[i + GRANULITY - 1 : i])
	);
end
endgenerate


endmodule
