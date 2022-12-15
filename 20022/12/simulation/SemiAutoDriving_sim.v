`timescale 1ns / 1ps

module SemiAutoDriving_sim();

reg front_detector_sim,back_detector_sim,left_detetor_sim,right_detector_sim;
reg go_straight_command_sim,turn_left_command_sim,turn_right_command_sim;
wire move_forward_signal_sim,turn_left_signal_sim,turn_right_signal_sim;
wire[1:0] state_sim;

SemiAutoDriving ok(.front_detector(front_detector_sim), .back_detector(back_detector_sim), .left_detector(left_detetor_sim), .right_detector(right_detector_sim),
                .go_straight_command(go_straight_command_sim),
                .turn_left_command(turn_left_command_sim),
                .turn_right_command(turn_right_command_sim),
                .move_forward_signal(move_forward_signal_sim),
                .turn_left_signal(turn_left_signal_sim),
                .turn_right_signal(turn_right_signal_sim),
                .state(state_sim));

initial begin
    go_straight_command_sim=0;turn_left_command_sim=0;turn_right_command_sim=0;
    front_detector_sim=0;left_detetor_sim=1;right_detector_sim=1;//前方无障碍，�?直向前走
    #20
    front_detector_sim=0;left_detetor_sim=1;right_detector_sim=0;//既可以往前走，也可以右转
    #10
    turn_right_command_sim=1; #5 turn_right_command_sim=0;


    #10
    front_detector_sim=0;left_detetor_sim=1;right_detector_sim=1;//前方无障碍，�?直向前走
    #10
    $finish();


end

endmodule
