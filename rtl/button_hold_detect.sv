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
  localparam int CountMax = HOLD_CYCLES - 2;
  localparam int CountWidth = $clog2(CountMax + 1);
  initial held = 0;

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

  always_ff @(posedge clk) begin
    if (!button) begin
      held <= 0;
      count_rst <= 1;
      count_enable <= 0;
    end else if (button && count == '0) begin
      count_rst <= 0;
      count_enable <= 1;
    end else if (count == CountWidth'(CountMax) && !held) begin
      held <= 1;
    end
  end

endmodule
