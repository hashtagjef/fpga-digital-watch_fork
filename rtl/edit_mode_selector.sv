// Edit mode selector.
//
// Enters edit mode after a long button press, then cycles through seconds,
// minutes, and hours edit enables on short button presses. A short press from
// the final edit mode exits edit mode.
//
// Parameters:
//  HOLD_CYCLES - Number of clock cycles required to detect a long press.
//
// Ports:
//  clk         - Clock.
//  button      - Button/input signal used for long and short presses.
//  mode_enable - One-hot edit enable: 001 seconds, 010 minutes, 100 hours,
//                or 000 when edit mode is inactive.

`timescale 1ns / 1ps

module edit_mode_selector #(
    parameter int HOLD_CYCLES = 50_000_000
) (
    input logic clk,
    input logic button,
    output logic [2:0] mode_enable
);
  logic long_press;
  button_hold_pulse #(
      .HOLD_CYCLES(HOLD_CYCLES)
  ) u_hold_pulse (
      .clk(clk),
      .button(button),
      .pulse(long_press)
  );
  logic press;
  rising_edge_detector u_detector (
      .clk(clk),
      .sig_in(button),
      .rise(press)
  );
  logic armed;
  logic disarm;
  arming_latch u_latch (
      .clk(clk),
      .arm(long_press),
      .disarm(disarm),
      .armed(armed)
  );

  logic reset_counter;
  logic enable_counter;
  logic [1:0] count;
  mod_n_counter #(
      .N(3),
      .WIDTH(2)
  ) u_mod_3_counter (
      .clk(clk),
      .rst(reset_counter),
      .enable(enable_counter),
      .count(count)
  );

  assign enable_counter = armed & press;
  assign reset_counter = !armed;

  assign disarm = (enable_counter & (count == 2'd2));

  assign mode_enable = armed ? (3'b001 << count) : 3'b000;

endmodule
