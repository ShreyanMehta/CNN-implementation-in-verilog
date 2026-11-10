`timescale 1ns/1ps

module dense (
    input wire signed [15:0] relu_0,
    input wire signed [15:0] relu_1,
    input wire signed [15:0] relu_2,
    input wire signed [15:0] relu_3,

    output reg signed [15:0] class_0,
    output reg signed [15:0] class_1,
    output reg signed [15:0] class_2
);

`include "weights.vh"

integer acc0;
integer acc1;
integer acc2;

integer prod;

always @(*) begin

    // ========================================================
    // CLASS 0
    // ========================================================

    acc0 = DENSE_B_0;

    prod = relu_0 * DENSE_W_0_0;
    acc0 = acc0 + (prod >>> 4);

    prod = relu_1 * DENSE_W_1_0;
    acc0 = acc0 + (prod >>> 4);

    prod = relu_2 * DENSE_W_2_0;
    acc0 = acc0 + (prod >>> 4);

    prod = relu_3 * DENSE_W_3_0;
    acc0 = acc0 + (prod >>> 4);


    // ========================================================
    // CLASS 1
    // ========================================================

    acc1 = DENSE_B_1;

    prod = relu_0 * DENSE_W_0_1;
    acc1 = acc1 + (prod >>> 4);

    prod = relu_1 * DENSE_W_1_1;
    acc1 = acc1 + (prod >>> 4);

    prod = relu_2 * DENSE_W_2_1;
    acc1 = acc1 + (prod >>> 4);

    prod = relu_3 * DENSE_W_3_1;
    acc1 = acc1 + (prod >>> 4);


    // ========================================================
    // CLASS 2
    // ========================================================

    acc2 = DENSE_B_2;

    prod = relu_0 * DENSE_W_0_2;
    acc2 = acc2 + (prod >>> 4);

    prod = relu_1 * DENSE_W_1_2;
    acc2 = acc2 + (prod >>> 4);

    prod = relu_2 * DENSE_W_2_2;
    acc2 = acc2 + (prod >>> 4);

    prod = relu_3 * DENSE_W_3_2;
    acc2 = acc2 + (prod >>> 4);


    // ========================================================
    // OUTPUTS
    // ========================================================

    class_0 = acc0;
    class_1 = acc1;
    class_2 = acc2;

end

endmodule