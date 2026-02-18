module tb_and_gate;
    logic a, b;
    logic y;

    // Instantiate the AND gate
    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $display("--- Starting AND Gate Simulation ---");
        
        // Test Case 1: 0 & 0
        a = 0; b = 0; #10;
        $display("a=%b b=%b -> y=%b", a, b, y);

        // Test Case 2: 0 & 1
        a = 0; b = 1; #10;
        $display("a=%b b=%b -> y=%b", a, b, y);

        // Test Case 3: 1 & 1
        a = 1; b = 1; #10;
        $display("a=%b b=%b -> y=%b", a, b, y);

        $display("--- Simulation Finished ---");
        $finish;
    end
endmodule