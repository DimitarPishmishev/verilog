

class agent_uart extends uvm_agent;

  `uvm_component_utils(agent_uart)

    virtual interface_uart vif;

    monitor_uart mon;
    sequencer_uart seqr;
    driver_uart drv;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual interface_uart)::get(this, "", "vif", vif))
        `uvm_fatal(get_type_name(), "Could not get vif from config_db in the agent!")

    mon = monitor_uart::type_id::create("mon",this);
    seqr = sequencer_uart::type_id::create("seqr",this);
    drv = driver_uart::type_id::create("drv",this);


    endfunction

    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    drv.vif = vif;
    mon.vif = vif;

    endfunction


endclass