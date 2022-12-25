`timescale 1ns / 1ps


module clk_div_100HZ(input clk,output reg clk_100HZ  );//0信号使能，2hz分频器
parameter  period = 1_000_000;

reg [31:0] div100hz_cnt=0;
always@(posedge clk )
begin
	if( div100hz_cnt==250000)
	begin
		clk_100HZ=~clk_100HZ;
        div100hz_cnt=0;
	end
	else
		div100hz_cnt=div100hz_cnt+1'b1;
end



endmodule