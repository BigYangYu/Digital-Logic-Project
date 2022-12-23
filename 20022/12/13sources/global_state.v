module global_state (input sys_clk,
                     input rst_n,
                     input throttle,              //油门
                     input clutch,                //离合
                     input brake,
                     input reverse,               //倒车
                     input rx,
                     output tx,
                     input turn_left_signal,
                     input turn_right_signal,
                     input move_forward_signal,
                     output reg power_on_led = 0,
                     output reg [2:0] mode_led,
                     output left_led,
                     output right_led,
                     input power_on,
                     input power_off,
                     input [2:0] mode_signal,
                     output [7:0] seg_enable,
                     output[7:0] seg_led1,
                     output [7:0] seg_led2,
                     output back_detector,
                     output left_detector,
                     output front_detector,
                     output right_detector);
    wire debounced_power_on; // when you instaintiate a submodlue, the register type can NOT be used and the wire type should be used.
    wire [3:0] answer; //依次输出左转，右转，后�??，前进信�????
    wire [3:0] state;
    wire power_now;
    wire [26:0] record;
    reg manul_mode_on     ;
    reg semi_auto_mode_on = 0;
    reg auto_mode_on      = 0;
    reg place_barrier_signal;
    reg destroy_barrier_signal;
    debouncer d0(power_on,power_off,sys_clk,debounced_power_on);
    ManualDrivingMode manual_top(
    .clk(sys_clk),
    .rst(rst_n),
    .power_input(manul_mode_on),
    .throttle(throttle),
    .clutch(clutch),
    .brake(brake),
    .reverse(reverse),
    .turn_left_signal(~turn_left_signal),
    .turn_right_signal(~turn_right_signal),
    .answer(answer),
    .state(state),
    .power_now(power_now)
    );
    record_manual record0(
    .clk(sys_clk),
    .rst(rst_n),
    .power_now(power_now),
    .state(state),
    .record(record)
    );
    flash_led_top flahs0(
    .clk(sys_clk),
    .rst_n(rst_n),
    .power_now(power_now),
    .state1(state),
    .record(record),
    .led(seg_enable),
    .seg_led1(seg_led1),
    .seg_led2(seg_led2)
    );
    turn_left_right_light turn_light0(
    .clk(sys_clk),
    .rst(rst_n),
    .power_now(power_now),
    .state(state),
    .answer(answer),
    .left_led(left_led),
    .right_led(right_led)
    );
    SimulatedDevice sim(
    sys_clk,
    rx,
    tx,
    answer[3],answer[2],answer[0],answer[1],
    place_barrier_signal,destroy_barrier_signal,
    front_detector,back_detector,left_detector,right_detector);   // NOT revised the bug in simulation.
    
    always @(*) begin
        case ({debounced_power_on})
            1'b1:
            begin
                power_on_led = 1'b1;
                // should be one
                case (mode_signal)
                    3'b001:
                    // the manual mode is on.
                    begin
                        mode_led[0]       = 1;
                        mode_led[1]       = 0;
                        mode_led[2]       = 0;
                        manul_mode_on     = 1'b1;
                        semi_auto_mode_on = 0;
                        auto_mode_on      = 0;
                        
                    end
                    3'b010:
                    begin
                        mode_led[0]       = 0;
                        mode_led[1]       = 1;
                        mode_led[2]       = 0;
                        manul_mode_on     = 0;
                        semi_auto_mode_on = 1'b1;
                        auto_mode_on      = 0;
                    end
                    3'b100:
                    begin
                        mode_led[0]       = 0;
                        mode_led[1]       = 0;
                        mode_led[2]       = 1;
                        manul_mode_on     = 0;
                        semi_auto_mode_on = 0;
                        auto_mode_on      = 1'b1;
                    end
                    default:
                    begin
                        mode_led[0]       = 0;
                        mode_led[1]       = 0;
                        mode_led[2]       = 0;
                        manul_mode_on     = 0;
                        semi_auto_mode_on = 0;
                        auto_mode_on      = 0;
                    end
                endcase
            end
            // 10 is the state when power on.
            1'b0:
            begin
                power_on_led      = 0;
                mode_led[0]       = 0;
                mode_led[1]       = 0;
                mode_led[2]       = 0;
                manul_mode_on     = 0;
                semi_auto_mode_on = 0;
                auto_mode_on      = 0;
               
            end
        endcase
    end
endmodule
    
    // Implementation of press and hold on power on button for at least 1 seconds,
    // the car will enable its engine.
    // 1/100 s
    module debouncer (
        input power_on,
        input power_off,
        input sys_clk,
        output reg debounced_power_on);
        // get the 100Hz clock first.
        wire debouncer_divclk;
        debouncer_clk_div div(sys_clk,debouncer_divclk);
        // get delay signals.
        reg[9:0] cnt = 0;
        always @(posedge debouncer_divclk) begin
            casex ({power_on,power_off})
                2'b00:
                // press the power_on button
                begin
                    case (cnt)
                        10'd1000: debounced_power_on <= 1'b1;
                        default:
                        begin
                            cnt                <= cnt+1'b1;
                            debounced_power_on <= 1'b0;
                        end
                    endcase
                end
                2'b11:
                // press the power_off button
                begin
                    cnt <= 0;
                    debounced_power_on <= 1'b0;
                end
                default:
                // none of the button is pressed or both of the button is pressed.
                // At this circumstance, we can NOT  declear whether it is power on or off. 
                 cnt <= 0;
                // press 2 button at the same time
            endcase
            
        end
    endmodule
        module debouncer_clk_div (
            input sys_clk,
            output reg debouncer_divclk
            );
            reg[31:0] cnt = 0;
            always@(posedge sys_clk)//1000HZ
            begin
                if (cnt == 32'd50000)
                begin
                    debouncer_divclk <= ~debouncer_divclk;
                    cnt              <= 0;
                end
                else
                    cnt <= cnt+1'b1;
            end
        endmodule
            
            
            
            
