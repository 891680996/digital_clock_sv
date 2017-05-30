module display_decoder (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input [3:0] number_data,
    output [7:0] smg_data
    
);
    
    /*==========================================================*/
    parameter    _0 = 8'b1100_0000,    _1 = 8'b1111_1001,    _2 = 8'b1010_0100,
                 _3 = 8'b1011_0000,    _4 = 8'b1001_1001,    _5 = 8'b1001_0010,
                 _6 = 8'b1000_0010,    _7 = 8'b1111_1000,    _8 = 8'b1000_0000,
                 _9 = 8'b1001_0000;

    logic [7:0] rsmg_data;

    always_ff @(posedge clk or negedge rst_n) begin : proc_rsmg_data
        if(~rst_n) begin
            rsmg_data <= 8'hff;
        end else begin
            case (number_data)
                4'd0      : rsmg_data <= _0;
                4'd1      : rsmg_data <= _1;
                4'd2      : rsmg_data <= _2;
                4'd3      : rsmg_data <= _3;
                4'd4      : rsmg_data <= _4;
                4'd5      : rsmg_data <= _5;
                4'd6      : rsmg_data <= _6;
                4'd7      : rsmg_data <= _7;
                4'd8      : rsmg_data <= _8;
                4'd9      : rsmg_data <= _9;
                default   : ;
            endcase
        end
    end

    assign smg_data = rsmg_data;
    
endmodule