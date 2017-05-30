module display_top (
    input clk,    // Clock
   
    input rst_n,  // Asynchronous reset active low
    input [1:0] blink,

    input [23:0] time_date,
    output [7:0] smg_data,
    output [5:0] column_scan_signal
    
);
    
    logic [23:0] number_sig;


    display_encoder u_display_encoder(
        .clk       (clk),
        .rst_n     (rst_n),
        .time_date (time_date),
        .number_sig(number_sig)
        );

    logic [3:0] number_data;

    display_controller u_display_controller(
        .clk        (clk),
        .rst_n      (rst_n),
        .number_sig (number_sig),
        .number_data(number_data)
        );

    logic [7:0] rsmg_data;

    display_decoder u_display_decoder(
        .clk        (clk),
        .rst_n      (rst_n),
        .number_data(number_data),
        .smg_data   (rsmg_data)
        );

    logic [5:0] rcolumn_scan_signal;

    display_scan u_display_scan(
        .clk               (clk),
        .rst_n             (rst_n),
        .column_scan_signal(rcolumn_scan_signal)
        );

    // parameter T500MS = 2'd10800;//50M*0.01-1=499_999
    // reg [13:0]Count1;
    reg rblink;
    parameter T500MS = 7'd75;
    reg [6:0] count;
	always_ff @(posedge clk or negedge rst_n) begin : proc_rblink
        if(!rst_n) begin 
            rblink <= 1'b0;
        end else begin 
            if(blink) begin
                if(count == T500MS) begin
                    rblink <= ~rblink;
                    count  <= 7'd0;
                end else begin 
                    count <= count + 1'b1;
                end
            end        
        end
    end

    reg [7:0] rrsmg_data;
    always @(*) begin
        case (blink)
            2'd3 : rrsmg_data = (rblink&&(~(rcolumn_scan_signal[4]
        &&rcolumn_scan_signal[5])))?8'b1111_1111:rsmg_data;
            2'd2 : rrsmg_data = (rblink&&(~(rcolumn_scan_signal[0]
        &&rcolumn_scan_signal[1])))?8'b1111_1111:rsmg_data;
            2'd1 : rrsmg_data = (rblink&&(~(rcolumn_scan_signal[2]
        &&rcolumn_scan_signal[3])))?8'b1111_1111:rsmg_data;
            2'd0 : rrsmg_data = rsmg_data;
        endcase
    end
    assign smg_data = rrsmg_data;
    assign column_scan_signal = rcolumn_scan_signal;
    /******************************************/
    endmodule