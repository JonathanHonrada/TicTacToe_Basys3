# TicTacToe_Basys3
#### Creators: Jonathan Honrada, Rocio Sanchez, Jared Rocha
Brief Description
---------------
This is a Tic Tac Toe game meant to be implemented on a Basys3 FPGA. All files are coded in Verilog and a constraints file is provided.

Requirements
---------------
- Basys3 Board with USB Cable
- Digilent Pmod Keypad (2x6 pin) 

![alt text](https://instructure-uploads-2.s3.amazonaws.com/account_20000000000009/attachments/59084640/Basys3_PmodKYPD.jpg?response-content-disposition=attachment%3B%20filename%3D%22Basys3_PmodKYPD.jpg%22%3B%20filename%2A%3DUTF-8%27%27Basys3%255FPmodKYPD.jpg&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJDW777BLV26JM2MQ%2F20181203%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20181203T181741Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=f31cf70a7ad3f50690393487f03a6280c0a87bed23b8c8a00bd72b9151d1e1fe)

Functionality
---------------
This Tic Tac Toe game reads player moves from the Digilent Pmod Keypad accessory and translates them to the gameboard which is shown on the three rightmost anode sections. These anode sections utilize the 3 horizontal bars present in each to create a 3x3 gameboard to play Tic Tac Toe. The left-most anode section is dedicated to displaying which player is currently making the move. Although the keypad attachment has a 4x4 set of buttons, only the 3x3 section with numbers 1 to 9 are used as inputs; the remaining buttons are unused. As one might assume, the 1 key refers to the upper-left section of the board and the number 9 refers to the bottom-right section of the board. One can easily figure out how the rest of the keys on the keypad are mapped to the gameboard.

The game automatically switches from Player 1 to Player 2 after Player 1 makes a move and vice versa. Since X's and O's cannot be represented on a single segment of a seven segment display, we instead represent Player 1 as a solid bar and Player 2 as a flashing bar. The left-most anode section displays a number indicating which player's move it currently is.

When a win is detected by either Player 1 or Player 2 executing a winning move (3 horizontal possibilities, 3 vertical posibilities, or 2 diagonal posibilities), the game is over. This is indicated by the winning player's number being displayed on all the anode sections of the seven segment display. The game can be reset to a new game by using the reset button which is mapped to the upper D-pad key on the Basys 3.

Architecture
--------------
