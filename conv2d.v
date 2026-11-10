

`timescale 1ns/1ps

module conv2d (
    input wire pixel_00,
    input wire pixel_01,
    input wire pixel_02,
    input wire pixel_10,
    input wire pixel_11,
    input wire pixel_12,
    input wire pixel_20,
    input wire pixel_21,
    input wire pixel_22,

    output reg signed [15:0] conv_out_0,
    output reg signed [15:0] conv_out_1,
    output reg signed [15:0] conv_out_2,
    output reg signed [15:0] conv_out_3
);

`include "weights.vh"


// ============================================================
// ACCUMULATORS
// ============================================================

integer acc0;
integer acc1;
integer acc2;
integer acc3;


// ============================================================
// CONVOLUTION
// ============================================================

always @(*) begin

    // --------------------------------------------------------
    // FILTER 0
    // --------------------------------------------------------

    acc0 = CONV_B_0;

    if (pixel_00) acc0 = acc0 + CONV_W_0_0_0;
    if (pixel_01) acc0 = acc0 + CONV_W_0_0_1;
    if (pixel_02) acc0 = acc0 + CONV_W_0_0_2;

    if (pixel_10) acc0 = acc0 + CONV_W_0_1_0;
    if (pixel_11) acc0 = acc0 + CONV_W_0_1_1;
    if (pixel_12) acc0 = acc0 + CONV_W_0_1_2;

    if (pixel_20) acc0 = acc0 + CONV_W_0_2_0;
    if (pixel_21) acc0 = acc0 + CONV_W_0_2_1;
    if (pixel_22) acc0 = acc0 + CONV_W_0_2_2;


    // --------------------------------------------------------
    // FILTER 1
    // --------------------------------------------------------

    acc1 = CONV_B_1;

    if (pixel_00) acc1 = acc1 + CONV_W_1_0_0;
    if (pixel_01) acc1 = acc1 + CONV_W_1_0_1;
    if (pixel_02) acc1 = acc1 + CONV_W_1_0_2;

    if (pixel_10) acc1 = acc1 + CONV_W_1_1_0;
    if (pixel_11) acc1 = acc1 + CONV_W_1_1_1;
    if (pixel_12) acc1 = acc1 + CONV_W_1_1_2;

    if (pixel_20) acc1 = acc1 + CONV_W_1_2_0;
    if (pixel_21) acc1 = acc1 + CONV_W_1_2_1;
    if (pixel_22) acc1 = acc1 + CONV_W_1_2_2;


    // --------------------------------------------------------
    // FILTER 2
    // --------------------------------------------------------

    acc2 = CONV_B_2;

    if (pixel_00) acc2 = acc2 + CONV_W_2_0_0;
    if (pixel_01) acc2 = acc2 + CONV_W_2_0_1;
    if (pixel_02) acc2 = acc2 + CONV_W_2_0_2;

    if (pixel_10) acc2 = acc2 + CONV_W_2_1_0;
    if (pixel_11) acc2 = acc2 + CONV_W_2_1_1;
    if (pixel_12) acc2 = acc2 + CONV_W_2_1_2;

    if (pixel_20) acc2 = acc2 + CONV_W_2_2_0;
    if (pixel_21) acc2 = acc2 + CONV_W_2_2_1;
    if (pixel_22) acc2 = acc2 + CONV_W_2_2_2;


    // --------------------------------------------------------
    // FILTER 3
    // --------------------------------------------------------

    acc3 = CONV_B_3;

    if (pixel_00) acc3 = acc3 + CONV_W_3_0_0;
    if (pixel_01) acc3 = acc3 + CONV_W_3_0_1;
    if (pixel_02) acc3 = acc3 + CONV_W_3_0_2;

    if (pixel_10) acc3 = acc3 + CONV_W_3_1_0;
    if (pixel_11) acc3 = acc3 + CONV_W_3_1_1;
    if (pixel_12) acc3 = acc3 + CONV_W_3_1_2;

    if (pixel_20) acc3 = acc3 + CONV_W_3_2_0;
    if (pixel_21) acc3 = acc3 + CONV_W_3_2_1;
    if (pixel_22) acc3 = acc3 + CONV_W_3_2_2;


    // --------------------------------------------------------
    // OUTPUTS
    // --------------------------------------------------------

    conv_out_0 = acc0;
    conv_out_1 = acc1;
    conv_out_2 = acc2;
    conv_out_3 = acc3;

end


endmodule