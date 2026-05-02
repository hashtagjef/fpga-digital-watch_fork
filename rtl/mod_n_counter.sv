
// Mod n counter
//
// Parameters:
//  N       - The number we are taking the count mod to (largest value + 1)
//  WIDTH   - The required width to store the largest count
//
// Ports:
//  clk     - Our clock
//  rst     - Reset pin, when high sets the count back to 0
//  enable  - when high, we count
//  count   - the count when counter is on

`timescale 1ns / 1ps

module mod_n_counter #(
    parameter int N = 4,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [WIDTH - 1:0] count
);
  initial count = '0;
  logic [WIDTH - 1:0] next_count;
  localparam logic [WIDTH - 1:0] Max = WIDTH'(N - 1);

  always_comb next_count = (count < Max) ? count + WIDTH'(1) : '0;

  always_ff @(posedge clk)
    if (rst) count <= '0;
    else if (enable) count <= next_count;

endmodule
