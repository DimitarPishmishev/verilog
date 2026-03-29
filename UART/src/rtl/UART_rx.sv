`timescale 1ns/1ps

module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx_in,
    input  wire       tick,
    output reg [7:0]  data_out,
    output reg        rx_done
);
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;

    reg [3:0] tick_count;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            rx_done <= 0;
            data_out <= 8'b0;
        end else if (tick) begin
            case (state)
                IDLE: begin
                    rx_done <= 0;
                    tick_count <= 0;
                    if (rx_in == 1'b0) state <= START;
                end
                START: begin
                    if (tick_count == 7) begin
                        tick_count <= 0;
                        bit_count <= 0;
                        state <= DATA;
                    end else tick_count <= tick_count + 1;
                end
                DATA: begin
                    if (tick_count == 15) begin 
                        tick_count <= 0;
                        shift_reg <= {rx_in, shift_reg[7:1]};
                        if (bit_count == 7) state <= STOP;
                        else bit_count <= bit_count + 1;
                    end else tick_count <= tick_count + 1;
                end
                STOP: begin
                    if (tick_count == 15) begin
                        data_out <= shift_reg;
                        rx_done <= 1'b1;
                        state <= IDLE;
                    end else tick_count <= tick_count + 1;
                end
            endcase
        end
    end
endmodule