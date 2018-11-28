`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:CPE 133 // Prof. Joseph Callenes-Sloan
// Engineers:Jonathan Honrada, Rocio Sanchez, Jared Rocha
// 
// Create Date: 11/15/2018 04:38:26 PM
// Design Name: Tic Tac Toe Input Module
// Module Name: submission
// Project Name: Tic Tac Toe
// Target Devices: 
// Tool Versions: 
// Description: This module handles the submission of moves by the player. The outputs "player_out" and "z" are tied together in the next module and used to determine the positions being played on the board. We use a submit button "s" to that stores the current move and outputs it to the next module on the rising clockedge.    
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module submission(
   // input player, //represented by a switch, off refers to player1, on refers to player2
    input last_player,
    input [2:0] x,//x-coordinate input represented by 3 switch inputs, receives decoder like inputs (ex. x = 100 refers to the third x column, x = 001 refers to the first column) 
    input [2:0] y,//y -coordinate input represented by 3 switch inputs,
    input reset, //resets the game
    output player_out,//outputs the player who's move is being submitted
    input s,//a submit button
    input clk,//clock input
    output [3:0] z//output which is used to determine the position on the board being occupied in the next module
    );

    reg [3:0] Z = 4'b0000;
    reg play = 1'b0;
    //reg  PS, NS;
    //parameter st_p1 = 1'b0, st_p2 = 1'b1;
    always @ (posedge clk)
    begin
    
    begin   
    if (reset == 0)
    begin
     if (s == 1)
        begin
            if (x == 3'b001 && y == 3'b001)//translating input coordinates into a position
            begin
                Z = 4'b0001;
            end
            else if (x == 3'b001 && y == 3'b010)
            begin
                Z = 4'b0100;
            end
            else if (x == 3'b001 && y == 3'b100)
            begin
               Z = 4'b0111;
            end
            else if (x == 3'b010 && y == 3'b001)
            begin
                 Z = 4'b0010;
             end
             else if (x == 3'b010 && y == 3'b010)
             begin
                Z = 4'b0101;
             end
             else if (x == 3'b010 && y == 3'b100)
             begin
                Z = 4'b1000;
             end
             else if (x == 3'b100 && y == 3'b001)
             begin
                Z = 4'b0011;
             end
             else if (x == 3'b100 && y == 3'b010)
             begin
                Z = 4'b0110;
             end
             else if (x == 3'b100 && y == 3'b100)
             begin
                 Z = 4'b1001;
             end
        end    
    end
             
    else if (reset == 1)
        begin
        Z = 4'b0000;
        end
   end
   if (last_player == 1'b0)
   		begin
   			play = 1'b1;
    	end
   else if(last_player == 1'b1)
    	begin
    		play = 1'b0;
    	end 
   else
        begin
        play = 1'b0;
        end
end

assign player_out = play; //final assignment of registers to outputs
assign z = Z; //these outputs will be tied together as wires in the top module
              // and used to determine which position is being played on the board
    
endmodule
