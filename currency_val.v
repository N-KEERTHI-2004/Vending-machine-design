module currency_val #(
    parameter CURRENCY_WIDTH = 7  //max value 127
)(
    input wire clk, //clk signal
    input wire  rstn,  //active low signal
    input wire [CURRENCY_WIDTH-1:0] currency_value, //it carries the value of the currency inserted
    input wire currency_valid,    //indicates when currency is valid
    output reg [CURRENCY_WIDTH-1:0] total_currency,   //tracks the sum of all recieved currency value
    output  reg currency_avail //a one-cycle flag indicated that a valid currency was added
);
 reg currency_valid_sync_0, currency_valid_sync_1; //two synchronization registers for the asynchronus curency_valid signal

    wire rising_edge = currency_valid_sync_0 & ~currency_valid_sync_1; // is only true for one clock cycle at the moment of the rising edge

    always @(posedge clk or negedge rstn) begin   //it clears both outputs
        if (!rstn) begin
            currency_valid_sync_0 <= 0;
            currency_valid_sync_1 <= 0;
        end else begin   // Synchronize
            currency_valid_sync_0 <= currency_valid;
            currency_valid_sync_1 <= currency_valid_sync_0;
        end
    end

    always @(posedge clk or negedge rstn) begin 
        if (!rstn) begin
            total_currency <= 0;
            currency_avail <= 0;
        end else begin
            if (rising_edge) begin
                total_currency <= total_currency + currency_value;
                currency_avail <= 1;
            end else begin
                currency_avail <= 0;
            end
        end
    end
endmodule
