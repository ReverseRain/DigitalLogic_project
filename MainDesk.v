`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 20:38:31
// Design Name: 
// Module Name: MainDesk
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


module MainDesk(
    input clk,
    input reset,
    input left,
    input right,
    input up,
    input down,
    input [6:0] notes,
    input ishigher,
    input islower,
    output reg pwm,
    output reg o=0,
    output reg[6:0] light,
    output reg[3:0] an,
    output reg[6:0]ledlight 
    );
     `include "parameter_file.v"

   reg divclk=0;
   reg[31:0] count=0;
   always @(posedge clk ) begin
       if (count<=500000) begin
        count=count+1;
       end
       else begin
        divclk=~divclk;
        count=0;      
       end
   end

  

   reg rq1=0;
   reg rq2=0;
   reg lq1=0;
   reg lq2=0;
   reg uq1=0;
   reg uq2=0;
   reg dq1=0;
   reg dq2=0;

   always @(posedge divclk) begin
      rq1=right;
   end

   always @(posedge divclk) begin
      rq2=rq1;
   end

    assign  right_posedge = rq1& ~rq2;

    always @(posedge divclk) begin
      lq1=left;
   end

   always @(posedge divclk) begin
      lq2=lq1;
   end

    assign  left_posedge = lq1& ~lq2;

    always @(posedge divclk) begin
      uq1=up;
   end

   always @(posedge divclk) begin
      uq2=uq1;
   end

    assign  up_posedge = uq1& ~uq2;

    always @(posedge divclk) begin
      dq1=down;
   end

   always @(posedge divclk) begin
      dq2=dq1;
   end

    assign  down_posedge = dq1& ~dq2;

    // reg[1:0] checkRight=2'b00;
    // always @(posedge divclk ) begin
    //    checkRight<={checkRight[0],right};
    // end
    // assign  right_posedge = ~checkRight[1] & checkRight[0];

    // reg[1:0] checkLeft=2'b00;
    // always @(posedge divclk ) begin
    //    checkLeft<={checkLeft[0],left};
    // end
    // assign  left_posedge = ~checkLeft[1] & checkLeft[0];

    // reg[1:0] checkUp=2'b00;
    // always @(posedge divclk ) begin
    //    checkUp<={checkUp[0],up};
    // end
    // assign  up_posedge = ~checkUp[1] & checkUp[0];

    // reg[1:0] checkDown=2'b00;
    // always @(posedge divclk ) begin
    //    checkDown<={checkDown[0],down};
    // end
    // assign  down_posedge = ~checkDown[1] & checkDown[0];

    // reg[1:0] checkReset=2'b00;
    // always @(posedge divclk ) begin
    //    checkReset<={checkReset[0],reset};
    // end
    // assign  reset_posedge = ~checkReset[1] & checkReset[0];


     wire freepwm;
      wire [3:0] freean;
      wire [6:0] freelight;
      wire [6:0] freeledlight;

      reg isMatch=0;
      reg isAuto=1;
      reg [1:0]song_num;
      wire autoisHight;
      wire autoisLow;
      wire [3:0]autoan;
      wire [6:0]autoledlight;
      wire [6:0]autolight;
      wire autopwm;

      wire selectpwm;
      wire [3:0]selectan;
      wire [6:0]selectledlight;
      wire [6:0]selectlight;





      reg [1:0] state;
      reg [1:0] nextstate;
      reg [1:0] nextsong_num;

      always @(posedge clk ,negedge reset) begin
        if (!reset) begin
          state<=2'b00;
          nextstate<=2'b00;
        end
        else begin
           if (right_posedge) begin
         case(state)
        2'b00: nextstate<=2'b01;
        2'b01: nextstate<=2'b10;
        2'b10: nextstate<=2'b00;
        endcase
      end
      else if (left_posedge) begin
          case(state)
        2'b00: nextstate<=2'b10;
        2'b01: nextstate<=2'b00;
        2'b10: nextstate<=2'b01;
        endcase
      end


         state<=nextstate;




        end
    
      end

      always @(posedge clk ,negedge reset) begin
        if (!reset) begin
          song_num<=song1;
          nextsong_num<=song1;
        end
        else begin
           if (state==2'b10) begin
        if (down_posedge) begin
           case (song_num)
                song1: nextsong_num=song2;
                song2: nextsong_num=song3;
                song3: nextsong_num=song1;
                default: nextsong_num=song1; 
            endcase
        end
        else if (up_posedge) begin
          case (song_num)
                song1: nextsong_num=song3;
                song2: nextsong_num=song1;
                song3: nextsong_num=song2;
                default: nextsong_num=song1; 
            endcase
        end

       end
          song_num<=nextsong_num;

        end
        
      end

    
          
         
         
    


    // always @(*) begin
    //   if (reset_posedge) begin
    //       state=2'b00;
        
          
    //   end
    //   else if (right_posedge) begin
    //      case(state)
    //     2'b00: state=2'b01;
    //     2'b01: state=2'b10;
    //     2'b10: state=2'b00;
    //    // 2'b11: state=2'b00;
    //     endcase
    //   end
    //   else if (left_posedge) begin
    //      case(state)
    //     2'b00: state=2'b11;
    //     2'b01: state=2'b00;
    //     2'b10: state=2'b00;
    //    // 2'b11: state=2'b10;
    //     endcase
    //   end


      

    //    end




  
    wire modechange;
    assign modechange=right_posedge|left_posedge;

 

  

    music freemode(.clk(clk),.notes(notes),.ishigher(ishigher),.islower(islower),.pwm(freepwm),.an(freean),.light(freelight),.ledlight(freeledlight),.reset(reset),.modechange(modechange));
    Automusic automode(.clk(clk),.isMatch(isMatch),.isAuto(isAuto),.present_song(song_num),.an(autoan),.led_light(autoledlight),.lights(autolight),.pwm(autopwm),.reset(reset),.modechange(modechange));
    Selectmode selectmode(.clk(clk),.pwm(selectpwm),.an(selectan),.ledlight(selectledlight),.light(selectlight));

    always @(state) begin
        case (state)
          2'b00 : begin
            pwm=selectpwm;
            light=selectlight;
            ledlight=selectledlight;
            an=selectan;
            
          end
          2'b01: begin
            pwm=freepwm;
            light=freelight;
            ledlight=freeledlight;
            an=freean;
            
          end
          2'b10: begin
            pwm=autopwm;
            light=autolight;
            ledlight=autoledlight;
            an=autoan;
            
          end
          2'b11: begin
            
          end
             
        endcase
    end

    // always @(*) begin
    //   if (reset_posedge) begin
    //     song_num=song1;
    //   end


    //    if (state==2'b10) begin
    //     if (up_posedge) begin
    //        case (song_num)
    //             song1: song_num=song2;
    //             song2: song_num=song3;
    //             song3: song_num=song1;
    //             default: song_num=song1; 
    //         endcase
    //     end
    //     else if (down_posedge) begin
    //       case (song_num)
    //             song1: song_num=song3;
    //             song2: song_num=song1;
    //             song3: song_num=song2;
    //             default: song_num=song1; 
    //         endcase
    //     end

    //    end
    // end

    
    

  
  

endmodule
