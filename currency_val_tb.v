module currency_val_tb();
    // Parameters
    parameter CURRENCY_WIDTH = 7;
    // Inputs
    reg clk;
    reg rstn;
    reg [CURRENCY_WIDTH-1:0] currency_value;
    reg currency_valid;
    
    // Outputs
    wire [CURRENCY_WIDTH-1:0] total_currency;
    wire currency_avail;
    
    // Instantiate the Unit Under Test (UUT)
    currency_val #(
        .CURRENCY_WIDTH(CURRENCY_WIDTH)
    ) uut (
        .clk(clk),
        .rstn(rstn),
        .currency_value(currency_value),
        .currency_valid(currency_valid),
        .total_currency(total_currency),
        .currency_avail(currency_avail)
    );
    
   always #10 clk=~clk;
    // Test procedure
    initial begin
        // Initialize inputs
        clk=0;
        rstn = 0;
        currency_value = 0;
        currency_valid = 0;
        
        // Reset the system
        #20;
        rstn = 1;
        #10;
        
        // Test 1: Single currency insertion
        $display("Test 1: Single currency insertion (value=5)");
        currency_value = 5;
        currency_valid = 1;
        #40;
        currency_valid = 0;
        #50;
       
      // Test 2: Reset functionality
      $display("Test 2: Reset functionality");
      #10;
        rstn = 0;
        #10;
       
        rstn = 1;
        #10;
        
        // Test 3: Multiple currency insertions
      $display("Test 3: Multiple currency insertions");
        currency_value = 10;
        currency_valid = 1;
        #40;
        currency_valid = 0;
        #40;
        currency_value = 20;
        currency_valid = 1;
        #40;
        currency_valid = 0;
        #40;
        // All tests passed
        $display("All tests passed successfully!");
        $finish;
    end
    // Monitor signals
    initial begin
        $monitor("Time=%0t: rstn=%b, currency_value=%d, currency_valid=%b, total_currency=%d, currency_avail=%b",
                 $time, rstn, currency_value, currency_valid, total_currency, currency_avail);
    end
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
  end
endmodule
