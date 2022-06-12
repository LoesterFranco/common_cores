////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2016-2022, Arman Avetisyan
// 
////////////////////////////////////////////////////////////////////////////////


#include <verilated.h>
#include <verilated_vcd_c.h>
#include <iostream>


vluint64_t simulation_time = 0;

using namespace std;

#ifdef TRACE
VerilatedVcdC	*m_trace;
#endif

#ifndef TOP_MODULE_DECLARATION
#error "Top module declaration macro definition missing"
#endif

TOP_MODULE_DECLARATION;

bool error_happened;
string current_test;

double sc_time_stamp() {
    return simulation_time;  // Note does conversion to real, to match SystemC
}

void dump_step() {
    simulation_time++;
    #ifdef TRACE
    m_trace->dump(simulation_time);
    #endif
}


void update() {
    TOP->eval();
    dump_step();
}

void posedge() {
    TOP->clk = 1;
    update();
    update();
}

void till_user_update() {
    TOP->clk = 0;
    update();
}
void after_user_update() {
    update();
}

void next_cycle() {
    after_user_update();

    posedge();
    till_user_update();
}

void start_test(string c) {
    cout << "[" << to_string(simulation_time) << "]" << "[Testbench] Starting test: " << c << endl;
    current_test = c;
}

#define check_equal(first, second)  \
    if((first != second)) { \
        cout << "%Error: Check failed: " \
            << #first  << "( " << int(first) << ") does not equal " \
            << #second  << "( " << int(second) << ") " \
            << ", Test: " << current_test << endl; \
        cout << "cycle: " << simulation_time << endl; \
        throw runtime_error("eqaul check failed"); \
    }


#define check(match, msg) \
    if(!(match)) { \
        cout << "%Error: Check failed: " << #match << ", Test: " << current_test << endl; \
        cout << "cycle: " << simulation_time << endl; \
        cout << "Message: " << msg << endl; \
        throw runtime_error(msg); \
    }


