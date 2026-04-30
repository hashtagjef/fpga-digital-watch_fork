`timescale 1ns / 1ps

module binary_to_bcd (
    input  [6:0] bin,   // binary input 0-99
    output [3:0] tens,  // decimal tens digit (BCD)
    output [3:0] ones   // decimal ones digit (BCD)
);
  assign tens = 4'(bin / 7'd10);
  assign ones = 4'(bin % 7'd10);
endmodule
