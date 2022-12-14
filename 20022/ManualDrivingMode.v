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
    input power_input,
//     input module_choose,
    input throttle,//油门
    input clutch,//离合
    input brake,
    input reverse,//倒车
    input turn_left_signal,
    input turn_right_signal,
    output  [3:0]answer,//依次输出左转，右转，后退，前进信号
    output  [3:0] state1,//输出小车当前状态0是通电，1是断电
    output   power_now
    ); 
     reg[3:0] state;
     reg[3:0] cur=4'b0000 ;
    parameter unstarting=4'b0001, starting=4'b0010, moving=4'b0100,power_off=4'b1000;
always @(posedge clk ) begin
       if(power_input==1'b1)
          case(state)
         4'b0001:case({clutch,throttle,brake,reverse})
                        4'b00XX : state<=unstarting;
                        4'b010X : state<=power_off;
                        4'b011X : state<=unstarting;
                        4'b10XX : state<=unstarting;
                        4'b110X : state<=starting;
                        4'b111X : state<=unstarting;
               endcase
        4'b0010:case({clutch,throttle,brake,reverse})
                        4'b00XX : state<=starting;
                        4'b010X : state<=moving;
                        4'b011X : state<=starting;
                        4'b1XXX : state<=starting;
               endcase
        4'b0100:case({clutch,throttle,brake,reverse})
                        4'b00X0 : state<=starting;
                        4'b0XX1 : state<=power_off;
                        4'b0100 : state<=moving;
                        4'b0110 : state<=starting;
                        4'b1000 : state<=starting;
                        4'b1001 : state<=moving;
                        4'b101X : state<=unstarting;
                        4'b110X : state<=starting;
                        4'b111X : state<=unstarting;
               endcase
        4'b1000:case({clutch,throttle,brake,reverse})
                        4'bXXXX : state<=power_off;
               endcase
          endcase
        else
          state<=power_off;
end //判断状态
always @(state,turn_left_signal,turn_right_signal,reverse)begin
       case(state)
       unstarting:case({turn_right_signal,turn_left_signal,reverse})
                        3'bXXX :cur=4'b0000;
       endcase      
       starting:case({turn_right_signal,turn_left_signal,reverse})
                        3'b00X :cur=4'b0000;
                        3'b10X :cur=4'b1000;
                        3'b01X :cur=4'b0100;
                        3'b11X :cur=4'b0000;
       endcase
       moving:case({turn_right_signal,turn_left_signal,reverse})
                        3'b000 :cur=4'b0001;
                        3'b001 :cur=4'b0010;
                        3'b010 :cur=4'b0101;
                        3'b011 :cur=4'b0110;
                        3'b100 :cur=4'b1001;
                        3'b101 :cur=4'b1010;
                        3'b110 :cur=4'b0001;
                        3'b111 :cur=4'b0010;
       endcase
       power_off:case({turn_right_signal,turn_left_signal,reverse})
                        3'bXXX :cur=4'b0000;
     
       endcase
       endcase
    end
  assign answer=cur;
  assign state1=state;
  assign power_now=state[0];

endmodule
