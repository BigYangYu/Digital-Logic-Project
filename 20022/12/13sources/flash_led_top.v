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
    input sw0,//流水方向
    input [26:0] record,
    output reg [7:0] led,//八个灯的使能，用流水灯
    output [7:0] seg_led1,
    output [7:0] seg_led2,
    output [7:0] seg_led3,
    output [7:0] seg_led4,
    output [7:0] seg_led5,
    output [7:0] seg_led6,
    output [7:0] seg_led7,
    output [7:0] seg_led8//八个灯的值 
    );
    wire clk_bps;
    counter cnt1(.clk(clk),.rst_n(rst_n),.clk_bps(clk_bps));
    flash_led_ctrl fled_ctrl(.clk(clk),.rst_n(rst_n),.dir(sw0),.clk_bps(clk_bps),.led(led));

    reg [3:0] led1,led2,led3,led4,led5,led6,led7,led8;//led8是最高位
    reg [3:0] in1,in2,in3,in4,in5,in6,in7,in8;
    light_7seg_ego ego1(.sw(in1),.rst(rst_n),.seg_out(seg_led1));
    light_7seg_ego ego2(.sw(in2),.rst(rst_n),.seg_out(seg_led2));
    light_7seg_ego ego3(.sw(in3),.rst(rst_n),.seg_out(seg_led3));
    light_7seg_ego ego4(.sw(in4),.rst(rst_n),.seg_out(seg_led4));
    light_7seg_ego ego5(.sw(in5),.rst(rst_n),.seg_out(seg_led5));
    light_7seg_ego ego6(.sw(in6),.rst(rst_n),.seg_out(seg_led6));
    light_7seg_ego ego7(.sw(in7),.rst(rst_n),.seg_out(seg_led7));
    light_7seg_ego ego8(.sw(in8),.rst(rst_n),.seg_out(seg_led8));

  always @(record) begin
        led8 = record/1000_0000;
        led7 = (record%1000_0000)/100_0000;
        led6 = (record%100_0000)/10_0000;
        led5 = (record%10_0000)/1_0000;
        led4 = (record%1_0000)/1000;
        led3 = (record%1000)/100;
        led2 = (record%100)/10;
        led1 = record%10;
  end
      always @(posedge clk,posedge ~rst_n ) begin//复位和断电状态就让板子灯熄灭
        if (~rst_n&&power_now) begin
          led <= 8'b0000_0000;
          in1 <=8'b1111_1100; //0
          in2 <=8'b1111_1100; //0
          in3 <=8'b1111_1100; //0
          in4 <=8'b1111_1100; //0
          in5 <=8'b1111_1100; //0
          in6 <=8'b1111_1100; //0
          in7 <=8'b1111_1100; //0
          in8 <=8'b1111_1100; //0
        end
      
      else begin//就让八个灯显示里程
          in1<=led1;
          in2<=led2;
          in3<=led3;
          in4<=led4;
          in5<=led5;
          in6<=led6;
          in7<=led7;
          in8<=led8;
        end
        end
endmodule
