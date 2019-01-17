# TicTacToe_Basys3 #
##### Creators: Jonathan Honrada, Rocio Sanchez, Jared Rocha #####
Brief Description
-----------------
This is a Tic Tac Toe game meant to be implemented on a Basys3 FPGA. All files are coded in Verilog and a constraints file is provided.

Requirements
---------------
- Basys3 Board with USB Cable
- Digilent Pmod Keypad (2x6 pin) 

![Picture:Keypad and Basys 3](https://raw.githubusercontent.com/JonathanHonrada/TicTacToe_Basys3/master/Basys3_PmodKYPD.jpg)
                                    _(image brought to you by someone on the internet)_

Functionality
---------------
This Tic Tac Toe game reads player moves from the Digilent Pmod Keypad accessory and translates them to the gameboard which is shown on the three rightmost anode sections. These anode sections utilize the 3 horizontal bars present in each to create a 3x3 gameboard to play Tic Tac Toe. The left-most anode section is dedicated to displaying which player is currently making the move. Although the keypad attachment has a 4x4 set of buttons, only the 3x3 section with numbers 1 to 9 are used as inputs; the remaining buttons are unused. As one might assume, the 1 key refers to the upper-left section of the board and the number 9 refers to the bottom-right section of the board. One can easily figure out how the rest of the keys on the keypad are mapped to the gameboard.

The game automatically switches from Player 1 to Player 2 after Player 1 makes a move and vice versa. Since X's and O's cannot be represented on a single segment of a seven segment display, we instead represent Player 1 as a solid bar and Player 2 as a flashing bar. The left-most anode section displays a number indicating which player's move it currently is.

When a win is detected by either Player 1 or Player 2 executing a winning move (3 horizontal possibilities, 3 vertical posibilities, or 2 diagonal posibilities), the game is over. This is indicated by the winning player's number being displayed on all the anode sections of the seven segment display. The game can be reset to a new game by using the reset button which is mapped to the upper D-pad key on the Basys 3.

Please click on the picture below for a video demonstration!!

[![Youtube Video: Tic Tac Toe on Basys 3](https://i.ytimg.com/vi/3Zp5S_m8s-U/hqdefault.jpg?sqp=-oaymwEjCPYBEIoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLBg3-e8QM3Py1Z66wh6rr2dO1FEpA)](https://www.youtube.com/watch?v=3Zp5S_m8s-U)

Architecture
--------------
Looking at the black box diagram, we can see that there are is a 4-bit input from the keypad rows and a 4-bit output to the keypad columns. These are signals are both read in our circuit to determine which move is currently being played or in short, they detect a button press for specific keys. The column outputs are used to drive the keypad and this function will be explained later on. There is also a reset input which is used to clear the game board. And there is a 4-bit output DISP_EN which drives the anodes on the seven segment display and a 8-bit output SEGMENTS which drives the segments on the seven segment display. And lastly there is a clock input which is used to synchronize various modules of our circuit.

### Submit Move Module ### 
The first step is creating a module to receive submitted moves. On our schematic, this is the "submit_move" module on the bottom right. This module contains the keypad driver FSM we described in the last step. This module also contains a section dedicated to reading moves while simultaneously submitting read moves to the next module. Again the reading of moves is done by detecting when a column and row on the keypad have both been driven to logic level low. This module also automatically switches between players via the use of a "last_player" signal which indicates the last player who made a move. This signal is generated in the next module.

### Game Controller Module ###
The next module is the "game_controller" which receives moves from the "submit_move" module. And although this module is called the "game_controller", the "win_detector" module also controls part of the game, this is just the name we gave it at the beginning and it stuck. Anyways, this module stores the current moves played in an 18-bit register (2 bits for every space on the 3x3 gameboard). A state of '00' for a space means that it is unoccupied. A state of '01' means that player 1 is occupying that space. A state of '10' means that player 2 is occupying that space. This module also does not allow moves to be over written. The reset signal is also received here as a special input move from the "submit_move" module. If this signal is received, it sets all spaces registers back to '00', starting a new game. When moves are stored in the 18-bit register, they are simultaneously being read by our "win_detector" module and our "seven_segment_display" module.

### Win Detector Module ### 
The "win_detector" controls the current state of the game by reading the current moves played that are stored in the 18 bit register. If no win has been detected, a two-bit signal '00' is sent to the display module which tells it to continue displaying the game. If a win for player one is detected, a signal '01' is sent to the display module, telling it to display a flashing 1 on all anode sections of the display. If a win for player two is detected, a signal '10' is sent to the display module, telling it to display a flashing 2 on all anode sections of the display. If a tie is detected (all spaces occupied but no winner detected), a signal '11' is sent to the display module telling it to display the words tie. After a tie or win is detected, a signal is sent to a counter that counts for 4 seconds before sending a signal that auto-resets the game.

### Seven Segment Display Module ###
The last module is the "seven_segment_module" which was borrowed from Professer Joseph Callenes-Sloan. This display is a multiplexed display which cycles through a set of segment bits at a very fast rate, allowing the viewer to perceive a constant gameboard. The outputs of this module, "SEGMENTS[7:0]" (cathodes) and "DISP_EN[3:0]" (anodes) are used to drive the seven segment display. The game also receives an inverted "last_player" input to display the current player making the move.

![Picture:Elaborated Design](https://raw.githubusercontent.com/JonathanHonrada/TicTacToe_Basys3/master/elaborated_design.png)

It's worthwhile to describe the operational characteristics of the Pmod Keypad since it's an external device which is necessary to implement this game properly.

An FSM is used to sequentially drive each column to a low logic level while a high logic level is maintained on the remaining columns. This happense sequentially from left to right and wraps around when it reaches the rightmost column. When a button is pressed, a switch is closed and the row at which the button is located is subsequently driven to a low logic level. The input module of this circuit then reads when both a column and row are at logic level low to determine which button is currently being pressed. This sequencing of the keypad is not done syncronously with the main driving clock of the circuit. This design choice was made by because doing so resulted in the FSM failing to properly read button presses. Coming back to it now (a month and a half later), I realize this was probably due to some timing issue, but if you wish to use this driving FSM feel free to mess around with the clock divider and find an optimal value to drive the keypad.

![Picture:Keypad Module](https://i.imgur.com/PWv8lRb.png)

Future Implementations
----------------
At the moment we are considering several future implementations or features that we may add or you can add to this project. The first of these is an auto reset that resets the game once a win or a tie has been connected. The master reset button would still function alongside this feature. To implement this, we would need to wire a second-based counter to our win detector finite state machine that would begin a count for say, 4 or 5 seconds, and then assert a reset signal which would also inherently set the win signal back to zero (no winner/game being played - state).

Acknowledgments and Other Thoughts
----------------------------
The code for the Clock Divider and Seven Segment Display Driver were borrowed from Professor Joseph Callenes-Sloan at Cal Poly SLO. We also took inspiration from the design [these fellas](https://www.youtube.com/watch?v=Il5ZAfsUkPk) created, although our design was mostly original aside from the seven segment display driver. Please feel free to try and implement this on your own and make your own modifications.
