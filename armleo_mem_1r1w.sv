////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
// Purpose:	Used by regfile to allow two reads and one write.
//		two instances is used, where
//		write port is connected together and exposed and
//		two read ports are exposed to core itself
//		
//
////////////////////////////////////////////////////////////////////////////////

module armleocpu_1r1w (clk, read_addr, read, read_data, write_addr, write, write_data);
	parameter DEPTH_LOG2 = 5;
	localparam ELEMENTS = 2**DEPTH_LOG2;
	parameter WIDTH = 32;

	input wire clk;

    input wire [DEPTH_LOG2-1:0] read_addr;
    input wire read;
	output reg [WIDTH-1:0] read_data;


	input wire [DEPTH_LOG2-1:0] write_addr;
	input wire write;
	input wire  [WIDTH-1:0] write_data;

reg [WIDTH-1:0] storage[ELEMENTS-1:0];

always @(posedge clk) begin
	if(write) begin
		storage[write_addr] <= write_data;
	end
	if(read)
		read_data <= storage[read_addr];
end

endmodule

