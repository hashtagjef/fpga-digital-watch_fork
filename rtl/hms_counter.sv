`timescale 1ns / 1ps

module hms_counter #(
    parameter int N_HOURS   = 24,
    parameter int N_MINUTES = 60,
    parameter int N_SECONDS = 60,

    parameter int W_HOURS   = 5,
    parameter int W_MINUTES = 6,
    parameter int W_SECONDS = 6
) (
    input logic clk,
    input logic enable,
    output logic [W_HOURS - 1:0] hours,
    output logic [W_MINUTES - 1:0] minutes,
    output logic [W_SECONDS - 1:0] seconds
);
  logic second_rollover;
  logic minute_rollover;

  localparam logic [W_MINUTES -1:0] MaxMinutes = W_MINUTES'(N_MINUTES - 1);
  localparam logic [W_SECONDS -1:0] MaxSeconds = W_SECONDS'(N_SECONDS - 1);

  up_down_counter #(
      .WIDTH(W_HOURS),
      .MAX  (N_HOURS - 1)
  ) u_hour (
      .clk(clk),
      .enable(enable & minute_rollover),
      .up(1'b1),
      .count(hours)
  );
  up_down_counter #(
      .WIDTH(W_MINUTES),
      .MAX  (N_MINUTES - 1)
  ) u_minutes (
      .clk(clk),
      .enable(enable & second_rollover),
      .up(1'b1),
      .count(minutes)
  );
  up_down_counter #(
      .WIDTH(W_SECONDS),
      .MAX  (N_SECONDS - 1)
  ) u_seconds (
      .clk(clk),
      .enable(enable),
      .up(1'b1),
      .count(seconds)
  );

  always_comb begin
    second_rollover = (seconds == MaxSeconds) ? 1 : 0;
    minute_rollover = (minutes == MaxMinutes && second_rollover) ? 1 : 0;
  end




endmodule
