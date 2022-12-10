`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/07 22:54:41
// Design Name: 
// Module Name: GTR
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


module GTR(
    input clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin

    input rst,//复位信号
    input throttle,//油门
    input clutch,//离合
    input brake,//刹车
    input turn_left,//左转
    input turn_right,//右转
    input move_forward,//前进
    input move_backward,//后退
    // 
    input manul_mode,//选择模式按钮
    input semi_auto_mode;
    input auto_mode;
    output turn_left_light,//左转向灯
    output turn_right_light,//右转向灯
    output [7:0] seg_selection,//八个流水灯开关
    output [7:0] seg_left,//左边四个流水灯
    output [7:0] seg_right//右边四个流水灯
    );
   // Global states
reg power_state;//电源状态
//各个模式的输出，绑定在simulate的输入
wire front_decoder;//前障碍检测
wire back_detector;//右障碍检测
wire left_detector;//左障碍检测
wire right_detector;//右障碍检测
reg turn_left_signal;//左转信号
reg turn_right_signal;//右转信号
reg move_forward_signal;//前进信号
reg move_backward_signal;//后退信号
reg place_barrier_signal;//放置障碍信号
reg destroy_barrier_signal;//破坏障碍信号，这俩我还不知道干啥用的
parameter power_on =1'b1,power_0ff=1'b0 ;

power_state=power_0ff;
always @(posedge clk) begin
    //press for more than 1 s
    
end

reg [1:0] mode;//驾驶模式,01为手动，10为半自动，11为全自动
always @(*) begin
if(power_state==1'b0) begin
mode=2'b00;
end
else begin
mode=mode_selection ;
end
end
//接下来是分别对应的手动，自动，半自动等模块。其中每个模块的输出都是给的sim模块的部分输入。sim模块不能更改！



endmodule
