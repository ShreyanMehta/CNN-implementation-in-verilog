`timescale 1ns/1ps

// ============================================================
// CONV2D TESTBENCH
// ============================================================

module conv2d_tb;

    // --------------------------------------------------------
    // INPUTS
    // --------------------------------------------------------

    reg pixel_00;
    reg pixel_01;
    reg pixel_02;

    reg pixel_10;
    reg pixel_11;
    reg pixel_12;

    reg pixel_20;
    reg pixel_21;
    reg pixel_22;


    // --------------------------------------------------------
    // OUTPUTS
    // --------------------------------------------------------

    wire signed [15:0] conv_out_0;
    wire signed [15:0] conv_out_1;
    wire signed [15:0] conv_out_2;
    wire signed [15:0] conv_out_3;


    // --------------------------------------------------------
    // DUT
    // Device Under Test
    // --------------------------------------------------------

    conv2d dut (

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
    // TASK: APPLY INPUT
    // ========================================================

    task apply_input;

        input p00;
        input p01;
        input p02;

        input p10;
        input p11;
        input p12;

        input p20;
        input p21;
        input p22;

        begin

            pixel_00 = p00;
            pixel_01 = p01;
            pixel_02 = p02;

            pixel_10 = p10;
            pixel_11 = p11;
            pixel_12 = p12;

            pixel_20 = p20;
            pixel_21 = p21;
            pixel_22 = p22;

            #10;

        end

    endtask


    // ========================================================
    // TASK: DISPLAY RESULTS
    // ========================================================

    task display_results;

        input signed [15:0] expected0;
        input signed [15:0] expected1;
        input signed [15:0] expected2;
        input signed [15:0] expected3;

        begin

            $display("--------------------------------------------");

            $display(
                "Actual   : %0d  %0d  %0d  %0d",
                conv_out_0,
                conv_out_1,
                conv_out_2,
                conv_out_3
            );

            $display(
                "Expected : %0d  %0d  %0d  %0d",
                expected0,
                expected1,
                expected2,
                expected3
            );

            if (
                conv_out_0 === expected0 &&
                conv_out_1 === expected1 &&
                conv_out_2 === expected2 &&
                conv_out_3 === expected3
            ) begin

                $display("RESULT   : PASS");

            end
            else begin

                $display("RESULT   : FAIL");

            end

        end

    endtask


    // ========================================================
    // TEST SEQUENCE
    // ========================================================

    initial begin

        $display("");
        $display("============================================");
        $display("       CONV2D VERILOG TESTBENCH");
        $display("============================================");


        // ----------------------------------------------------
        // TEST 1: NO EDGE
        // ----------------------------------------------------

        $display("");
        $display("TEST 1: NO EDGE");

        apply_input(
            0,0,0,
            0,0,0,
            0,0,0
        );

        display_results(
            -2,
             15,
             -6,
             -3
        );


        // ----------------------------------------------------
        // TEST 2: HORIZONTAL CENTER
        // ----------------------------------------------------

        $display("");
        $display("TEST 2: HORIZONTAL CENTER");

        apply_input(
            0,0,0,
            1,1,1,
            0,0,0
        );

        display_results(
            18,
             0,
            24,
            23
        );


        // ----------------------------------------------------
        // TEST 3: VERTICAL CENTER
        // ----------------------------------------------------

        $display("");
        $display("TEST 3: VERTICAL CENTER");

        apply_input(
            0,1,0,
            0,1,0,
            0,1,0
        );

        display_results(
            -1,
            14,
            14,
            39
        );


        // ----------------------------------------------------
        // TEST 4: HORIZONTAL TOP
        // ----------------------------------------------------

        $display("");
        $display("TEST 4: HORIZONTAL TOP");

        apply_input(
            1,1,1,
            0,0,0,
            0,0,0
        );

        display_results(
            14,
            -1,
            20,
            29
        );


        // ----------------------------------------------------
        // TEST 5: HORIZONTAL BOTTOM
        // ----------------------------------------------------

        $display("");
        $display("TEST 5: HORIZONTAL BOTTOM");

        apply_input(
            0,0,0,
            0,0,0,
            1,1,1
        );

        display_results(
            -34,
            0,
            8,
            39
        );


        // ----------------------------------------------------
        // TEST 6: VERTICAL LEFT
        // ----------------------------------------------------

        $display("");
        $display("TEST 6: VERTICAL LEFT");

        apply_input(
            1,0,0,
            1,0,0,
            1,0,0
        );

        display_results(
            4,
            21,
            14,
            46
        );


        // ----------------------------------------------------
        // TEST 7: VERTICAL RIGHT
        // ----------------------------------------------------

        $display("");
        $display("TEST 7: VERTICAL RIGHT");

        apply_input(
            0,0,1,
            0,0,1,
            0,0,1
        );

        display_results(
            -5,
            -36,
            24,
            6
        );


        // ----------------------------------------------------
        // END
        // ----------------------------------------------------

        $display("");
        $display("============================================");
        $display("          TESTBENCH COMPLETE");
        $display("============================================");

        #10;

        $stop;

    end

endmodule