module serializer_stage #(
    parameter INPUT_WIDTH = 8
)(
    input  wire                     clk,      
    input  wire                     rst,
    input  wire                     sel,      
    input  wire [INPUT_WIDTH-1:0]   data_in,
    output wire [(INPUT_WIDTH/2)-1:0] data_out
);
    localparam OUT_WIDTH = INPUT_WIDTH / 2;
    reg [OUT_WIDTH-1:0] reg_pos;
    reg [OUT_WIDTH-1:0] reg_neg;

    always @(posedge clk or posedge rst) begin
        if (rst) reg_pos <= 0;
        else     reg_pos <= data_in[OUT_WIDTH-1:0];
    end

    always @(negedge clk or posedge rst) begin
        if (rst) reg_neg <= 0;
        else     reg_neg <= data_in[INPUT_WIDTH-1:OUT_WIDTH];
    end

    assign data_out = sel ? reg_pos : reg_neg;

endmodule
