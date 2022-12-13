`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/12 23:33:20
// Design Name: 
// Module Name: record_manual
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


module record_manual(//我设计的是每0.5s里程加一，缺点是如果没到0.5s就断电，里程表仍然会加一（我觉得应该不是什么问题）
                        input clk,
                         input rst,
                         input power_now,
                         input [3:0] state,
                         output reg[26:0] record   );
        wire clk_2hz;
        reg[26:0] cur;
        cik_div_2HZ manual_record(
                                    .clk(clk),
                                    .rst(rst),
                                    .enable(~power_now&&(state==4'b0100)),
                                    .clk_2HZ(clk_2hz)
        );
        always@(posedge clk,posedge ~rst)begin
            if(~rst||~power_now||record<=27'd9999_9999)begin
                record<=0;
            end
            else
                record<=cur;
        end

        always@(negedge clk_2hz,negedge ~rst,negedge ~power_now)begin
           if(~rst||~power_now||record<=27'd9999_9999)begin
                cur<=0;
            end
            else
                cur<=cur+1;
        
        end


endmodule
