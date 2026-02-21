module UART_c #(
    parameter int BAUD_RATE=4800,
    parameter int CLK_FREQ=50000000
    )(
    input logic         clk,
    input logic         rst,
    input logic         start_bit,
    input logic  [0:7]  data_in,
    input logic         rx_in,

    output logic        data_out_tx,
    output logic        tx_busy,
    output logic        rx_done,
    output logic [0:7]  data_out_rx
);

localparam MAX_COUNT = CLK_FREQ/BAUD_RATE;

//tx internal signals.
logic tx_tick;
logic rx_tick;
logic tx_rdy;




//Instances
uart_sync #(.MAX_COUNT(MAX_COUNT)
            ) u_uart_sync(
            .clk     	(clk),
            .rst        (rst),
            .tx_tick 	(tx_tick),
            .rx_tick 	(rx_tick)
);

UART_tx u_UART_tx(
    .data       (data_in),
    .clk        (clk),
    .rst        (rst),
    .start_bit  (start_bit),
    .tx_tick    (tx_tick),

    .tx_busy    (tx_busy),
    .tx_rdy     (tx_rdy),
    .out  	    (data_out_tx)
);


endmodule