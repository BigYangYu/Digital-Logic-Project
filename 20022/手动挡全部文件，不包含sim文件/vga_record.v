module vga_record (input has_record,
                   input [3:0] led1,
                   led2,
                   led3,
                   led4,
                   led5,
                   led6,
                   led7,
                   input [9:0] hc,
                   input [9:0] vc,
                   output has_num);
    reg [19:0] num_line;
    parameter hbp      = 144;       //行显示后沿，144（128+16） 96+48
    parameter hfp      = 784;       //行显示前沿784（128+16+640）800-16
    parameter vbp      = 35;       //场显示后延，31（2+29）  ??????? 35(33+2)
    parameter vfp      = 515;
    parameter nums_xs1 = 320;
    parameter nums_xe1 = 340;
    parameter nums_xs2 = 340;
    parameter nums_xe2 = 360;
    parameter nums_xs3 = 360;
    parameter nums_xe3 = 380;
    parameter nums_xs4 = 380;
    parameter nums_xe4 = 400;
    parameter nums_xs5 = 400;
    parameter nums_xe5 = 420;
    parameter nums_xs6 = 420;
    parameter nums_xe6 = 440;
    parameter nums_xs7 = 440;
    parameter nums_xe7 = 460;
    parameter nums_xs8 = 460;
    parameter nums_xe8 = 480;
    parameter nums_ys  = 352;
    parameter nums_ye  = 416;
    reg [3:0] digit; // stores the digit of current bit
    reg [19:0] words [31:0]; // store the current graph
    
    // 20 x 32
    // 0
    
    
    always @(*) begin
        case (has_record)
            1'b1:
            begin
                if ((hc >= hbp+nums_xs1)&&(hc < hbp+nums_xe1)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led7;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs1]
                end
                else if ((hc >= hbp+nums_xs2)&&(hc < hbp+nums_xe2)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led6;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs2]
                end
                else if ((hc >= hbp+nums_xs3)&&(hc < hbp+nums_xe3)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led5;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs3]
                end
                else if ((hc >= hbp+nums_xs4)&&(hc < hbp+nums_xe4)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led4;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs4]
                end
                else if ((hc >= hbp+nums_xs5)&&(hc < hbp+nums_xe5)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led3;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs5]
                end
                else if ((hc >= hbp+nums_xs6)&&(hc < hbp+nums_xe6)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led2;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs6]
                end
                else if ((hc >= hbp+nums_xs7)&&(hc < hbp+nums_xe7)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = led1;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs7]
                end
                else if ((hc >= hbp+nums_xs8)&&(hc < hbp+nums_xe8)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                    digit = 0;
                    has_num = words[vc-vbp-nums_ys][hc-hbp-nums_xs8]
                end
                else begin
                    has_num = 0;
                end
            end
            default: has_num = 0;
        endcase
    end
    
    
    
endmodule
