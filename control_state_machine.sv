/*==========================================================*/

//the state machine control clock at which setting module
//have four states: idle_state:         display time
//                  set_time_state:     set time module  
//                  set_date_state:     set date module
//                  set_alarm_state:    set alarm module
                   
/*==========================================================*/
module control_state_machine (
     input clk,    // Clock
     input rst_n,  // Asynchronous reset active low
     
     input set_module_en,   //enable at high level 1

     output set_time_en,
     output set_date_en
     //output set_alarm_en
 );
/***********************************************************/
    //define four states 
    parameter   idle_state      = 2'b00,
                set_time_state  = 2'b01,
                set_date_state  = 2'b10;
                //set_alarm_state = 2'b100;

    //define current state
    logic c_idle_state;
    logic c_set_time_state;
    logic c_set_date_state;
    //logic c_set_alarm_state;

    //define next state
    logic n_idle_state;
    logic n_set_time_state;
    logic n_set_date_state;
    //logic n_set_alarm_state;

    logic [1:0] current_state;
    logic [1:0] next_state;
/***********************************************************/
    //the first section ascertain current state
    assign c_idle_state      = (current_state == idle_state);
    assign c_set_time_state  = (current_state == set_time_state);
    assign c_set_date_state  = (current_state == set_date_state);
    //assign c_set_alarm_state = (current_state == set_alarm_state);

    //the second section
    assign n_idle_state      = c_set_date_state  & set_module_en;
    assign n_set_time_state  = c_idle_state      & set_module_en;
    assign n_set_date_state  = c_set_time_state  & set_module_en;
    //assign n_set_alarm_state = c_set_date_state  & set_module_en;

    //the third section ascertain next state
    assign next_state = {2{n_idle_state}}       & idle_state |
                        {2{n_set_time_state}}   & set_time_state |
                        {2{n_set_date_state}}   & set_date_state;

    //the fourth section 
    always_ff @(posedge clk or negedge rst_n) begin : proc_current_state
        if(~rst_n) begin
            current_state <= 2'b0;
        end else begin
            if(n_idle_state | n_set_time_state | n_set_date_state) begin
                current_state <= next_state;
            end else begin
            end
        end
    end
/***********************************************************/
    //define output at different state
    assign set_time_en  = c_set_time_state;
    assign set_date_en  = c_set_date_state;
    //assign set_alarm_en = c_set_alarm_state;

/***********************************************************/
endmodule
/*==========================================================*/
