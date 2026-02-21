module UART_tx (
    input logic         clk,
    input logic         rst,
    input logic         start_bit,
    input logic         tx_tick,
    input logic  [0:7]  data,

    output logic        tx_busy,
    output logic        tx_rdy,
    output logic        out
);

logic parity_bit,start_bit,end_bit,output_bit;

 
//tx states.
typedef enum logic [1:0] {
        IDLE,   // 00
        START,  // 01
        DATA,   // 10
        STOP    // 11
} state_t;

state_t curr_state,nxt_state;


// TX state machine.


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end
always @(posedge clk, negedge rst)begin
    nxt_state = curr_state;
        case (curr_state) 
            IDLE:begin
                if(start_bit)begin
                    nxt_state = START;
                end else begin
                 nxt_state = IDLE
                end
            end
            START:begin
                
                nxt_state = DATA;
            end
            DATA:begin
                
                nxt_state = STOP;
            end
            STOP:begin
                
                nxt_state = IDLE;
            end


            
        endcase
    end


endmodule