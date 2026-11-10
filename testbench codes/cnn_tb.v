`timescale 1ns/1ps

module cnn_tb;

    reg pixel_00;
    reg pixel_01;
    reg pixel_02;

    reg pixel_10;
    reg pixel_11;
    reg pixel_12;

    reg pixel_20;
    reg pixel_21;
    reg pixel_22;

    wire [1:0] class_out;

    cnn dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),

        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),

        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),

        .class_out(class_out)
    );


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


    task check_result;
        input [1:0] expected;
        begin

            $display("--------------------------------------------");
            $display("Actual class   : %0d", class_out);
            $display("Expected class : %0d", expected);

            if (class_out === expected)
                $display("RESULT         : PASS");
            else
                $display("RESULT         : FAIL");

        end
    endtask


    initial begin

        $display("");
        $display("============================================");
        $display("       COMPLETE CNN VERILOG TESTBENCH");
        $display("============================================");


        // ====================================================
        // TEST 1: NO EDGE
        //
        // 000
        // 000
        // 000
        //
        // Expected = 0
        // ====================================================

        $display("");
        $display("TEST 1: NO EDGE");

        apply_input(
            0,0,0,
            0,0,0,
            0,0,0
        );

        check_result(2'd0);


        // ====================================================
        // TEST 2: HORIZONTAL CENTER
        //
        // 000
        // 111
        // 000
        //
        // Expected = 1
        // ====================================================

        $display("");
        $display("TEST 2: HORIZONTAL CENTER");

        apply_input(
            0,0,0,
            1,1,1,
            0,0,0
        );

        check_result(2'd1);


        // ====================================================
        // TEST 3: VERTICAL CENTER
        //
        // 010
        // 010
        // 010
        //
        // Expected = 2
        // ====================================================

        $display("");
        $display("TEST 3: VERTICAL CENTER");

        apply_input(
            0,1,0,
            0,1,0,
            0,1,0
        );

        check_result(2'd2);


        // ====================================================
        // TEST 4: HORIZONTAL TOP
        //
        // 111
        // 000
        // 000
        //
        // Expected = 1
        // ====================================================

        $display("");
        $display("TEST 4: HORIZONTAL TOP");

        apply_input(
            1,1,1,
            0,0,0,
            0,0,0
        );

        check_result(2'd1);


        // ====================================================
        // TEST 5: HORIZONTAL BOTTOM
        //
        // 000
        // 000
        // 111
        //
        // Expected = 1
        // ====================================================

        $display("");
        $display("TEST 5: HORIZONTAL BOTTOM");

        apply_input(
            0,0,0,
            0,0,0,
            1,1,1
        );

        check_result(2'd1);


        // ====================================================
        // TEST 6: VERTICAL LEFT
        //
        // 100
        // 100
        // 100
        //
        // Expected = 2
        // ====================================================

        $display("");
        $display("TEST 6: VERTICAL LEFT");

        apply_input(
            1,0,0,
            1,0,0,
            1,0,0
        );

        check_result(2'd2);


        // ====================================================
        // TEST 7: VERTICAL RIGHT
        //
        // 001
        // 001
        // 001
        //
        // Expected = 2
        // ====================================================

        $display("");
        $display("TEST 7: VERTICAL RIGHT");

        apply_input(
            0,0,1,
            0,0,1,
            0,0,1
        );

        check_result(2'd2);


        $display("");
        $display("============================================");
        $display("       COMPLETE CNN TESTBENCH DONE");
        $display("============================================");

        #10;
        $stop;

    end

endmodule