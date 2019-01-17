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

### "Submit Move" Module ### 
has an fsm which drives keypad(col output), reads from keypad(encoding), switches players after turn is done,reset input which submits a special move "0000" that clears the 18-bit game register;

### "Game Controller" Module ###
decodes output from submit move module into positions on the board stored in 18-bit register, tells the submit move module which player made the last move allowing it to conduct the player-switch function,

### "Win Detector" module" ### 
constantly reading the 18-bit game register on the clock edge, if a win is detected for player 1 outputs "01" to sseg module, if a win is detected for player 2 outputs "10" to game module, default output of "00" means no win detected

### "SSEG DISP" ###
drives the segment display at like 4500 Hz i think to allow display multiplexing (super cool), displays current game on leftmost seven segments, solid bar = pl 1, flashing bar = pl 2 ONLY while win == "00", if win == "01" or "10" it'll display that number on all segments instead

![Picture:Elaborated Design](https://raw.githubusercontent.com/JonathanHonrada/TicTacToe_Basys3/master/elaborated_design.png)

It's worthwhile to describe the operational characteristics of the Pmod Keypad since it's an external device which is necessary to implement this game properly.

An FSM is used to sequentially drive each column to a low logic level while a high logic level is maintained on the remaining columns. This happense sequentially from left to right and wraps around when it reaches the rightmost column. When a button is pressed, a switch is closed and the row at which the button is located is subsequently driven to a low logic level. The input module of this circuit then reads when both a column and row are at logic level low to determine which button is currently being pressed. This sequencing of the keypad is not done syncronously with the main driving clock of the circuit. This design choice was made by because doing so resulted in the FSM failing to properly read button presses. Coming back to it now (a month and a half later), I realize this was probably due to some timing issue, but if you wish to use this driving FSM feel free to mess around with the clock divider and find an optimal value to drive the keypad.

![Picture:Keypad Module](https://i.imgur.com/PWv8lRb.png)

Future Implementations
----------------
At the moment we are considering several future implementations or features that we may add or you can add to this project. The first of these is an auto reset that resets the game once a win or a tie has been connected. The master reset button would still function alongside this feature. To implement this, we would need to wire a second-based counter to our win detector finite state machine that would begin a count for say, 4 or 5 seconds, and then assert a reset signal which would also inherently set the win signal back to zero (no winner/game being played - state).

