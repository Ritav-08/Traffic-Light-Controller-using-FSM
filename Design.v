`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 18:07:26
// Design Name: 
// Module Name: TLC
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

module TLC(
   input clk_i,
   input rst_i,
   output [8:0]light_o
);

//net(s)
reg [5:0]timer;
reg [2:0]state;

//parameter(s)
localparam //state(s)
           S1 = 3'd1, 
           S2 = 3'd2,
           S3 = 3'd3,
           S4 = 3'd4,
           S5 = 3'd5,
           S6 = 3'd6, 
           //light(s) -- (R1 Y1 G1 R2 Y2 G2 R3 Y3 G3)
           G1R2R3 = 9'b001100100, 
           Y1R2R3 = 9'b010100100, 
           R1G2R3 = 9'b100001100, 
           R1Y2R3 = 9'b100010100, 
           R1R2G3 = 9'b100100001, 
           R1R2Y3 = 9'b100100010, 
           //timing(s)
           green = 6'd45, //45
           yellow    = 6'd5  //5
; //parameter end

//State Transitions --Next Stage Logic
always@(posedge clk_i, posedge rst_i) begin
   if(rst_i) begin
      state <= S1;
      timer <= 6'b0;
   end
   else begin
      timer <= timer + 1; //counter 
      case(state)
         S1: begin
            if(timer == green - 1) begin //(
               state <= S2;
               timer <= 6'b0;
            end
         end //S1
         S2: begin
            if(timer == yellow - 1) begin //(so extra 1s is granted)
               state <= S3;
               timer <= 6'b0;
            end
         end //S2
         S3: begin
            if(timer == green - 1) begin //(so n-1 timing used)
               state <= S4;
               timer <= 6'b0;
            end
         end //S3
         S4: begin
            if(timer == yellow - 1) begin 
               state <= S5;
               timer <= 6'b0;
            end
         end //S4
         S5: begin
            if(timer == green - 1) begin
               state <= S6;
               timer <= 6'b0;
            end
         end //S5
         S6: begin
            if(timer == yellow - 1) begin
               state <= S1;
               timer <= 6'b0;
            end
         end //S6
         default: begin
               state <= S1;
               timer <= 6'b0;
         end //default
      endcase
   end //else block
end //always block

//Output Transitions -- Output Logic
assign light_o = (state == S1)? G1R2R3 : 
              ((state == S2)? Y1R2R3 : 
              ((state == S3)? R1G2R3 : 
              ((state == S4)? R1Y2R3 : 
              ((state == S5)? R1R2G3 : 
              ((state == S6)? R1R2Y3 : 
                                       G1R2R3)))));

endmodule
//Note: Timer calculate at Active Region (t1) and update scheduled for NBA Region (t2) say.
//      Timer compared at t1 and if true, reset scheduled for t2.
//      In NBA Region, last schedule assignment wins.
//      So n-1 timing is used in comparison.

/* OR -- Output Teansitions (one may also use always with temp reg...)
always @(*) begin
    case(state)
        S1: light_o = G1R2R3;
        S2: light_o = Y1R2R3;
        S3: light_o = R1G2R3;
        S4: light_o = R1Y2R3;
        S5: light_o = R1R2G3;
        S6: light_o = R1R2Y3;
        default: light_o = G1R2R3;
    endcase
end
*/

//Note: For synthesis and readability, traffic-light FSMs are usually written using:
//State register
//Next-state logic
//Output logic
//using state reg, next state reg

//AI generated:- 
module TLC (
    input  wire       clk_i,
    input  wire       rst_i,
    output reg [8:0]  light_o
);

    //==================================================
    // State definitions
    //==================================================
    localparam S1 = 3'd0,
               S2 = 3'd1,
               S3 = 3'd2,
               S4 = 3'd3,
               S5 = 3'd4,
               S6 = 3'd5;

    //==================================================
    // Light definitions
    // (R1 Y1 G1 R2 Y2 G2 R3 Y3 G3)
    //==================================================
    localparam G1R2R3 = 9'b001100100,
               Y1R2R3 = 9'b010100100,
               R1G2R3 = 9'b100001100,
               R1Y2R3 = 9'b100010100,
               R1R2G3 = 9'b100100001,
               R1R2Y3 = 9'b100100010;

    //==================================================
    // Timing definitions
    //==================================================
    localparam GREEN  = 6'd45;
    localparam YELLOW = 6'd5;

    //==================================================
    // Registers
    //==================================================
    reg [2:0] state, next_state;
    reg [5:0] timer;

    //==================================================
    // BLOCK 1 : State Register + Timer
    //==================================================
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            state <= S1;
            timer <= 6'd0;
        end
        else begin
            state <= next_state;

            if (state != next_state)
                timer <= 6'd0;
            else
                timer <= timer + 1'b1;
        end
    end

    //==================================================
    // BLOCK 2 : Next-State Logic
    //==================================================
    always @(*) begin

        next_state = state;

        case (state)

            S1: begin
                if (timer == GREEN-1)
                    next_state = S2;
            end

            S2: begin
                if (timer == YELLOW-1)
                    next_state = S3;
            end

            S3: begin
                if (timer == GREEN-1)
                    next_state = S4;
            end

            S4: begin
                if (timer == YELLOW-1)
                    next_state = S5;
            end

            S5: begin
                if (timer == GREEN-1)
                    next_state = S6;
            end

            S6: begin
                if (timer == YELLOW-1)
                    next_state = S1;
            end

            default: begin
                next_state = S1;
            end

        endcase
    end

    //==================================================
    // BLOCK 3 : Output Logic
    //==================================================
    always @(*) begin

        case (state)

            S1:      light_o = G1R2R3;
            S2:      light_o = Y1R2R3;
            S3:      light_o = R1G2R3;
            S4:      light_o = R1Y2R3;
            S5:      light_o = R1R2G3;
            S6:      light_o = R1R2Y3;

            default: light_o = G1R2R3;

        endcase
    end

endmodule
