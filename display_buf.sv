/*==========================================================*/

//

/*==========================================================*/
module display_buf (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_module_en_button,
    input set_time_shift_button,
    input set_time_add_button,

    output [23:0] time_date,
    output [1:0]  blink
    
);

    logic set_time_en;
    logic set_date_en;

    logic [7:0] out_second;
    logic [7:0] out_minute;
    logic [7:0] out_hour;
    logic [7:0] out_day;
    logic [7:0] out_week;
    logic [7:0] out_month;
    logic [7:0] out_year;

    control_state_machine u_control_state_machine(
        .clk          (clk),
        .rst_n        (rst_n),
        .set_module_en(set_module_en_button),
        .set_time_en  (set_time_en),
        .set_date_en  (set_date_en)
        //.set_alarm_en (set_alarm_en)
        );

    logic [1:0] blink1;
    logic [1:0] blink2;
    logic cout_day;

    time_top u_time_top(
        .clk           (clk),
        //.clk_1hz       (clk_1hz),
        .rst_n         (rst_n),
        .set_time_en   (set_time_en),
        .set_time_add  (set_time_add_button),
        .set_time_shift(set_time_shift_button),
        .out_second    (out_second),
        .out_minute    (out_minute),
        .out_hour      (out_hour),
        .cout_day      (cout_day),
        .blink1        (blink1)
        );

    date_top u_date_top(
        .clk           (clk),
        .clk_day       (cout_day),
        .rst_n         (rst_n),
        .set_date_en   (set_date_en),
        .set_date_add  (set_time_add_button),
        .set_date_shift(set_time_shift_button),
        .blink2        (blink2),
        .out_day       (out_day),
        .out_week      (out_week),
        .out_month     (out_month),
        .out_year      (out_year)
        );

    logic [1:0] rblink;
    always_ff @(posedge clk or negedge rst_n) begin : proc_rblink
        if(~rst_n) begin
            rblink <= 2'd0;
        end else begin
            case ({set_time_en, set_date_en})
                2'b10 : rblink <= blink1;
                2'b01 : rblink <= blink2;
            
                default : rblink <= 2'd0;
            endcase
        end
    end

    logic [23:0] rtime_date;
    always_ff @(posedge clk or negedge rst_n) begin : proc_rtime_date
        if(~rst_n) begin
            rtime_date <= {out_hour, out_minute, out_second};
        end else begin
            casex ({set_time_en, set_date_en, set_time_add_button})
                3'b10x : rtime_date <= {out_hour, out_minute, out_second};
                3'b01x : rtime_date <= {out_year, out_month, out_day};
                3'b001 : rtime_date <= {out_year, out_month, out_day};
                default : rtime_date <= {out_hour, out_minute, out_second};
            endcase
        end
    end


    assign blink = rblink;
    assign time_date = rtime_date;

/***********************************************************/
endmodule
/*==========================================================*/
