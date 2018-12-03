`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2018 12:59:29 AM
// Design Name: 
// Module Name: tic_tac_toe_top
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


module tic_tac_toe_top(
   // input [4:1] x,
 //   input [4:1] y,
    input reset,
    input clk,
   // input player,
   // input submit,
    output [3:0] DISP_EN,
    output [7:0] SEGMENTS,
    output [4:1] COL,
    input [4:1] ROW
    );
wire [3:0] zz;
wire pp;
wire last_player;
//wire [4:1]col;
/*keypad_driver keypad_driver(
.clk(clk),
.COL(col)
);*/
//assign COL = col;
submission submit_move(
.last_player(last_player),
.reset(reset),
.x(COL),
.y(ROW),
.clk(clk),
//.player(player),
//.s(submit),
.player_out(pp),
.z(zz)
);

wire[1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9;
wire [1:0] win;
game game_controller(
//.reset(reset),
.clk(clk),
.move({pp,zz}),  
.pos1(pos1),
.pos2(pos2),
.pos3(pos3),
.pos4(pos4),
.pos5(pos5),
.pos6(pos6),
.pos7(pos7),
.pos8(pos8),
.pos9(pos9),
.last_player(last_player)
//.win(win) 
);

win_detector win_detector(
.clk(clk),
//.reset(reset),
.pos1(pos1),
.pos2(pos2),
.pos3(pos3),
.pos4(pos4),
.pos5(pos5),
.pos6(pos6),
.pos7(pos7),
.pos8(pos8),
.pos9(pos9),
.win(win)
);

BC_DEC seven_segment_display(
.player({!last_player}),
.pos1(pos1),
.pos2(pos2),
.pos3(pos3),
.pos4(pos4),
.pos5(pos5),
.pos6(pos6),
.pos7(pos7),
.pos8(pos8),
.pos9(pos9),
.win(win),
.CLK(clk),
.DISP_EN(DISP_EN),
.SEGMENTS(SEGMENTS)
);

endmodule
