////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
////////////////////////////////////////////////////////////////////////////////

`define TIMEOUT 2000000
`define SYNC_RST
`define CLK_HALF_PERIOD 10

`define TOP_TB armleo_register_slice_tb

`include "armleo_template.svh"

localparam DW = 16;

reg in_valid;
reg [DW-1:0] in_data;
wire in_ready;

wire out_valid;
wire [DW-1:0] out_data;
reg out_ready;

armleo_register_slice #(
	.DW(DW),
	.PASSTHROUGH(0)
) register_slice (
	.*
);


localparam PASSTHROUGH_DW = 2;

reg passthrough_in_valid;
reg [PASSTHROUGH_DW-1:0] passthrough_in_data;
wire passthrough_in_ready;

wire passthrough_out_valid;
wire [PASSTHROUGH_DW-1:0] passthrough_out_data;
reg passthrough_out_ready;

armleo_register_slice #(
	.DW(PASSTHROUGH_DW),
	.PASSTHROUGH(1)
) register_slice_passthrough (
	.clk		(clk),
	.rst_n		(rst_n),

	.in_valid	(passthrough_in_valid),
	.in_data	(passthrough_in_data),
	.in_ready   (passthrough_in_ready),

	.out_valid	(passthrough_out_valid),
	.out_ready	(passthrough_out_ready),
	.out_data	(passthrough_out_data)
);

initial begin
	integer i;
	in_valid = 0;
	out_ready = 0;
	@(posedge rst_n)
	@(negedge clk)
	`assert_equal(out_valid, 0)

	$display("Test case: Input is fed and no buffered data, no stall");
	in_valid = 1;
	in_data = 16'hFE0B;
	`assert_equal(in_ready, 1)
	@(negedge clk)
	`assert_equal(out_valid, 1)
	`assert_equal(out_data, 16'hFE0B)
	out_ready = 1;
	in_valid = 0;

	@(negedge clk)
	`assert_equal(out_valid, 0)
	



	$display("Test case: Two cycles Input is fed and no buffered data, no stall");
	in_valid = 1;
	in_data = 16'hFE0A;
	`assert_equal(in_ready, 1)
	@(negedge clk)
	`assert_equal(out_valid, 1)
	`assert_equal(out_data, 16'hFE0A)
	out_ready = 1;
	in_data = 16'hFE0C;
	@(negedge clk)
	`assert_equal(out_valid, 1)
	`assert_equal(out_data, 16'hFE0C)
	in_valid = 0;
	@(negedge clk)
	`assert_equal(out_valid, 0)
	

	$display("Test case: One cycle, then output is stalled");
	in_valid = 1;
	in_data = 16'hFE0A;
	`assert_equal(in_ready, 1)
	@(negedge clk)
	`assert_equal(out_valid, 1)
	`assert_equal(out_data, 16'hFE0A)
	in_data = 16'hFE0B;
	`assert_equal(in_ready, 1)
	out_ready = 0;
	@(negedge clk)
	`assert_equal(out_valid, 1)
	`assert_equal(out_data, 16'hFE0A)
	out_ready = 1;
	in_valid = 0;
	@(negedge clk)
	`assert_equal(out_valid, 1)
	`assert_equal(out_data, 16'hFE0B)

	for(i = 0; i < 100; i = i + 1) begin
		{
			passthrough_in_valid,
			passthrough_out_ready,
			passthrough_in_data
		} = ($urandom() % 16);
		#1;
		assert(passthrough_in_valid == passthrough_out_valid);
		assert(passthrough_in_data == passthrough_out_data);
		assert(passthrough_in_ready == passthrough_out_ready);
	end

	@(negedge clk)
	@(negedge clk)
	$finish;
end


endmodule