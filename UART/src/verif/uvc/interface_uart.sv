interface interface_uart;
    logic clk;
    logic rst;

    // TX side (TB drives tx_data/tx_start, DUT drives tx_pin/tx_done)
    logic [7:0] tx_data;
    logic       tx_start;
    logic       tx_pin;
    logic       tx_done;

    // RX side (TB drives rx_pin, DUT drives rx_data/rx_done)
    logic       rx_pin;
    logic [7:0] rx_data;
    logic       rx_done;

    // Clocking block for driver - drives inputs to DUT
    clocking drv_cb @(posedge clk);
        default input #1 output #1;
        output tx_data, tx_start;
        output rx_pin;
        input  tx_pin, tx_done;
        input  rx_data, rx_done;
    endclocking

    // Clocking block for monitor - only observes
    clocking mon_cb @(posedge clk);
        default input #1;
        input tx_data, tx_start, tx_pin, tx_done;
        input rx_pin, rx_data, rx_done;
    endclocking

    modport DRV (clocking drv_cb, input clk, input rst);
    modport MON (clocking mon_cb, input clk, input rst);

endinterface
