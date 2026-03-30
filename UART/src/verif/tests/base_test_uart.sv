class base_test extends uvm_test;


    `uvm_component_utils(base_test)

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Building base_test", UVM_LOW)
        
        enivornment env_h;
        env_h = enivornment::type_id::create("env_h", this);

        if (! uvm_config_db #(virtual interface_uart) :: get (this, "", "dut_if", m_cfg0.vif)) begin
         `uvm_fatal (get_type_name (), "DUT Interface not found !")
        end

    endfunction
    
endclass