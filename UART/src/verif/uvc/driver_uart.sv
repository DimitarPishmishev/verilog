class driver_uart extends uvm_driver #(seq_item_uart);

    `uvm_component_utils(driver_uart)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual interface_uart vif;


    task run_phase(uvm_phase phase);
      `uvm_info(get_type_name(), "Driver waiting for reset...", UVM_LOW)
      wait(vif.rst === 1'b1);
      `uvm_info(get_type_name(), "Driver reset done, starting...", UVM_LOW)
      forever begin
        seq_item_port.get_next_item(req);
        `uvm_info(get_type_name(), $sformatf("Driving tx_data=%0h", req.tx_data), UVM_LOW)

        @(vif.drv_cb);
        vif.drv_cb.tx_data  <= req.tx_data;
        vif.drv_cb.tx_start <= 1'b1;

        wait(vif.tx_done == 1'b0);
        vif.drv_cb.tx_start <= 1'b0;

        wait(vif.tx_done == 1'b1);

        `uvm_info(get_type_name(), "TX done", UVM_LOW)
        seq_item_port.item_done();
      end
    endtask
    



endclass