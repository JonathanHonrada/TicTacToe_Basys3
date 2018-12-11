`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2018 10:06:19 AM
// Design Name: Tic Tac Toe Win Detection Module
// Module Name: win_detector
// Project Name: Tic Tac Toe
// Target Devices: 
// Tool Versions: 
// Description: This module receives the current positions being played on the board and detects if a winning move is played. Once a win is detected, a signal is sent to the seven segment display module indicating whether it was player 1 or player 2 who won.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module win_detector(
input clk,
input [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
output [1:0] win,
output reset
    );
wire finclk;
wire auto_reset;
clk_div4 clk_div4(
.clk(clk),
.sclk(finclk)
);

count_to_five count_to_five(
.clk(finclk),
.in(win),
.reset(auto_reset)
);

reg res;
reg [1:0]  win_signal;
always@(posedge clk)
    begin
    if (auto_reset == 0)
    begin
    if(pos1 == 2'b01 && pos2 == 2'b01 && pos3 == 2'b01 || //win detection for player 1
        pos4 == 2'b01 && pos5 == 2'b01 && pos6 == 2'b01 ||
        pos7 == 2'b01 && pos8 == 2'b01 && pos9 == 2'b01 ||
        pos1 == 2'b01 && pos5 == 2'b01 && pos9 == 2'b01 ||
        pos7 == 2'b01 && pos5 == 2'b01 && pos3 == 2'b01 ||
        pos1 == 2'b01 && pos4 == 2'b01 && pos7 == 2'b01 ||
        pos2 == 2'b01 && pos5 == 2'b01 && pos8 == 2'b01 ||
        pos3 == 2'b01 && pos6 == 2'b01 && pos9 == 2'b01)
        begin
            win_signal = 2'b01;
            res = 0;
        end
    else if(pos1 == 2'b10 && pos2 == 2'b10 && pos3 == 2'b10 || //win detection for player 2
            pos4 == 2'b10 && pos5 == 2'b10 && pos6 == 2'b10 ||
            pos7 == 2'b10 && pos8 == 2'b10 && pos9 == 2'b10 ||
            pos1 == 2'b10 && pos5 == 2'b10 && pos9 == 2'b10 ||
            pos7 == 2'b10 && pos5 == 2'b10 && pos3 == 2'b10 ||
            pos1 == 2'b10 && pos4 == 2'b10 && pos7 == 2'b10 ||
            pos2 == 2'b10 && pos5 == 2'b10 && pos8 == 2'b10 ||
            pos3 == 2'b10 && pos6 == 2'b10 && pos9 == 2'b10)
            begin
                win_signal = 2'b10;
                res = 0;
            end
    else if(pos1 > 0 && pos2 > 0 && pos3 > 0 && pos4 > 0 &&
            pos5 > 0 && pos6 > 0 && pos7 > 0 && pos8 > 0 &&
            pos9 > 0 && win_signal != 2'b10 && win_signal != 2'b10) // tie detector
     	begin 
        win_signal = 2'b11;
        res = 0;
    	end
    	
    else//default win signal of 00 which means game is still being played
        begin
        win_signal = 2'b00;
        res = 0;
        end
    end
    else if(auto_reset == 1)
        begin 
        win_signal = 2'b00;
        res = 1;
        end
    
end


assign reset = res;
assign win = win_signal;
endmodule

module clk_div4 (
   input clk,
   output sclk
);

integer MAX_COUNT = 10000000; 
integer div_cnt =0;
reg tmp_clk=0; 

always @ (posedge clk)              
begin
   if (div_cnt == MAX_COUNT) 
      begin
      tmp_clk = ~tmp_clk; 
      div_cnt = 0;
      end 
   else
      div_cnt = div_cnt + 1;  
end 
assign sclk = tmp_clk; 
   
endmodule

module count_to_five (input clk, //counter that counts to 5 then submits a reset seignal 
input [1:0] in,
output reset
);
reg PS,NS;
parameter [1:0] IDLE = 2'b00, COUNT = 2'b01;
reg res = 0;
integer  cnt_dig = 0;
always@(posedge clk)
PS <= NS;


always@(posedge clk)
begin
    case(PS)
        IDLE:
            begin
            if (in == 2'b00)
                begin
                res = 0;
                NS = IDLE;
                end
            else  // if a win or tie is detected switch to count state
                begin
                NS = COUNT;
                res = 0;
                cnt_dig = 0;
                end
            end
            
         COUNT:
            begin
            
            if(cnt_dig < 12) //count to 12 at divided clock's edge --> ~4 seconds
                begin
                cnt_dig = cnt_dig + 1;
                NS = COUNT;
                res = 0;
                end
            else if (cnt_dig == 12) //once count reaches 12, send reset signal, next state idle
                begin
                NS = IDLE;
                res = 1;
                end
            end
            
         default:
            begin
             if (in == 2'b00)
                 begin
                 res = 0;
                 NS = IDLE;
                 end
             else
                 begin
                 NS = COUNT;
                 res = 0;
                 end
             end
         endcase
                
end

assign reset = res;
endmodule


