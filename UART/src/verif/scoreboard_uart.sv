`uvm_analysis_imp_decl(_expected)
`uvm_analysis_imp_decl(_actual)

class scoreboard_uart extends uvm_scoreboard;

    `uvm_component_utils(scoreboard_uart)

    uvm_analysis_imp_expected #(seq_item_uart, scoreboard_uart) expected_export;
    uvm_analysis_imp_actual   #(seq_item_uart, scoreboard_uart) actual_export;

    seq_item_uart expected_q[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        expected_export = new("expected_export", this);
        actual_export   = new("actual_export", this);
    endfunction

    function void write_expected(seq_item_uart item);
        expected_q.push_back(item);
    endfunction

    function void write_actual(seq_item_uart item);
        seq_item_uart exp;
        if (expected_q.size() == 0) begin
            `uvm_error(get_type_name(), "Received actual item but expected queue is empty!")
            return;
        end
        exp = expected_q.pop_front();
        if (exp.tx_data !== item.tx_data) begin
            `uvm_error(get_type_name(), $sformatf("MISMATCH: expected=%0h, actual=%0h", exp.tx_data, item.tx_data))
        end else begin
            `uvm_info(get_type_name(), $sformatf("MATCH: %0h", item.tx_data), UVM_MEDIUM)
        end
    endfunction

    function void check_phase(uvm_phase phase);
        if (expected_q.size() > 0)
            `uvm_error(get_type_name(), $sformatf("%0d expected items never received!", expected_q.size()))
    endfunction

endclass
