
module serializer_8bit_internal_clk (
    input  wire       clk,      
    input  wire       rst,
    input  wire [7:0] pDataIn,
    output wire       ser_out
);

    reg [1:0] clk_divider;
    
    always @(posedge clk or posedge rst) begin
        if (rst) clk_divider <= 2'b0;
        else     clk_divider <= clk_divider + 1'b1;
    end

    wire d2_clk = clk_divider[0]; 
    wire d4_clk = clk_divider[1]; 

    reg sel1, sel2, sel3_pre;
    wire sel3;

    always @(posedge d2_clk or posedge rst) 
        if (rst) sel1 <= 0; else sel1 <= ~sel1;

    always @(posedge clk or posedge rst) 
        if (rst) sel2 <= 0; else sel2 <= ~sel2;

    always @(posedge clk or posedge rst) 
        if (rst) sel3_pre <= 0; else sel3_pre <= ~sel3_pre;
    
    assign sel3 = sel2 ^ sel3_pre;

    wire [3:0] stage1_to_2;
    wire [1:0] stage2_to_3;

    serializer_stage #(.INPUT_WIDTH(8)) stg1 (
        .clk     (d4_clk),
        .rst     (rst),
        .sel     (sel1),
        .data_in (pDataIn),
        .data_out(stage1_to_2)
    );

    serializer_stage #(.INPUT_WIDTH(4)) stg2 (
        .clk     (d2_clk),
        .rst     (rst),
        .sel     (sel2),
        .data_in (stage1_to_2),
        .data_out(stage2_to_3)
    );

    serializer_stage #(.INPUT_WIDTH(2)) stg3 (
        .clk     (clk),
        .rst     (rst),
        .sel     (sel3),
        .data_in (stage2_to_3),
        .data_out(ser_out)
    );

endmodule



