`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 10:08:18
// Design Name: 
// Module Name: ManualDrivingMode
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
module ManualDrivingMode(
    input clk, //bind to P17 pin (100MHz system clock)
    input rst,
    
    input throttle,//油门
    input clutch,//离合
    input brake,
    input turn_left_signal,
    input turn_right_signal,
    input move_forward_signal,
    input move_backward_signal,

    output[7:0]rec,
    output[5:0]answer,
    output[1:0] state1
    );
    //输出复位信号
     reg[1:0] state;
     reg[5:0] cur=6'b100000 ;
    parameter unstarting=2'b00, starting=2'b01, moving=2'b10,poweroff=2'b11;
always@(* ) 
   if(~rst)begin
            state= unstarting;
            end
            else    
          case (state)
unstarting:if(throttle&&~clutch) state=poweroff;
           else if(clutch&&throttle&&~brake) state=starting;
           else state=unstarting;
starting:if(brake) state=unstarting;
         else if(throttle&&~clutch)state=moving ;
         else state=starting;
moving: if(brake) state=unstarting;
        else if(~throttle)state=starting;
        else if(clutch) state=starting;
        else if(~move_backward_signal&&~clutch)state=poweroff;
        else state=moving;
    endcase  
//状态切换
always@(*)begin
    case(state)
    2'b00:  cur=6'b100000;
     2'b01: cur={ 2'b10, ~turn_right_signal, ~turn_left_signal, 2'b10 };
      2'b10:  cur={2'b10,  ~turn_right_signal, ~turn_left_signal, ~move_backward_signal, ~move_forward_signal};
       2'b11:  cur=6'b100000;
endcase
    end
    assign answer=cur;
    assign state1=state;
endmodule
