`timescale 1ns/1ps

module uart_top #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output wire       tx_pin,
    output wire       tx_done,
    input  wire       rx_pin,
    output wire [7:0] rx_data,
    output wire       rx_done
);
    wire tick;

    baud_gen #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) bgen (
        .clk(clk), .rst(rst), .tick(tick)
    );

    uart_tx transmitter (
        .clk(clk), .rst(rst), .tick(tick),
        .tx_start(tx_start), .data_in(tx_data),
        .tx_reg(tx_pin), .tx_done(tx_done)
    );

    uart_rx receiver (
        .clk(clk), .rst(rst), .tick(tick),
        .rx_in(rx_pin), .data_out(rx_data),
        .rx_done(rx_done)
    );
endmodule