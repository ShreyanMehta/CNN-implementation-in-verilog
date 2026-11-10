// ====================================================
// weights.v
// Automatically generated from trained CNN
// Fixed-point format: Q4.4
// Weight width: 8-bit signed
// ====================================================

// ====================================================
// CONVOLUTION WEIGHTS
//
// Organization:
// CONV_W_FILTER_ROW_COL
// ====================================================

localparam signed [7:0] CONV_W_0_0_0 = 8'sd5;
localparam signed [7:0] CONV_W_0_0_1 = 8'sd9;
localparam signed [7:0] CONV_W_0_0_2 = 8'sd2;
localparam signed [7:0] CONV_W_0_1_0 = 8'sd10;
localparam signed [7:0] CONV_W_0_1_1 = 8'sd5;
localparam signed [7:0] CONV_W_0_1_2 = 8'sd5;
localparam signed [7:0] CONV_W_0_2_0 = -8'sd9;
localparam signed [7:0] CONV_W_0_2_1 = -8'sd13;
localparam signed [7:0] CONV_W_0_2_2 = -8'sd10;

localparam signed [7:0] CONV_W_1_0_0 = 8'sd2;
localparam signed [7:0] CONV_W_1_0_1 = 8'sd0;
localparam signed [7:0] CONV_W_1_0_2 = -8'sd18;
localparam signed [7:0] CONV_W_1_1_0 = 8'sd3;
localparam signed [7:0] CONV_W_1_1_1 = -8'sd1;
localparam signed [7:0] CONV_W_1_1_2 = -8'sd17;
localparam signed [7:0] CONV_W_1_2_0 = 8'sd1;
localparam signed [7:0] CONV_W_1_2_1 = 8'sd0;
localparam signed [7:0] CONV_W_1_2_2 = -8'sd16;

localparam signed [7:0] CONV_W_2_0_0 = 8'sd6;
localparam signed [7:0] CONV_W_2_0_1 = 8'sd9;
localparam signed [7:0] CONV_W_2_0_2 = 8'sd11;
localparam signed [7:0] CONV_W_2_1_0 = 8'sd9;
localparam signed [7:0] CONV_W_2_1_1 = 8'sd8;
localparam signed [7:0] CONV_W_2_1_2 = 8'sd13;
localparam signed [7:0] CONV_W_2_2_0 = 8'sd5;
localparam signed [7:0] CONV_W_2_2_1 = 8'sd3;
localparam signed [7:0] CONV_W_2_2_2 = 8'sd6;

localparam signed [7:0] CONV_W_3_0_0 = 8'sd16;
localparam signed [7:0] CONV_W_3_0_1 = 8'sd13;
localparam signed [7:0] CONV_W_3_0_2 = 8'sd3;
localparam signed [7:0] CONV_W_3_1_0 = 8'sd13;
localparam signed [7:0] CONV_W_3_1_1 = 8'sd10;
localparam signed [7:0] CONV_W_3_1_2 = 8'sd3;
localparam signed [7:0] CONV_W_3_2_0 = 8'sd20;
localparam signed [7:0] CONV_W_3_2_1 = 8'sd19;
localparam signed [7:0] CONV_W_3_2_2 = 8'sd3;

// ====================================================
// CONVOLUTION BIASES
// ====================================================

localparam signed [7:0] CONV_B_0 = -8'sd2;
localparam signed [7:0] CONV_B_1 = 8'sd15;
localparam signed [7:0] CONV_B_2 = -8'sd6;
localparam signed [7:0] CONV_B_3 = -8'sd3;

// ====================================================
// DENSE WEIGHTS
//
// Organization:
// DENSE_W_FEATURE_CLASS
// ====================================================

localparam signed [7:0] DENSE_W_0_0 = -8'sd7;
localparam signed [7:0] DENSE_W_0_1 = 8'sd22;
localparam signed [7:0] DENSE_W_0_2 = -8'sd4;

localparam signed [7:0] DENSE_W_1_0 = 8'sd32;
localparam signed [7:0] DENSE_W_1_1 = -8'sd27;
localparam signed [7:0] DENSE_W_1_2 = 8'sd3;

localparam signed [7:0] DENSE_W_2_0 = -8'sd31;
localparam signed [7:0] DENSE_W_2_1 = -8'sd5;
localparam signed [7:0] DENSE_W_2_2 = 8'sd13;

localparam signed [7:0] DENSE_W_3_0 = -8'sd29;
localparam signed [7:0] DENSE_W_3_1 = 8'sd13;
localparam signed [7:0] DENSE_W_3_2 = 8'sd6;

// ====================================================
// DENSE BIASES
// ====================================================

localparam signed [7:0] DENSE_B_0 = 8'sd15;
localparam signed [7:0] DENSE_B_1 = -8'sd4;
localparam signed [7:0] DENSE_B_2 = -8'sd14;

// ====================================================
// END OF GENERATED WEIGHTS
// ====================================================
