/*==========================================================*/

//count minute and output out_en to next module

/*==========================================================*/

module time_minute_counter (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_time_en,
    input [5:0] set_time_minute,
    output [5:0] out_minute,
    output cout_hour
);
    
/***********************************************************/
    
    logic [5:0] rout_minute;
    logic rcout_hour;     
    
/***********************************************************/
    always_ff @(posedge clk or negedge rst_n) begin : proc_rout_minute
        if(~rst_n) begin
            rout_minute <= 6'd0;
            rcout_hour  <= 1'd0;
        end else begin
            if (set_time_en) begin
                if(rout_minute  == 6'd59) begin
                    rcout_hour  <= 1'd1;
                    rout_minute <= 6'd0;   
                end else begin
                    rcout_hour  <= 1'd0;
                    rout_minute <= set_time_minute;
                end
            end else begin
                if(rout_minute  == 6'd59) begin
                    rcout_hour  <= 1'd1;
                    rout_minute <= 6'd0;   
                end else begin
                    rcout_hour  <= 1'd0;
                    rout_minute <= rout_minute + 1'd1;
                end
            end
        end
    end
/***********************************************************/

    assign out_minute = rout_minute;
    assign cout_hour  = rcout_hour;
    
/***********************************************************/

endmodule

/*==========================================================*/
