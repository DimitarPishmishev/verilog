class environment extends uvm_env;

    `uvm_component_utils(environment)
    
    virtual interface_uart vif_u1;
    virtual interface_uart vif_u2;

    agent_uart agent1;
    agent_uart agent2;
    scoreboard_uart scb;
    subscriber_uart sub;
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
    
            if (!uvm_config_db#(virtual interface_uart)::get(this, "", "vif1", vif_u1))
                `uvm_fatal(get_type_name(), "Could not get vif_u1 from config_db!")
            if (!uvm_config_db#(virtual interface_uart)::get(this, "", "vif2", vif_u2))
                `uvm_fatal(get_type_name(), "Could not get vif_u2 from config_db!")
    
            uvm_config_db#(virtual interface_uart)::set(this, "agent1", "vif", vif_u1);
            uvm_config_db#(virtual interface_uart)::set(this, "agent2", "vif", vif_u2);

            agent1 = agent_uart::type_id::create("agent1", this);
            agent2 = agent_uart::type_id::create("agent2", this);
            scb = scoreboard_uart::type_id::create("scb", this);
            sub = subscriber_uart::type_id::create("sub", this);

        endfunction
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent1.mon.ap.connect(scb.expected_export);
        agent2.mon.ap.connect(scb.actual_export);
        agent2.mon.ap.connect(sub.analysis_export);
    endfunction

endclass


