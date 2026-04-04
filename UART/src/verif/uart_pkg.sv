`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

package uart_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uvc/seq_item_uart.sv"
    `include "uvc/sequencer_uart.sv"
    `include "uvc/driver_uart.sv"
    `include "uvc/monitor_uart.sv"
    `include "uvc/agent_uart.sv"
    `include "uvc/sequences/base_sequence.sv"
    `include "scoreboard_uart.sv"
    `include "subscriber_uart.sv"
    `include "enivornment.sv"
    `include "tests/base_test_uart.sv"

endpackage
