`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/13 14:36:37
// Design Name: 
// Module Name: turn_left_right_light
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


module turn_left_right_light(
                             input rst,
                             input clk,
                             input power_now,
                             input [1:0] module_choose,
                             // useless
                             input [3:0] state,//小车状态0001是未启动，0010是starting，0100是moving，1000是断电
                             input [3:0]answer,//左转，右转，后退，前进信号
                             // Answers are the signals as the input of dev_top.
                             output left_led,
                             output right_led,
                             
                              );
  wire clk_2hz;
          cik_div_2HZ manual_record(
                                    .clk(clk),
                                    .rst(rst),
                                    .enable(0),
                                    .clk_2HZ(clk_2hz)
        );
             always @(posedge clk_2hz or negedge rst) begin
                    if(~rst||~power_now)begin
                left_led<=2'b00;
                right_led<=2'b00;
                    end      
             else begin
                case (state)
            4'b0000: begin//未启动状态
                    left_led<=2'b00;
                    right_led<=2'b00;         
                       end

            4'b0001: begin//未启动状态
                    left_led<=2'b00;
                    right_led<=2'b00;         
                       end
            4'b0010: begin//启动状态
                   if(answer[4]==1)begin
                    left_led<=clk_2hz;
                   end
                   else if(answer[3]==1)begin
                    right_led<=clk_2hz;
                   end
                   else begin
                     left_led<=2'b00;
                     right_led<=2'b00; 
                   end    
                       end
            4'b0100: begin//移动状态
                   if(answer[4]==1)begin
                    left_led<=clk_2hz;
                   end
                   else if(answer[3]==1)begin
                    right_led<=clk_2hz;
                   end
                   else begin
                     left_led<=2'b00;
                     right_led<=2'b00; 
                   end    
                       end
             4'b0000: begin//断电状态
                    left_led<=2'b00;
                    right_led<=2'b00;         
                       end
                endcase
             end 
        end 
endmodule
