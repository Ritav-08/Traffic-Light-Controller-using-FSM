module TLC(
   input clk_i,
   input rst_i,
   output [8:0]light
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

//State Transitions
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

//Output Transitions -- (one may also use always, temp reg...)
assign light = (state == S1)? G1R2R3 : 
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
