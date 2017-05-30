module display_encoder (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    input [23:0] time_date,
    output [23:0] number_sig
    
);

    logic [31:0] rone_data0;
    logic [31:0] rten_data0;
    logic [31:0] rone_data1;
    logic [31:0] rten_data1;
    logic [31:0] rone_data2;
    logic [31:0] rten_data2;

    always_ff @(posedge clk or negedge rst_n) begin : proc_time
        if(~rst_n) begin
            rone_data0 <= 32'b0;
            rten_data0 <= 32'b0;
            rone_data1 <= 32'b0;
            rten_data1 <= 32'b0;
            rone_data2 <= 32'b0;
            rten_data2 <= 32'b0;
        end else begin
            rone_data0 <= time_date[7:0]%10;
            rten_data0 <= time_date[7:0]/10;
            rone_data1 <= time_date[15:8]%10;
            rten_data1 <= time_date[15:8]/10;
            rone_data2 <= time_date[23:16]%10;
            rten_data2 <= time_date[23:16]/10;
        end
    end // proc_data_gen
   
    /***********************************************************/
    assign number_sig = {rten_data2[3:0],rone_data2[3:0],rten_data1[3:0],
                         rone_data1[3:0],rten_data0[3:0],rone_data0[3:0]
                        };
    /*==========================================================*/

endmodule // smg_display
