`timescale 1ns / 1ps

//此模块不需要了
module turning_clk_div(
    input sys_clk,
    output reg turning_clk
);
    reg[31:0] cnt=0;
    // reg turning_clk=0;
    always @ (posedge sys_clk) begin
        if(cnt==32'd1_000_000) begin
            turning_clk <= ~turning_clk;
            cnt <= 0;
        end
        else
            cnt<=cnt+1'b1;
    end
endmodule
