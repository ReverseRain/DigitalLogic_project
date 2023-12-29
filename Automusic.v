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
 input  reset,
 input modechange,
 
 

 
 output pwm,

 input [31:0]outfre,
 input isMatch,
 input isAuto,
 input isMemory,
 input [1:0]present_song,// the song number
  output reg[13:0]outaddress=0,
  output reg isHight,
  output reg isLow,
  output [3:0] an,
  output [6:0] led_light,
  output reg[6:0]  lights,
  output reg[31:0] index,

  output reg isEnd
//  output reg[31:0] frequency
 
    );
     `include "parameter_project.v"

   
    
   
    
    reg[31:0] true_frequency;
    reg[31:0] frequency;
 reg[31:0] tv_count; //The counter computes the time of every notes
    reg isSlience;
//    reg isEnd;
    reg [2000:0]melody;
    reg [31:0]melody_length;
 reg[31:0]  stop;// silence time
 reg[31:0]  time_value;// play time
    reg[1:0] modes;
 reg[31:0] gap_time;// The diffenent time between player and the standard time


    LED led(clk,modes,present_song,frequency,an,led_light);
    Buzz buzz(.clk(clk),.frequency(frequency),.pwm(pwm),.reset(reset),.modechange(modechange));

    reg[1:0] last_song;reg lastMemory;

    
    always @(posedge clk,negedge reset) begin
     if (last_song!=present_song||lastMemory!=isMemory) begin //when change song,initiate
           lastMemory<=isMemory;
            last_song=present_song;
            case (present_song)
               song1: begin melody_length<=littleStar_length;melody<=littleStar; end
               song2:begin melody_length<=happyBirthday_length;melody<=happyBirthday;end
               song3:begin melody_length<=happiness_length;melody<=happiness; end
            endcase
            gap_time<=0;
            tv_count<=0;
            index<=0;     
            isEnd<=1'b0;
            isSlience<=1'b1;
            outaddress<=0;
        end
        //how to stop?
     if(isAuto==1'b0&&isEnd==1'b0) modes<=learn; // The learning part
        else if(isAuto==1'b1&&isMemory==1'b1) modes<=memory;
        else if(isAuto==1'b1&&isMemory==1'b0) modes<=auto;
        else if(isAuto==1'b0&&isEnd==1'b1)begin
        if(gap_time<900000000)
        modes<=select;
        else if(gap_time<2000000000)
        modes<=auto;
        else
        modes<=free;
        end
        if (modechange) begin
             tv_count<=0;
            index<=0;     
            isEnd<=1'b0;
            isSlience<=1'b1;
            melody_length<=littleStar_length;
            melody<=littleStar;
            last_song<=song1;
            gap_time<=0;
            outaddress<=0;
        end

        if (!reset) begin
            tv_count<=0;
            index<=0;     
            isEnd<=1'b0;
            isSlience<=1'b1;
            melody_length<=littleStar_length;
            melody<=littleStar;
            last_song<=song1;
            outaddress<=0;
        end
        else begin
            if (index>=melody_length) isEnd<=1'b1;
        else isEnd<=1'b0;
        if(isAuto==1'b1||(isMatch==1'b1&&isAuto==1'b0)) begin
        if (!isEnd) begin
            if (tv_count<stop) begin
                isSlience<=1'b1;
                tv_count<=tv_count+1'b1;
            end
            else if (tv_count>=stop&&tv_count<time_value) begin
                isSlience<=1'b0;
                tv_count<=tv_count+1'b1;
            end
            else if(tv_count>=time_value) begin
                tv_count=32'h0000;
                index=index+1'b1;  
                if(isMemory==1'b1) begin
                outaddress<=outaddress+1'b1;
                 end                                     
            end     
        end
        else if(isAuto==1'b1) begin
            tv_count<=0;
            index<=0;     
            isEnd<=1'b0;
            isSlience<=1'b1;
        end
      else if(isAuto==1'b0) begin
      isSlience<=1'b1;
      end
       
end
else if(isMatch==1'b0&&isAuto==1'b0)begin
gap_time<=gap_time+1;
        end
    end    
        
    end

    always @(*) begin
        if (isSlience) begin
            frequency=0;
        end
        else begin
        if(isMemory==1'b0) begin
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
           end
           else if(isMemory==1'b1) begin
           frequency=outfre;
           stop=stop_value_4;time_value=time_value_4;
           end
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
