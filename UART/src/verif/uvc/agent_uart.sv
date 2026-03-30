class agent extends uvm_agent;


virtual interface_uart();

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


endclass