`define DEFINE_REG_REG_NXT(WIDTH, REG, REG_NXT, CLK) \
    reg [WIDTH-1:0] REG; \
    reg [WIDTH-1:0] REG_NXT; \
    always @(posedge CLK) REG <= REG_NXT; \

