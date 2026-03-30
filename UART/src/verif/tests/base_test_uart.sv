class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    enivornment env_h;
    virtual interface_uart vif_u1;
    virtual interface_uart vif_u2;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual interface_uart)::get(this, "", "intf_u1", vif_u1))
            `uvm_fatal(get_type_name(), "Could not get intf_u1 from config_db!")
        if (!uvm_config_db#(virtual interface_uart)::get(this, "", "intf_u2", vif_u2))
            `uvm_fatal(get_type_name(), "Could not get intf_u2 from config_db!")

        uvm_config_db#(virtual interface_uart)::set(this, "env_h", "vif1", vif_u1);
        uvm_config_db#(virtual interface_uart)::set(this, "env_h", "vif2", vif_u2);

        env_h = environment::type_id::create("env_h", this);

        `uvm_info(get_type_name(), "base_test build_phase complete", UVM_LOW)
    endfunction



    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        super.run_phase(phase);
  

        phase.drop_objection(this);
        `uvm_info(get_type_name(), "base_test run_phase complete", UVM_LOW)
    endtask


endclass