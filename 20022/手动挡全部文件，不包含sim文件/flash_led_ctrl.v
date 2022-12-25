`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 09:51:57
// Design Name: 
// Module Name: flash_led_ctrl
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
module flash_led_ctrl(//流水灯模�??
    input clk,
    input rst_n,
    input clk_bps,
    input power_now,
    input state1,
    input [26:0] record,
    output reg [7:0] led,//八个灯的使能，用流水�??
    output [7:0] seg_led1,
    output [7:0] seg_led2
    );
    reg [3:0] led1,led2,led3,led4,led5,led6,led7;//led8是最高位
    reg [3:0] in1,in2;
    reg[3:0] cur1,cur2;
    light_7seg_ego ego1(.sw(cur1),.rst(rst_n),.seg_out(seg_led1));
    light_7seg_ego ego2(.sw(cur2),.rst(rst_n),.seg_out(seg_led2));
    always@(posedge clk or posedge rst_n)
        if( rst_n||power_now )
            led <= 8'h80;
        else  
                    if(clk_bps)
                        if( led != 8'h01 )
                            led <= led >>1'b1;  //shift right
                        else
                            led <= 8'h80;

always @(posedge clk_bps ) begin//复位和断电状态就让板子灯熄灭
        if (rst_n&&power_now) begin
          led7 <=0; //0
          led6 <=0; //0
          led5 <=0; //0
          led4 <=0; //0
          led3 <=0; //0
          led2 <=0; //0
          led1 <=0; //0
      
         
        end
        else begin
                    led7 <= (record/100_0000)%10;
                    led6 <= (record/10_0000)%10;
                    led5 <= (record/1_0000)%10;
                    led4 <= (record/1_000)%10;
                    led3 <= (record/100)%10;
                    led2 <= (record/10)%10;
                    led1 <= record%10;
        end   
        end
    always @(power_now,led,state1) begin
            if(power_now&&state1!=4'b0100) begin
              cur1<=4'hc;
              cur2<= 4'hd;
            end
            else begin
              case(led)
              8'b1000_0000:begin
                            cur1<=led7;
                                     
              end
              8'b0100_0000:begin
                            cur1<=led6; 
                                  
              end
              8'b0010_0000:begin
                            cur1<=led5; 
                                  
              end
              8'b0001_0000:begin
                            cur1<=led4;  
                            
              end
              8'b0000_1000:begin
                            cur2<=led3; 
                                  
              end
              8'b0000_0100:begin
                            cur2<=led2;         
              end
              8'b0000_0010:begin
                            cur2<=led1;         
              end
              8'b0000_0001:begin
                            cur2<=0;         
              end
            endcase
            end
    end

             
           
endmodule
