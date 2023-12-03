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
input [6:0] notes,
input ishigher,
input islower,
output reg pwm=1'b0,
output [3:0] an,
output [6:0]light
    );
    `include "parameter_project.v"
   


    reg[31:0] frequency;
    reg[31:0] count=0;
    wire[1:0] mode;

    wire[1:0] num;
    assign mode=free;
    assign num=2'b00;
    assign light=notes;
    LED led(clk,mode,num,frequency,an,light);
    
    always @(posedge clk ) begin
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
        default:pwm=0;
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
         
        default:pwm=0;
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
   
        default:pwm=0;
            endcase
            
        end
        
        else  pwm=0;
        
        
       
        
    end




endmodule
