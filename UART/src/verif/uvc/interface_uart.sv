    interface interface_uart;
        logic clk;
        logic rst;

        logic [7:0] tx_data;
        logic       tx_start;
        logic       tx_pin;
        logic       tx_done;

        logic       rx_pin;
        logic [7:0] rx_data;
        logic       rx_done;
    endinterface
