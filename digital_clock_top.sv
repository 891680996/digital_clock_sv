/*==========================================================*/

//

/*==========================================================*/
module digital_clock_top (
    input ext_clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input set_module_en_button,
    input set_time_shift_button,
    input set_time_add_button,

    output  [5:0]   column_scan_signal,
    output  [7:0]   smg_data
    
);

    logic [1:0] blink;
    logic [23:0] time_date;
    
    logic set_module_en_button1;
    logic set_time_shift_button1;
    logic set_time_add_button1;

    
    logic clk;
    // logic rst_n;
    logic clk_300hz;
    clock_divide u_clock_divide(
        .clk      (ext_clk),
        .rst_n    (rst_n),
        .clk_300hz(clk_300hz),
        .clk_4hz  (clk)
        );


    debounce_module   debounce0 (clk_300hz,set_module_en_button,set_module_en_button1);
    debounce_module   debounce1 (clk_300hz,set_time_shift_button,set_time_shift_button1);
    debounce_module   debounce2 (clk_300hz,set_time_add_button,set_time_add_button1);
    // debounce_module   debounce3 (ext_clk,ext_rst_n,rst_n);


    display_buf u_display_buf(
        .clk                  (clk),
        .rst_n                (rst_n),
        .set_module_en_button (set_module_en_button1),
        .set_time_shift_button(set_time_shift_button1),
        .set_time_add_button  (set_time_add_button1),
        .time_date            (time_date),
        .blink                (blink)
        );

    display_top u_display_top(
        .clk               (clk_300hz),
        .rst_n             (rst_n),
        .time_date         (time_date),
        .blink             (blink),
        .column_scan_signal(column_scan_signal),
        .smg_data          (smg_data)
        );


/***********************************************************/
endmodule
/*=========================================================*/
