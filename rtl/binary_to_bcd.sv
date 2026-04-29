module binary_to_bcd(input [6:0] bin, output [3:0] tens, output [3:0] ones);
    assign tens = bin / 10;
    assign ones = bin % 10;
endmodule
