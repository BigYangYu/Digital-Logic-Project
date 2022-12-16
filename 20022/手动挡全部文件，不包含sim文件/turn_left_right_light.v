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
                             input [3:0] state,//小车状态0001是未启动，0010是starting，0100是moving，1000是断电
                             input [3:0]answer,//左转，右转，后退，前进信号
                             output reg left_led,
                             output reg right_led
                            
                                );
  wire clk_2hz;
  reg cur=0;
  reg cur1=0;
  reg[2:0] count;
  reg[2:0] count1;
  reg [1:0] temp;
          cik_div_2HZ manual_record(
                                    .clk(clk),
                                    .rst(rst),
                                    .clk_2HZ(clk_2hz)
        );


       always @(posedge clk_2hz or negedge rst) begin
              if(rst)begin
		count=3'd00;
		end
	else if( count==2)
	begin
		cur=~cur;
              count=0;
	end
	else
		count=count+1'b1;

       end
       always @(posedge clk_2hz or negedge rst) begin
              if(rst)begin
		count1=3'd00;
		end
	else if( count1==2)
	begin
		cur1=~cur1;
              count1=0;
	end
	else
		count1=count1+1'b1;
       end

             always @(posedge clk or negedge rst) begin
                      if(rst||power_now) begin
                            temp<=2'b00;
                      end
                     else begin
                     case (temp)
                     2'b00:begin
                            if(state==4'b0100||state==4'b0010)begin
                                  temp<=2'b01;
                            end
                     
                            end
                     2'b01:begin
                            if(state!=4'b0100&&state!=4'b0010)begin
                                  temp<=2'b00;
                            end
                             else if(answer[3]==1)begin
                                   temp<=2'b10;
                            end
                             else if(answer[2]==1)begin
                                   temp<=2'b11;
                            end
                     end
                      2'b10:begin
                            if(answer[3]!=1)begin
                                  temp<=2'b00;
                            end
                     end
                     2'b11:begin
                            if(answer[2]!=1)begin
                                  temp<=2'b00;
                            end
                     end
                     endcase
             end
             end
           always @(posedge clk) begin
              case(temp) 
                     2'b00:begin
                            left_led<=0;
                            right_led<=0;
                     end
                     2'b01:begin
                            left_led<=0;
                            right_led<=0;
                     end
                     2'b10:begin
                            left_led<=cur;
                            right_led<=0;
                     end
                     2'b11:begin
                            left_led<=0;
                            right_led<=cur1;
                     end
              endcase
           end

endmodule
