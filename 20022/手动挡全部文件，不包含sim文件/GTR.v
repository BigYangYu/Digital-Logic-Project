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
                     input power_on,

    input clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    input rst,//复位信号

    input throttle,//油门
    input clutch,//离合
    input brake,//刹车
    input turn_left,//左转
    input turn_right,//右转
    input move_backward,//后�??
    // 
    output turn_left_light,//左转向灯
    output turn_right_light,//右转向灯
    output [7:0] seg_en,//八个流水灯开�?
    output [7:0] seg_out0,//左边四个流水�?
    output [7:0] seg_out1,//右边四个流水�?
    output [3:0] answer,
    output  [3:0] state ,
   output   power_now
    );
   // Global states
reg power_state;//电源状�??
//各个模式的输出，绑定在simulate的输�?
wire front_detector;//前障碍检�?
wire back_detector;//右障碍检�?
wire left_detector;//左障碍检�?
wire right_detector;//右障碍检�?
reg turn_left_signal;//左转信号
reg turn_right_signal;//右转信号
reg move_forward_signal;//前进信号
reg move_backward_signal;//后�??信号
reg place_barrier_signal;//放置障碍信号
reg destroy_barrier_signal;//破坏障碍信号，这俩我还不知道干啥用的
//  wire [3:0]answer;//依次输出左转，右转，后�??，前进信�?
//  wire  [3:0] state;
 //输出小车当前状�??0是�?�电�?1是断�?
 wire [26:0] record;
//parameter power_on =1'b1,power_0ff=1'b0 ;
ManualDrivingMode fk(
                    .clk(clk),
                    .rst(rst),
                    .power_input(power_on),
                    .throttle(throttle),
                    .clutch(clutch),
                    .brake(brake),
                    .reverse(move_backward),
                    .turn_left_signal(~turn_left),
                    .turn_right_signal(~turn_right),
                    .answer(answer),
                    .state(state),
                    .power_now(power_now)
);
record_manual haha(
                     .clk(clk),
                     .rst(rst),
                     .power_now(power_now),
                     .state(state),
                     .record(record)
);                  
flash_led_top xixi(
                    .clk(clk),
                     .rst_n(rst),
                     .power_now(power_now),
                      .record(record),
                      .led(seg_en),
                      .state1(state),
                      .seg_led1(seg_out0),
                      .seg_led2(seg_out1)
);
turn_left_right_light cc(
                     .clk(clk),
                     .rst(rst),
                     .power_now(power_now),
                     .state(state),
                     .answer(answer),
                     .left_led(turn_left_light),
                     .right_led(turn_right_light)
);
SimulatedDevice sim(
                 .sys_clk(clk),
                 .rx(rx),
                 .tx(tx),
                 .turn_left_signal(answer[3]),
                 .turn_right_signal(answer[2]),
                 .move_forward_signal(answer[0]),
                 .move_backward_signal(answer[1]),
                 .place_barrier_signal(place_barrier_signal),
                 .destroy_barrier_signal(destroy_barrier_signal),
                 .front_detector(front_detector),
                 .back_detector(back_detector),
                 .left_detector(back_detector),
                 .right_detector(right_detector)
);
endmodule
