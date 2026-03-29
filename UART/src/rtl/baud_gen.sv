`timescale 1ns/1ps

module baud_gen #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst,
    output wire tick
);
   
    localparam MAX_COUNT = CLK_FREQ / (BAUD_RATE * 16);
    reg [15:0] count;

    always @(posedge clk or negedge rst) begin
        if (!rst) 
            count <= 16'b0;
        else if (count >= (MAX_COUNT - 1))
            count <= 16'b0;
        else 
            count <= count + 1'b1;
    end

    assign tick = (count == (MAX_COUNT - 1));
endmodule