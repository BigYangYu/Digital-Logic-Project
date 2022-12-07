`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 22:10:40
// Design Name: 
// Module Name: dev_top
// Project Name: 
// Target Devices：
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


module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    input rst,
    
    input throttle,//油门
    input clutch,//离合
    input brake,

    input turn_left_signal,
    input turn_right_signal,
    input move_forward_signal,
    input move_backward_signal,
    input place_barrier_signal,
    input destroy_barrier_signal,
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector
    );

    wire [7:0] rec;
    assign front_detector = rec[0];
    assign back_detector = rec[1];
    assign left_detector = rec[2];
    assign right_detector = rec[3];
   
    
   ManualDrivingMode xixi(.clk(sys_clk), .rst(rst),.throttle(throttle),.clutch(clutch),.brake(brake),.rx(rx),.tx(tx)
   ,.rec(rec),.turn_left_signal(turn_left_signal),.turn_right_signal(turn_right_signal),.move_forward_signal(move_forward_signal)
   ,.move_backward_signal(move_backward_signal),.place_barrier_signal(place_barrier_signal),.destroy_barrier_signal(destroy_barrier_signal)
   );
endmodule
