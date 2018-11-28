# TicTacToe_Basys3
#### Creators: Jonathan Honrada, Rocio Sanchez, Jared Rocha
Brief Description
---------------
This is a Tic Tac Toe game meant to be implemented on a Basys3 FPGA. All files are coded in Verilog and a constraints file is provided.

Functionality
---------------
This game of Tic Tac Toe has 6 input switches and two button inputs. The three left-most swithches represent the x-axis of the 
Tic Tac Toe board and the three right-most switches represent the y-axis of the board. These two 3-bit switch buses will take a 
one-hot code and translate that to a position on the board. This input is read when the submit button, represented by the bottom 
button is pressed. For example, if the left-most switches and right-most switches are toggled as such respectively, [1 0 0] and 
[0 1 0], these coordinates represent the first column and second row, and a players move will be stored at that location. There
is also a reset button, which is the top button on the Basys3. When asserted, the reset button clears the game board completely.

//player-switching, flashing vs solid

//win indication

//possible changes or features

Architecture
--------------
