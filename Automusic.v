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

    parameter do_high =47801 ;
    parameter re_high =42553 ;
    parameter mi_high =37936 ;
    parameter fa_high =35791 ;
    parameter sol_high =31888 ;
    parameter la_high =28409 ;
    parameter si_high =25304 ;
    
    
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
    parameter littleStar =294'b000000_001000_001001_001001_001010_001010_001011_001011_000000_001100_001101_001101_001100_001100_001000_001000_000000_001001_001010_001010_001011_001011_001100_001100_000000_001001_001010_001010_001011_001011_001100_001100_000000_001000_001001_001001_001010_001010_001011_001011_000000_001100_001101_001101_001100_001100_001000_001000_000000;


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
            6'd0: begin frequency=0;stop=stop_value_8;time_value=time_value_8;    end
            6'd1: begin frequency=do;stop=stop_value_8;time_value=time_value_8;    end
            6'd2: begin frequency=re;stop=stop_value_8;time_value=time_value_8;    end
            6'd3: begin frequency=mi;stop=stop_value_8;time_value=time_value_8;    end
            6'd4: begin frequency=fa;stop=stop_value_8;time_value=time_value_8;    end
            6'd5: begin frequency=sol;stop=stop_value_8;time_value=time_value_8;    end
            6'd6: begin frequency=la;stop=stop_value_8;time_value=time_value_8;    end
            6'd7: begin frequency=si;stop=stop_value_8;time_value=time_value_8;    end
            6'd8: begin frequency=do;stop=stop_value_4;time_value=time_value_4;    end
            6'd9: begin frequency=re;stop=stop_value_4;time_value=time_value_4;    end
            6'd10: begin frequency=mi;stop=stop_value_4;time_value=time_value_4;    end
            6'd11: begin frequency=fa;stop=stop_value_4;time_value=time_value_4;    end
            6'd12: begin frequency=sol;stop=stop_value_4;time_value=time_value_4;   end
            6'd13: begin frequency=la;stop=stop_value_4;time_value=time_value_4;end    
            6'd14: begin frequency=si;stop=stop_value_4;time_value=time_value_4;   end
            6'd15: begin frequency=do;stop=stop_value_16;time_value=time_value_16;   end
            6'd16: begin frequency=re;stop=stop_value_16;time_value=time_value_16;   end
            6'd17: begin frequency=mi;stop=stop_value_16;time_value=time_value_16;   end
            6'd18: begin frequency=fa;stop=stop_value_16;time_value=time_value_16;   end
            6'd19: begin frequency=sol;stop=stop_value_16;time_value=time_value_16;   end
            6'd20: begin frequency=la;stop=stop_value_16;time_value=time_value_16;   end
            6'd21: begin frequency=si;stop=stop_value_16;time_value=time_value_16;   end 
            6'd22: begin frequency=do_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd23: begin frequency=re_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd24: begin frequency=mi_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd25: begin frequency=fa_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd26: begin frequency=sol_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd27: begin frequency=la_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd28: begin frequency=si_low;stop=stop_value_8;time_value=time_value_8;    end
            6'd29: begin frequency=do_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd30: begin frequency=re_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd31: begin frequency=mi_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd32: begin frequency=fa_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd33: begin frequency=sol_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd34: begin frequency=la_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd35: begin frequency=si_low;stop=stop_value_4;time_value=time_value_4;    end
            6'd36: begin frequency=do_low;stop=stop_value_16;time_value=time_value_16;    end
            6'd37: begin frequency=re_low;stop=stop_value_16;time_value=time_value_16;    end  
            6'd38: begin frequency=mi_low;stop=stop_value_16;time_value=time_value_16;    end
            6'd39: begin frequency=fa_low;stop=stop_value_16;time_value=time_value_16;    end
            6'd40: begin frequency=sol_low;stop=stop_value_16;time_value=time_value_16;    end  
            6'd41: begin frequency=la_low;stop=stop_value_16;time_value=time_value_16;    end  
            6'd42: begin frequency=si_low;stop=stop_value_16;time_value=time_value_16;    end
            6'd43: begin frequency=do_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd44: begin frequency=re_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd45: begin frequency=mi_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd46: begin frequency=fa_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd47: begin frequency=sol_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd48: begin frequency=la_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd49: begin frequency=si_high;stop=stop_value_8;time_value=time_value_8;    end 
            6'd50: begin frequency=do_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd51: begin frequency=re_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd52: begin frequency=mi_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd53: begin frequency=fa_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd54: begin frequency=sol_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd55: begin frequency=la_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd56: begin frequency=si_high;stop=stop_value_4;time_value=time_value_4;   end
            6'd57: begin frequency=do_high;stop=stop_value_16;time_value=time_value_16;   end
            6'd58: begin frequency=re_high;stop=stop_value_16;time_value=time_value_16;   end
            6'd59: begin frequency=mi_high;stop=stop_value_16;time_value=time_value_16;   end
            6'd60: begin frequency=fa_high;stop=stop_value_16;time_value=time_value_16;   end
            6'd61: begin frequency=sol_high;stop=stop_value_16;time_value=time_value_16;   end
            6'd62: begin frequency=la_high;stop=stop_value_16;time_value=time_value_16;   end
            6'd63: begin frequency=si_high;stop=stop_value_16;time_value=time_value_16;   end


            
            





            endcase
        end
        
    end

    





endmodule
