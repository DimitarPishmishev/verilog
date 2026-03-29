`timescale 1ns/1ps

module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire       tick,
    input  wire [7:0] data_in,
    output reg        tx_reg,
    output wire       tx_done
);
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;

    reg [3:0] tick_count;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    assign tx_done = (state == IDLE);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            tx_reg <= 1'b1;
        end else if (tick) begin
            case (state)
                IDLE: begin
                    tx_reg <= 1'b1;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        tick_count <= 0;
                        state <= START;
                    end
                end
                START: begin
                    tx_reg <= 1'b0;
                    if (tick_count == 15) begin
                        tick_count <= 0;
                        bit_count <= 0;
                        state <= DATA;
                    end else tick_count <= tick_count + 1;
                end
                DATA: begin
                    tx_reg <= shift_reg[0];
                    if (tick_count == 15) begin
                        tick_count <= 0;
                        if (bit_count == 7) begin
                            state <= STOP;
                        end else begin
                            shift_reg <= {1'b0, shift_reg[7:1]};
                            bit_count <= bit_count + 1;
                        end
                    end else tick_count <= tick_count + 1;
                end
                STOP: begin
                    tx_reg <= 1'b1;
                    if (tick_count == 15) state <= IDLE;
                    else tick_count <= tick_count + 1;
                end
            endcase
        end
    end
endmodule