
////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
////////////////////////////////////////////////////////////////////////////////

`ifndef MAXIMUM_ERRORS
    `define MAXIMUM_ERRORS 1
`endif
//verilator lint_off UNUSED
integer assert_errors = 0;
// verilator lint_on UNUSED


`define assert(expr) \
    if ((!(expr)) === 1) begin \
        $display("[%d] !ERROR! ASSERTION FAILED in %m: ", $time, expr); \
        assert_errors = assert_errors + 1; \
        if(assert_errors == `MAXIMUM_ERRORS) \
            $fatal; \
    end


`define assert_equal(signal, value) \
        if ((signal) !== (value)) begin \
            $display("[%d] !ERROR! ASSERTION FAILED in %m: signal(%d) != value(%d)", $time, signal, value); \
            assert_errors = assert_errors + 1; \
            if(assert_errors == `MAXIMUM_ERRORS) \
                $fatal; \
        end

`define assert_finish if(assert_errors > 0) $fatal; else $finish;