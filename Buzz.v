`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 15:23:05
// Design Name: 
// Module ns: 
// DescriptioName: Buzz
// Project Name: 
// Target Devices: 
// Tool Version: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Buzz(

    input clk,
    input [31:0] frequency,
    input reset,
    input modechange,
    output reg pwm

    );
    reg[31:0] count;
    always @(posedge clk ,negedge reset) begin
        if (modechange) begin
            pwm=1'b0;
            count=0;
        end

        if (!reset) begin
            pwm=1'b0;
            count=0;
        end
        else begin
             if (frequency!=0) begin
            if (count<frequency) begin
           count<=count+1;
        end
        else begin
            pwm=~pwm;
            count<=0;
        end
        end
        else pwm=1'b0; 
        end
            
            
    
    end



endmodule
