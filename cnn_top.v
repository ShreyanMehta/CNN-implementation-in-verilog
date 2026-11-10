`timescale 1ns/1ps

// Final DE2 top-level.
// Standard Altera DE2 board: CLOCK_50 is 50 MHz.
// SW[8:0] are the 3x3 binary image inputs.
// KEY[0] is active-low reset.
// LCD outputs connect to the onboard 16x2 LCD.

module cnn_top (
    input  wire        CLOCK_50,
    input  wire [8:0]  SW,
    input  wire [0:0]  KEY,

    output wire [7:0]  LCD_DATA,
    output wire        LCD_RW,
    output wire        LCD_EN,
    output wire        LCD_RS,
    output wire        LCD_ON,
    output wire        LCD_BLON
);

    wire [1:0] class_out;

    // CNN
    cnn u_cnn (
        .pixel_00(SW[0]),
        .pixel_01(SW[1]),
        .pixel_02(SW[2]),

        .pixel_10(SW[3]),
        .pixel_11(SW[4]),
        .pixel_12(SW[5]),

        .pixel_20(SW[6]),
        .pixel_21(SW[7]),
        .pixel_22(SW[8]),

        .class_out(class_out)
    );

    // LCD
    assign LCD_ON   = 1'b1;
    assign LCD_BLON = 1'b1;

    lcd_controller #(
        .CLOCK_FREQ_HZ(50000000)
    ) u_lcd (
        .clk(CLOCK_50),
        .reset_n(KEY[0]),
        .class_in(class_out),

        .lcd_data(LCD_DATA),
        .lcd_rs(LCD_RS),
        .lcd_rw(LCD_RW),
        .lcd_en(LCD_EN)
    );

endmodule
