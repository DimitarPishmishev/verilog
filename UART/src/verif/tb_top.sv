`timescale 1ns/1ps

module tb_top();

    // Parameters for testing
    localparam CLK_PERIOD = 20; // 50 MHz clock
    localparam BAUD_RATE  = 9600;
    localparam CLK_FREQ   = 50_000_000;
    localparam MAX_COUNT  = CLK_FREQ / BAUD_RATE;

    // Signals
    logic clk = 0;
    logic rst;
    logic tx_tick;
    logic rx_tick;

    // 1. Clock Generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // 2. Instantiate the Unit Under Test (UUT)
    uart_sync #(.MAX_COUNT(MAX_COUNT)) uut (
        .clk(clk),
        .rst(rst),
        .tx_tick(tx_tick),
        .rx_tick(rx_tick)
    );

    // 3. Stimulus
    initial begin
        $display("Starting UART Sync TB...");
        $display("Targeting MAX_COUNT: %d", MAX_COUNT);
        
        // Initial Reset
        rst = 0;
        #(CLK_PERIOD * 5);
        rst = 1;

        // Run for a "lot" of cycles
        // Enough to see several TX ticks (which are slow)
        repeat (MAX_COUNT * 5) @(posedge clk);

        $display("Simulation Finished.");
        $finish;
    end

    // 4. Optional: Simple Monitors to see pulses in console
    always @(posedge tx_tick) $display("TX Tick at time %t", $time);

endmodule