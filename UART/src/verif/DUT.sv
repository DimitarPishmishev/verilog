`timescale 1ns/1ps


module dut #(
    parameter int CLK_FREQ = 50000000,
    parameter int BAUD_RATE = 115200
) (
    interface_uart uart_if0,
    interface_uart uart_if1
);

    // Instance 0 uses uart_if0 signals
    uart_top #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) uart_inst0 (
        .clk   (uart_if0.clk),
        .rst   (uart_if0.rst),
        .tx_data (uart_if0.tx_data),
        .tx_start(uart_if0.tx_start),
        .tx_pin  (uart_if0.tx_pin),
        .tx_done (uart_if0.tx_done),
        .rx_pin  (uart_if0.rx_pin),
        .rx_data (uart_if0.rx_data),
        .rx_done (uart_if0.rx_done)
    );

    // Instance 1 uses uart_if1 signals
    uart_top #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) uart_inst1 (
        .clk   (uart_if1.clk),
        .rst   (uart_if1.rst),
        .tx_data (uart_if1.tx_data),
        .tx_start(uart_if1.tx_start),
        .tx_pin  (uart_if1.tx_pin),
        .tx_done (uart_if1.tx_done),
        .rx_pin  (uart_if1.rx_pin),
        .rx_data (uart_if1.rx_data),
        .rx_done (uart_if1.rx_done)
    );

endmodule
