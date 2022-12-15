`timescale 1ns / 1ps


module SemiAutoDriving(
    input clk,
    // input rst,

    input front_detector,
    input back_detector,
    input left_detector,
    input right_detector,

    input go_straight_command,
    input turn_left_command,
    input turn_right_command,

    output reg move_forward_signal,
    // output reg move_backward_signal,
    output reg turn_left_signal,
    output reg turn_right_signal,
    // output reg [3:0] answer,//左转，右转，后退，前进

    output reg [1:0]state
);
// reg[1:0] state;
//Wait-for-command,Turn-Left,Turn-Right,Moving
//00,01,10,11

// move_backward_signal=1b'0;
reg clk_50Hz;
reg[31:0] cnt;
clk_div_50HZ clk50(.sys_clk(clk),.turning_clk(clk_50Hz));
reg[1:0] turning;
//00没在转向，01正在左转，10正在右转，11转向结束

always @ (posedge clk) begin
    case(state)
        2'b11: case({front_detector,left_detector,right_detector})
                    3'b000: state<=2'b00;
                    3'b100: state<=2'b00;
                    3'b010: state<=2'b00;
                    3'b001: state<=2'b00;
                    default: {move_forward_signal,turn_left_signal,turn_right_signal}=3'b100;
                endcase
        2'b01: if(cnt==32'b1_000_000) begin
                    state=2'b11;
                    cnt<=0;
                end
                else 
                    cnt<=cnt+1'b1;
        2'b10: if(cnt==32'b1_000_000) begin
                    state=2'b11;
                    cnt<=0;
                end
                else
                    cnt<=cnt+1'b1;
        2'b00: cnt<=0;
    endcase;
end

always@(posedge clk_50Hz) begin
    if(turning==2'b01) begin
        
    end
end
always @(state,go_straight_command,turn_left_command,turn_right_command) begin
    case(state)
        2'b00: case({go_straight_command,turn_left_command,turn_right_command})
                    3'b100: 
                        // {move_forward_signal,turn_left_signal,turn_right_signal}=3'b100;
                        state=2'b11;
                    3'b010: 
                        // {move_forward_signal,turn_left_signal,turn_right_signal}=3'b010;
                        state=2'b01;
                    3'b001: 
                        // {move_forward_signal,turn_left_signal,turn_right_signal}=3'b001;
                        state=2'b10;
                    // default: state=2'b00;
                endcase
        2'b01: //左转90度
            {move_forward_signal,turn_left_signal,turn_right_signal}=3'b010;
        // case({go_straight_command,turn_left_command,turn_right_command}):
        //             3b'100: {move_forward_signal,turn_left_signal,turn_right_signal}=3b'100;
        //             3b'010: {move_forward_signal,turn_left_signal,turn_right_signal}=3b'010;
        //             3b'001: {move_forward_signal,turn_left_signal,turn_right_signal}=3b'001;
        //         endcase;
        2'b10: 
            {move_forward_signal,turn_left_signal,turn_right_signal}=3'b001;
        // case({go_straight_command,turn_left_command,turn_right_command}):
                    // 3b'100: {move_forward_signal,turn_left_signal,turn_right_signal}=3b'100;
                    // 3b'010: {move_forward_signal,turn_left_signal,turn_right_signal}=3b'010;
                    // 3b'001: {move_forward_signal,turn_left_signal,turn_right_signal}=3b'001;
                // endcase;
        2'b11: {move_forward_signal,turn_left_signal,turn_right_signal}=3'b100;
    endcase

end

endmodule