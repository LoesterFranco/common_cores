////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2021, Arman Avetisyan
// 
////////////////////////////////////////////////////////////////////////////////

#include <Varmleo_regfile_2r1w.h>

#define TOP_ALLOCATION armleo_regfile_2r1w = new Varmleo_regfile_2r1w;
#define TOP_MODULE_DECLARATION Varmleo_regfile_2r1w* armleo_regfile_2r1w;
#define TOP armleo_regfile_2r1w
#define TRACE

#include <verilator_template_header.cpp>

uint32_t testnum = 0;


#include <verilator_template_main_start.cpp>
    armleo_regfile_2r1w->rst_n = 0;
    armleo_regfile_2r1w->rd_write = 0;
    armleo_regfile_2r1w->rd_addr = 10; // Random addr
    armleo_regfile_2r1w->rd_wdata = 50;
    next_cycle();

    armleo_regfile_2r1w->rst_n = 1;
    armleo_regfile_2r1w->rs1_read = 1;
    armleo_regfile_2r1w->rs2_read = 1;
    next_cycle();

    for(int i = 0; i < 32; i++) {
        testnum = i;
        uint32_t val = i | (i << 8) | (i << 16) | (i << 24);
        armleo_regfile_2r1w->rd_write = 1;
        armleo_regfile_2r1w->rd_addr = i;
        armleo_regfile_2r1w->rd_wdata = val;
        next_cycle();

        armleo_regfile_2r1w->rd_write = 0;
        armleo_regfile_2r1w->rs1_addr = i;
        armleo_regfile_2r1w->rs2_addr = i;

        next_cycle();
        check(armleo_regfile_2r1w->rs1_rdata == val, "RS1_RDATA: Incorrect");
        check(armleo_regfile_2r1w->rs2_rdata == val, "RS2_RDATA: Incorrect");
        next_cycle();
    
        
    }

    
    for(int i = 0; i < 32; i++) {
        testnum = 100 + i;
        uint32_t val = i | (i << 8) | (i << 16) | (i << 24);
        armleo_regfile_2r1w->rd_write = 0;
        armleo_regfile_2r1w->rs1_addr = i;
        armleo_regfile_2r1w->rs2_addr = i;
        next_cycle();

        check(armleo_regfile_2r1w->rs1_rdata == val, "RS1_RDATA: Incorrect");
        check(armleo_regfile_2r1w->rs2_rdata == val, "RS2_RDATA: Incorrect");
        next_cycle();
    
        
    }

    cout << "Regfile tests done" << endl;

#include <verilator_template_footer.cpp>
    