
// Taken from AXI4 Specification
// AXI Defs
`define AXI_BURST_INCR (2'b01)
`define AXI_BURST_WRAP (2'b10)

`define AXI_RESP_OKAY   (2'b00)
`define AXI_RESP_EXOKAY (2'b01)
`define AXI_RESP_SLVERR (2'b10)
`define AXI_RESP_DECERR (2'b11)

`define AXI_BASE_WRITE_MODULE_IO_NAMELIST(prefix) \
    ``prefix``awvalid, ``prefix``awready, ``prefix``awaddr, ``prefix``awlen, ``prefix``awburst, ``prefix``awsize, ``prefix``awid, \
    ``prefix``wvalid, ``prefix``wready, ``prefix``wdata, ``prefix``wstrb, ``prefix``wlast, \
    ``prefix``bvalid, ``prefix``bready, ``prefix``bresp, ``prefix``bid

`define AXI_BASE_READ_MODULE_IO_NAMELIST(prefix) \
    ``prefix``arvalid, ``prefix``arready, ``prefix``araddr, ``prefix``arlen, ``prefix``arsize, ``prefix``arburst, ``prefix``arid, \
    ``prefix``rvalid, ``prefix``rready, ``prefix``rresp, ``prefix``rlast, ``prefix``rdata, ``prefix``rid


`define AXI_BASE_MODULE_IO_NAMELIST(prefix) `AXI_BASE_WRITE_MODULE_IO_NAMELIST(prefix), `AXI_BASE_READ_MODULE_IO_NAMELIST(prefix)



`define AXI_FULL_READ_MODULE_IO_NAMELIST(prefix) `AXI_BASE_READ_MODULE_IO_NAMELIST(prefix), \
    ``prefix``arprot, ``prefix``arlock

`define AXI_FULL_WRITE_MODULE_IO_NAMELIST(prefix) `AXI_BASE_WRITE_MODULE_IO_NAMELIST(prefix), \
    ``prefix``awprot, ``prefix``awlock

`define AXI_FULL_MODULE_IO_NAMELIST(prefix) `AXI_FULL_READ_MODULE_IO_NAMELIST(prefix), `AXI_FULL_WRITE_MODULE_IO_NAMELIST(prefix)


`define CONNECT_AXI_BUS(left, right) \
.``left``awvalid(``right``awvalid), \
.``left``awready(``right``awready), \
.``left``awaddr(``right``awaddr), \
.``left``awlen(``right``awlen), \
.``left``awsize(``right``awsize), \
.``left``awburst(``right``awburst), \
.``left``awid(``right``awid), \
\
.``left``wvalid(``right``wvalid), \
.``left``wready(``right``wready), \
.``left``wdata(``right``wdata), \
.``left``wstrb(``right``wstrb), \
.``left``wlast(``right``wlast), \
\
.``left``bvalid(``right``bvalid), \
.``left``bready(``right``bready), \
.``left``bresp(``right``bresp), \
.``left``bid(``right``bid), \
\
.``left``arvalid(``right``arvalid), \
.``left``arready(``right``arready), \
.``left``araddr(``right``araddr), \
.``left``arlen(``right``arlen), \
.``left``arsize(``right``arsize), \
.``left``arburst(``right``arburst), \
.``left``arid(``right``arid), \
\
.``left``rvalid(``right``rvalid), \
.``left``rready(``right``rready), \
.``left``rresp(``right``rresp), \
.``left``rdata(``right``rdata), \
.``left``rid(``right``rid), \
.``left``rlast(``right``rlast)



`define CONNECT_AXI_FULL_BUS(left, right) \
.``left``awvalid(``right``awvalid), \
.``left``awready(``right``awready), \
.``left``awaddr(``right``awaddr), \
.``left``awlen(``right``awlen), \
.``left``awsize(``right``awsize), \
.``left``awburst(``right``awburst), \
.``left``awid(``right``awid), \
.``left``awlock(``right``awid), \
.``left``awprot(``right``awid), \
\
.``left``wvalid(``right``wvalid), \
.``left``wready(``right``wready), \
.``left``wdata(``right``wdata), \
.``left``wstrb(``right``wstrb), \
.``left``wlast(``right``wlast), \
\
.``left``bvalid(``right``bvalid), \
.``left``bready(``right``bready), \
.``left``bresp(``right``bresp), \
.``left``bid(``right``bid), \
\
.``left``arvalid(``right``arvalid), \
.``left``arready(``right``arready), \
.``left``araddr(``right``araddr), \
.``left``arlen(``right``arlen), \
.``left``arsize(``right``arsize), \
.``left``arburst(``right``arburst), \
.``left``arid(``right``arid), \
.``left``arlock(``right``awid), \
.``left``arprot(``right``awid), \
\
.``left``rvalid(``right``rvalid), \
.``left``rready(``right``rready), \
.``left``rresp(``right``rresp), \
.``left``rdata(``right``rdata), \
.``left``rid(``right``rid), \
.``left``rlast(``right``rlast)


`define AXI_FULL_SIGNALS(prefix, addr_width, data_width, id_width) \
    logic           ``prefix``awvalid; \
    logic           ``prefix``awready; \
    logic  [``addr_width``-1:0] \
                        ``prefix``awaddr; \
    logic  [7:0]   ``prefix``awlen; \
    logic  [3-1:0] \
                        ``prefix``awsize; \
    logic  [1:0]    ``prefix``awburst; \
    logic           ``prefix``awlock; \
    logic  [``id_width``-1:0] \
                    ``prefix``awid; \
    logic  [2:0]    ``prefix``awprot; \
    \
    logic          ``prefix``wvalid; \
    logic           ``prefix``wready; \
    logic   [``data_width``-1:0] \
                    ``prefix``wdata; \
    logic   [(``data_width``/8)-1:0] \
                    ``prefix``wstrb; \
    logic           ``prefix``wlast; \
    \
    logic           ``prefix``bvalid; \
    logic           ``prefix``bready; \
    logic[1:0]      ``prefix``bresp; \
    logic[``id_width``-1:0] \
                    ``prefix``bid; \
    \
    logic           ``prefix``arvalid; \
    logic           ``prefix``arready; \
    logic   [``addr_width``-1:0] \
                    ``prefix``araddr; \
    logic   [7:0]   ``prefix``arlen; \
    logic   [3-1:0] \
                    ``prefix``arsize; \
    logic   [1:0]   ``prefix``arburst; \
    logic   [``id_width``-1:0] \
                    ``prefix``arid; \
    logic           ``prefix``arlock; \
    logic   [2:0]   ``prefix``arprot; \
    \
    logic           ``prefix``rvalid; \
    logic           ``prefix``rready; \
    logic [1:0]     ``prefix``rresp; \
    logic           ``prefix``rlast; \
    logic [``data_width``-1:0] \
                    ``prefix``rdata; \
    logic [``id_width``-1:0] \
                    ``prefix``rid;


`define AXI_FULL_IO_CLIENT(prefix, addr_width, data_width, id_width) \
    input wire          ``prefix``awvalid; \
    output logic        ``prefix``awready; \
    input wire  [``addr_width``-1:0] \
                        ``prefix``awaddr; \
    input wire  [7:0]   ``prefix``awlen; \
    input wire  [3-1:0] \
                        ``prefix``awsize; \
    input wire  [1:0]   ``prefix``awburst; \
    input wire          ``prefix``awlock; \
    input wire  [``id_width``-1:0] \
                        ``prefix``awid; \
    input wire  [2:0]   ``prefix``awprot; \
    \
    input wire          ``prefix``wvalid; \
    output logic        ``prefix``wready; \
    input wire   [``data_width``-1:0] \
                        ``prefix``wdata; \
    input wire   [(``data_width``/8)-1:0] \
                        ``prefix``wstrb; \
    input wire          ``prefix``wlast; \
    \
    output logic        ``prefix``bvalid; \
    input wire          ``prefix``bready; \
    output logic[1:0]   ``prefix``bresp; \
    output logic[``id_width``-1:0] \
                        ``prefix``bid; \
    \
    input wire          ``prefix``arvalid; \
    output logic        ``prefix``arready; \
    input wire   [``addr_width``-1:0] \
                        ``prefix``araddr; \
    input wire   [7:0]  ``prefix``arlen; \
    input wire   [3-1:0] \
                        ``prefix``arsize; \
    input wire   [1:0]  ``prefix``arburst; \
    input wire   [``id_width``-1:0] \
                        ``prefix``arid; \
    input wire          ``prefix``arlock; \
    input wire   [2:0]  ``prefix``arprot; \
    \
    output logic        ``prefix``rvalid; \
    input  wire         ``prefix``rready; \
    output logic [1:0]  ``prefix``rresp; \
    output logic        ``prefix``rlast; \
    output logic [``data_width``-1:0] \
                        ``prefix``rdata; \
    output logic [``id_width``-1:0] \
                        ``prefix``rid;


`define AXI_FULL_IO_HOST(prefix, addr_width, data_width, id_width) \
    output logic        ``prefix``awvalid; \
    input wire          ``prefix``awready; \
    output logic  [``addr_width``-1:0] \
                        ``prefix``awaddr; \
    output logic  [7:0] ``prefix``awlen; \
    output logic  [3-1:0] \
                        ``prefix``awsize; \
    output logic  [1:0] ``prefix``awburst; \
    output logic        ``prefix``awlock; \
    output logic  [``id_width``-1:0] \
                        ``prefix``awid; \
    output logic  [2:0] ``prefix``awprot; \
    \
    output logic        ``prefix``wvalid; \
    input wire          ``prefix``wready; \
    output logic   [``data_width``-1:0] \
                        ``prefix``wdata; \
    output logic   [(``data_width``/8)-1:0] \
                        ``prefix``wstrb; \
    output logic        ``prefix``wlast; \
    \
    input wire          ``prefix``bvalid; \
    output logic        ``prefix``bready; \
    input wire [1:0]    ``prefix``bresp; \
    input wire [``id_width``-1:0] \
                        ``prefix``bid; \
    \
    output logic        ``prefix``arvalid; \
    input wire          ``prefix``arready; \
    output logic   [``addr_width``-1:0] \
                        ``prefix``araddr; \
    output logic  [7:0] ``prefix``arlen; \
    output logic   [3-1:0] \
                        ``prefix``arsize; \
    output logic   [1:0]``prefix``arburst; \
    output logic   [``id_width``-1:0] \
                        ``prefix``arid; \
    output logic        ``prefix``arlock; \
    output logic  [2:0] ``prefix``arprot; \
    \
    input wire          ``prefix``rvalid; \
    output logic        ``prefix``rready; \
    input wire  [1:0]   ``prefix``rresp; \
    input wire          ``prefix``rlast; \
    input wire  [``data_width``-1:0] \
                        ``prefix``rdata; \
    input wire  [``id_width``-1:0] \
                        ``prefix``rid;

