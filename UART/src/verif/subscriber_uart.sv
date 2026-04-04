class subscriber_uart extends uvm_subscriber #(seq_item_uart);

    `uvm_component_utils(subscriber_uart)

    covergroup uart_cg;
        tx_data_cp: coverpoint item.tx_data {
            bins low    = {[0:63]};
            bins mid    = {[64:191]};
            bins high   = {[192:255]};
        }
    endgroup

    seq_item_uart item;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        uart_cg = new();
    endfunction

    function void write(seq_item_uart t);
        item = t;
        uart_cg.sample();
        `uvm_info(get_type_name(), $sformatf("Coverage sampled: %0h", t.tx_data), UVM_HIGH)
    endfunction

endclass
