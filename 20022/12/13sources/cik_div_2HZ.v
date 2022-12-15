`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/12 22:44:16
// Design Name: 
// Module Name: cik_div_2HZ
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


module cik_div_2HZ(input clk,rst,enable,output reg clk_2HZ  );//0信号使能，2hz分频器
parameter  period = 50_000000;

reg [25:0] div2hz_cnt;


always@(posedge clk or negedge rst)
begin
	if(~rst&&enable)
		div2hz_cnt<=24'b00;
	else
		div2hz_cnt<=div2hz_cnt+1'b1;
end
always@(posedge clk or negedge rst)
begin
	if(~rst)
		clk_2HZ<=0;
	else if(div2hz_cnt==26'd24_999999 || div2hz_cnt==26'd49_999999)
		clk_2HZ<=~clk_2HZ;
	else
		clk_2HZ<=clk_2HZ;
end


endmodule

