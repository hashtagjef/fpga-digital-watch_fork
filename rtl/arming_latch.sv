// Arming latch.
//
// Stores an armed state that can be set with arm and cleared with disarm.
// When arm and disarm are asserted together, disarm has priority.
//
// Ports:
//  clk    - Clock.
//  arm    - Sets armed high on the next rising clock edge.
//  disarm - Clears armed low on the next rising clock edge.
//  armed  - Latched armed state.
`timescale 1ns / 1ps
module arming_latch (
    input  logic clk,
    input  logic arm,
    input  logic disarm,
    output logic armed
);
  initial armed = 1'b0;
  always_ff @(posedge clk) begin
    if (disarm) armed <= 1'b0;
    else if (arm) armed <= 1'b1;
  end
endmodule
