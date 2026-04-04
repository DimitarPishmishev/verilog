class monitor_uart extends uvm_monitor;

`uvm_component_utils(monitor_uart)

virtual interface_uart vif;
uvm_analysis_port #(seq_item_uart) ap;
seq_item_uart item;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
endfunction


task run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.mon_cb.rx_done);
        
        item = seq_item_uart::type_id::create("item");
        item.tx_data = vif.mon_cb.rx_data;
        
        ap.write(item);
        `uvm_info(get_type_name(), $sformatf("Captured: %0h", item.tx_data), UVM_MEDIUM)
    end

endtask



endclass






