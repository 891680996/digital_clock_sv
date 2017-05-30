/*==========================================================*/

//generate year month day signals output to display moudle

/*==========================================================*/
module date_top (
    input clk,    // Clock
    input clk_day,
    input rst_n,  // Asynchronous reset active low

    input set_date_en,      //from control_state_machine.sv
    input set_date_add,     //adjust time by adding it up
    input set_date_shift,   //select position 
     
    output [1:0] blink2,
    output [7:0] out_day,
    output [2:0] out_week,
    output [7:0] out_month,
    output [7:0] out_year
);
/***********************************************************/
    //define output register
/***********************************************************/
    logic set_year_en;
    logic set_month_en;
    logic set_day_en;
    
    date_set u_date_set(
        .clk            (clk),
        .rst_n          (rst_n),
        .set_date_en    (set_date_en),
        .set_date_shift (set_date_shift),
        .set_year_en    (set_year_en),
        .set_month_en   (set_month_en),
        .set_day_en     (set_day_en)
        );

    logic [1:0] rblink2;
    logic [7:0] rout_day;
    logic [7:0] rout_month;
    logic [7:0] rout_year;
    logic [1:0] cnt_1hz;

    always_ff @(posedge clk or negedge rst_n) begin : proc_rout
        if(~rst_n) begin
            rout_day   <= 8'd1;
            rout_month <= 8'd1;
            rout_year  <= 8'd17;
            cnt_1hz     <= 2'd0;
            // rblink2       <= 2'b0;
        end else begin
            cnt_1hz <= cnt_1hz +1'b1;
            if(cnt_1hz == 2'b11) begin
                cnt_1hz <= 2'b0;
                
                if(clk_day) begin          
                    if(((rout_year % 4) == 0)) begin
                        if(rout_month == 8'd2) begin
                            if(rout_day == 8'd29) begin
                                rout_day   <= 8'd1;
                                rout_month <= rout_month + 1'd1;
                            end else begin 
                                rout_day   <= rout_day + 1'd1;
                            end
                        end

                        if((rout_month == 8'd1) || (rout_month == 8'd3) ||
                           (rout_month == 8'd5) || (rout_month == 8'd7) ||
                           (rout_month == 8'd8) || (rout_month == 8'd10)) begin
                            if(rout_day == 8'd31) begin 
                                rout_day   <= 8'd1;
                                rout_month <= rout_month + 1'd1;
                            end else begin 
                                rout_day   <= rout_day + 1'd1;
                            end
                        end

                        if((rout_month == 8'd4) || (rout_month == 8'd6) ||
                           (rout_month == 8'd9) || (rout_month == 8'd11)) begin
                            if(rout_day == 8'd30) begin
                                rout_day   <= 8'd1;
                                rout_month <= rout_month + 1'd1;
                            end else begin
                                rout_day   <= rout_day + 1'd1;
                            end
                        end

                        if(rout_month == 8'd12) begin
                            if(rout_day == 8'd31) begin
                                rout_day <= 8'd1;
                                if(rout_year == 8'd99) begin
                                    rout_year  <= 8'd17;
                                    rout_month <= 8'd1;
                                end else begin
                                    rout_month <= 8'd1;
                                    rout_year  <= rout_year + 1'd1;
                                end
                            end else begin 
                                rout_day <= rout_day + 1'd1;
                            end
                        end
                    end else begin
                        if(rout_month == 8'd2) begin
                            if(rout_day == 8'd28) begin
                                rout_day   <= 8'd1;
                                rout_month <= rout_month + 1'd1;
                            end else begin 
                                rout_day   <= rout_day + 1'd1;
                            end
                        end

                        if((rout_month == 8'd1) || (rout_month == 8'd3) ||
                           (rout_month == 8'd5) || (rout_month == 8'd7) ||
                           (rout_month == 8'd8) || (rout_month == 8'd10)) begin
                            if(rout_day == 8'd31) begin 
                                rout_day   <= 8'd1;
                                rout_month <= rout_month + 1'd1;
                            end else begin 
                                rout_day   <= rout_day + 1'd1;
                            end
                        end

                        if((rout_month == 8'd4) || (rout_month == 8'd6) ||
                           (rout_month == 8'd9) || (rout_month == 8'd11)) begin
                            if(rout_day == 8'd30) begin
                                rout_day   <= 8'd1;
                                rout_month <= rout_month + 1'd1;
                            end else begin
                                rout_day   <= rout_day + 1'd1;
                            end
                        end

                        if(rout_month == 8'd12) begin
                            if(rout_day == 8'd31) begin
                                rout_day <= 8'd1;
                                if(rout_year == 8'd99) begin
                                    rout_year  <= 8'd17;
                                    rout_month <= 8'd1;
                                end else begin
                                    rout_month <= 8'd1;
                                    rout_year  <= rout_year + 1'd1;
                                end
                            end else begin 
                                rout_day <= rout_day + 1'd1;
                            end
                        end            
                    end
                end
            end

            if(set_date_en && set_year_en && set_date_add) begin
                if(rout_year == 8'd99) begin
                    rout_year <= 8'd17;
                end else begin 
                    rout_year <= rout_year + 1'd1;
                end
            end

            if(set_date_en && set_month_en && set_date_add) begin
                if(rout_month == 8'd12) begin
                    rout_month <= 8'd1;
                end else begin 
                    rout_month <= rout_month + 1'd1;
                end
            end

            if(set_date_en && set_day_en && set_date_add) begin
                if((rout_year % 4) == 0) begin
                    if(rout_month == 8'd2) begin
                        if(rout_day == 8'd29) begin
                            rout_day <= 8'd1;
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end 

                    if((rout_month == 8'd4) || (rout_month == 8'd6) ||
                       (rout_month == 8'd9) || (rout_month == 8'd11)) begin
                        if(rout_day == 8'd30) begin
                            rout_day <= 8'd1;
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end 

                    if((rout_month == 8'd1) || (rout_month == 8'd3) ||
                       (rout_month == 8'd5) || (rout_month == 8'd7) ||
                       (rout_month == 8'd8) || (rout_month == 8'd10)) begin
                        if(rout_day == 8'd31) begin
                            rout_day <= 8'd1;
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end

                    if(rout_month == 8'd12) begin
                        if(rout_day == 8'd31) begin
                            rout_day <= 8'd1;
                            if(rout_year == 8'd99) begin
                                rout_year  <= 8'd17;
                                rout_month <= 8'd1;
                            end else begin
                                rout_month <= 8'd1;
                                rout_year  <= rout_year + 1'd1;
                            end
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end 
                end else begin 
                    if(rout_month == 8'd2) begin
                        if(rout_day == 8'd28) begin
                            rout_day <= 8'd1;
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end 

                    if((rout_month == 8'd4) || (rout_month == 8'd6) ||
                       (rout_month == 8'd9) || (rout_month == 8'd11)) begin
                        if(rout_day == 8'd30) begin
                            rout_day <= 8'd1;
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end 

                    if((rout_month == 8'd1) || (rout_month == 8'd3) ||
                       (rout_month == 8'd5) || (rout_month == 8'd7) ||
                       (rout_month == 8'd8) || (rout_month == 8'd10)) begin
                        if(rout_day == 8'd31) begin
                            rout_day <= 8'd1;
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end

                    if(rout_month == 8'd12) begin
                        if(rout_day == 8'd31) begin
                            rout_day <= 8'd1;
                            if(rout_year == 8'd99) begin
                                rout_year  <= 8'd17;
                                rout_month <= 8'd1;
                            end else begin
                                rout_month <= 8'd1;
                                rout_year  <= rout_year + 1'd1;
                            end
                        end else begin 
                            rout_day <= rout_day + 1'd1;
                        end
                    end 
                end
            end
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin : proc_rblink2
        if(~rst_n) begin
            rblink2 <= 2'd0;
        end else begin 
            if(set_date_en) begin
                if(set_year_en)
                    rblink2 <= 2'd1;
                if(set_month_en)
                    rblink2 <= 2'd2;
                if(set_day_en)
                    rblink2 <= 2'd3;
            end else begin
                rblink2 <= 2'd0;
            end
        end
    end
/***********************************************************/

    logic [7:0] rrout_day;
    logic [7:0] rrout_month;
    logic [7:0] rrout_year;
	logic [31:0] rout_week;

    assign rrout_month = ((rout_month == 8'd1)||(rout_month == 8'd2))?
                         (rout_month + 8'd12) : rout_month;
    assign rrout_day   = rout_day;
    assign rrout_year  = ((rout_month == 8'd1)||(rout_month == 8'd2))?
                         (rout_year - 1'd1) : rout_year;

    assign rout_week   = ((rrout_year + rrout_year/4 +
                                 26*(rrout_month + 1)/10 + rrout_day - 36) % 7); 
	assign out_week  = rout_week[2:0];			 
    assign out_day   = rout_day;
    assign out_month = rout_month;
    assign out_year  = rout_year;
    assign blink2     = rblink2;

/***********************************************************/
endmodule
/*=========================================================*/