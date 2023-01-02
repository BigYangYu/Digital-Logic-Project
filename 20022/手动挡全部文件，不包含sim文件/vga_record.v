module vga_record (input has_record,
input clk_vga,
                   input [3:0] led1,
                   input [3:0] led2,
                   input [3:0] led3,
                   input [3:0] led4,
                   input [3:0] led5,
                   input [3:0] led6,
                   input [3:0] led7,
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

    always @(*) begin
        case (has_record)
            1'b1:
            begin
                    
            end
            default: has_num = 0;
        endcase
    end
    
    parameter zero_words_line00 = 20'b00000000000000000000;
    parameter zero_words_line01 = 20'b00000000000000000000;
    parameter zero_words_line02 = 20'b00000000000000000000;
    parameter zero_words_line03 = 20'b00000000000000000000;
    parameter zero_words_line04 = 20'b00000000000000000000;
    parameter zero_words_line05 = 20'b00000000000000000000;
    parameter zero_words_line06 = 20'b00000000000000000000;
    parameter zero_words_line07 = 20'b00000000000000000000;
    parameter zero_words_line08 = 20'b00000000000000000000;
    parameter zero_words_line09 = 20'b00001100000000000000;
    parameter zero_words_line10 = 20'b00011100000000000000;
    parameter zero_words_line11 = 20'b00111111000000000000;
    parameter zero_words_line12 = 20'b01111111000000000000;
    parameter zero_words_line13 = 20'b01111111000000000000;
    parameter zero_words_line14 = 20'b01110111100000000000;
    parameter zero_words_line15 = 20'b11100011100000000000;
    parameter zero_words_line16 = 20'b11100011100000000000;
    parameter zero_words_line17 = 20'b11100011100000000000;
    parameter zero_words_line18 = 20'b11100011100000000000;
    parameter zero_words_line19 = 20'b11100001100000000000;
    parameter zero_words_line20 = 20'b11100001100000000000;
    parameter zero_words_line21 = 20'b11100001100000000000;
    parameter zero_words_line22 = 20'b11100001100000000000;
    parameter zero_words_line23 = 20'b11100001100000000000;
    parameter zero_words_line24 = 20'b11100011100000000000;
    parameter zero_words_line25 = 20'b11100011100000000000;
    parameter zero_words_line26 = 20'b11100011100000000000;
    parameter zero_words_line27 = 20'b11110011100000000000;
    parameter zero_words_line28 = 20'b01110111100000000000;
    parameter zero_words_line29 = 20'b01110111100000000000;
    parameter zero_words_line30 = 20'b01111111000000000000;
    parameter zero_words_line31 = 20'b00111110000000000000;

    parameter one_words_line00 = 20'b00000000000000000000;
    parameter one_words_line01 = 20'b00000000000000000000;
    parameter one_words_line02 = 20'b00000000000000000000;
    parameter one_words_line03 = 20'b00000000000000000000;
    parameter one_words_line04 = 20'b00000000000000000000;
    parameter one_words_line05 = 20'b00000000000000000000;
    parameter one_words_line06 = 20'b00000000000000000000;
    parameter one_words_line07 = 20'b00000000000000000000;
    parameter one_words_line08 = 20'b00000000000000000000;
    parameter one_words_line09 = 20'b00001100000000000000;
    parameter one_words_line10 = 20'b00001100000000000000;
    parameter one_words_line11 = 20'b00011100000000000000;
    parameter one_words_line12 = 20'b00111100000000000000;
    parameter one_words_line13 = 20'b00111100000000000000;
    parameter one_words_line14 = 20'b01111100000000000000;
    parameter one_words_line15 = 20'b01111100000000000000;
    parameter one_words_line16 = 20'b01111100000000000000;
    parameter one_words_line17 = 20'b01111100000000000000;
    parameter one_words_line18 = 20'b00011100000000000000;
    parameter one_words_line19 = 20'b00011100000000000000;
    parameter one_words_line20 = 20'b00011100000000000000;
    parameter one_words_line21 = 20'b00011100000000000000;
    parameter one_words_line22 = 20'b00011100000000000000;
    parameter one_words_line23 = 20'b00011100000000000000;
    parameter one_words_line24 = 20'b00011100000000000000;
    parameter one_words_line25 = 20'b00011100000000000000;
    parameter one_words_line26 = 20'b00011100000000000000;
    parameter one_words_line27 = 20'b00011100000000000000;
    parameter one_words_line28 = 20'b00011110000000000000;
    parameter one_words_line29 = 20'b00011110000000000000;
    parameter one_words_line30 = 20'b00111111000000000000;
    parameter one_words_line31 = 20'b00111111000000000000;

    parameter two_words_line00 = 20'b00000000000000000000;
    parameter two_words_line01 = 20'b00000000000000000000;
    parameter two_words_line02 = 20'b00000000000000000000;
    parameter two_words_line03 = 20'b00000000000000000000;
    parameter two_words_line04 = 20'b00000000000000000000;
    parameter two_words_line05 = 20'b00000000000000000000;
    parameter two_words_line06 = 20'b00000000000000000000;
    parameter two_words_line07 = 20'b00000000000000000000;
    parameter two_words_line08 = 20'b00000000000000000000;
    parameter two_words_line09 = 20'b00011100000000000000;
    parameter two_words_line10 = 20'b00011110000000000000;
    parameter two_words_line11 = 20'b00111111000000000000;
    parameter two_words_line12 = 20'b01111111100000000000;
    parameter two_words_line13 = 20'b01111111100000000000;
    parameter two_words_line14 = 20'b01111111100000000000;
    parameter two_words_line15 = 20'b11100011100000000000;
    parameter two_words_line16 = 20'b11100011100000000000;
    parameter two_words_line17 = 20'b11100011100000000000;
    parameter two_words_line18 = 20'b00000011100000000000;
    parameter two_words_line19 = 20'b00000111100000000000;
    parameter two_words_line20 = 20'b00001111100000000000;
    parameter two_words_line21 = 20'b00001111000000000000;
    parameter two_words_line22 = 20'b00001111000000000000;
    parameter two_words_line23 = 20'b00011110000000000000;
    parameter two_words_line24 = 20'b00011110000000000000;
    parameter two_words_line25 = 20'b00111100100000000000;
    parameter two_words_line26 = 20'b00111000100000000000;
    parameter two_words_line27 = 20'b01111001100000000000;
    parameter two_words_line28 = 20'b11111111100000000000;
    parameter two_words_line29 = 20'b11111111100000000000;
    parameter two_words_line30 = 20'b11111111100000000000;
    parameter two_words_line31 = 20'b11111111100000000000;

    parameter three_words_line00 = 20'b00000000000000000000;
    parameter three_words_line01 = 20'b00000000000000000000;
    parameter three_words_line02 = 20'b00000000000000000000;
    parameter three_words_line03 = 20'b00000000000000000000;
    parameter three_words_line04 = 20'b00000000000000000000;
    parameter three_words_line05 = 20'b00000000000000000000;
    parameter three_words_line06 = 20'b00000000000000000000;
    parameter three_words_line07 = 20'b00000000000000000000;
    parameter three_words_line08 = 20'b00000000000000000000;
    parameter three_words_line09 = 20'b00001110000000000000;
    parameter three_words_line10 = 20'b00001110000000000000;
    parameter three_words_line11 = 20'b00111111000000000000;
    parameter three_words_line12 = 20'b01111111000000000000;
    parameter three_words_line13 = 20'b01111111000000000000;
    parameter three_words_line14 = 20'b01111111000000000000;
    parameter three_words_line15 = 20'b01100111000000000000;
    parameter three_words_line16 = 20'b01100111000000000000;
    parameter three_words_line17 = 20'b01001111000000000000;
    parameter three_words_line18 = 20'b00001110000000000000;
    parameter three_words_line19 = 20'b00011111100000000000;
    parameter three_words_line20 = 20'b00011111100000000000;
    parameter three_words_line21 = 20'b00011111100000000000;
    parameter three_words_line22 = 20'b00011111100000000000;
    parameter three_words_line23 = 20'b00000011100000000000;
    parameter three_words_line24 = 20'b00000011100000000000;
    parameter three_words_line25 = 20'b00000011100000000000;
    parameter three_words_line26 = 20'b00000011100000000000;
    parameter three_words_line27 = 20'b00000011100000000000;
    parameter three_words_line28 = 20'b11110111100000000000;
    parameter three_words_line29 = 20'b11110111100000000000;
    parameter three_words_line30 = 20'b11111111000000000000;
    parameter three_words_line31 = 20'b11111110000000000000;

    parameter four_words_line00 = 20'b00000000000000000000;
    parameter four_words_line01 = 20'b00000000000000000000;
    parameter four_words_line02 = 20'b00000000000000000000;
    parameter four_words_line03 = 20'b00000000000000000000;
    parameter four_words_line04 = 20'b00000000000000000000;
    parameter four_words_line05 = 20'b00000000000000000000;
    parameter four_words_line06 = 20'b00000000000000000000;
    parameter four_words_line07 = 20'b00000000000000000000;
    parameter four_words_line08 = 20'b00000000000000000000;
    parameter four_words_line09 = 20'b00000011000000000000;
    parameter four_words_line10 = 20'b00000011000000000000;
    parameter four_words_line11 = 20'b00000111000000000000;
    parameter four_words_line12 = 20'b00001111000000000000;
    parameter four_words_line13 = 20'b00001111000000000000;
    parameter four_words_line14 = 20'b00001111000000000000;
    parameter four_words_line15 = 20'b00011111000000000000;
    parameter four_words_line16 = 20'b00011111000000000000;
    parameter four_words_line17 = 20'b00111111000000000000;
    parameter four_words_line18 = 20'b00111111000000000000;
    parameter four_words_line19 = 20'b00111111000000000000;
    parameter four_words_line20 = 20'b01110111000000000000;
    parameter four_words_line21 = 20'b01110111000000000000;
    parameter four_words_line22 = 20'b11110111000000000000;
    parameter four_words_line23 = 20'b11111111110000000000;
    parameter four_words_line24 = 20'b11111111110000000000;
    parameter four_words_line25 = 20'b11111111110000000000;
    parameter four_words_line26 = 20'b11111111110000000000;
    parameter four_words_line27 = 20'b11111111110000000000;
    parameter four_words_line28 = 20'b00000111000000000000;
    parameter four_words_line29 = 20'b00000111000000000000;
    parameter four_words_line30 = 20'b00000111000000000000;
    parameter four_words_line31 = 20'b00000111000000000000;

    parameter five_words_line00 = 20'b00000000000000000000;
    parameter five_words_line01 = 20'b00000000000000000000;
    parameter five_words_line02 = 20'b00000000000000000000;
    parameter five_words_line03 = 20'b00000000000000000000;
    parameter five_words_line04 = 20'b00000000000000000000;
    parameter five_words_line05 = 20'b00000000000000000000;
    parameter five_words_line06 = 20'b00000000000000000000;
    parameter five_words_line07 = 20'b00000000000000000000;
    parameter five_words_line08 = 20'b00000000000000000000;
    parameter five_words_line09 = 20'b00111111000000000000;
    parameter five_words_line10 = 20'b00111111000000000000;
    parameter five_words_line11 = 20'b00111111000000000000;
    parameter five_words_line12 = 20'b00111111000000000000;
    parameter five_words_line13 = 20'b00111111000000000000;
    parameter five_words_line14 = 20'b00111111000000000000;
    parameter five_words_line15 = 20'b00110000000000000000;
    parameter five_words_line16 = 20'b00110000000000000000;
    parameter five_words_line17 = 20'b00111110000000000000;
    parameter five_words_line18 = 20'b00111110000000000000;
    parameter five_words_line19 = 20'b00111111000000000000;
    parameter five_words_line20 = 20'b00111111100000000000;
    parameter five_words_line21 = 20'b00111111100000000000;
    parameter five_words_line22 = 20'b00111111100000000000;
    parameter five_words_line23 = 20'b00000011100000000000;
    parameter five_words_line24 = 20'b00000011100000000000;
    parameter five_words_line25 = 20'b00000011100000000000;
    parameter five_words_line26 = 20'b00000011100000000000;
    parameter five_words_line27 = 20'b00000011100000000000;
    parameter five_words_line28 = 20'b01110111100000000000;
    parameter five_words_line29 = 20'b01110111100000000000;
    parameter five_words_line30 = 20'b01111111000000000000;
    parameter five_words_line31 = 20'b01111111000000000000;

    parameter six_words_line00 = 20'b00000000000000000000;
    parameter six_words_line01 = 20'b00000000000000000000;
    parameter six_words_line02 = 20'b00000000000000000000;
    parameter six_words_line03 = 20'b00000000000000000000;
    parameter six_words_line04 = 20'b00000000000000000000;
    parameter six_words_line05 = 20'b00000000000000000000;
    parameter six_words_line06 = 20'b00000000000000000000;
    parameter six_words_line07 = 20'b00000000000000000000;
    parameter six_words_line08 = 20'b00000000000000000000;
    parameter six_words_line09 = 20'b00000001000000000000;
    parameter six_words_line10 = 20'b00000011000000000000;
    parameter six_words_line11 = 20'b00001111000000000000;
    parameter six_words_line12 = 20'b00011111000000000000;
    parameter six_words_line13 = 20'b00011111000000000000;
    parameter six_words_line14 = 20'b00111110000000000000;
    parameter six_words_line15 = 20'b00111100000000000000;
    parameter six_words_line16 = 20'b01111100000000000000;
    parameter six_words_line17 = 20'b01111000000000000000;
    parameter six_words_line18 = 20'b01110000000000000000;
    parameter six_words_line19 = 20'b01111111000000000000;
    parameter six_words_line20 = 20'b11111111100000000000;
    parameter six_words_line21 = 20'b11111111100000000000;
    parameter six_words_line22 = 20'b11101111100000000000;
    parameter six_words_line23 = 20'b11100011100000000000;
    parameter six_words_line24 = 20'b11100011100000000000;
    parameter six_words_line25 = 20'b11100011100000000000;
    parameter six_words_line26 = 20'b11100011100000000000;
    parameter six_words_line27 = 20'b11110011100000000000;
    parameter six_words_line28 = 20'b01110111100000000000;
    parameter six_words_line29 = 20'b01110111100000000000;
    parameter six_words_line30 = 20'b01111111100000000000;
    parameter six_words_line31 = 20'b00111111000000000000;

    parameter seven_words_line00 = 20'b00000000000000000000;
    parameter seven_words_line01 = 20'b00000000000000000000;
    parameter seven_words_line02 = 20'b00000000000000000000;
    parameter seven_words_line03 = 20'b00000000000000000000;
    parameter seven_words_line04 = 20'b00000000000000000000;
    parameter seven_words_line05 = 20'b00000000000000000000;
    parameter seven_words_line06 = 20'b00000000000000000000;
    parameter seven_words_line07 = 20'b00000000000000000000;
    parameter seven_words_line08 = 20'b00000000000000000000;
    parameter seven_words_line09 = 20'b01111111100000000000;
    parameter seven_words_line10 = 20'b11111111100000000000;
    parameter seven_words_line11 = 20'b11111111100000000000;
    parameter seven_words_line12 = 20'b11111111100000000000;
    parameter seven_words_line13 = 20'b11111111100000000000;
    parameter seven_words_line14 = 20'b11111111100000000000;
    parameter seven_words_line15 = 20'b11000011100000000000;
    parameter seven_words_line16 = 20'b11000011100000000000;
    parameter seven_words_line17 = 20'b00000111000000000000;
    parameter seven_words_line18 = 20'b00000111000000000000;
    parameter seven_words_line19 = 20'b00000111000000000000;
    parameter seven_words_line20 = 20'b00000110000000000000;
    parameter seven_words_line21 = 20'b00000110000000000000;
    parameter seven_words_line22 = 20'b00001110000000000000;
    parameter seven_words_line23 = 20'b00001110000000000000;
    parameter seven_words_line24 = 20'b00001110000000000000;
    parameter seven_words_line25 = 20'b00001100000000000000;
    parameter seven_words_line26 = 20'b00001100000000000000;
    parameter seven_words_line27 = 20'b00011100000000000000;
    parameter seven_words_line28 = 20'b00011100000000000000;
    parameter seven_words_line29 = 20'b00011100000000000000;
    parameter seven_words_line30 = 20'b00011000000000000000;
    parameter seven_words_line31 = 20'b00011000000000000000;

    parameter eight_words_line00 = 20'b00000000000000000000;
    parameter eight_words_line01 = 20'b00000000000000000000;
    parameter eight_words_line02 = 20'b00000000000000000000;
    parameter eight_words_line03 = 20'b00000000000000000000;
    parameter eight_words_line04 = 20'b00000000000000000000;
    parameter eight_words_line05 = 20'b00000000000000000000;
    parameter eight_words_line06 = 20'b00000000000000000000;
    parameter eight_words_line07 = 20'b00000000000000000000;
    parameter eight_words_line08 = 20'b00000000000000000000;
    parameter eight_words_line09 = 20'b00011110000000000000;
    parameter eight_words_line10 = 20'b00011110000000000000;
    parameter eight_words_line11 = 20'b00111111000000000000;
    parameter eight_words_line12 = 20'b01111111100000000000;
    parameter eight_words_line13 = 20'b01111111100000000000;
    parameter eight_words_line14 = 20'b01110011100000000000;
    parameter eight_words_line15 = 20'b01110011100000000000;
    parameter eight_words_line16 = 20'b01110011100000000000;
    parameter eight_words_line17 = 20'b01111111100000000000;
    parameter eight_words_line18 = 20'b01111111100000000000;
    parameter eight_words_line19 = 20'b01111111100000000000;
    parameter eight_words_line20 = 20'b01111111000000000000;
    parameter eight_words_line21 = 20'b00111111100000000000;
    parameter eight_words_line22 = 20'b01111111100000000000;
    parameter eight_words_line23 = 20'b01111111100000000000;
    parameter eight_words_line24 = 20'b01111111100000000000;
    parameter eight_words_line25 = 20'b01110011100000000000;
    parameter eight_words_line26 = 20'b01100001100000000000;
    parameter eight_words_line27 = 20'b01110011100000000000;
    parameter eight_words_line28 = 20'b01111111100000000000;
    parameter eight_words_line29 = 20'b01111111100000000000;
    parameter eight_words_line30 = 20'b01111111100000000000;
    parameter eight_words_line31 = 20'b00111111000000000000;

    parameter nine_words_line00 = 20'b00000000000000000000;
    parameter nine_words_line01 = 20'b00000000000000000000;
    parameter nine_words_line02 = 20'b00000000000000000000;
    parameter nine_words_line03 = 20'b00000000000000000000;
    parameter nine_words_line04 = 20'b00000000000000000000;
    parameter nine_words_line05 = 20'b00000000000000000000;
    parameter nine_words_line06 = 20'b00000000000000000000;
    parameter nine_words_line07 = 20'b00000000000000000000;
    parameter nine_words_line08 = 20'b00000000000000000000;
    parameter nine_words_line09 = 20'b00011100000000000000;
    parameter nine_words_line10 = 20'b00011100000000000000;
    parameter nine_words_line11 = 20'b01111111000000000000;
    parameter nine_words_line12 = 20'b01111111000000000000;
    parameter nine_words_line13 = 20'b01111111000000000000;
    parameter nine_words_line14 = 20'b11110111100000000000;
    parameter nine_words_line15 = 20'b11100011100000000000;
    parameter nine_words_line16 = 20'b11100011100000000000;
    parameter nine_words_line17 = 20'b11100011100000000000;
    parameter nine_words_line18 = 20'b11100011100000000000;
    parameter nine_words_line19 = 20'b11110011100000000000;
    parameter nine_words_line20 = 20'b11111111100000000000;
    parameter nine_words_line21 = 20'b11111111100000000000;
    parameter nine_words_line22 = 20'b01111111100000000000;
    parameter nine_words_line23 = 20'b01111111100000000000;
    parameter nine_words_line24 = 20'b00111111100000000000;
    parameter nine_words_line25 = 20'b00000111100000000000;
    parameter nine_words_line26 = 20'b00000111000000000000;
    parameter nine_words_line27 = 20'b00001111000000000000;
    parameter nine_words_line28 = 20'b00111110000000000000;
    parameter nine_words_line29 = 20'b00111110000000000000;
    parameter nine_words_line30 = 20'b01111100000000000000;
    parameter nine_words_line31 = 20'b01111000000000000000;
    
    
    
endmodule
