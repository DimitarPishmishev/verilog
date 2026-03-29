module tx_top (
    input logic         clk,
    input logic         rst_n,
    input logic         tx_tick,
    input logic [7:0]   tx_data,
    input logic         tx_valid,
    output logic        tx_ready,
    output logic        tx_out,
    output logic        tx_busy
);

        serializer u_serializer (
        .clk        (clk),
        .rst_n      (rst_n),
        .tx_tick    (tx_tick),
        .tx_data    (tx_data),
        .tx_valid   (tx_valid),
        .tx_ready   (tx_ready),
        .tx_out     (tx_out),
        .tx_busy    (tx_busy)
    );




endmodule