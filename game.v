`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:CPE 133 / Prof. Joseph Callenes-Sloan 
// Engineer:Jonathan Honrada, Rocio Sanchez, Jared Rocha
// 
// Create Date: 11/19/2018 04:03:22 PM
// Design Name:Tic Tac Toe Game Module
// Module Name:game
// Project Name:Tic Tac Toe
// Target Devices: 
// Tool Versions: 
// Description:This module translates and stores player move inputs into registers that are sent to a "Win Detection" module and the Seven Segment Display module. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module game(
//input reset,
input [4:0] move, //5-bit input receiving the submitted move from the first module the MSB indicates the player(0 == player 1, 1 == player 2) and the remaing bits are used to determine which position is being played on the board 
input clk,
output last_player,
output [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9//9 position signals corresponding to spaces on the board, these are received by the display module and are translated to spaces on the board
//output [1:0] win
    );
reg [17:0] pos_reg = 18'b000000000000000000;
reg last_play;
//reg [1:0] win_signal = 2'b00;

always@(posedge clk)
    begin
    if(move == 5'b00001 && pos_reg[1:0] == 2'b00) //translation and storing of moves into registers, will not overwrite space if player 2 already owns it
        begin
        pos_reg[1:0] = 2'b01; //pos1 <= player1
	last_play = 1'b0;
        end
    else if(move == 5'b00010 && pos_reg[3:2] == 2'b00)
        begin
        pos_reg[3:2] = 2'b01; //pos2 <= player1
	last_play = 1'b0;
        end
    else if(move == 5'b00011 && pos_reg[5:4] == 2'b00)
        begin
        pos_reg[5:4] = 2'b01; //pos3 <= player1
	last_play = 1'b0;
        end
    else if(move == 5'b00100 && pos_reg[7:6] == 2'b00)
        begin
        pos_reg[7:6] = 2'b01; //pos4 <= player1
	last_play = 1'b0;
        end
    else if(move == 5'b00101 && pos_reg[9:8] == 2'b00)
        begin
        pos_reg[9:8] = 2'b01; //pos5 <= player1
	last_play = 1'b0;
        end
    else if(move == 5'b00110 && pos_reg[11:10] == 2'b00)
        begin
        pos_reg[11:10] = 2'b01; //pos6 <= player1
	last_play = 1'b0;
        end
    else if(move == 5'b00111 && pos_reg[13:12] == 2'b00)
         begin
         pos_reg[13:12] = 2'b01; //pos7 <= player1
	 last_play = 1'b0;
         end
    else if(move == 5'b01000 && pos_reg[15:14] == 2'b00)
         begin
         pos_reg[15:14] = 2'b01; //pos8 <= player1
	last_play = 1'b0;
         end
     else if(move == 5'b01001 && pos_reg[17:16] == 2'b00)
         begin
         pos_reg[17:16] = 2'b01; //pos9 <= player1
	last_play = 1'b0;
         end
     else if(move == 5'b10001 && pos_reg[1:0] == 2'b00) 
         begin
         pos_reg[1:0] = 2'b10; //pos1 <= player2
	last_play = 1'b1;
         end
     else if(move == 5'b10010 && pos_reg[3:2] == 2'b00)
         begin
         pos_reg[3:2] = 2'b10; //pos2 <= player2
	last_play = 1'b1;
         end
     else if(move == 5'b10011 && pos_reg[5:4] == 2'b00)
         begin
         pos_reg[5:4] = 2'b10; //pos3 <= player2
	last_play = 1'b1;
         end
     else if(move == 5'b10100 && pos_reg[7:6] == 2'b00)
         begin
         pos_reg[7:6] = 2'b10; //pos4 <= player2
	last_play = 1'b1;
         end
     else if(move == 5'b10101 && pos_reg[9:8] == 2'b00)
         begin
         pos_reg[9:8] = 2'b10; //pos5 <= player2
	last_play = 1'b1;
         end
     else if(move == 5'b10110 && pos_reg[11:10] == 2'b00)
         begin
         pos_reg[11:10] = 2'b10; //pos6 <= player2
	last_play = 1'b1;
         end
     else if(move == 5'b10111 && pos_reg[13:12] == 2'b00)
          begin
          pos_reg[13:12] = 2'b10; //pos7 <= player2
	last_play = 1'b1;
          end
     else if(move == 5'b11000 && pos_reg[15:14] == 2'b00)
          begin
          pos_reg[15:14] = 2'b10; //pos8 <= player2
	last_play = 1'b1;
          end
      else if(move == 5'b11001 && pos_reg[17:16] == 2'b00)
	  begin
          pos_reg[17:16] = 2'b10; //pos9 <= player2
	last_play = 1'b1;
          end
      else if (move == 5'b10000 || move == 5'b00000) //if reset signal is received, clears all spaces by setting them to zero
          begin
            pos_reg = 18'b000000000000000000;
		last_play = 1'b1;
          end
      else
        begin
        pos_reg <= pos_reg;
        end
    end

assign pos1 = pos_reg[1:0]; //assign position registers to their specific output which will be translated to positions on the SSD
assign pos2 = pos_reg[3:2];
assign pos3 = pos_reg[5:4];
assign pos4 = pos_reg[7:6];
assign pos5 = pos_reg[9:8];
assign pos6 = pos_reg[11:10];
assign pos7 = pos_reg[13:12];
assign pos8 = pos_reg[15:14];
assign pos9 = pos_reg[17:16];
assign last_player = last_play;
/*
always@(*)
begin
if(pos1 == 2'b01 && pos2 == 2'b01 && pos3 == 2'b01 ||
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
else if(pos1 == 2'b10 && pos2 == 2'b10 && pos3 == 2'b10 ||
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
 else
    begin
    win_signal = 2'b00;
    end
end
assign win = win_signal;
*/    
endmodule
