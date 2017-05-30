/*==========================================================*/

//when set_date_en is 1, set date then output to next module 

/*==========================================================*/  
module date_set (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_date_en,      //from control_state_machine.sv
    input set_date_shift,   //select position 

    output set_day_en,
    output set_month_en,
    output set_year_en

);
/***********************************************************/
    //define three states
    parameter   set_year_state  = 3'b00,
                set_month_state = 3'b01,
                set_day_state   = 3'b10;

    //define current state
    logic c_set_year_state;
    logic c_set_month_state;
    logic c_set_day_state;

    //define next_state
    logic n_set_year_state;
    logic n_set_month_state;
    logic n_set_day_state;
    
    logic [2:0] current_state;
    logic [2:0] next_state;
/***********************************************************/
    //the first section ascertain current state
    assign c_set_year_state  = (current_state == set_year_state);
    assign c_set_month_state = (current_state == set_month_state);
    assign c_set_day_state   = (current_state == set_day_state);

    //the second section
    assign n_set_year_state  = set_date_en & c_set_day_state   & set_date_shift;
    assign n_set_month_state = set_date_en & c_set_year_state  & set_date_shift;
    assign n_set_day_state   = set_date_en & c_set_month_state & set_date_shift;

    //the third section ascertain next state
    assign next_state = {2{n_set_year_state}}  & set_year_state  |
                        {2{n_set_month_state}} & set_month_state |
                        {2{n_set_day_state}}   & set_day_state;

    //the fourth section 
    always_ff @(posedge clk or negedge rst_n) begin : proc_current_state
        if(~rst_n) begin
            current_state <= set_year_state;
        end else begin
            if(set_date_en) begin
                if(n_set_year_state | n_set_month_state | n_set_day_state) begin
                    current_state <= next_state;
                end
            end else begin
                current_state <= set_year_state;
            end
        end
    end

/***********************************************************/
    assign set_year_en  = c_set_year_state;
    assign set_month_en = c_set_month_state;
    assign set_day_en   = c_set_day_state;
/***********************************************************/
endmodule
/*==========================================================*/
