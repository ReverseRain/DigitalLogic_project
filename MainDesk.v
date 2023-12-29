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
    input confirm,
    output reg pwm,
    output reg[6:0] light,
    output reg[3:0] an,
    output reg[6:0]ledlight 
    );
     `include "parameter_project.v"
     
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
      rq1<=right;
      rq2<=rq1;
   end

   

    assign  right_posedge = rq1& ~rq2;

    always @(posedge divclk) begin
      lq1<=left;
      lq2<=lq1;
   end

   

    assign  left_posedge = lq1& ~lq2;

    always @(posedge divclk) begin
      uq1<=up;
      uq2<=uq1;
   end

   

    assign  up_posedge = uq1& ~uq2;

    always @(posedge divclk) begin
      dq1<=down;
      dq2<=dq1;
   end

   

    assign  down_posedge = dq1& ~dq2;
    
    reg [2:0] state;
          reg [2:0] nextstate;
          reg [1:0] nextsong_num;
          reg [1:0]song_num;
    
          always @(posedge divclk ,negedge reset) begin
            if (!reset) begin
              state<=3'b000;
              nextstate<=3'b000;
            end
            else begin
               if (right_posedge) begin
             case(state)
            3'b000: nextstate<=3'b001;
            3'b001: nextstate<=3'b010;
            3'b010: nextstate<=3'b011;
            3'b011: nextstate<=3'b100; 
            3'b100: nextstate<=3'b101;
            3'b101: nextstate<=3'b000;           
            endcase
          end
          else if (left_posedge) begin
              case(state)
            3'b101: nextstate<=3'b100;
            3'b100: nextstate<=3'b011;
            3'b011: nextstate<=3'b010;
            3'b010: nextstate<=3'b001;
            3'b001: nextstate<=3'b000;
            3'b000: nextstate<=3'b101;
            endcase
          end
             state<=nextstate;
    
            end
        
          end
    
          always @(posedge divclk ,negedge reset) begin
            if (!reset) begin
              song_num<=song1;
              nextsong_num<=song1;
            end
            else begin
               if (state==3'b010||state==3'b011) begin
            if (down_posedge) begin
               case (song_num)
                    song1: nextsong_num<=song2;
                    song2: nextsong_num<=song3;
                    song3: nextsong_num<=song1;
                    default: nextsong_num<=song1; 
                endcase
            end
            else if (up_posedge) begin
              case (song_num)
                    song1: nextsong_num<=song3;
                    song2: nextsong_num<=song1;
                    song3: nextsong_num<=song2;
                    default: nextsong_num<=song1; 
                endcase
            end
    
           end
              song_num<=nextsong_num;
    
            end
            
          end

    
    


 

    
    
      wire freepwm;
      wire [3:0] freean;
      wire [6:0] freelight;
      wire [6:0] freeledlight;

//      reg isMatch=1'b0;
//      reg isAuto=1'b1;
      
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

      wire learnpwm;
      wire [3:0]learnan;
      wire [6:0]learnledlight;
      wire [6:0]learnlight;
      
     wire definepwm;
    wire [3:0]definean;
     wire [6:0]defineledlight;
      wire [6:0]definelight;
      reg enable;
      
      wire memorypwm;
      wire [3:0]memoryan;
      wire [6:0]memoryledlight;
      wire [6:0]memorylight;
      reg memoryenable;
      
      wire modechange;
          assign modechange=right_posedge|left_posedge;
      
    music freemode(.clk(clk),.notes(notes),.ishigher(ishigher),.islower(islower),.pwm(freepwm),.an(freean),.light(freelight),.isdefine(false),.ledlight(freeledlight),.reset(reset),.ismemory(false));
    Automusic automode(.clk(clk),.isMatch(false),.isAuto(true),.present_song(song_num),.an(autoan),.led_light(autoledlight),.lights(autolight),.pwm(autopwm),.reset(reset),.modechange(modechange),.isMemory(false),.outfre(0));
    Selectmode selectmode(.clk(clk),.pwm(selectpwm),.an(selectan),.ledlight(selectledlight),.light(selectlight));
    learning learnMachain(.clk(clk),.present_song(song_num),.play(notes),.reset(reset),.ishigher(ishigher),.islower(islower),.an(learnan),.led_light(learnledlight),.lights(learnlight),.pwm(learnpwm),.modechange(modechange));
    definite definemode(.confirm(confirm),.clk(clk),.play(notes),.ishigher(ishigher),.islower(islower),.reset(reset),.an(definean),.led_light(defineledlight),.lights(definelight),.pwm(definepwm),.enable(enable));
    memory memorymode(.clk(clk),.notes(notes),.ishigher(ishigher),.islower(islower),.reset(reset),.enable(confirm),.an(memoryan),.ledlight(memoryledlight),.light(memorylight),.pwm(memorypwm),.isMemory(memoryenable));
    
    always @(state) begin
        case (state)
          3'b000 : begin
            pwm=selectpwm;
            light=selectlight;
            ledlight=selectledlight;
            an=selectan;
            enable=false;
            memoryenable=false;
          end
          3'b001: begin
            pwm=freepwm;
            light=freelight;
            ledlight=freeledlight;
            an=freean;
            enable=false;
            memoryenable=false;
          end
          3'b010: begin
            pwm=autopwm;
            light=autolight;
            ledlight=autoledlight;
            an=autoan;
            enable=false;
            memoryenable=false;
          end
          3'b011: begin
            pwm=learnpwm;
            light=learnlight;
            ledlight=learnledlight;
            an=learnan;
            enable=false;
            memoryenable=false;
          end
          3'b100: begin
          pwm=definepwm;
          light=definelight;
          ledlight=defineledlight;
          an=definean;
          enable=true;
          memoryenable=false;
          end 
          3'b101:begin
          pwm=memorypwm;
          light=memorylight;
          ledlight=memoryledlight;
          an=memoryan;
          enable=false;
          memoryenable=true;
          end  
        endcase
    end

//    always @(*) begin
//       if (state==2'b10) begin
//        if (up_posedge) begin
//           case (song_num)
//                song1: song_num=song2;
//                song2: song_num=song3;
//                song3: song_num=song1;
//                default: song_num=song1; 
//            endcase
//        end
//        else if (down_posedge) begin
//          case (song_num)
//                song1: song_num=song3;
//                song2: song_num=song1;
//                song3: song_num=song2;
//                default: song_num=song1; 
//            endcase
//        end

//       end
//    end

    
    

  
  

endmodule
