`timescale 1ns / 1ps


module clk_div_100HZ(input clk,rst,enable,output reg clk_100HZ  );//0信号使能，2hz分频器
parameter  period = 1_000_000;

reg [31:0] cnt;

always@(posedge clk or negedge rst)
begin
	if(~rst&&enable)
		cnt<=32'b00;
	else
		cnt<=cnt+1'b1;
end
always@(posedge clk or negedge rst)
begin
	if(~rst)
		clk_100HZ<=0;
	else if(cnt==32'd499_999 || cnt==32'd999_999)
		clk_100HZ<=~clk_100HZ;
	else
		clk_100HZ<=clk_100HZ;
end

endmodule