`timescale 1ns / 1ps

// Change this macro to set adder width
`define ADDER_WIDTH {{BIT_WIDTH}}

module ripple_carry_adder (
    input  [`ADDER_WIDTH-1:0] a,
    input  [`ADDER_WIDTH-1:0] b,
    output [`ADDER_WIDTH-1:0] sum
);

    wire [`ADDER_WIDTH:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < `ADDER_WIDTH; i = i + 1) begin : RCA_STAGE
            assign sum[i]     = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) |
                                (a[i] & carry[i]) |
                                (b[i] & carry[i]);
        end
    endgenerate

    // carry[`ADDER_WIDTH] is discarded

endmodule

module behavioral_adder (
    input  [`ADDER_WIDTH-1:0] a,
    input  [`ADDER_WIDTH-1:0] b,
    output [`ADDER_WIDTH-1:0] sum
);

    assign sum = a + b;
endmodule
