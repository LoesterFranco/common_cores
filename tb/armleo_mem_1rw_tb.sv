////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
////////////////////////////////////////////////////////////////////////////////

`define TOP_TB armleo_mem_1rw_tb

`define TIMEOUT 10000
`define SYNC_RST
`define CLK_HALF_PERIOD 1

`include "armleo_template.svh"

localparam WIDTH = 16;
localparam DEPTH_LOG2 = 3;

reg [DEPTH_LOG2-1:0] address;
reg read;
wire[WIDTH-1:0] readdata;
reg write;
reg [WIDTH-1:0] writedata;

armleo_mem_1rw #(
	.DEPTH_LOG2(DEPTH_LOG2),
	.WIDTH(WIDTH)
) dut (
	.*
);

task write_req;
input [DEPTH_LOG2-1:0] addr;
input [WIDTH-1:0] dat;
begin
	write = 1;
	writedata = dat;
	address = addr;
end
endtask


task read_req;
input [DEPTH_LOG2-1:0] addr;
begin
	read = 1;
	address = addr;
end
endtask

task next_cycle;
begin
	@(negedge clk);
	read = 0;
	write = 0;
end
endtask

reg [WIDTH-1:0] mem[2**DEPTH_LOG2 -1:0];

localparam DEPTH = 2**DEPTH_LOG2;

reg [DEPTH_LOG2-1:0] word;

integer i;
initial begin
	read = 0;
	write = 0;
	next_cycle();

	$display("Test Read should be keeping its value after write");
	write_req(0, 0);
	next_cycle();

	read_req(0);
	next_cycle();
	`assert_equal(readdata, 0)

	write_req(0, 1);
	next_cycle();
	`assert_equal(readdata, 0)

	next_cycle();
	`assert_equal(readdata, 0)


	$display("Test write multiple data");
	for(i = 0; i < 2**DEPTH_LOG2; i = i + 1) begin
		mem[i] = $random % (2**WIDTH);
		write_req(i, mem[i]);
		next_cycle();

		if(i < 10)
			$display("mem[%d] = 0x%x", i, mem[i]);
	end

	$display("Test read multiple data after modification");
	for(i = 0; i < 2**DEPTH_LOG2; i = i + 1) begin
		read_req(i);
		next_cycle();
		`assert_equal(readdata, mem[i]);
		write_req(i, 0);
		next_cycle();
		`assert_equal(readdata, mem[i]);

		write_req(i, 1);
		next_cycle();
		`assert_equal(readdata, mem[i]);

		write_req(i, mem[i]);
		next_cycle();
	end

	$display("Test random read write");

	for(i = 0; i < 1000; i = i + 1) begin
		word = $urandom() % (DEPTH);
		
		if($urandom() & 1) begin
			mem[word] = $urandom() & ((2 ** WIDTH) - 1);
			$display("Random write addr = %d, data = 0x%x", word, mem[word]);
			
			write_req(word, //addr
					mem[word]
				);
			next_cycle();
		end else begin
			
			read_req(word);
			next_cycle();
			$display("Random read addr = %d, data = 0x%x, got value: 0x%x", word, mem[word], readdata);
			`assert_equal(readdata, mem[word]);
		end
	end
	$finish;
end


endmodule