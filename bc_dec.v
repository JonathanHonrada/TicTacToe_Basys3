//----------------------------------------------------------------------------------
//-- Module Name:    BC_DEC
//-- Description: Special 7-segment display driver (4-letter words only)
//--
//--  One Input:  Z
//--
//--      Z = '1': COOL
//--      Z = '0': CrAP 
//-- J. Callenes
//--------------------------------------------------------------------------------


//-------------------------------------------------------------
//-- Two word seven-segment display driver. Outputs are active
//-- low and configured ABCEDFG in "segment" output. 
//--------------------------------------------------------------
module BC_DEC(    input CLK,
                  input [1:0] pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,
                  input [1:0] win,
                  input player,  
                  output [3:0] DISP_EN,
                  output [7:0] SEGMENTS);

   
//   -- intermediate signal declaration -----------------------
   reg  [1:0] cnt_dig; 
   reg [3:0]   digit;
   reg [7:0] seg = 8'b11111111;
   wire   sclk;
   wire disp_clk; 

   clk_div my_clk(.clk(CLK),
                  .sclk(sclk));
                   
   clk_div2 clock_for_display(.clk(CLK),
                    .disp_clk(disp_clk)); 

//   -- advance the count (used for display multiplexing) -----
  always@ (posedge sclk)
   begin
         cnt_dig <= cnt_dig + 1;
   end 

//   -- select the display sseg data abcdefg (active low) -----
   /*assign SEGMENTS = 
                     (digit==0)? 8'b00100101 :  //2
                     (digit==1)? 8'b01111111 :  //top player 1
                     (digit==2)? 8'b11111101 :  //middle player 1
                     (digit==3)? 8'b11101111 :  //bottom player 1
                     (digit==4)? {disp_clk,7'b1111111} :  //top player 2
                     (digit==5)? {6'b111111,disp_clk,1'b1} :  //middle player 2
                     (digit==6)? {3'b111,disp_clk,4'b1111} :  //bottom player 2
                     (digit==7)? 8'b10011111: // 1
                     (digit==8)? 8'b11111111:
                     8'b11111111;*/

//   -- actuate the correct display --------------------------
   assign DISP_EN = (cnt_dig==0)? 4'b1110: 
                    (cnt_dig==1)? 4'b1101:
                    (cnt_dig==2)? 4'b1011: 
                    (cnt_dig==3)? 4'b0111: 4'b1111;
       
   always @ (posedge sclk)
   
   begin
   seg = 8'b11111111;
   if (win == 0) //will display current game if there is no winner yet
	begin
      case (cnt_dig)
        3:begin // left most seven segment display used to indicate which player is currently making a move
            case (player)
            0:seg <= 8'b10011111;
            1:seg <= 8'b00100101;
            endcase
          end

        2:begin//controls game display for the middle-left seven segment display
         case (pos3)
            0:seg[4] <= 1;
            1:seg[4] <= 0;
            2:seg[4] <= disp_clk;
            default: seg[4] <= 1;
          endcase
          case (pos6)
             0:seg[1] <= 1;
             1:seg[1] <= 0;
             2:seg[1] <= disp_clk;
             default: seg[1] <= 1;
          endcase
          case (pos9)
             0:seg[7] <= 1;
             1:seg[7] <= 0;
             2:seg[7] <= disp_clk;
             default: seg[7] <= 1;
          endcase
         end

        1:begin // controls game display for the middle-right seven segment display
          case (pos2)
             0:seg[4] <= 1;
             1:seg[4] <= 0;
             2:seg[4] <= disp_clk;
             default: seg[4] <= 1;
           endcase
           case (pos5)
              0:seg[1] <= 1;
              1:seg[1] <= 0;
              2:seg[1] <= disp_clk;
              default: seg[1] <= 1;
           endcase
           case (pos8)
              0:seg[7] <= 1;
              1:seg[7] <= 0;
              2:seg[7] <= disp_clk;
              default: seg[7] <= 1;
           endcase
          end

         0: // controls game display for the right-most seven segment display
         begin 
          case (pos1)
             0:seg[4] <= 1;
             1:seg[4] <= 0;
             2:seg[4] <= disp_clk;
             default: seg[4] <= 1;
           endcase
           case (pos4)
              0:seg[1] <= 1;
              1:seg[1] <= 0;
              2:seg[1] <= disp_clk;
              default: seg[1] <= 1;
           endcase
           case (pos7)
              0:seg[7] <= 1;
              1:seg[7] <= 0;
              2:seg[7] <= disp_clk;
              default: seg[7] <= 1;
           endcase
          end
          default: seg <= 8'b11111111;
        endcase
      end

    else if(win == 1)// win signal of 1 indicates player 1 wins, displays 1 on all seven segment displays
        begin
        case(cnt_dig)
           1:seg <= 8'b10011111;
           2:seg <= 8'b10011111;
           3:seg <= 8'b10011111;
           0:seg <= 8'b10011111;
           default: seg <= 8'b11111111;
        endcase
        end 

    else if(win == 2)// win signal of 2 indicates player 2 wins, displays 2 on all seven segment displays
         begin
         case(cnt_dig)
            1:seg <= 8'b00100101;
            2:seg <= 8'b00100101;
            3:seg <= 8'b00100101;
            0:seg <= 8'b00100101;
            default: seg <= 8'b11111111;
          endcase
          end 
    end 
 
assign SEGMENTS = seg;
endmodule

//-----------------------------------------------------------------------
//-- Module to divide the clock 
//-----------------------------------------------------------------------
module clk_div (  input clk,
                  output sclk);

  integer MAX_COUNT = 2200; 
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
    
module clk_div2 (  input clk,
                  output disp_clk);

  integer MAX_COUNT = 10000000; 
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
   assign disp_clk = tmp_clk; 
endmodule
