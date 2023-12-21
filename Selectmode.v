`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 17:01:31
// Design Name: 
// Module Name: Selectmode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Selectmode(
    input clk,
    output reg pwm=0,
    output [3:0]an,
    output [6:0]ledlight,
    output reg [6:0]light=7'b0000000

    );
    `include "parameter_file.v"
    reg [1:0]mode=select;

    LED led(.clk(clk),.mode(mode),.an(an),.a_g(ledlight));

endmodule
