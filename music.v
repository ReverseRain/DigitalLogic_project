`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 20:13:03
// Design Name: 
// Module Name: music
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


module music(
input clk,
input reset,
    input [6:0] notes, //the nodes player play
input ishigher,
input islower,
input isdefine,
input ismemory,
//input isLoad,
output  pwm,//the sound signal
output [3:0] an,
output reg[6:0]light,
output [6:0]ledlight
    );
    `include "parameter_project.v"
   


    reg[31:0] frequency;
    reg[31:0] count=0;
    reg[2:0] mode;
    reg[1:0] num=2'b11;
    LED led(clk,mode,num,frequency,an,ledlight);
    Buzz buzz(.clk(clk),.frequency(frequency),.pwm(pwm),.reset(reset));
//    memory memory(.clk(clk),.notes(notes),.ishigher(ishigher),.islower(islower),.stopLoad(stopLoad),.reset(reset)); 
   always@(posedge clk)begin
   if(isdefine==1'b1) begin
   mode=define;
   end
   else if(ismemory==1'b1) begin
   mode=memory;
   end
   else
   mode=free;
   end  //change mode
      
    always @(*) begin
        if (!ishigher&&!islower) begin
                case (notes)
        7'b1000000:frequency=do; 
        7'b0100000:frequency=re; 
        7'b0010000:frequency=mi;
        7'b0001000:frequency=fa;  
        7'b0000100:frequency=sol;
        7'b0000010:frequency=la;    
        7'b0000001:frequency=si; 
        default:frequency=0;
            endcase  
        end
        else if (ishigher&&!islower) begin
                     case (notes)
        7'b1000000: frequency=do_high;
        7'b0100000:frequency=re_high;
        
        7'b0010000:frequency=mi_high;
        
        7'b0001000:frequency=fa_high;
        
        7'b0000100:frequency=sol_high;
        
        7'b0000010:frequency=la_high;
        
        7'b0000001:frequency=si_high;
         
        default:frequency=0;
            endcase
            
        end
        
        else if (!ishigher&&islower) begin
            case (notes)
        7'b1000000:frequency=do_low;
        7'b0100000:frequency=re_low;
        7'b0010000:frequency=mi_low;
       
        7'b0001000:frequency=fa_low;
          
        7'b0000100:frequency=sol_low;
         
        7'b0000010:frequency=la_low;
         
        7'b0000001: frequency=si_low;
   
        default:frequency=0;
            endcase
            
        end
        
        else  frequency=0;

        case (notes)
        7'b1000000:light=7'b1000000;
        7'b0100000:light=7'b0100000;
        7'b0010000:light=7'b0010000;
       
        7'b0001000:light=7'b0001000;
          
        7'b0000100:light=7'b0000100;
         
        7'b0000010:light=7'b0000010;
         
        7'b0000001: light=7'b0000001;
            default: light=0;
        endcase
        
        
       
        
    end


endmodule


