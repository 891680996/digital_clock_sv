/*==========================================================*/

//generate year month day signals output to display moudle

/*==========================================================*/
module time_operation (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    
    input set_time_en,
    input [5:0] set_time_second,
    input [5:0] set_time_minute,
    input [4:0] set_time_hour,
    
    output [5:0] out_second,
    output [5:0] out_minute,
    output [4:0] out_hour,
    output cout_day
);
/***********************************************************/
    //define output register
    logic rclk_minute;
    logic rclk_hour;
    logic rcout_minute;
    logic rcout_hour;

/***********************************************************/
    time_second_counter u_time_second_counter(
        .clk(clk),
        .rst_n(rst_n),

        .set_time_en(set_time_en),
        .set_time_second(set_time_second),
        .out_second(out_second),
        .cout_minute(rclk_minute)
        );

    time_minute_counter u_time_minute_counter(
        .clk(rclk_minute),
        .rst_n(rst_n),

        .set_time_en(set_time_en),
        .set_time_minute(set_time_minute),
        .out_minute(out_minute),
        .cout_hour(rclk_hour)
        );

    time_hour_counter u_time_hour_counter(
        .clk(rclk_hour),
        .rst_n(rst_n),

        .set_time_en(set_time_en),
        .set_time_hour(set_time_hour),
        .out_hour(out_hour),
        .cout_day(cout_day)
        );

/***********************************************************/
endmodule
/*==========================================================*/
