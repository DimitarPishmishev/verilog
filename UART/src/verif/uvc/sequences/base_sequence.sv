class base_sequence extends uvm_sequence #(seq_item_uart);

    `uvm_object_utils(base_sequence)

    int num_items = 10;

    function new(string name = "base_sequence");
        super.new(name);
    endfunction

    task body();
        repeat (num_items) begin
            req = seq_item_uart::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask

endclass
