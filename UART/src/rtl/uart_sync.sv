`timescale 1ns/1ps

module uart_sync#(
    parameter MAX_COUNT
)(
    input logic clk,
    input logic rst,
    output logic tx_tick,
    output logic rx_tick
);

logic [$clog2(MAX_COUNT)-1:0] tx_count;
logic [$clog2(MAX_COUNT/16)-1:0] rx_count;

always @(posedge clk ,negedge rst) begin
    if (!rst) begin
        rx_count <= 0;
        rx_tick  <= 1'b0;
    end else begin
        if (rx_count == (MAX_COUNT/16) - 1) begin
            rx_count <= 0;
            rx_tick  <= 1'b1; 
        end else begin
            rx_count <= rx_count + 1;
            rx_tick  <= 1'b0;
        end
    end
end


always @(posedge clk ,negedge rst) begin
    if (!rst) begin
        tx_count <= 0;
        tx_tick  <= 1'b0;
    end else begin
        if (tx_count == MAX_COUNT - 1) begin
            tx_count <= 0;
            tx_tick  <= 1'b1; 
        end else begin
            tx_count <= tx_count + 1;
            tx_tick  <= 1'b0;
        end
    end
end




endmodule