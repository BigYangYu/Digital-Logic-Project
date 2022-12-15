`timescale 1ns / 1ps


module SemiAutoDriving(
    input clk, //(100MHz system clock)
    // input rst,

    input front_detector,
    input back_detector,
    input left_detector,
    input right_detector,

    input go_straight_command,
    input turn_left_command,
    input turn_right_command,

    output reg move_forward_signal,
    output reg turn_left_signal,
    output reg turn_right_signal,

    output reg [1:0]state
);
// reg[1:0] state;
//Wait-for-command,Turn-Left,Turn-Right,Moving
//00,01,10,11


reg[31:0] cnt;
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
                    state<=2'b11;
                    cnt<=0;
                end
                else 
                    cnt<=cnt+1'b1;
        2'b10: if(cnt==32'b1_000_000) begin
                    state<=2'b11;
                    cnt<=0;
                end
                else
                    cnt<=cnt+1'b1;
        2'b00: cnt<=0;
    endcase
end


always @(state,go_straight_command,turn_left_command,turn_right_command) begin
    case(state)
        2'b00: case({go_straight_command,turn_left_command,turn_right_command})
                    3'b100: 
                        state=2'b11;
                    3'b010: 
                        state=2'b01;
                    3'b001: 
                        state=2'b10;
                    // default: state=2'b00;
                endcase
        2'b01: 
            {move_forward_signal,turn_left_signal,turn_right_signal}=3'b010;
        2'b10: 
            {move_forward_signal,turn_left_signal,turn_right_signal}=3'b001;
        2'b11: 
            {move_forward_signal,turn_left_signal,turn_right_signal}=3'b100;
    endcase
end


endmodule