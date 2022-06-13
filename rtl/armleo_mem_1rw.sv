////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2016-2022, Arman Avetisyan
// 
// Filename: armleo_mem_1rw.v
//
// Purpose:	Memory cell, read first,
//			read result stays same until next read request is complete
//
////////////////////////////////////////////////////////////////////////////////

module armleo_mem_1rw (clk, address, read, readdata, write, writedata);
    parameter DEPTH_LOG2 = 7;
    parameter WIDTH = 32;
    localparam DEPTH = 2**DEPTH_LOG2;

    input wire clk;

    input wire [DEPTH_LOG2-1:0] address;
    input wire read;
    output reg [WIDTH-1:0] readdata;

    input wire write;
    input wire [WIDTH-1:0] writedata;

reg [WIDTH-1:0] storage [DEPTH-1:0];

always @(posedge clk) begin
    if(write) begin
        storage[address] <= writedata;
    end
    if(read)
        readdata <= storage[address];
end

endmodule

