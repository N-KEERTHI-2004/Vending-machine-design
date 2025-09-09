
module item_memory_tb;

    // Parameters
    parameter MAX_ITEMS = 1024;
    localparam ADDR_WIDTH = $clog2(MAX_ITEMS);

    // DUT Inputs
    reg clk;
    reg we;
    reg dispense_valid;
    reg [ADDR_WIDTH-1:0] waddr;
    reg [ADDR_WIDTH-1:0] dispensed_item_index;
    reg [7:0] dispensed_item;
    reg [7:0] count;
    reg [15:0] price;
    reg [ADDR_WIDTH-1:0] raddr;

    // DUT Outputs
    wire [15:0] item_price;
    wire [7:0] avail_count;
    wire [7:0] stored_item_id;

    // Instantiate DUT
    item_memory #(.MAX_ITEMS(MAX_ITEMS)) dut (
        .clk(clk),
        .we(we),
        .dispense_valid(dispense_valid),
        .waddr(waddr),
        .dispensed_item(dispensed_item),
        .count(count),
        .price(price),
        .dispensed_item_index(dispensed_item_index),
        .raddr(raddr),
        .item_price(item_price),
        .avail_count(avail_count),
        .stored_item_id(stored_item_id)
    );

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100 MHz

    // Simulation
    initial begin
        $dumpfile("item_memory.vcd");
        $dumpvars(0, item_memory_tb);

        // Initialize
        we = 0;
        dispense_valid = 0;
        waddr = 0;
        dispensed_item_index = 0;
        dispensed_item = 0;
        count = 0;
        price = 0;
        raddr = 0;

        #10;

        // 1. Write item #3 with price=40, count=5, dispensed=0
        @(posedge clk);
        we = 1;
        waddr = 3;
        dispensed_item = 8'd0;
        count = 8'd5;
        price = 16'd40;

        @(posedge clk);
        we = 0;

        // 2. Wait 1 cycle and read
        @(posedge clk);
        raddr = 3;

        @(posedge clk);
        $display("Initial Read: Price = %0d, Count = %0d, Dispensed = %0d", item_price, avail_count, stored_item_id);

        // 3. Simulate 1 dispense of item 3
        @(posedge clk);
        dispense_valid = 1;
        dispensed_item_index = 3;

        @(posedge clk);
        dispense_valid = 0;

        // 4. Wait and read again
        @(posedge clk);
        raddr = 3;

        @(posedge clk);
        $display("After 1 Sale: Price = %0d, Count = %0d, Dispensed = %0d", item_price, avail_count, stored_item_id);

        if (avail_count == 4 && stored_item_id == 1)
            $display(" Test Passed");
        else
            $display(" Test Failed");

        #20 $finish;
    end

endmodule
