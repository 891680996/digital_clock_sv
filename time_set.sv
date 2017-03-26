/*==========================================================*/

//when set_time_en is 1, set time then output to next module 

/*==========================================================*/	
module time_set (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_time_en,		//from control_state_machine.sv
    input set_time_add,		//adjust time by adding it up
    input set_time_shift,	//select position 

    output [4:0] set_time_hour,
    output [5:0] set_time_minute,
    output [5:0] set_time_second
);
/***********************************************************/
    logic [4:0] rset_time_hour;
    logic [5:0] rset_time_minute;
    logic [5:0] rset_time_second;
    //define three states
    parameter	set_hour_state   = 2'b00,
				set_minute_state = 2'b01,
				set_second_state = 2'b10;

    //define current state
    logic c_set_hour_state;
    logic c_set_minute_state;
    logic c_set_second_state;

    //define next_state
    logic n_set_hour_state;
    logic n_set_minute_state;
    logic n_set_second_state;

    logic [1:0] current_state;
    logic [1:0] next_state;
/***********************************************************/
    //the first section ascertain current state
    assign c_set_hour_state   = (current_state == set_hour_state);
    assign c_set_minute_state = (current_state == set_minute_state);
    assign c_set_second_state = (current_state == set_second_state);

    //the second section
    assign n_set_hour_state   = c_set_second_state  & set_time_en & set_time_shift;
    assign n_set_minute_state = c_set_hour_state    & set_time_en & set_time_shift;
    assign n_set_second_state = c_set_minute_state  & set_time_en & set_time_shift;

    //the third section ascertain next state
    assign next_state = {2{n_set_hour_state}}       & set_hour_state |
                        {2{n_set_minute_state}}     & set_minute_state |
                        {2{n_set_second_state}}     & set_second_state;

    //the fourth section 
    always_ff @(posedge clk or negedge rst_n) begin : proc_current_state
        if(~rst_n) begin
            current_state <= set_hour_state;
        end else begin
            if(n_set_hour_state | n_set_minute_state | n_set_second_state) begin
                current_state <= next_state;
            end else begin
            end
        end
    end
/***********************************************************/
    //define output at different state
    always_ff @(posedge clk or negedge rst_n) begin : proc_set_time
        if(~rst_n) begin
            rset_time_hour   <= 0;
            rset_time_minute <= 0;
            rset_time_second <= 0;
        end else begin
            rset_time_hour   <= rset_time_hour   + c_set_hour_state;
            rset_time_minute <= rset_time_minute + c_set_minute_state;
            rset_time_second <= rset_time_second + c_set_second_state;
        end
    end
/***********************************************************/
    assign set_time_second = rset_time_second;
    assign set_time_minute = rset_time_minute;
    assign set_time_hour   = rset_time_hour;
/***********************************************************/
endmodule
/*==========================================================*/
