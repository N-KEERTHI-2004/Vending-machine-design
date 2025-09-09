module config_mode(pclk,prstn,cfg_mode,paddr,psel,pwrite,pwdata,prdata,pready,item_select,
                    item_select_valid,item_dispense_valid,item_dispense,currency_value,currency_change);


input pclk,prstn,psel,pwrite,cfg_mode;
input item_select_valid;
input [14:0] paddr;
input [31:0] pwdata;
input [9:0] item_select;
input [7:0] currency_value;

output reg pready;
output reg item_dispense_valid;
output reg [9:0]item_dispense;
output reg [31:0] prdata;
output reg [7:0] currency_change;

reg [7:0] total_amount;
reg [31:0] memory [0:1023];
reg [9:0]total_dispensed, total_available; 
reg item_available;
reg [31:0]time_out;

wire empty = memory [item_select][31];
wire [7:0] items_dispensed = memory [item_select][30:24],
           items_available = memory [item_select][23:16];
wire [15:0] item_cost = memory [item_select][15:0];

parameter max_items = 1024;
localparam EMPTY = 10'd1023  ;


initial begin
pready = 0;
prdata = 0;
currency_change = 0;
total_amount =0;
time_out = 0;
total_dispensed = 0;
total_available = max_items;
end


always@(posedge pclk or negedge prstn) begin

    if(prstn==0) begin
    pready <=0;
    prdata <= 32'b0;
    currency_change <= 0;
    total_amount <= 0;
    time_out <=0;
    item_dispense_valid <= 0;
    item_dispense <= 0;
    end



// Config mode

    else if(psel == 1) begin
        if(cfg_mode == 1) begin
        pready <=1;
            if (pwrite) begin
            memory [(paddr - 15'h0004)>>2] <= pwdata;
            end
            else begin
            prdata <= memory [(paddr - 15'h0004)>>2];
            end
        end
        else
        pready <=0;
        end
    

    
// operation mode

    else begin
    pready <=0;

        if(items_available==0) begin
        item_dispense_valid <= 1;
        item_dispense <= EMPTY;
        currency_change <= currency_value; 
        time_out <= 0;
        end
    
 
    
        else begin
        total_amount <= total_amount + currency_value;
            if (total_amount >= item_cost) begin
            time_out                <= 0;
            item_dispense_valid     <= 1;
            item_dispense           <= item_select;
            currency_change         <= total_amount - item_cost;
            total_amount            <= 0;
            memory [item_select] <= {(items_available == 1),items_dispensed + 1, items_available - 1, item_cost};
            total_dispensed <= total_dispensed +1;
            total_available <= total_available -1;
            end
        
        
            else  begin
                // total_amount <= total_amount + currency_value;
                if(time_out == 5000000) begin
                item_dispense_valid  <= 1;
                item_dispense        <= EMPTY;
                currency_change      <= total_amount;
                time_out             <= 0;
                end
            
                else begin
                time_out <= time_out +1;
                end
            
            end                                    // timing block
        
        end                                       // dispensing
    
    end                                          //operation mode

end                                             // always block
endmodule
