// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
module tb_coffee_machine;
    reg clk=0, reset;
    reg [1:0] coin_in;
    reg coin_inserted;
    wire dispense;
    wire [3:0] change;

    coffee_machine dut (
        .clk(clk), .reset(reset),
        .coin_in(coin_in),
        .coin_inserted(coin_inserted),
        .dispense(dispense), .change(change)
    );

    always #5 clk = ~clk; // 10ns period

    initial begin
        $dumpfile("coffee.vcd");
        $dumpvars(0, tb_coffee_machine);
        reset = 1; coin_in=0; coin_inserted=0; #12;
        reset = 0; #10;

        // 2+3+2 = 7
        coin_in=2'b10; coin_inserted=1; #10; coin_inserted=0; #10;
        coin_in=2'b11; coin_inserted=1; #10; coin_inserted=0; #10;
        coin_in=2'b10; coin_inserted=1; #10; coin_inserted=0; #10;
        #20;

        // 3+3+2 = 8 -> change 1
        coin_in=2'b11; coin_inserted=1; #10; coin_inserted=0; #10;
        coin_in=2'b11; coin_inserted=1; #10; coin_inserted=0; #10;
        coin_in=2'b10; coin_inserted=1; #10; coin_inserted=0; #10;
        #20;

        $finish;
    end

    always @(posedge clk) begin
        $display("t=%0t coin=%b ins=%b disp=%b change=%0d", $time, coin_in, coin_inserted, dispense, change);
    end
endmodule
