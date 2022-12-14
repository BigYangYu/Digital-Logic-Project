`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/05 22:39:46
// Design Name: 
// Module Name: fipower_input
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


module first();
   reg sys_clk = 0;     //bind to P17 pin (100MHz system clock)
   reg power_input = 0;
//    reg module_choose;

   reg throttle = 0;//油门
   reg clutch = 0;//离合
   reg brake = 0;
   reg reverse = 0;

   reg turn_left_signal= 0;
   reg turn_right_signal= 0;
   
    wire[3:0]answer;
    wire[3:0]state;
    wire power_now;

   


ManualDrivingMode try(
    .clk(sys_clk),
    .power_input(power_input),.
    // module_choose(module_choose),.
    clutch(clutch),
    .brake(brake),
    .reverse(reverse),
    .throttle(throttle),
    .turn_left_signal(turn_left_signal),
    .turn_right_signal(turn_right_signal),
    .power_now(power_now),
    .answer(answer),
    .state1(state)
);
    initial
        begin
     forever #1 sys_clk=~sys_clk;
     end

        initial
         begin
        power_input=1'b1;;
        clutch=1'b1;
        throttle=1'b1;
        turn_left_signal=1'b0;
        turn_right_signal=1'b0;
      #50 $finish;
    end



endmodule
