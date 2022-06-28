////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
////////////////////////////////////////////////////////////////////////////////

`define TIMEOUT 2000000
`define SYNC_RST
`define CLK_HALF_PERIOD 10

`define TOP_TB armleo_round_robin_tb

`include "armleo_template.svh"



localparam WIDTH = 4;
localparam WIDTH_CLOG2 = $clog2(WIDTH);

logic ack;
logic [WIDTH-1:0] request;
logic [WIDTH-1:0] grant;
logic [WIDTH_CLOG2-1:0] grant_idx;

armleo_round_robin #(.WIDTH(WIDTH)) dut (
    .*
);


initial begin
	integer i;
    request = 0;
	@(posedge rst_n)
	@(negedge clk)
	`assert_equal(grant, 0)

    $display("Test case: Between two signals the LSB should be selected");
    request[2] = 1;
    request[3] = 1;
    ack = 1;
    #1
    `assert_equal(grant, 1 << 2)
    @(negedge clk);

    `assert_equal(grant, 1 << 3)

	$display("Test case: Request on any signal should result in grant");
    for(i = 0; i < WIDTH; i = i + 1) begin
        request = 0;
	    request[i] = 1;
        #1
        `assert_equal(grant, 1 << i)
        @(negedge clk);
    end
	
	@(negedge clk);
	@(negedge clk);
	`assert_finish;
end



endmodule
