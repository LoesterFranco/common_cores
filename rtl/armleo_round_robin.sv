////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
//
// Purpose:	Simple round robin. 
////////////////////////////////////////////////////////////////////////////////


module armleo_round_robin(
    clk, rst_n, request, grant, grant_idx
);

input logic clk;
input logic rst_n;

parameter WIDTH = 4;
localparam WIDTH_CLOG2 = $clog2(WIDTH);

// req == Request
// -> rotated_req == rotate depending on last decision (rotation)
// -> rotated_grant ==  priority arbitrage
// -> grant == rotate back to generate the grant signal

input logic [WIDTH-1:0]     request;
logic [WIDTH_CLOG2-1:0]     rotation; // Highest priority request state; Flip flop
logic [WIDTH_CLOG2-1:0]     rotation_nxt; // Highest priority request state; Flip flop's D Input
logic [WIDTH-1:0]           rotated_req; // Rotated request
logic [WIDTH-1:0]           rotated_grant; // rotated grants; Priority decreases on the bit number increasing
output logic [WIDTH-1:0]    grant; // unrotated decision
output logic [WIDTH_CLOG2-1:0] grant_idx;

logic found_priority;


always_ff @(posedge clk) begin
    if(!rst_n) begin
        rotation <= 0;
    end else begin
        rotation <= rotation_nxt;
    end
end

integer i;

always_comb begin
    // Rotate request, so higher priority request is LSB
    rotated_req = {request, request} >> rotation;

    // Priority arbitrage
    found_priority = 0;
    rotated_grant = 0;
    rotation_nxt = rotation;

    for (i = 0; i < WIDTH; i = i + 1) begin
        if(!found_priority && rotated_req[i]) begin
            rotated_grant[i] = 1;
            rotation_nxt = (i + 1) % WIDTH;
            found_priority = 1;
        end
    end

    // Rotate the grants back, so we can assign the outputs
    grant = ({rotated_grant, rotated_grant} << rotation) >> WIDTH;

    grant_idx = 0;
    for (int i = 0; i < WIDTH; i++) begin
        if (grant[i]) begin
            grant_idx = i[WIDTH_CLOG2-1:0];
        end
    end
end

endmodule