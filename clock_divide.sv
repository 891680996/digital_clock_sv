`timescale 1ns/1ns
module clock_divide (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low

    output clk_300hz,
    //output clk_1hz,
    output clk_4hz
    
);

    parameter T300HZ = 6'd54;
    parameter T4HZ  = 13'b1_0000_0000_0000;
    //parameter T1HZ   = 15'b100_0000_0000_0000;
    logic rclk_300hz;
    logic rclk_4hz;
    //logic rclk_1hz;
    logic [5:0]  count1;
    logic [12:0] count3;
    //logic [14:0] count2; 

    always_ff @(posedge clk or negedge rst_n) begin : proc_clk_300hz

        if(~rst_n) begin
            rclk_300hz<= 1'd0;
            count1     <= 5'd0;
        end else begin
            if(count1 == T300HZ) begin
                count1     <= 6'd0;
                rclk_300hz<= ~rclk_300hz;
            end else begin
                count1     <= count1 + 1'b1;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin : proc_clk_4hz

        if(~rst_n) begin
            rclk_4hz<= 1'd0;
            count3   <= 13'd0;
        end else begin
            if(count3[12] == 1'b1) begin
                count3    <= 13'd0;
                rclk_4hz <= ~rclk_4hz;
            end else begin
                count3    <= count3 + 1'b1;
            end
        end
    end

    assign clk_300hz = rclk_300hz;
    assign clk_4hz  = rclk_4hz;
    // assign clk_1hz   = rclk_1hz;
endmodule