// Top-level time display for the digital watch.
//
// Generates selectable tick enables from CLOCK_50, drives an hours/minutes/
// seconds counter, converts each value to BCD, and displays HH:MM:SS on six
// seven-segment outputs.
//
// Parameters:
//  CYCLES_PER_SECOND - Number of CLOCK_50 cycles per second.
//
// Ports:
//  CLOCK_50  - Board/system clock.
//  SW   [1:0] - Speed select:
//               00 = 1 Hz, 01 = 25 Hz, 10 = 1 kHz, 11 = every clock cycle.
//  HEX5 [6:0] - Hours tens seven-segment output.
//  HEX4 [6:0] - Hours ones seven-segment output.
//  HEX3 [6:0] - Minutes tens seven-segment output.
//  HEX2 [6:0] - Minutes ones seven-segment output.
//  HEX1 [6:0] - Seconds tens seven-segment output.
//  HEX0 [6:0] - Seconds ones seven-segment output.

`timescale 1ns / 1ps
module top_time_display_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic CLOCK_50,
    input logic [1:0] SW,
    output logic [6:0] HEX5,
    output logic [6:0] HEX4,
    output logic [6:0] HEX3,
    output logic [6:0] HEX2,
    output logic [6:0] HEX1,
    output logic [6:0] HEX0
);
  logic tick_1HZ, tick_25HZ, tick_1KHZ, tick;
  logic [5:0] seconds, minutes;
  logic [4:0] hours;
  logic [3:0] hours_tens, minutes_tens, seconds_tens;
  logic [3:0] hours_ones, minutes_ones, seconds_ones;

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND)
  ) u_tick1HZ (
      .clk (CLOCK_50),
      .run (SW == 2'b00),
      .tick(tick_1HZ)
  );
  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 25)
  ) u_tick25HZ (
      .clk (CLOCK_50),
      .run (SW == 2'b01),
      .tick(tick_25HZ)
  );
  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 1000)
  ) u_tick1KHZ (
      .clk (CLOCK_50),
      .run (SW == 2'b10),
      .tick(tick_1KHZ)
  );

  always_comb begin
    unique case (SW)
      2'b00: tick = tick_1HZ;
      2'b01: tick = tick_25HZ;
      2'b10: tick = tick_1KHZ;
      2'b11: tick = 1'b1;
    endcase
  end

  hms_counter u_hms (
      .clk(CLOCK_50),
      .enable(tick),
      .hours(hours),
      .minutes(minutes),
      .seconds(seconds)
  );

  binary_to_bcd u_bcd_hours (
      .bin ({2'b0, hours}),
      .tens(hours_tens),
      .ones(hours_ones)
  );
  binary_to_bcd u_bcd_minutes (
      .bin ({1'b0, minutes}),
      .tens(minutes_tens),
      .ones(minutes_ones)
  );
  binary_to_bcd u_bcd_seconds (
      .bin ({1'b0, seconds}),
      .tens(seconds_tens),
      .ones(seconds_ones)
  );

  seven_segment u_ss_hours_tens (
      .digit(hours_tens),
      .blank(1'b0),
      .segments(HEX5)
  );
  seven_segment u_ss_hours_ones (
      .digit(hours_ones),
      .blank(1'b0),
      .segments(HEX4)
  );

  seven_segment u_ss_minutes_tens (
      .digit(minutes_tens),
      .blank(1'b0),
      .segments(HEX3)
  );
  seven_segment u_ss_minutes_ones (
      .digit(minutes_ones),
      .blank(1'b0),
      .segments(HEX2)
  );

  seven_segment u_ss_seconds_tens (
      .digit(seconds_tens),
      .blank(1'b0),
      .segments(HEX1)
  );
  seven_segment u_ss_seconds_ones (
      .digit(seconds_ones),
      .blank(1'b0),
      .segments(HEX0)
  );

endmodule
