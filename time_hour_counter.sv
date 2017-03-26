/*==========================================================*/

//count hour and output out_en to nest module

/*==========================================================*/

module time_hour_counter (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    
    input set_time_en, // Clock Enable
    input [4:0] set_time_hour,
    output [4:0] out_hour,
    output cout_day
);

/***********************************************************/

    logic [4:0] rout_hour;
    logic rcout_day;

/***********************************************************/
    always_ff @(posedge clk or negedge rst_n) begin : proc_rout_hour
        if(~rst_n) begin
            rout_hour <= 5'd0;
            rcout_day <= 1'd0;
        end else begin
            if(set_time_en) begin
                if(rout_hour  == 5'd23) begin
                    rcout_day <= 1'd1;
                    rout_hour <= 5'd0;
                end else begin
                    rcout_day <= 1'd0;
                    rout_hour <= set_time_hour;
                end
            end else begin
                if(rout_hour  == 5'd23) begin
                    rcout_day <= 1'd1;
                    rout_hour <= 5'd0;
                end else begin
                    rcout_day <= 1'd0;
                    rout_hour <= rout_hour + 1'd1;
                end
            end
        end
    end
/***********************************************************/
    
    assign out_hour = rout_hour;
    assign cout_day = rcout_day;
    
/***********************************************************/

endmodule

/*==========================================================*/
