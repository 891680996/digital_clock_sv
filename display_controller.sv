module display_controller (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset actrive low

    input [23:0] number_sig,
    output [3:0] number_data
    
);

    logic [3:0] rnumber_data;
    logic [3:0] ri;

    always_ff @(posedge clk or negedge rst_n) begin : proc_rnumber_data
        if(~rst_n) begin
            rnumber_data <= 4'b0;
            ri <= 4'b0;
        end else begin
            case (ri)
                4'd0 : begin
                    rnumber_data <= number_sig[23:20];
                    ri <= ri + 1'b1;
                end

                4'd1 : begin
                    rnumber_data <= number_sig[19:16];
                    ri <= ri + 1'b1;
                end

                4'd2 : begin
                    rnumber_data <= number_sig[15:12];
                    ri <= ri + 1'b1;
                end

                4'd3 : begin
                    rnumber_data <= number_sig[11:8];
                    ri <= ri + 1'b1;
                end

                4'd4 : begin
                    rnumber_data <= number_sig[7:4];
                    ri <= ri + 1'b1;
                end

                4'd5 : begin
                    rnumber_data <= number_sig[3:0];
                    ri <= 4'd0;
                end
                default : ;
            endcase
        end
    end

    assign number_data = rnumber_data;

endmodule