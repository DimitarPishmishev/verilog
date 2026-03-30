`timescale 1ns/1ps

module tb_top();

interface_uart intf_u1_h;
interface_uart intf_u2_h;


dut #(.CLK_FREQ(50000000), .BAUD_RATE(115200)) u_dut (
    .uart_if0(intf_u1_h),
    .uart_if1(intf_u2_h)
);
always #10 intf_u1_h.clk = ~intf_u1_h.clk;
assign intf_u2_h.clk = intf_u1_h.clk;

initial begin
    uvm_config_db#(interface_uart)::set(null, "base_test", "uart_if", intf_u1_h);
    uvm_config_db#(interface_uart)::set(null, "base_test", "uart_if", intf_u2_h);
    #10;

    run_test ("base_test");



    #10;
    $finish;
end



endmodule