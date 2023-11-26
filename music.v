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


    reg[31:0] frequency;
    reg[31:0] count=0;
    
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
