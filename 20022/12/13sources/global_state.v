module global_state (input sys_clk,
                     input rx,
                     output tx,
                     input turn_left_signal,
                     input turn_right_signal,
                     input move_forward_signal,
                     input move_backward_signal,
                     input place_barrier_signal,
                     input destroy_barrier_signal,
                     output front_detector,
                     output back_detector,
                     output left_detector,
                     output right_detector,
                     // above are the input and output in the module SimulatedDevice.
                     // below are NEW input and output created by hfm.
                     // The constraints have been added.
                     // use 2 buttons on the left side of the board to control power on/off.
                     // use the far left 2 switches to choose modes.
                     input power_on,
                     input power_off,
                     input mode_signal1,
                     input mode_signal2);
    // reg or wire?
    reg debounced_power_on;
    debouncer d0(power_on,sys_clk,debounced_power_on);
    always @(*) begin
        casex ({debounced_power_on,power_off})
            2'b10: mode_choose ch0()
            // 10 is the state when power on.
            default:
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
            input sys_clk;
            output debouncer_divclk;
            );
            reg[31:0] cnt        = 0;
            reg debouncer_divclk = 0;
            always@(posedge sys_clk)//1000HZ
            begin
                if (cnt == 26'd50000)
                begin
                    debouncer_divclk <= ~debouncer_divclk;
                    cnt              <= 0;
                end
                else
                    cnt <= cnt+1'b1;
            end
        endmodule
            
            // module to choose mode.
            module mode_choose (
                input mode_signal1,
                input mode_signal2);
                always @(*) begin
                    casex ({mode_signal1,mode_signal2})
                        2'b00:
                        2'b01:
                        2'b1x:
                    endcase
                end
            endmodule
                
                module display (
                    
                    );
                    
                endmodule
                    
                    
