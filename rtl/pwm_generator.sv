// Pulse-width modulation generator.
//
// Produces a periodic output that is high for DUTY_CYCLES clock cycles and low
// for the rest of each PERIOD_CYCLES cycle period.
//
// Parameters:
//  PERIOD_CYCLES - Number of clock cycles in one PWM period.
//  DUTY_CYCLES   - Number of clock cycles that pwm_out is high each period.
//
// Ports:
//  clk     - Clock.
//  rst     - Synchronous reset, clears the PWM counter to the start of a period.
//  pwm_out - PWM output signal.

`timescale 1ns / 1ps
module pwm_generator #(
    parameter int PERIOD_CYCLES = 50_000_000,

    parameter int DUTY_CYCLES = 25_000_000
) (
    input  logic clk,
    input  logic rst,
    output logic pwm_out
);
  localparam int PeriodWidth = $clog2(PERIOD_CYCLES);
  localparam int CompareWidth = $clog2(PERIOD_CYCLES + 1);

  logic [ PeriodWidth - 1 : 0] count;
  logic [CompareWidth - 1 : 0] DutyCompare;
  logic [CompareWidth - 1 : 0] CountCompare;

  assign CountCompare = CompareWidth'(count);
  assign DutyCompare  = CompareWidth'(DUTY_CYCLES);

  mod_n_counter #(
      .N(PERIOD_CYCLES),
      .WIDTH(PeriodWidth)
  ) u_mod_n_counter (
      .clk(clk),
      .rst(rst),
      .enable(1'b1),
      .count(count)
  );

  assign pwm_out = (CountCompare < DutyCompare);


endmodule
