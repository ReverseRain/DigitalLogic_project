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
 output reg pwm=1'b0,
 input isMatch,
 input isAuto,
 input [1:0]mode,// the song number
 output reg isHight,
 output reg isLow,
 output [3:0] an,
 output [6:0] led_light,
 output reg[6:0]  lights
    );
     `include "parameter_project.v"

    
    
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
    parameter happyBirthday_length=30;
    parameter happyBirthday=180'b001001_001001_001010_001000_001010_000100_000100_100010_100011_001000_001010_001100_011010_011010_001000_001000_001001_100001_100010_011010_011010_000000_100011_100011_001000_100001_100010_011010_011010_000000;
    parameter happiness_length=55;
    parameter happiness=330'b101011_101111_101101_101110_101101_111010_111001_111001_111010_111010_111011_111011_111100_111001_111010_111001_111010_111010_111001_111010_111010_111001_111010_111010_111011_111011_111100_111100_111101_111010_111010_111010_101011_111011_101100_111010_111010_101100_111010_111010_101100_111001_010101_101100_111011_111011_101101_111011_111011_101101_111011_111011_101101_111010_111001;
    

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
    wire [1:0]modes;//auto mode
    assign modes=auto;


    LED led(clk,modes,mode,frequency,an,led_light);

     always @(mode) begin
    index =1'b0;
    isEnd=1'b0;
    isSlience=1'b1;
    tv_count=1'b0;
    
    case(mode)
    song1:begin melody_length=littleStar_length;melody=littleStar;end
    song2:begin melody_length=happyBirthday_length;melody=happyBirthday;end
    song3:begin melody_length=happiness_length;melody=happiness; end
    endcase
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
        if(isAuto==1'b1||(isMatch==1'b1&&isAuto==1'b0)) begin
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
        tv_count<=tv_count+1;
end
        
    end

    always @(*) begin
        if (isSlience) frequency=0;
        else begin
            case (melody[index*6+5-:6])
            6'd0: begin frequency=0;stop=stop_value_8;time_value=time_value_8;    end  //000000
            6'd1: begin frequency=do;stop=stop_value_8;time_value=time_value_8;    end  //000001
            6'd2: begin frequency=re;stop=stop_value_8;time_value=time_value_8;    end  //000010
            6'd3: begin frequency=mi;stop=stop_value_8;time_value=time_value_8;    end  //000011
            6'd4: begin frequency=fa;stop=stop_value_8;time_value=time_value_8;    end  //000100
            6'd5: begin frequency=sol;stop=stop_value_8;time_value=time_value_8;    end //000101
            6'd6: begin frequency=la;stop=stop_value_8;time_value=time_value_8;    end  //000110
            6'd7: begin frequency=si;stop=stop_value_8;time_value=time_value_8;    end  //000111
            6'd8: begin frequency=do;stop=stop_value_4;time_value=time_value_4;    end  //001000
            6'd9: begin frequency=re;stop=stop_value_4;time_value=time_value_4;    end  //001001
            6'd10: begin frequency=mi;stop=stop_value_4;time_value=time_value_4;    end //001010
            6'd11: begin frequency=fa;stop=stop_value_4;time_value=time_value_4;    end //001011
            6'd12: begin frequency=sol;stop=stop_value_4;time_value=time_value_4;   end //001100
            6'd13: begin frequency=la;stop=stop_value_4;time_value=time_value_4;end    //001101
            6'd14: begin frequency=si;stop=stop_value_4;time_value=time_value_4;   end //001110
            6'd15: begin frequency=do;stop=stop_value_16;time_value=time_value_16;   end //001111
            6'd16: begin frequency=re;stop=stop_value_16;time_value=time_value_16;   end //010000
            6'd17: begin frequency=mi;stop=stop_value_16;time_value=time_value_16;   end //010001
            6'd18: begin frequency=fa;stop=stop_value_16;time_value=time_value_16;   end //010010
            6'd19: begin frequency=sol;stop=stop_value_16;time_value=time_value_16;   end //010011
            6'd20: begin frequency=la;stop=stop_value_16;time_value=time_value_16;   end  //010100
            6'd21: begin frequency=si;stop=stop_value_16;time_value=time_value_16;   end  //010101
            6'd22: begin frequency=do_low;stop=stop_value_8;time_value=time_value_8;    end //010110
            6'd23: begin frequency=re_low;stop=stop_value_8;time_value=time_value_8;    end //010111
            6'd24: begin frequency=mi_low;stop=stop_value_8;time_value=time_value_8;    end //011000
            6'd25: begin frequency=fa_low;stop=stop_value_8;time_value=time_value_8;    end //011001
            6'd26: begin frequency=sol_low;stop=stop_value_8;time_value=time_value_8;    end //011010
            6'd27: begin frequency=la_low;stop=stop_value_8;time_value=time_value_8;    end //011011
            6'd28: begin frequency=si_low;stop=stop_value_8;time_value=time_value_8;    end //011100
            6'd29: begin frequency=do_low;stop=stop_value_4;time_value=time_value_4;    end //011101
            6'd30: begin frequency=re_low;stop=stop_value_4;time_value=time_value_4;    end //011110
            6'd31: begin frequency=mi_low;stop=stop_value_4;time_value=time_value_4;    end //011111
            6'd32: begin frequency=fa_low;stop=stop_value_4;time_value=time_value_4;    end //100000
            6'd33: begin frequency=sol_low;stop=stop_value_4;time_value=time_value_4;    end //100001
            6'd34: begin frequency=la_low;stop=stop_value_4;time_value=time_value_4;    end //100010
            6'd35: begin frequency=si_low;stop=stop_value_4;time_value=time_value_4;    end //100011
            6'd36: begin frequency=do_low;stop=stop_value_16;time_value=time_value_16;    end //100100
            6'd37: begin frequency=re_low;stop=stop_value_16;time_value=time_value_16;    end  //100101
            6'd38: begin frequency=mi_low;stop=stop_value_16;time_value=time_value_16;    end  //100110
            6'd39: begin frequency=fa_low;stop=stop_value_16;time_value=time_value_16;    end  //100111
            6'd40: begin frequency=sol_low;stop=stop_value_16;time_value=time_value_16;    end  //101000
            6'd41: begin frequency=la_low;stop=stop_value_16;time_value=time_value_16;    end  //101001
            6'd42: begin frequency=si_low;stop=stop_value_16;time_value=time_value_16;    end //101010
            6'd43: begin frequency=do_high;stop=stop_value_8;time_value=time_value_8;    end //101011
            6'd44: begin frequency=re_high;stop=stop_value_8;time_value=time_value_8;    end //101100
            6'd45: begin frequency=mi_high;stop=stop_value_8;time_value=time_value_8;    end //101101
            6'd46: begin frequency=fa_high;stop=stop_value_8;time_value=time_value_8;    end //101110
            6'd47: begin frequency=sol_high;stop=stop_value_8;time_value=time_value_8;    end //101111
            6'd48: begin frequency=la_high;stop=stop_value_8;time_value=time_value_8;    end //110000
            6'd49: begin frequency=si_high;stop=stop_value_8;time_value=time_value_8;    end //110001
            6'd50: begin frequency=do_high;stop=stop_value_4;time_value=time_value_4;   end //110010
            6'd51: begin frequency=re_high;stop=stop_value_4;time_value=time_value_4;   end //110011
            6'd52: begin frequency=mi_high;stop=stop_value_4;time_value=time_value_4;   end //110100
            6'd53: begin frequency=fa_high;stop=stop_value_4;time_value=time_value_4;   end //110101
            6'd54: begin frequency=sol_high;stop=stop_value_4;time_value=time_value_4;   end //110110
            6'd55: begin frequency=la_high;stop=stop_value_4;time_value=time_value_4;   end //110111
            6'd56: begin frequency=si_high;stop=stop_value_4;time_value=time_value_4;   end //111000
            6'd57: begin frequency=do_high;stop=stop_value_16;time_value=time_value_16;   end //111001
            6'd58: begin frequency=re_high;stop=stop_value_16;time_value=time_value_16;   end //111010
            6'd59: begin frequency=mi_high;stop=stop_value_16;time_value=time_value_16;   end //111011
            6'd60: begin frequency=fa_high;stop=stop_value_16;time_value=time_value_16;   end //111100
            6'd61: begin frequency=sol_high;stop=stop_value_16;time_value=time_value_16;   end //111101
            6'd62: begin frequency=la_high;stop=stop_value_16;time_value=time_value_16;   end //111110
            6'd63: begin frequency=si_high;stop=stop_value_16;time_value=time_value_16;   end//111111
            endcase
        case(frequency)
             0:begin lights=7'b0000000; isHight=1'b0;isLow=1'b0;end
            do:begin lights=7'b1000000; isHight=1'b0;isLow=1'b0;end
            re:begin lights=7'b0100000; isHight=1'b0;isLow=1'b0; end
            mi:begin lights=7'b0010000;  isHight=1'b0;isLow=1'b0; end
            fa:begin lights=7'b0001000;  isHight=1'b0;isLow=1'b0; end
            sol:begin lights=7'b0000100;  isHight=1'b0;isLow=1'b0; end
            la:begin lights=7'b0000010;  isHight=1'b0;isLow=1'b0; end
            si:begin lights=7'b0000001;  isHight=1'b0;isLow=1'b0; end
            do_high:begin lights=7'b1000000; isHight=1'b1;isLow=1'b0;end
            re_high:begin lights=7'b0100000; isHight=1'b1;isLow=1'b0; end
            mi_high:begin lights=7'b0010000;  isHight=1'b1;isLow=1'b0; end
            fa_high:begin lights=7'b0001000;  isHight=1'b1;isLow=1'b0; end
            sol_high:begin lights=7'b0000100;  isHight=1'b1;isLow=1'b0; end
            la_high:begin lights=7'b0000010;  isHight=1'b1;isLow=1'b0; end
            si_high:begin lights=7'b0000001;  isHight=1'b1;isLow=1'b0; end
            do_low:begin lights=7'b1000000; isHight=1'b0;isLow=1'b1;end
            re_low:begin lights=7'b0100000; isHight=1'b0;isLow=1'b1; end
            mi_low:begin lights=7'b0010000;  isHight=1'b0;isLow=1'b1; end
            fa_low:begin lights=7'b0001000;  isHight=1'b0;isLow=1'b1; end
            sol_low:begin lights=7'b0000100;  isHight=1'b0;isLow=1'b1; end
            la_low:begin lights=7'b0000010;  isHight=1'b0;isLow=1'b1; end
            si_low:begin lights=7'b0000001;  isHight=1'b0;isLow=1'b1; end
            endcase    
        end
        
    end

    





endmodule
