/*==========================================================*/

//count seconds and output out_en signal to next moudle

/*==========================================================*/
module time_second_counter (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_time_en,   // Clock Enable
    input [5:0] set_time_second,
    output [5:0] out_second,
    output cout_minute
);
   
/***********************************************************/

    logic [5:0] rout_second;
    logic rcout_minute;

/***********************************************************/
    always_ff @(posedge clk or negedge rst_n) begin : proc_rout_second
       if(~rst_n) begin
            rout_second <= 6'd0;
            rcout_minute  <= 1'd0;
        end else begin
            if(set_time_en) begin
                if(rout_second   == 6'd59) begin
                    rcout_minute <= 1'd1;
                    rout_second  <= 6'd0;
                end else begin
                    rout_second  <= set_time_second;
                    rcout_minute <= 1'd0;
                end
            end else begin
                if(rout_second   == 6'd59) begin
                    rcout_minute <= 1'd1;
                    rout_second  <= 6'd0;
                end else begin
                    rout_second  <= rout_second + 1'd1;
                    rcout_minute <= 1'd0;
                end
            end 
        end
    end
/***********************************************************/

    assign out_second  = rout_second;
    assign cout_minute = rcout_minute;

/***********************************************************/

endmodule // second_counter

/*==========================================================*/
