`timescale 1ns/1ps

module cnn_lcd_tb;

    reg CLOCK_50;
    reg [8:0] SW;
    reg [0:0] KEY;

    wire [7:0] LCD_DATA;
    wire LCD_RW;
    wire LCD_EN;
    wire LCD_RS;
    wire LCD_ON;
    wire LCD_BLON;

    cnn_top dut (
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        .KEY(KEY),
        .LCD_DATA(LCD_DATA),
        .LCD_RW(LCD_RW),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON)
    );

    // 50 MHz clock
    initial CLOCK_50 = 1'b0;
    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin

        // Start in reset
        SW = 9'b000000000;
        KEY = 1'b0;

        #100;
        KEY = 1'b1;

        // Wait for LCD initialization
        #25000000;

        // NO EDGE
        SW = 9'b000000000;
        #5000000;

        // HORIZONTAL CENTER
        SW = 9'b000111000;
        #5000000;

        // VERTICAL CENTER
        SW = 9'b010010010;
        #5000000;

        $display("CNN + LCD simulation complete.");
        $stop;
    end

endmodule