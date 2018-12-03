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
    output [4:1] x,//x-coordinate input represented by 3 switch inputs, receives decoder like inputs (ex. x = 100 refers to the third x column, x = 001 refers to the first column) 
    input [4:1] y,//y -coordinate input represented by 3 switch inputs,
    input reset, //resets the game
    output player_out,//outputs the player who's move is being submitted
  //  input s,//a submit button
    input clk,//clock input
    output [3:0] z//output which is used to determine the position on the board being occupied in the next module
    );

    reg [3:0] Z;
    reg play = 1'b0;
    wire sclk;
    clk_div3 clk_div(
    .clk(clk),
    .sclk(sclk)
    );
    reg[1:0] PS, NS;
    parameter st_1 = 2'b00, st_2 = 2'b01, st_3 = 2'b10, st_4 = 2'b11;
    reg [4:1]col;
    always@(posedge sclk)
    PS <= NS;
    
    always@(*)
    begin
    begin
        case(PS)
            st_1:begin
                col = 4'b0111;
                NS = st_2;
                end
            
            st_2:begin
                col = 4'b1011;
                NS = st_3;
                end
                
            st_3:begin
                col = 4'b1101;
                NS = st_4;
                end
                
            st_4:begin
                col = 4'b1110;
                NS = st_1;
                end
            
            default: begin col = 4'b0111; NS = st_2; end
        endcase
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
/*
    begin
        if(col[1] == 0 && ROW[1] == 0)
        begin
            seg = 8'b10011111;
        end
        else if(col[2] == 0 && ROW[2] == 0)
            begin
                seg = 8'b01001001;
            end
            else if(col[3] == 0 && ROW[3] == 0)
                begin
                    seg = 8'b00011001;
                end
            else 
                begin
                    seg = 8'b11111111;
                end
    end
    end
    assign COL = col;
    assign SEGMENTS = seg;
    assign DISP_EN = 4'b0000;
    endmodule*/
always@(posedge sclk)
 begin
        begin
            if (col[1] == 0 && y[3] == 0)//translating input coordinates into a position
            begin
                Z = 4'b0001;
            end
            else if (col[1] == 0 && y[2] == 0)
            begin
                Z = 4'b0100;
            end
            else if (col[1] == 0 && y[1] == 0)
            begin
               Z = 4'b0111;
            end
            else if (col[2] == 0 && y[3] == 0)
            begin
                 Z = 4'b0010;
             end
             else if (col[2] == 0 && y[2] == 0)
             begin
                Z = 4'b0101;
             end
             else if (col[2] == 0 && y[1] == 0)
             begin
                Z = 4'b1000;
             end
             else if (col[3] == 0 && y[3] == 0)
             begin
                Z = 4'b0011;
             end
             else if (col[3] == 0 && y[2] == 0)
             begin
                Z = 4'b0110;
             end
             else if (col[3] == 0 && y[1] == 0)
             begin
                 Z = 4'b1001;
             end 
             else if (col[4] == 0 && y[4] == 0) // included this case and the last else case to avoid inferring latches
                begin
                Z = 4'b1111;
                end
             else 
                begin
                Z = 4'b1111;
                end
    end
 if (reset == 1)
            begin
            Z = 4'b0000;
            end            
    
   
end

assign x = col;
assign player_out = play; //final assignment of registers to outputs
assign z = Z; //these outputs will be tied together as wires in the top module
              // and used to determine which position is being played on the board
    
endmodule

module clk_div3 (  input clk,
                  output sclk);

  integer MAX_COUNT = 100000; 
  integer div_cnt =0;
  reg tmp_clk=0; 

   always @ (posedge clk)              
   begin
         if (div_cnt == MAX_COUNT) 
         begin
            tmp_clk = ~tmp_clk; 
            div_cnt = 0;
         end else
            div_cnt = div_cnt + 1;  
   end 
   assign sclk = tmp_clk; 
endmodule
