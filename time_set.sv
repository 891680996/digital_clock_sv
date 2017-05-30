/*==========================================================*/

//when set_time_en is 1, set time then output to next module 

/*==========================================================*/  
module time_set (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_time_en,      //from control_state_machine.sv
    input set_time_shift,   //select position 

    output set_hour_en,
    output set_minute_en,
    output set_second_en

);
/***********************************************************/
    //define three states
    parameter   set_hour_state   = 2'b00,
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
    assign n_set_hour_state   = set_time_en & c_set_second_state & set_time_shift;
    assign n_set_minute_state = set_time_en & c_set_hour_state   & set_time_shift;
    assign n_set_second_state = set_time_en & c_set_minute_state & set_time_shift;

    //the third section ascertain next state
    assign next_state = {2{n_set_hour_state}}   & set_hour_state   |
                        {2{n_set_minute_state}} & set_minute_state |
                        {2{n_set_second_state}} & set_second_state;

    //the fourth section 
    always_ff @(posedge clk or negedge rst_n) begin : proc_current_state
        if(~rst_n) begin
            current_state <= set_hour_state;
        end else begin
            if(set_time_en) begin
                if(n_set_hour_state || n_set_minute_state || n_set_second_state) begin
                    current_state <= next_state;
                end 
            end else begin
                current_state <= set_hour_state;
            end
        end
    end

/***********************************************************/
    assign set_hour_en   = c_set_hour_state   ;
    assign set_minute_en = c_set_minute_state ;
    assign set_second_en = c_set_second_state ;
/***********************************************************/
endmodule
/*==========================================================*/
