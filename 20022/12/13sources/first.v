`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/05 22:39:46
// Design Name: 
// Module Name: first
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
 reg sys_clk; //bind to P17 pin (100MHz system clock)
   reg rst;
    
   reg throttle;//油门
   reg clutch;//离合
   reg brake;

   reg turn_left_signal;
   reg turn_right_signal;
   reg move_forward_signal;
   reg move_backward_signal;
  wire[7:0]rec;
    wire[7:0]answer;
    wire[1:0]state;
ManualDrivingMode try(
    .clk(sys_clk),.rst(rst),.throttle(throttle),.clutch(clutch),.brake(brake),.turn_left_signal(turn_left_signal)
    ,.turn_right_signal(turn_right_signal),.move_backward_signal(move_backward_signal),.move_forward_signal(move_forward_signal)
    ,.rec(rec),.answer(answer),.state1(state)
);
// initial fork
//     sys_clk<=0;
//     {rx,rst,throttle,clutch,brake,turn_left_signal,turn_right_signal,move_backward_signal,
//     move_forward_signal,place_barrier_signal,destroy_barrier_signal
//     } <= 11'b00000000000;
//     repeat(2047) begin
//         #2 {rx,rst,throttle,clutch,brake,turn_left_signal,turn_right_signal,move_backward_signal,
//     move_forward_signal,place_barrier_signal,destroy_barrier_signal
//     } <= {rx,rst,throttle,clutch,brake,turn_left_signal,turn_right_signal,move_backward_signal,
//     move_forward_signal,place_barrier_signal,destroy_barrier_signal
//     } + 1;
//     end
//   forever begin
//     #2 sys_clk=~sys_clk;
//   end
   
//    $finish();
// join
initial begin
    {rst,throttle,clutch,brake,turn_left_signal,turn_right_signal,move_backward_signal,
    move_forward_signal,sys_clk
    } = 9'b0000000001;
    // repeat(2050) begin
    //     #2 {rst,throttle,clutch,brake,turn_left_signal,turn_right_signal,move_backward_signal,
    // move_forward_signal,place_barrier_signal,destroy_barrier_signal,sys_clk
    // } = {rst,throttle,clutch,brake,turn_left_signal,turn_right_signal,move_backward_signal,
    // move_forward_signal,place_barrier_signal,destroy_barrier_signal,sys_clk
    // } + 1;
    // end $finish();
end
endmodule
