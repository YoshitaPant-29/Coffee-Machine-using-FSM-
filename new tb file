`timescale 1ns/1ps

module coffee_machine_tb;

    reg clk, reset, coin_inserted, test, milk_present;
    reg [1:0] coin_in;
    wire dispense;
    wire [3:0] change;

    coffee_machine uut (
        .clk(clk),
        .reset(reset),
        .coin_in(coin_in),
        .coin_inserted(coin_inserted),
        .test(test),
        .milk_present(milk_present),
        .dispense(dispense),
        .change(change)
    );

    // Clock
    always #5 clk = ~clk;

    // Task to insert coin
    task insert_coin(input [1:0] coin);
    begin
        coin_in = coin;
        coin_inserted = 1;
        #10;
        coin_inserted = 0;
        #10;
    end
    endtask

    initial begin
        $dumpfile("coffee_machine_tb.vcd");
        $dumpvars(0, coffee_machine_tb);

        clk = 0;
        reset = 1;
        coin_in = 2'b00;
        coin_inserted = 0;
        test = 0;
        milk_present = 1;

        #20 reset = 0;

        // 1. Power OFF test
        insert_coin(2'b01); // Won't count
        #20;

        // 2. Power ON + exact payment (7)
        test = 1;
        insert_coin(2'b10); // +2
        insert_coin(2'b11); // +3
        insert_coin(2'b01); // +1 (total 6)
        insert_coin(2'b01); // +1 (total 7) -> Dispense
        #20;

        // 3. Overpayment (8) with change
        insert_coin(2'b11); // +3
        insert_coin(2'b11); // +3
        insert_coin(2'b10); // +2 (total 8) -> Change=1
        #20;

        // 4. Back-to-back orders
        insert_coin(2'b11);
        insert_coin(2'b11);
        insert_coin(2'b01);
        #20;
        insert_coin(2'b10);
        insert_coin(2'b11);
        insert_coin(2'b01);
        #20;

        // 5. No milk case
        milk_present = 0;
        insert_coin(2'b11);
        insert_coin(2'b11);
        insert_coin(2'b01);
        milk_present = 1; // Refill milk
        #20;

        // 6. Refund: 6 rupees + timeout
        insert_coin(2'b11); // 3
        insert_coin(2'b11); // 6
        #40; // Wait enough for timeout

        #50 $finish;
    end
endmodule
