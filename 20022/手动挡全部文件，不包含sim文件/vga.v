//640*480
module vga_top (input clk,
                input debounced_power_on,
                input manul_mode_on,
                input semi_auto_mode_on,
                input auto_mode_on,
                input record,
                input power_now,
                input rst_n,
                output reg hsync,
                output reg vsync,         // hsync and vsync are connected to the port on board.
                output reg [3:0] red,
                output reg [3:0] green,
                output reg [3:0] blue);   // color
    reg [9:0] hc;   // h_cnt
    reg [9:0] vc;
    reg [3:0] led1,led2,led3,led4,led5,led6,led7;
    reg has_record; // diffe
    reg has_num; // whether the zone can together display a num
    wire has_color; // whether the pixel has color
    wire clk25;
    reg [3:0] digit; // store the current digit to display
    // x y store the coordinate in the valid zone
    reg x;
    reg y;
    reg [1:0] clk_counter;
    reg can_be_colored;
    num_switch num_switch(
    digit,
    y,
    x,
    has_color
    );
    parameter hpixels = 800;    // number of pixel of every horizontal line
    parameter hbp     = 144;       // left bound
    parameter hfp     = 783;       // reight bound, revised from 784
    parameter vbp     = 31;       // upper bound
    parameter vfp     = 510;       // lower bound
    
    parameter state_xs = 310;
    parameter state_xe = 330;
    parameter state_ys = 160;
    parameter state_ye = 192;
    parameter nums_xs1 = 240;
    parameter nums_xe1 = 260;
    parameter nums_xs2 = 260;
    parameter nums_xe2 = 280;
    parameter nums_xs3 = 280;
    parameter nums_xe3 = 300;
    parameter nums_xs4 = 300;
    parameter nums_xe4 = 320;
    parameter nums_xs5 = 320;
    parameter nums_xe5 = 340;
    parameter nums_xs6 = 340;
    parameter nums_xe6 = 360;
    parameter nums_xs7 = 360;
    parameter nums_xe7 = 380;
    parameter nums_xs8 = 380;
    parameter nums_xe8 = 400;
    parameter nums_ys  = 256;
    parameter nums_ye  = 288;
    
    
    always@(posedge clk)
    begin
        begin
        clk_counter <= clk_counter+1'b1;
    end
    end
    assign clk25 = clk_counter[1];
    
    always @(posedge clk25) begin
        if (hc == hpixels - 1)
        begin
            hc <= 0;
        end
        else
        begin
            hc <= hc +1'b1;
        end
    end
    
    always @(*) begin
        if (hc < 96)  //ͬ��Ϊ96 96 is the sync time
            hsync = 0;
        else
            hsync = 1'b1;
    end
    
    // update the index of current vertical line when the scan reach the end of a horizontal line
    always @(posedge clk25) begin
        if (hc == 799) // when the scan reach the end of a horizontal line
        begin
            if (vc == 520)
                vc <= 0;
            else
                vc <= vc + 1'b1;
        end
        else
            vc <= vc;
    end
    
    
    always @(*) begin
        if (vc < 2)   //ͬ��Ϊ2  2 is the sync time
            vsync = 1'b0;
        else
            vsync = 1'b1;
    end
    
    always @(*) begin
        if ((hc >= hbp) && (hc < = hfp) && (vc >= vbp) && (vc < = vfp))
        begin
            can_be_colored = 1'b1;
        end
        else
            can_be_colored = 1'b0;
    end
    
    
    always @(*) begin
        case (debounced_power_on)
            0: begin
                if ((hc >= hbp+state_xs)&&(hc < hbp+state_xe)&&(vc >= vbp+state_ys)&&(vc < vbp+state_ye))
                begin
                    has_num = 1;
                    x       = hc-hbp-state_xs;
                    y       = vc-vbp-state_ys;
                    digit   = 0;
                end
                else
                begin
                    has_num = 0;
                end
            end
            default: begin
                case ({manul_mode_on,semi_auto_mode_on,auto_mode_on})
                    3'b100:
                    begin
                        if ((hc >= hbp+state_xs)&&(hc < hbp+state_xe)&&(vc >= vbp+state_ys)&&(vc < vbp+state_ye))
                        begin
                            x       = hc-hbp-state_xs;
                            y       = vc-vbp-state_ys;
                            digit   = 1;
                            has_num = 1;
                        end
                        else
                        begin
                            if (rst_n&&power_now) begin
                                has_num = 0;
                            end
                            else begin
                                led7 = (record/100_0000)%10;
                                led6 = (record/10_0000)%10;
                                led5 = (record/1_0000)%10;
                                led4 = (record/1_000)%10;
                                led3 = (record/100)%10;
                                led2 = (record/10)%10;
                                led1 = record%10;

                                if ((hc >= hbp+nums_xs1)&&(hc < hbp+nums_xe1)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led7;
                                    x       = hc-hbp-nums_xs1;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                end
                                else if ((hc >= hbp+nums_xs2)&&(hc < hbp+nums_xe2)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led6;
                                    x       = hc-hbp-nums_xs2;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                    else if ((hc >= hbp+nums_xs3)&&(hc < hbp+nums_xe3)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led5;
                                    x       = hc-hbp-nums_xs3;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                    else if ((hc >= hbp+nums_xs4)&&(hc < hbp+nums_xe4)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led4;
                                    x       = hc-hbp-nums_xs4;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                    else if ((hc >= hbp+nums_xs5)&&(hc < hbp+nums_xe5)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led3;
                                    x       = hc-hbp-nums_xs5;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                    else if ((hc >= hbp+nums_xs6)&&(hc < hbp+nums_xe6)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led2;
                                    x       = hc-hbp-nums_xs6;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                    else if ((hc >= hbp+nums_xs7)&&(hc < hbp+nums_xe7)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = led1;
                                    x       = hc-hbp-nums_xs7;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                    else if ((hc >= hbp+nums_xs8)&&(hc < hbp+nums_xe8)&&(vc >= vbp+nums_ys)&&(vc < vbp+nums_ye)) begin
                                    digit   = 0;
                                    x       = hc-hbp-nums_xs8;
                                    y       = vc-vbp-nums_ys;
                                    has_num = 1;
                                    end
                                else begin
                                    has_num = 0;
                                end
                                
                            end
                        end
                    end
                    3'b010:
                    begin
                        has_record = 0;
                        if ((hc >= hbp+state_xs)&&(hc < hbp+state_xe)&&(vc >= vbp+state_ys)&&(vc < vbp+state_ye))
                        begin
                            x       = hc-hbp-state_xs;
                            y       = vc-vbp-state_ys;
                            has_num = 1;
                            digit   = 2;
                        end
                        else
                        begin
                            has_num = 0;
                        end
                    end
                    3'b001:
                    begin
                        has_record = 0;
                        if ((hc >= hbp+state_xs)&&(hc < hbp+state_xe)&&(vc >= vbp+state_ys)&&(vc < vbp+state_ye))
                        begin
                            x       = hc-hbp-state_xs;
                            y       = vc-vbp-state_ys;
                            has_num = 1;
                            digit   = 3;
                        end
                        else
                        begin
                            has_num = 0;
                        end
                    end
                    default:begin
                        has_num = 0;
                    end
                endcase
            end
        endcase
    end
    
    always @(posedge clk25) begin // this block control color
        case ({can_be_colored,has_num,has_color})
            3'b111:
            begin   //��ɫ
                red   = 4'b1111;
                green = 4'b1111;
                blue  = 4'b1111;
            end
            default:
            begin
                red   = 0;   //����������������������
                blue  = 0;
                green = 0;
            end
        endcase
    end
endmodule
    
