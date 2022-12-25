`timescale 1ns / 1ps

module draft_top(
    input clk, //P17 pin
    input rx_1,
    output tx_1,


    input user_goStraght,
    input user_turnLeft,
    input user_turnRight


);
    wire front_detector_1,left_detector_1,right_detector_1;
    wire turn_left_signal_1,turn_right_signal_1,move_forward_signal_1,move_backward_signal_1;
    wire go_straight_command_1,turn_left_command_1,turn_right_command_1;

    wire [1:0] state_1;

    SimulatedDevice ok1(.sys_clk(clk), .rx(rx_1), .tx(tx_1), 
                        .turn_left_signal(turn_left_signal_1), .turn_right_signal(turn_right_signal_1), .move_forward_signal(move_forward_signal_1),
                        .move_backward_signal(0), .place_barrier_signal(0), .destroy_barrier_signal(0),
                        .front_detector(front_detector_1), .left_detector(left_detector_1), .right_detector(right_detector_1));


    SemiAutoDriving ok2(.clk(clk), .front_detector(front_detector_1), .back_detector(0), .left_detector(left_detector_1), .right_detector(right_detector_1),
                        .go_straight_command(user_goStraght), .turn_left_command(user_turnLeft), .turn_right_command(user_turnRight),
                        .move_forward_signal(move_forward_signal_1), .turn_left_signal(turn_left_signal_1), .turn_right_signal(turn_right_signal_1),
                        .state(state_1)
                        );


endmodule
