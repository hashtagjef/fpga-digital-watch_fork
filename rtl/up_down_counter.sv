`timescale 1ns / 1ps

// Up down counter
//
// Parameters:
//   MAX   - The largest value we want the counter to reach
//   WIDTH - The required width we require for our counter to hold MAX
//
// Ports:
//   clk    - Our clock
//   enable - when high, the counter counts
//   up     - when high, the counter counts up, else it counts down
//   count  - The count the counter is on


module up_down_counter #(
    parameter int MAX   = 2,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic enable,
    input logic up,
    output logic [WIDTH - 1:0] count
);

  localparam logic [WIDTH - 1:0] Max = WIDTH'(MAX);
  initial count = '0;
  logic [WIDTH - 1:0] next_count;

  always_ff @(posedge clk) if (enable) count <= next_count;

  always_comb begin
    if (up) next_count = (count < Max) ? count + WIDTH'(1) : '0;
    else next_count = (count > 0) ? count - WIDTH'(1) : Max;
  end
endmodule
