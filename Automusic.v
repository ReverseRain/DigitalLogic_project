`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/26 10:10:47
// Design Name: 
// Module Name: Automusic
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


module Automusic(
 input clk,
 input [2:0] mode,
 output reg pwm=1'b0
    );
    parameter do_low =190840 ;
    parameter re_low =170068 ;
    parameter mi_low =151515 ;
    parameter fa_low =143266 ;
    parameter sol_low =127551 ;
    parameter la_low =113636 ;
    parameter si_low =101215 ;


    parameter do =95602 ;
    parameter re =85179 ;
    parameter mi =75873 ;
    parameter fa =71633 ;
    parameter sol =63776 ;
    parameter la =56818 ;
    parameter si =50607 ;
    
    
    parameter play_value_16 = 100*100000 ;
    parameter stop_value_16 = 25*100000;
    parameter time_value_16 = 125*100000; //0.125s

    parameter play_value_8 = 2*play_value_16 ;
    parameter stop_value_8 = 2*stop_value_16;
    parameter time_value_8 = 2*time_value_16; //0.25s

    parameter play_value_4 = 4*play_value_16 ;
    parameter stop_value_4 = 4*stop_value_16;
    parameter time_value_4 = 4*time_value_16; //0.5s

    parameter littleStar_length = 48;
    parameter littleStar =288'b000000_001000_001001_001001_001010_001010_001011_001011_000000_001100_001101_001101_001100_001100_001000_001000_000000_001001_001010_001010_001011_001011_001100_001100_000000_001001_001010_001010_001011_001011_001100_001100_000000_001000_001001_001001_001010_001010_001011_001011_000000_001100_001101_001101_001100_001100_001000_001000;


    reg[31:0] frequency;
    reg[31:0] fre_count=0;
    reg[31:0] tv_count=0;
    reg[31:0] index=0;
    reg isSlience=1'b1;
    reg isEnd=1'b0;
    reg [2000:0]melody;
    reg melody_length;
    reg play;
    reg stop;
    reg time_value;

    always @(mode) begin
    case(mode)
    3'b001:melody_length=littleStar_length;
    3'b010:melody_length=littleStar_length;
    3'b100:melody_length=littleStar_length;
    endcase
    index <=1'b0;
    isEnd<=1'b0;
    isSlience<=1'b1;
    tv_count<=1'b0;
    end

    always @(posedge clk ) begin
        if (frequency!=0) begin
            if (fre_count<frequency) begin
            fre_count<=fre_count+1;
        end
        else begin
            pwm=~pwm;
            fre_count<=0;
        end
        end
        else pwm=1'b0;  
    end//single notes counter

    always @(posedge clk ) begin
        if (index>=melody_length) isEnd<=1'b1;
        else isEnd<=1'b0;

        if (!isEnd) begin
            if (tv_count<stop) begin
                isSlience<=1'b1;
            end
            else if (tv_count>=stop&&tv_count<time_value) begin
                isSlience<=1'b0;
            end
            else begin
                tv_count<=0;
                index<=index+1;
            end     
        end
        else begin
            isEnd<=1'b0;
            isSlience<=1'b1;
            tv_count<=0;
            index<=0;     
        end
        tv_count=tv_count+1;

        
    end

    always @(*) begin
        if (isSlience) frequency=0;
        else begin
            case (melody[index*6+5-:6])
            6'd0:
              
            endcase
        end
        
    end

    





endmodule
