class seq_item_uart extends uvm_sequence_item;

    `uvm_object_utils_begin(seq_item_uart)
        `uvm_field_int(tx_data, UVM_ALL_ON)
    `uvm_object_utils_end

    rand logic [7:0] tx_data;

    function new(string name = "seq_item_uart");
        super.new(name);
    endfunction

endclass
