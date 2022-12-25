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
    input power_input,//输入是必须是开机状态
    input throttle,//油门
    input clutch,//离合
    input brake,
    input reverse,//倒车
    input turn_left_signal,
    input turn_right_signal,
    output reg [3:0]answer,//依次输出左转，右转，后退，前进信号
    output  [3:0] state,
    output reg  power_now//输出小车当前状态0是通电，1是断电
    ); 
       reg previous;
       reg pre_shift;
        reg [3:0] state1= 4'b0001;
    parameter unstarting=4'b0001, starting=4'b0010, moving=4'b0100,power_off=4'b1000;
always @(posedge clk ,negedge rst) begin
         if(rst)begin
              state1<= 4'b0001;
              power_now<=0;
              end
       else if(power_input==1'b0)begin
          case(state1)
         4'b0001:casex({clutch,throttle,brake,reverse})//未启动
                        4'b000X : state1<=unstarting;
                        4'b001X : state1<=unstarting;
                        4'b010X : state1<=power_off;
                        4'b011X : state1<=unstarting;
                        4'b10XX : state1<=unstarting;
                        4'b110X : state1<=starting;
                        4'b111X : state1<=unstarting;
               endcase
        4'b0010:casex({clutch,throttle,brake,reverse})//启动
                        4'b000X :begin
                                   state1<=starting;pre_shift<=reverse;
                                   end 
                        4'b001X : state1<=unstarting;
                        4'b010X : begin state1<=moving;pre_shift<=reverse;
                                   end
                        4'b011X : state1<=unstarting;
                        4'b1X0X : state1<=starting;
                        4'b1X1X : state1<=unstarting;
               endcase
       4'b0100:casex({clutch,throttle,brake,reverse})
                        4'b0000 : state1<=starting;
                        4'b0010 : state1<=unstarting;
                        4'b0001 : state1<=power_off;
                        4'b0101 : begin if(pre_shift!=reverse)begin
                                   state1<=power_off;
                                    end
                                    else begin
                                    state1<=moving;
                                    end
                                 end
                        4'b0100 : state1<=moving;
                        4'b0111 : state1<=unstarting;
                        4'b0110 : state1<=unstarting;
                        4'b1000 : state1<=starting;
                        4'b1001 : state1<=starting;
                        4'b101X : state1<=unstarting;
                        4'b110X : state1<=starting;
                        4'b111X : state1<=unstarting;
               endcase
        4'b1000:casex({clutch,throttle,brake,reverse})
                        4'bXXXX :begin if(previous==0)begin
                                      state1<=unstarting;
                                      previous<=1;
                        end         else
                                      state1<=power_off;
                                       end
               endcase
         default :
                 state1<=unstarting;
          endcase
          power_now<=state1[3];
          end
        else begin
          previous<=0;
          state1<=power_off;
          power_now<=state1[3];
        end
       
end //判断状态
always @(*)begin
       case(state1)
       unstarting:casex({turn_right_signal,turn_left_signal,reverse})
                        3'bXXX :answer=4'b0000;
                    endcase      
       starting:casex({turn_right_signal,turn_left_signal,reverse})
                        3'b00X :answer=4'b0000;
                        3'b10X :answer=4'b1000;
                        3'b01X :answer=4'b0100;
                        3'b11X :answer=4'b0000;
       endcase
       moving:case({turn_right_signal,turn_left_signal,reverse})
                        3'b000 :answer=4'b0001;
                        3'b001 :answer=4'b0010;
                        3'b010 :answer=4'b0101;
                        3'b011 :answer=4'b0110;
                        3'b100 :answer=4'b1001;
                        3'b101 :answer=4'b1010;
                        3'b110 :answer=4'b0001;
                        3'b111 :answer=4'b0010;
       endcase
       power_off:casex({turn_right_signal,turn_left_signal,reverse})
                        3'bXXX :answer=4'b0000;
      default :
                answer=4'b0000;
       endcase
       endcase
    end
assign state=state1;
endmodule
