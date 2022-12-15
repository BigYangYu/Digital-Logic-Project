module global_state (input sys_clk,
                     input rst_n,
                     input throttle,            //油门
                     input clutch,              //离合
                     input brake,
                     input reverse,             //倒车
                     input rx,
                     output tx,
                     input turn_left_signal,
                     input turn_right_signal,
                     inout move_forward_signal,
                     output reg power_on_led,
                     output reg [2:0] mode_led,
                     output left_led,
                     output right_led,
                     input power_on,
                     input power_off,
                     input [1:0] mode_signal,
                     output [7:0] seg_enable,
                     output[7:0] seg_led1,
                     output [7:0] seg_led2);
    // reg or wire?
    reg debounced_power_on;
    reg [3:0] answer; //依次输出左转，右转，后退，前进信号
    reg [3:0] state;
    reg power_now;
    reg [26:0] record;
    reg back_detector;
    reg left_detector;
    reg front_detector;
    reg right_detector;
    debouncer d0(power_on,sys_clk,debounced_power_on);
    always @(*) begin
        casex ({debounced_power_on,power_off})
            2'b10:
            begin
                power_on_led = 1;
                casex (mode_signal)
                    2'b00:
                    begin
                        mode_led[0] = 0;
                        mode_led[1] = 0;
                        mode_led[2] = 0;
                    end
                    2'b01:
                    // the manual mode is on.
                    begin
                        mode_led[0] = 1;
                        mode_led[1] = 0;
                        mode_led[2] = 0;
                        ManualDrivingMode manual_top(sys_clk,rst_n,debounced_power_on,throttle,clutch,brake,reverse,turn_left_signal,turn_right_signal,answer,state,power_now);
                        turn_right_signal turn(rst_n,sys_clk,power_now,state,answer,left_led,right_led);
                        record_manual record(sys_clk,rst_n,power_now,state,record);
                        flash_led_top cnt(sys_clk,rst_n,power_now,1'b1,record,seg_enable,seg_led1,seg_led2);
                        // the module_choose should be deleted.
                        SimulatedDevice sim(sys_clk,rx,tx,rst_n,answer[3],answer[2],answer[0],answer[1],front_detector,back_detector,left_detector,right_detector)    // NOT revised the bug in simulation.
                    end
                    2'b10:
                    begin
                        mode_led[0] = 0;
                        mode_led[1] = 1;
                        mode_led[2] = 0;
                    end
                    2'b11:
                    begin
                        mode_led[0] = 0;
                        mode_led[1] = 0;
                        mode_led[2] = 1;
                    end
                endcase
            end
            // 10 is the state when power on.
            default: power_on_led = 0;
        endcase
    end
endmodule
    
    // Implementation of press and hold on power on button for at least 1 seconds,
    // the car will enable its engine.
    // 1/100 s
    module debouncer (
        input power_on,
        input sys_clk,
        output  debounced_power_on);
        // get the 100Hz clock first.
        wire debouncer_divclk;
        debouncer_clk_div div(sys_clk,debouncer_divclk);
        // get delay signals.
        reg Q1,
        reg Q2,
        reg debounced_power_on = 0;
        reg[9:0] cnt           = 0;
        always @(posedge debouncer_divclk) begin
            Q1 <= power_on;
            Q2 <= Q1;
            case (cnt)
                d'1000: debounced_power_on <= 1'b1;
                default:
                begin
                    casex ({Q1,Q2})
                        2'b00: cnt <= 0;
                        2'b11: cnt <= cnt+1'b1;
                    endcase
                end
            endcase
        end
    endmodule
        module debouncer_clk_div (
            input sys_clk,
            output debouncer_divclk
            );
            reg[31:0] cnt        = 0;
            reg debouncer_divclk = 0;
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
            
            
            
            
