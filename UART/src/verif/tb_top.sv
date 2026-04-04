`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import uart_pkg::*;

module tb_top();

interface_uart intf_u1_h();
interface_uart intf_u2_h();

dut #(
    .CLK_FREQ(50000000),
    .BAUD_RATE(115200)
) dut_inst (
    .uart_if0(intf_u1_h),
    .uart_if1(intf_u2_h)
);


assign intf_u1_h.rx_pin = intf_u2_h.tx_pin;
assign intf_u2_h.rx_pin = intf_u1_h.tx_pin;

initial begin
    intf_u1_h.clk = 0;
end
always #10 intf_u1_h.clk = ~intf_u1_h.clk;
assign intf_u2_h.clk = intf_u1_h.clk;

// Reset
initial begin
    intf_u1_h.rst = 0;
    intf_u2_h.rst = 0;
    #100;
    intf_u1_h.rst = 1;
    intf_u2_h.rst = 1;
end

initial begin
    uvm_config_db#(virtual interface_uart)::set(null, "*", "intf_u1", intf_u1_h);
    uvm_config_db#(virtual interface_uart)::set(null, "*", "intf_u2", intf_u2_h);
    run_test("base_test");
end

endmodule