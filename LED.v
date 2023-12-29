`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 18:40:10
// Design Name: 
// Module Name: LED
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


module LED(
    input clk,
    input[2:0] mode,
    input[1:0] num,
    input[31:0] fre,
    output reg[3:0] an,
    output reg[6:0] a_g//bond a to g from left to right

    );
    `include "parameter_project.v"
    reg[18:0] clkdiv=0;
    reg[3:0] display;// the code of the thing displayed on the LED
    always @(posedge clk ) begin
        
        clkdiv<=clkdiv+1;
    end

    wire [1:0] sign;//00-01-10-11 dilight 4 different light
    assign sign=clkdiv[18:17];

    always @(*) begin
        case (sign)
          2'b00: an=4'b1000;
          2'b01: an=4'b0100;
          2'b10: an=4'b0010; 
          2'b11: an=4'b0001;       
        endcase
    end

    always @(*) begin
        if (sign==2'b00) begin
            case(mode)
             free: display=4'd7;
             learn: display=4'd9;
             auto: display=4'd8;
             define:display=4'd13;
             select:display=4'd4;
             memory:display=4'd11;
             default:display=4'd12;
            endcase
        end
        else if (sign==2'b01) begin
            if (mode==auto||mode==learn) begin
                case(num)
             song1: display=4'd0;
             song2: display=4'd1;
             song3: display=4'd2;
             default:display=4'd12;

            endcase
            end
//            else if(mode==learn)begin
//            case(num)
//            endcase
//            end
            else
            display=4'd12;
            
            
        end
        else if (sign==2'b10) begin
            case(fre)
            do,do_high,do_low: display=4'd0;
            re,re_high,re_low: display=4'd1;
            mi,mi_high,mi_low: display=4'd2;
            fa,fa_high,fa_low: display=4'd3;
            sol,sol_high,sol_low: display=4'd4;
            la,la_high,la_low: display=4'd5;
            si,si_high,si_low: display=4'd6;
            default:display=4'd12;

            endcase
            
        end
        else if (sign==2'b11) begin
            case(fre)
            do,re,mi,fa,sol,la,si:display=4'd11;
            do_low,re_low,mi_low,fa_low,sol_low,la_low,si_low:display=4'd9;
            do_high,re_high,mi_high,fa_high,sol_high,la_high,si_high:display=4'd10;
            default:display=4'd12;
            endcase
            
        end

    end
    always @(*) begin
        case (display)
        4'd0:a_g=7'b0110000;//1
        4'd1:a_g=7'b1101101;//2
        4'd2:a_g=7'b1111001;//3
        4'd3:a_g=7'b0110011;//4
        4'd4:a_g=7'b1011011;//5
        4'd5:a_g=7'b1011111;//6
        4'd6:a_g=7'b1110000;//7
        4'd7:a_g=7'b1000111;//F
        4'd8:a_g=7'b1110111;//A
        4'd9:a_g=7'b0001110;//L
        4'd10:a_g=7'b0110111;//H
        4'd11:a_g=7'b0000001;//-
        4'd12:a_g=7'b1111110;//0   
        4'd13:a_g=7'b0111101;//d
        
            default:a_g=7'b1111110;//0 
        endcase
        
    end

    


endmodule
