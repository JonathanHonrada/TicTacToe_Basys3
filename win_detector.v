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
output [1:0] win

    );


reg [1:0]  win_signal;
always@(posedge clk)
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
            end
    else //default win signal of 00 which means game is still being played
     	begin 
        win_signal = 2'b00;
    	end
    end

assign win = win_signal;

endmodule
