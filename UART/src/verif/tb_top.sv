`timescale 1ns/1ps

module tb_top();

interface_uart intf_u1_h;
interface_uart intf_u2_h;


uart_top u_uart_top_0(
    .clk      (intf_u1_h.clk),
    .rst      (intf_u1_h.rst),
    .tx_data  (intf_u1_h.tx_data),
    .tx_start (intf_u1_h.tx_start),
    .tx_pin   (intf_u1_h.tx_pin),   
    .tx_done  (intf_u1_h.tx_done),
    .rx_pin   (intf_u2_h.tx_pin),   
    .rx_data  (intf_u1_h.rx_data),
    .rx_done  (intf_u1_h.rx_done)
);


uart_top u_uart_top_1(
    .clk      (intf_u2_h.clk),
    .rst      (intf_u2_h.rst),
    .tx_data  (intf_u2_h.tx_data),
    .tx_start (intf_u2_h.tx_start),
    .tx_pin   (intf_u2_h.tx_pin),   
    .tx_done  (intf_u2_h.tx_done),
    .rx_pin   (intf_u1_h.tx_pin),  
    .rx_data  (intf_u2_h.rx_data),
    .rx_done  (intf_u2_h.rx_done)
);
always #10 intf_u1_h.clk = ~intf_u1_h.clk;
assign intf_u2_h.clk = intf_u1_h.clk;

initial begin







    #10;
    $finish;
end



endmodule