`timescale 1ns/1ps

module dense_tb;

    reg signed [15:0] relu_0;
    reg signed [15:0] relu_1;
    reg signed [15:0] relu_2;
    reg signed [15:0] relu_3;

    wire signed [15:0] class_0;
    wire signed [15:0] class_1;
    wire signed [15:0] class_2;

    dense dut (
        .relu_0(relu_0),
        .relu_1(relu_1),
        .relu_2(relu_2),
        .relu_3(relu_3),
        .class_0(class_0),
        .class_1(class_1),
        .class_2(class_2)
    );

    task apply_input;
        input signed [15:0] r0;
        input signed [15:0] r1;
        input signed [15:0] r2;
        input signed [15:0] r3;
        begin
            relu_0 = r0;
            relu_1 = r1;
            relu_2 = r2;
            relu_3 = r3;
            #10;
        end
    endtask

    task display_results;
        input signed [15:0] expected0;
        input signed [15:0] expected1;
        input signed [15:0] expected2;
        begin
            $display("--------------------------------------------");
            $display("Actual   : %0d  %0d  %0d",
                     class_0, class_1, class_2);
            $display("Expected : %0d  %0d  %0d",
                     expected0, expected1, expected2);

            if (class_0 === expected0 &&
                class_1 === expected1 &&
                class_2 === expected2)
                $display("RESULT   : PASS");
            else
                $display("RESULT   : FAIL");
        end
    endtask

    initial begin

        $display("");
        $display("============================================");
        $display("        DENSE VERILOG TESTBENCH");
        $display("============================================");

        // ========================================
        // TEST 1: NO EDGE
        // Conv output = [-2, 15, -6, -3]
        // ReLU       = [ 0, 15,  0,  0]
        // ========================================

        $display("");
        $display("TEST 1: NO EDGE");

        apply_input(0, 15, 0, 0);
        display_results(45, -30, -12);


        // ========================================
        // TEST 2: HORIZONTAL CENTER
        // Conv output = [18, 0, 24, 23]
        // ReLU       = [18, 0, 24, 23]
        // ========================================

        $display("");
        $display("TEST 2: HORIZONTAL CENTER");

        apply_input(18, 0, 24, 23);
        display_results(-82, 30, 8);


        // ========================================
        // TEST 3: VERTICAL CENTER
        // Conv output = [-1, 14, 14, 39]
        // ReLU       = [ 0, 14, 14, 39]
        // ========================================

        $display("");
        $display("TEST 3: VERTICAL CENTER");

        apply_input(0, 14, 14, 39);
        display_results(-56, -2, 13);


        // ========================================
        // TEST 4: HORIZONTAL TOP
        // Conv output = [14, -1, 20, 29]
        // ReLU       = [14,  0, 20, 29]
        // ========================================

        $display("");
        $display("TEST 4: HORIZONTAL TOP");

        apply_input(14, 0, 20, 29);
        display_results(-84, 31, 8);


        // ========================================
        // TEST 5: HORIZONTAL BOTTOM
        // Conv output = [-34, 0, 8, 39]
        // ReLU       = [  0, 0, 8, 39]
        // ========================================

        $display("");
        $display("TEST 5: HORIZONTAL BOTTOM");

        apply_input(0, 0, 8, 39);
        display_results(-72, 24, 6);


        // ========================================
        // TEST 6: VERTICAL LEFT
        // Conv output = [4, 21, 14, 46]
        // ReLU       = [4, 21, 14, 46]
        // ========================================

        $display("");
        $display("TEST 6: VERTICAL LEFT");

        apply_input(4, 21, 14, 46);
        display_results(-57, -3, 16);


        // ========================================
        // TEST 7: VERTICAL RIGHT
        // Conv output = [-5, -36, 24, 6]
        // ReLU       = [0, 0, 24, 6]
        // ========================================

        $display("");
        $display("TEST 7: VERTICAL RIGHT");

        apply_input(0, 0, 24, 6);
        display_results(-43, -8, 7);


        $display("");
        $display("============================================");
        $display("          DENSE TESTBENCH COMPLETE");
        $display("============================================");

        #10;
        $stop;

    end

endmodule