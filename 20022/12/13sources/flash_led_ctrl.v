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
module flash_led_ctrl(
    input clk,
    input rst_n,
    input dir,
    input clk_bps,
    output reg[7:0] led
    );
    always@(posedge clk or negedge rst_n)
        if( !rst_n )
            led <= 8'h80;
        else
            case( dir )
                1'b0:
                    if(clk_bps)
                        if( led != 8'h01 )
                            led <= led >>1'b1;  //shift right
                        else
                            led <= 8'h80;
                1'b1:
                    if(clk_bps)
                        if( led != 8'h80 )
                            led <= led << 1'b1;  //shift left
                        else
                            led <= 8'h01;                    
            endcase
endmodule
