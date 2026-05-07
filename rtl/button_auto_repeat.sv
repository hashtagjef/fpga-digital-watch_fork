// Button auto-repeat pulse generator.
//
// Produces an initial pulse when the button is pressed, then produces repeated
// pulses while the button remains held.
//
// Parameters:
//  HOLD_CYCLES   - Number of clock cycles before repeat pulses begin.
//  REPEAT_CYCLES - Number of clock cycles between repeat pulses.
//
// Ports:
//  clk    - Clock.
//  button - Button/input signal to monitor.
//  pulse  - High for an initial press pulse and each auto-repeat pulse.

`timescale 1ns / 1ps

module button_auto_repeat #(
    parameter int HOLD_CYCLES   = 50_000_000,
    // REPEAT_CYCLES must be smaller than HOLD_CYCLES
    parameter int REPEAT_CYCLES = 5_000_000
) (
    input  logic clk,
    input  logic button,
    output logic pulse
);
  logic rise;
  logic held;
  logic pulse_train;

  assign pulse = (rise | button & pulse_train);

  rising_edge_detector u_Red (
      .clk(clk),
      .sig_in(button),
      .rise(rise)
  );
  button_hold_detect #(
      .HOLD_CYCLES(HOLD_CYCLES - REPEAT_CYCLES + 1)
  ) u_HoldDetect (
      .clk(clk),
      .button(button),
      .held(held)
  );
  restartable_rate_generator #(
      .CYCLE_COUNT(REPEAT_CYCLES)
  ) u_RateGen (
      .clk (clk),
      .run (held),
      .tick(pulse_train)
  );



endmodule
