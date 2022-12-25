`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 09:39:57
// Design Name: 
// Module Name: flash_led_top
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


module flash_led_top(//里程显示
    input clk,
    input rst_n,
    input power_now,
    input state1,
    input [26:0] record,
    output  [7:0] led,//八个灯的使能，用流水灯
    output [7:0] seg_led1,
    output [7:0] seg_led2
   
    );
    counter cnt1(.clk(clk),.rst_n(rst_n),.clk_bps(clk_bps));
    flash_led_ctrl fled_ctrl(.clk(clk),
                          .rst_n(rst_n),
                          .clk_bps(clk_bps),
                          .power_now(power_now),
                          .state1(state1),
                          .record(record),
                          .led(led),
                          .seg_led1(seg_led1),
                          .seg_led2(seg_led2));





endmodule
