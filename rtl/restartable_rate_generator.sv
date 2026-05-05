// Restartable rate generator
// Parameters:
//  CYCLE_COUNT - The number of cycles our clock should go through after run is enabled
//                before we make a tick
// Ports:
//  clk - Our clock
//  run - Our rate generator only ticks when run is high
//  tick - High when our clock has run CYCLE_COUNT-1 times after run was held down
//         or CYCLE_COUNT times after tick was last high



`timescale 1ns / 1ps
module restartable_rate_generator #(
    parameter int CYCLE_COUNT = 2
) (
    input  logic clk,
    input  logic run,
    output logic tick
);

  logic tick_qualifier;
  logic running = 1'b0;
  always_ff @(posedge clk) running <= run;
  assign tick = running && tick_qualifier;
  generate
    if (CYCLE_COUNT > 1) begin : g_general
      localparam int CountWidth = $clog2(CYCLE_COUNT);
      logic rst_count;
      logic enable_count;
      logic [CountWidth - 1:0] count;
      mod_n_counter #(
          .N(CYCLE_COUNT),
          .WIDTH(CountWidth)
      ) u_count (
          .clk(clk),
          .rst(rst_count),
          .enable(enable_count),
          .count(count)
      );

      assign rst_count = !run;
      assign enable_count = run;
      assign tick_qualifier = (count == CountWidth'(CYCLE_COUNT - 1));

    end else begin : g_special
      assign tick_qualifier = 1'b1;

    end
  endgenerate

endmodule
