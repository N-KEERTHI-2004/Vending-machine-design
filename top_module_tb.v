
module vending_machine_top_tb;

    parameter ITEM_ADDR_WIDTH = 10;
    parameter CURRENCY_WIDTH  = 7;
    parameter MAX_ITEMS       = 1024;

    reg clk, rstn;
    reg pclk, prstn;
    reg cfg_mode;
    reg [ITEM_ADDR_WIDTH-1:0] item_select;
    reg item_select_valid;
    reg [CURRENCY_WIDTH-1:0] currency_value;
    reg currency_valid;
    reg psel, pwrite;
    reg [14:0] paddr;
    reg [31:0] pwdata;

    wire [31:0] prdata;
    wire pready;
    wire dispense_valid;
    wire [ITEM_ADDR_WIDTH-1:0] item_dispensed;
    wire [CURRENCY_WIDTH-1:0] currency_change;

    vending_machine_top #(
        .ITEM_ADDR_WIDTH(ITEM_ADDR_WIDTH),
        .CURRENCY_WIDTH(CURRENCY_WIDTH),
        .MAX_ITEMS(MAX_ITEMS)
    ) dut (
        .clk(clk), .rstn(rstn),
        .cfg_mode(cfg_mode),
        .item_select(item_select),
        .item_select_valid(item_select_valid),
        .currency_value(currency_value),
        .currency_valid(currency_valid),
        .pclk(pclk), .prstn(prstn),
        .psel(psel), .pwrite(pwrite),
        .paddr(paddr), .pwdata(pwdata),
        .prdata(prdata), .pready(pready),
        .dispense_valid(dispense_valid),
        .item_dispensed(item_dispensed),
        .currency_change(currency_change)
    );

    // Clock generation
    always #5 clk = ~clk;
    always #10 pclk = ~pclk;

    initial begin
        clk = 0; pclk = 0;
        rstn = 0; prstn = 0;
        cfg_mode = 1;
        item_select = 0; item_select_valid = 0;
        currency_value = 0; currency_valid = 0;
        psel = 0; pwrite = 0;
        paddr = 0; pwdata = 0;

        #20;
        rstn = 1;
        prstn = 1;

        // Configure item #3
        @(posedge pclk);
        psel = 1; pwrite = 1;
        paddr = 15'h04 + (3 << 2);
        pwdata = {8'd0, 8'd5, 16'd30}; // dispensed=0, count=5, price=30
        @(posedge pclk);
        psel = 0; pwrite = 0;
        $display("CONFIGURED: Item 3 -> Price: %0d, Count: %0d", pwdata[15:0], pwdata[23:16]);

        // Switch to normal mode
        @(posedge clk);
        cfg_mode = 0;

        // Select item 3
        @(posedge clk);
        item_select = 3;
        item_select_valid = 1;
        @(posedge clk);
        item_select_valid = 0;

        $display("SELECT: Item = %0d", item_select);

        // Insert currency
        @(posedge clk);
        currency_value = 40;
        currency_valid = 1;
        @(posedge clk);
        currency_valid = 0;

        repeat (3) @(posedge clk);

        if (dispense_valid) begin
            $display("DISPENSED: Item = %0d | Change = %0d", item_dispensed, currency_change);
          // Read back the memory for item 3 after dispensing
@(posedge pclk);
psel = 1;
pwrite = 0;
paddr = 15'h04 + (3 << 2); // Address of item 3
@(posedge pclk);
psel = 0;

// Wait a few cycles for pready
repeat (2) @(posedge clk);

$display("AFTER DISPENSE: Memory Readback for Item 3:");
$display("  Dispensed Item ID  = %0d", prdata[31:24]);
$display("  Remaining Count    = %0d", prdata[23:16]);
$display("  Item Price         = %0d", prdata[15:0]);

        end else begin
            $display("FAILED: Item not dispensed.");
        end

        $finish;
    end

endmodule
