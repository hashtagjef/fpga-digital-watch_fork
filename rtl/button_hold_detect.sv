// Button hold detector.
//
// Detects when a button has been held high for HOLD_CYCLES clock cycles and
// keeps held asserted until the button is released.
//
// Parameters:
//  HOLD_CYCLES - Number of clock cycles the button must stay high before held
//                is asserted.
//
// Ports:
//  clk    - Clock.
//  button - Button/input signal to monitor.
//  held   - High after button has been held for HOLD_CYCLES cycles.

`timescale 1ns / 1ps
module button_hold_detect #(
    parameter int HOLD_CYCLES = 50_000_000
) (
    input  logic clk,
    input  logic button,
    output logic held
);
  localparam int CountMax = HOLD_CYCLES;
  localparam int CountWidth = $clog2(CountMax + 1);

  logic count_rst;
  logic count_enable;
  logic [CountWidth - 1:0] count;
  mod_n_counter #(
      .N(CountMax + 1),
      .WIDTH(CountWidth)
  ) u_counter (
      .clk(clk),
      .rst(count_rst),
      .enable(count_enable),
      .count(count)
  );

  assign count_rst = !button;
  assign count_enable = button && !held;
  assign held = (count == CountWidth'(CountMax));

endmodule
