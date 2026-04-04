class sequencer_uart extends uvm_sequencer #(seq_item_uart);

    `uvm_component_utils(sequencer_uart)
    

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction



endclass