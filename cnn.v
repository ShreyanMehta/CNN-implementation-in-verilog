`timescale 1ns/1ps

module cnn (
    input wire pixel_00,
    input wire pixel_01,
    input wire pixel_02,

    input wire pixel_10,
    input wire pixel_11,
    input wire pixel_12,

    input wire pixel_20,
    input wire pixel_21,
    input wire pixel_22,

    output reg [1:0] class_out
);

    // ========================================================
    // CONVOLUTION OUTPUTS
    // ========================================================

    wire signed [15:0] conv_out_0;
    wire signed [15:0] conv_out_1;
    wire signed [15:0] conv_out_2;
    wire signed [15:0] conv_out_3;


    // ========================================================
    // RELU OUTPUTS
    // ========================================================

    wire signed [15:0] relu_0;
    wire signed [15:0] relu_1;
    wire signed [15:0] relu_2;
    wire signed [15:0] relu_3;


    // ========================================================
    // DENSE OUTPUTS
    // ========================================================

    wire signed [15:0] class_score_0;
    wire signed [15:0] class_score_1;
    wire signed [15:0] class_score_2;


    // ========================================================
    // CONV2D
    // ========================================================

    conv2d u_conv2d (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),

        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),

        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),

        .conv_out_0(conv_out_0),
        .conv_out_1(conv_out_1),
        .conv_out_2(conv_out_2),
        .conv_out_3(conv_out_3)
    );


    // ========================================================
    // RELU
    // Negative values become zero.
    // ========================================================

    assign relu_0 = (conv_out_0 > 0) ? conv_out_0 : 16'sd0;
    assign relu_1 = (conv_out_1 > 0) ? conv_out_1 : 16'sd0;
    assign relu_2 = (conv_out_2 > 0) ? conv_out_2 : 16'sd0;
    assign relu_3 = (conv_out_3 > 0) ? conv_out_3 : 16'sd0;


    // ========================================================
    // DENSE LAYER
    // ========================================================

    dense u_dense (
        .relu_0(relu_0),
        .relu_1(relu_1),
        .relu_2(relu_2),
        .relu_3(relu_3),

        .class_0(class_score_0),
        .class_1(class_score_1),
        .class_2(class_score_2)
    );


    // ========================================================
    // ARGMAX
    //
    // 0 = NO EDGE
    // 1 = HORIZONTAL
    // 2 = VERTICAL
    // ========================================================

    always @(*) begin

        if ((class_score_0 >= class_score_1) &&
            (class_score_0 >= class_score_2)) begin

            class_out = 2'd0;

        end
        else if (class_score_1 >= class_score_2) begin

            class_out = 2'd1;

        end
        else begin

            class_out = 2'd2;

        end

    end

endmodule