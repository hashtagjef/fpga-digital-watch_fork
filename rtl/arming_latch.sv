module arming_latch(input clk, arm, disarm, output reg armed);
    initial armed = 1'b0;
    always_ff @(posedge clk) begin
        if(disarm) armed <= 1'b0;
        else if (arm) armed <= 1'b1;
    end
endmodule
