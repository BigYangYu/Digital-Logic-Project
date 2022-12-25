`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 22:10:40
// Design Name: 
// Module Name: dev_top
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


module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    // tx and rs are abbreviation for transmit and receive, respectively.
    
    input turn_left_signal,
    input turn_right_signal,
    input move_forward_signal,
    input move_backward_signal,
    input place_barrier_signal,
    input destroy_barrier_signal,
    // the above two signals are used in the auto driving mode
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector
    // The above 4 signals are activated when there are walls on the direction.
    // And the front can also detect becon.
    );
    wire [7:0] in = {2'b10, destroy_barrier_signal, place_barrier_signal, turn_right_signal, turn_left_signal, move_backward_signal, move_forward_signal};
    wire [7:0] rec;
    assign front_detector = rec[0];
    assign back_detector = rec[3];
    assign left_detector = rec[1];
    assign right_detector = rec[2];
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx));
    // In the uart_top module, uart_rx and uart_tx module will be initialized.
    // If the rst is 1, then in both of the module, will do reset operation.
endmodule
