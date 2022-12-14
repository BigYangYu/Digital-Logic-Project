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
    output [7:0] seg_led2
   
    );
    wire clk_bps;
    reg state;
    reg[3:0] cur1,cur2;
    counter cnt1(.clk(clk),.rst_n(rst_n),.clk_bps(clk_bps));
    flash_led_ctrl fled_ctrl(.clk(clk),.rst_n(rst_n),.dir(sw0),.clk_bps(clk_bps),.led(led),.power_now(power_now));

    reg [3:0] led1,led2,led3,led4,led5,led6,led7,led8;//led8是最高位
    reg [3:0] in1,in2;
    light_7seg_ego ego1(.sw(cur1),.rst(rst_n),.seg_out(seg_led1));
    light_7seg_ego ego2(.sw(cur2),.rst(rst_n),.seg_out(seg_led2));
    
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
      always @(posedge clk_bps,posedge ~rst_n ) begin//复位和断电状态就让板子灯熄灭
        if (~rst_n&&~power_now) begin
          led <= 8'b0000_0000;
          led8 <=8'b1111_1100; //0
          led7 <=8'b1111_1100; //0
          led6 <=8'b1111_1100; //0
          led5 <=8'b1111_1100; //0
          led4 <=8'b1111_1100; //0
          led3 <=8'b1111_1100; //0
          led2 <=8'b1111_1100; //0
          led1 <=8'b1111_1100; //0
          state<=4'b1000;
         
        end
        else begin
             if(state!=8'b0000_0001)
                state<=state>>1;
                else
                 state<=8'b1000_0000;
        end   
        end
    always @(state) begin
            if(~power_now) begin
              cur1<=4'hc;
              cur2<= 4'hd;
            end
            else begin
              case(state)
              8'b1000_0000:begin
                            cur1=led8;
                                     
              end
              8'b0100_0000:begin
                            cur1=led7;         
              end
              8'b0010_0000:begin
                            cur1=led6;         
              end
              8'b0001_0000:begin
                            cur1=led5;         
              end
              8'b0000_1000:begin
                            cur2=led4;         
              end
              8'b0000_0100:begin
                            cur2=led3;         
              end
              8'b0000_0010:begin
                            cur2=led2;         
              end
              8'b0000_0001:begin
                            cur2=led1;         
              end
            endcase
            end
    end






endmodule
