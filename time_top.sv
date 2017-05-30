///==========================================================

//generate year month day signals output to display moudle

/*==========================================================*/
module time_top (
    input clk,    // Clock
    //input clk_1hz,
    input rst_n,  // Asynchronous reset active low

    input set_time_en,      //from control_state_machine.sv
    input set_time_add,     //adjust time by adding it up
    input set_time_shift,   //select position 
     
    output [1:0] blink1,
    output [7:0] out_second,
    output [7:0] out_minute,
    output [7:0] out_hour,
    output cout_day
);
/***********************************************************/
    //define output register
/***********************************************************/
    logic set_hour_en;
    logic set_minute_en;
    logic set_second_en;
    
    time_set u_time_set(
        .clk            (clk),
        .rst_n          (rst_n),
        .set_time_en    (set_time_en),
        .set_time_shift (set_time_shift),
        .set_hour_en    (set_hour_en),
        .set_minute_en  (set_minute_en),
        .set_second_en  (set_second_en)
        );

    logic [7:0] rout_second;
    logic [7:0] rout_minute;
    logic [7:0] rout_hour;
    logic rcout_day;
    logic [1:0] cnt_1hz;
    logic [1:0] rblink1;
 
    always_ff @(posedge clk or negedge rst_n) begin : proc_rout
        if(~rst_n) begin
            rout_hour   <= 8'd0;
            rout_minute <= 8'd0;
            rout_second <= 8'd0;
            rcout_day   <= 1'd0;
            cnt_1hz     <= 2'd0;
            // rblink1       <= 2'b0;
        end else begin
            cnt_1hz <= cnt_1hz +1'b1;
            if(cnt_1hz == 2'b11) begin
                cnt_1hz <= 2'b0;

                if(rout_second == 8'd59) begin
                    rout_second <= 8'd0;
                    if(rout_minute == 8'd59) begin
                        rout_minute <= 8'd0;
                            if(rout_hour == 8'd23) begin
                                rout_hour <= 8'd0;
                                rcout_day <= 1'd1;
                            end else begin 
                                rout_hour <= rout_hour + 1'd1;
                                rcout_day <= 1'd0;
                            end 
                    end else begin
                        rout_minute <= rout_minute +1'd1;
                    end
                end else begin 
                    rout_second <= rout_second + 1'd1;
                    rcout_day <= 1'd0;
                end
            end

            if(set_time_en && set_second_en && set_time_add) begin
                rout_second  <= 8'd0;
            end
            
            if(set_time_en && set_minute_en && set_time_add) begin
                if(rout_minute == 8'd59) begin
                    rout_minute <= 8'd0;
                end else begin 
                    rout_minute <= rout_minute + 1'd1;
                end
            end
        
            if(set_time_en && set_hour_en && set_time_add) begin
                if(rout_hour == 8'd23) begin
                    rout_hour <= 8'd0;
                end else begin
                    rout_hour <= rout_hour + 1'd1;
                end
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin : proc_rblink1
        if(~rst_n) begin
            rblink1 <= 2'd0;
        end else begin
            if(set_time_en) begin
                if(set_hour_en)
                    rblink1 <= 2'd1;
                if(set_minute_en)
                    rblink1 <= 2'd2;
                if(set_second_en)
                    rblink1 <= 2'd3;
            end else begin
                rblink1 <= 2'd0;
            end
        end
    end
/***********************************************************/

    assign out_second = rout_second;
    assign out_minute = rout_minute;
    assign out_hour   = rout_hour;
    assign blink1     = rblink1;
    assign cout_day   = rcout_day;

/***********************************************************/
endmodule
//===========================================================