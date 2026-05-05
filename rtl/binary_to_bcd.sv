// Binary to BCD converter.
//
// Converts a binary value from 0 to 99 into separate decimal tens and ones
// digits.
//
// Ports:
//  bin  [6:0] - Binary input value, expected range 0 to 99.
//  tens [3:0] - Decimal tens digit.
//  ones [3:0] - Decimal ones digit.

`timescale 1ns / 1ps

module binary_to_bcd (
    input  [6:0] bin,   // binary input 0-99
    output [3:0] tens,  // decimal tens digit (BCD)
    output [3:0] ones   // decimal ones digit (BCD)
);
  assign tens = 4'(bin / 7'd10);
  assign ones = 4'(bin % 7'd10);
endmodule
