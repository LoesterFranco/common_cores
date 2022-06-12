////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
// Purpose: Register file. Reset clearts only register 0. Writing to
//      register 0 is ignored. Read is synchronous, that is the read
//      result will be output after the rising edge of the clock.
//      Depth == 2 ** DEPTH_LOG2;
//      Total bits of memory  == WIDTH x (2 ** DEPTH_LOG2)
// Parameters:
//      DEPTH_LOG2: Width of the address;
//      WIDTH: Width of the single register;
//
////////////////////////////////////////////////////////////////////////////////

module armleo_regfile(
    input  wire                     clk,
    input  wire                     rst_n,

    input  wire                     rs1_read,
    input  wire [DEPTH_LOG2-1:0]    rs1_addr,
    output wire [WIDTH-1:0]         rs1_rdata,

    input  wire                     rs2_read,
    input  wire [DEPTH_LOG2-1:0]    rs2_addr,
    output wire [WIDTH-1:0]         rs2_rdata,
    
    input  wire [DEPTH_LOG2-1:0]    rd_addr,
    input  wire [WIDTH-1:0]         rd_wdata,
    input  wire                     rd_write
);

parameter WIDTH = 32;
parameter DEPTH_LOG2 = 5;

wire                         write = !rst_n  ? 1 : (rd_write && (rd_addr != 0));
wire [DEPTH_LOG2-1:0] writeaddress = !rst_n  ? 0 : rd_addr;
wire [WIDTH-1:0]         writedata = !rst_n  ? 0 : rd_wdata;


armleo_mem_1r1w #(.DEPTH_LOG2(DEPTH_LOG2), .WIDTH(WIDTH)) lane0(
    .clk(clk),

    .readaddress(rs1_addr),
    .read(rs1_read),
    .readdata(rs1_rdata),

    .write(write),
    .writeaddress(writeaddress),
    .writedata(writedata)
);



armleo_mem_1r1w #(.DEPTH_LOG2(DEPTH_LOG2), .WIDTH(WIDTH)) lane1(
    .clk(clk),

    .readaddress(rs2_addr),
    .read(rs2_read),
    .readdata(rs2_rdata),

    .write(write),
    .writeaddress(writeaddress),
    .writedata(writedata)
);


endmodule


