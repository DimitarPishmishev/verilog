class environment extends uvm_env;
    `uvm_component_utils(environment)
    
    virtual interface_uart vif_u1;
    virtual interface_uart vif_u2;

    agent agent1;
    agent agent2;
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
    
            if (!uvm_config_db#(virtual interface_uart)::get(this, "env_h", "vif", vif_u1))
                `uvm_fatal(get_type_name(), "Could not get vif_u1 from config_db!")
            if (!uvm_config_db#(virtual interface_uart)::get(this, "env_h", "vif", vif_u2))
                `uvm_fatal(get_type_name(), "Could not get vif_u2 from config_db!")
    
            agent1 = agent::type_id::create("agent1", this);
            agent2 = agent::type_id::create("agent2", this);
        endfunction
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void connect_phase(uvm_phase phase);
        

    endfunction


endclass