// Rising edge detector.
//
// Detects a low-to-high transition on sig_in and asserts rise while sig_in is
// high and the previous sampled value was low.
//
// Ports:
//  clk    - Clock.
//  sig_in - Input signal to monitor.
//  rise   - High when a rising edge is detected on sig_in.

`timescale 1ns / 1ps
module rising_edge_detector (
    input  logic clk,
    input  logic sig_in,
    output logic rise
);
  logic SigHeld = 0;
  always_comb rise = (sig_in & !SigHeld);
  always_ff @(posedge clk) begin
    if (sig_in && !SigHeld) SigHeld <= 1;
    else if (!sig_in && SigHeld) SigHeld <= 0;
  end

endmodule
