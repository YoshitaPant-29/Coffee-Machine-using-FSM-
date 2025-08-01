module coffee_machine (
    input        clk,
    input        reset,          // active-high async
    input  [1:0] coin_in,        // 01=1,10=2,11=3
    input        coin_inserted,  // pulse per coin
    output reg   dispense,
    output reg [3:0] change
);

    parameter IDLE=2'b00, COUNTING=2'b01, DISPENSE=2'b10;
    reg [1:0] state, next_state;
    reg [3:0] total;
    wire [3:0] coin_value = (coin_in==2'b01)?4'd1 :
                            (coin_in==2'b10)?4'd2 :
                            (coin_in==2'b11)?4'd3 : 4'd0;

    // State update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            total <= 0;
        end else begin
            state <= next_state;
            if (state==IDLE && coin_inserted && coin_value>0)
                total <= coin_value;
            else if (state==COUNTING && coin_inserted && coin_value>0)
                total <= total + coin_value;
            else if (state==DISPENSE)
                total <= 0;
        end
    end

    // Next state / outputs (Moore)
    always @(*) begin
        next_state = state;
        dispense = 0;
        change = 0;
        case (state)
            IDLE: if (coin_inserted && coin_value>0) next_state = COUNTING;
            COUNTING: if (coin_inserted && coin_value>0) begin
                          if (total + coin_value >= 7) next_state = DISPENSE;
                      end
            DISPENSE: begin
                dispense = 1;
                if (total >= 7) change = total - 7;
                next_state = IDLE;
            end
        endcase
    end

endmodule
