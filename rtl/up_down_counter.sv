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
  logic next_count = 0;

  always_ff @(posedge clk) if (enable) count <= next_count;

  always_comb begin
    if (count < Max) assign next_count = count + WIDTH'(1);
    else assign next_count = '0;
  end

endmodule;
