`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 18:07:53
// Design Name: 
// Module Name: tb_TLC
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


module tb_TLC();
reg clk_ti;
reg rst_ti;
wire [8:0]light_to;

//instantiation
TLC DUT(.clk_i(clk_ti), 
        .rst_i(rst_ti), 
        .light_o(light_to)
);

//clock
initial begin
   clk_ti = 1'b0;
   forever #5 clk_ti = ~clk_ti;
end

//feeding
initial begin
   rst_ti = 1'b1;
   #13 rst_ti = 1'b0;
   #1560000 rst_ti = 1'b1;
   #10 rst_ti = 1'b1;
   #10 $finish;
end

//capture
initial begin
$dumpfile("TLC.vcd");
$dumpvars(0, tb_TLC);
$monitor("Time: %0t | Clk: %b, Rst: %b | Timer: %0d, State: %0d | Output: %0b", 
          $time,      clk_ti,  rst_ti,   DUT.timer, DUT.state,  light_to );
end

//color monitor
always@(posedge clk_ti, posedge rst_ti) begin
   $display("----------- \nColors are: ");
   case(DUT.light_o)
           9'b001100100: $display("G1 R2 R3");
           9'b010100100: $display("Y1 R2 R3");
           9'b100001100: $display("R1 G2 R3");
           9'b100010100: $display("R1 Y2 R3");
           9'b100100001: $display("R1 R2 G3");
           9'b100100010: $display("R1 R2 Y3");
           default: $display ("----------- Default triggered ------------");
      endcase
end

endmodule
