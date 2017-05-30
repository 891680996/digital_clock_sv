module display_scan (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    
    output [5:0] column_scan_signal

);

    reg [5:0] rcolumn_scan_signal;

    always_ff @(posedge clk or negedge rst_n) begin : proc_rcolumn_scan_signal
        if(~rst_n) begin
            rcolumn_scan_signal <= 6'b011111;
        end else begin
            rcolumn_scan_signal <= {rcolumn_scan_signal[0], rcolumn_scan_signal[5:1]};
        end 
    end // p

    /***********************************************************/
    //column scan signal output
    assign  column_scan_signal = rcolumn_scan_signal;
    //row scan signal output
    //assign  row_scan_signal    = rrow_scan_signal;
    /***********************************************************/

endmodule