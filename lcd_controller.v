`timescale 1ns/1ps

// DE2 16x2 LCD controller, 8-bit mode.
// CLOCK_50 = 50 MHz.
// LCD is write-only here: LCD_RW is always 0.
//
// class_in:
//   0 = NO EDGE
//   1 = HORIZONTAL
//   2 = VERTICAL
//
// Display:
//   line 1: CNN EDGE DETECTOR
//   line 2: EDGE: NO EDGE / EDGE: HORIZONTAL / EDGE: VERTICAL

module lcd_controller #(
    parameter integer CLOCK_FREQ_HZ = 50000000
)(
    input  wire       clk,
    input  wire       reset_n,
    input  wire [1:0] class_in,

    output reg [7:0] lcd_data,
    output reg       lcd_rs,
    output reg       lcd_rw,
    output reg       lcd_en
);

    // Approximate delays at 50 MHz.
    localparam integer RESET_DELAY_CYCLES = 1000000; // 20 ms
    localparam integer CMD_DELAY_CYCLES   = 2500;    // 50 us
    localparam integer CLEAR_DELAY_CYCLES = 100000;  // 2 ms
    localparam integer EN_PULSE_CYCLES    = 3;       // 60 ns

    localparam [4:0]
        ST_RESET_WAIT = 5'd0,
        ST_INIT_SEND  = 5'd1,
        ST_INIT_PULSE = 5'd2,
        ST_INIT_WAIT  = 5'd3,
        ST_ADDR1_SEND = 5'd4,
        ST_ADDR1_PULSE= 5'd5,
        ST_ADDR1_WAIT = 5'd6,
        ST_LINE1_SEND = 5'd7,
        ST_LINE1_PULSE= 5'd8,
        ST_LINE1_WAIT = 5'd9,
        ST_ADDR2_SEND = 5'd10,
        ST_ADDR2_PULSE= 5'd11,
        ST_ADDR2_WAIT = 5'd12,
        ST_LINE2_SEND = 5'd13,
        ST_LINE2_PULSE= 5'd14,
        ST_LINE2_WAIT = 5'd15,
        ST_IDLE       = 5'd16;

    reg [4:0] state;
    reg [31:0] delay_count;
    reg [4:0] init_index;
    reg [4:0] char_index;
    reg [1:0] displayed_class;

    wire class_changed;
    assign class_changed = (class_in != displayed_class);

    function [7:0] init_command;
        input [4:0] index;
        begin
            case (index)
                5'd0: init_command = 8'h38; // 8-bit, 2 lines, 5x8 font
                5'd1: init_command = 8'h0C; // display ON, cursor OFF
                5'd2: init_command = 8'h01; // clear
                5'd3: init_command = 8'h06; // increment cursor
                default: init_command = 8'h00;
            endcase
        end
    endfunction

    function [7:0] line1_char;
        input [4:0] index;
        begin
            case (index)
                5'd0:  line1_char = "C";
                5'd1:  line1_char = "N";
                5'd2:  line1_char = "N";
                5'd3:  line1_char = " ";
                5'd4:  line1_char = "E";
                5'd5:  line1_char = "D";
                5'd6:  line1_char = "G";
                5'd7:  line1_char = "E";
                5'd8:  line1_char = " ";
                5'd9:  line1_char = "D";
                5'd10: line1_char = "E";
                5'd11: line1_char = "T";
                5'd12: line1_char = "E";
                5'd13: line1_char = "C";
                5'd14: line1_char = "T";
                5'd15: line1_char = "O";
                5'd16: line1_char = "R";
                default: line1_char = " ";
            endcase
        end
    endfunction

    function [7:0] line2_char;
        input [1:0] class_value;
        input [4:0] index;
        begin
            case (class_value)
                2'd0: begin
                    case (index)
                        5'd0: line2_char = "E";
                        5'd1: line2_char = "D";
                        5'd2: line2_char = "G";
                        5'd3: line2_char = "E";
                        5'd4: line2_char = ":";
                        5'd5: line2_char = " ";
                        5'd6: line2_char = "N";
                        5'd7: line2_char = "O";
                        5'd8: line2_char = " ";
                        5'd9: line2_char = "E";
                        5'd10: line2_char = "D";
                        5'd11: line2_char = "G";
                        5'd12: line2_char = "E";
                        default: line2_char = " ";
                    endcase
                end

                2'd1: begin
                    case (index)
                        5'd0: line2_char = "E";
                        5'd1: line2_char = "D";
                        5'd2: line2_char = "G";
                        5'd3: line2_char = "E";
                        5'd4: line2_char = ":";
                        5'd5: line2_char = " ";
                        5'd6: line2_char = "H";
                        5'd7: line2_char = "O";
                        5'd8: line2_char = "R";
                        5'd9: line2_char = "I";
                        5'd10: line2_char = "Z";
                        5'd11: line2_char = "O";
                        5'd12: line2_char = "N";
                        5'd13: line2_char = "T";
                        5'd14: line2_char = "A";
                        5'd15: line2_char = "L";
                        default: line2_char = " ";
                    endcase
                end

                default: begin
                    case (index)
                        5'd0: line2_char = "E";
                        5'd1: line2_char = "D";
                        5'd2: line2_char = "G";
                        5'd3: line2_char = "E";
                        5'd4: line2_char = ":";
                        5'd5: line2_char = " ";
                        5'd6: line2_char = "V";
                        5'd7: line2_char = "E";
                        5'd8: line2_char = "R";
                        5'd9: line2_char = "T";
                        5'd10: line2_char = "I";
                        5'd11: line2_char = "C";
                        5'd12: line2_char = "A";
                        5'd13: line2_char = "L";
                        default: line2_char = " ";
                    endcase
                end
            endcase
        end
    endfunction

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state          <= ST_RESET_WAIT;
            delay_count    <= 32'd0;
            init_index     <= 5'd0;
            char_index     <= 5'd0;
            displayed_class<= 2'd3;
            lcd_data       <= 8'h00;
            lcd_rs         <= 1'b0;
            lcd_rw         <= 1'b0;
            lcd_en         <= 1'b0;
        end
        else begin
            // LCD_RW is always write.
            lcd_rw <= 1'b0;

            case (state)

                ST_RESET_WAIT: begin
                    lcd_en <= 1'b0;
                    if (delay_count < RESET_DELAY_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        delay_count <= 32'd0;
                        init_index  <= 5'd0;
                        state       <= ST_INIT_SEND;
                    end
                end

                ST_INIT_SEND: begin
                    lcd_rs   <= 1'b0;
                    lcd_data <= init_command(init_index);
                    lcd_en   <= 1'b1;
                    delay_count <= 32'd0;
                    state <= ST_INIT_PULSE;
                end

                ST_INIT_PULSE: begin
                    if (delay_count < EN_PULSE_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        lcd_en <= 1'b0;
                        delay_count <= 32'd0;
                        state <= ST_INIT_WAIT;
                    end
                end

                ST_INIT_WAIT: begin
                    if (delay_count <
                        ((init_index == 5'd2) ? CLEAR_DELAY_CYCLES : CMD_DELAY_CYCLES)-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        delay_count <= 32'd0;
                        if (init_index < 5'd3) begin
                            init_index <= init_index + 1'b1;
                            state <= ST_INIT_SEND;
                        end
                        else begin
                            state <= ST_ADDR1_SEND;
                        end
                    end
                end

                ST_ADDR1_SEND: begin
                    lcd_rs   <= 1'b0;
                    lcd_data <= 8'h80; // DDRAM address 0
                    lcd_en   <= 1'b1;
                    delay_count <= 32'd0;
                    state <= ST_ADDR1_PULSE;
                end

                ST_ADDR1_PULSE: begin
                    if (delay_count < EN_PULSE_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        lcd_en <= 1'b0;
                        delay_count <= 32'd0;
                        state <= ST_ADDR1_WAIT;
                    end
                end

                ST_ADDR1_WAIT: begin
                    if (delay_count < CMD_DELAY_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        delay_count <= 32'd0;
                        char_index <= 5'd0;
                        state <= ST_LINE1_SEND;
                    end
                end

                ST_LINE1_SEND: begin
                    lcd_rs   <= 1'b1;
                    lcd_data <= line1_char(char_index);
                    lcd_en   <= 1'b1;
                    delay_count <= 32'd0;
                    state <= ST_LINE1_PULSE;
                end

                ST_LINE1_PULSE: begin
                    if (delay_count < EN_PULSE_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        lcd_en <= 1'b0;
                        delay_count <= 32'd0;
                        state <= ST_LINE1_WAIT;
                    end
                end

                ST_LINE1_WAIT: begin
                    if (delay_count < CMD_DELAY_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        delay_count <= 32'd0;
                        if (char_index < 5'd15) begin
                            char_index <= char_index + 1'b1;
                            state <= ST_LINE1_SEND;
                        end
                        else begin
                            state <= ST_ADDR2_SEND;
                        end
                    end
                end

                ST_ADDR2_SEND: begin
                    lcd_rs   <= 1'b0;
                    lcd_data <= 8'hC0; // DDRAM address 40
                    lcd_en   <= 1'b1;
                    delay_count <= 32'd0;
                    state <= ST_ADDR2_PULSE;
                end

                ST_ADDR2_PULSE: begin
                    if (delay_count < EN_PULSE_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        lcd_en <= 1'b0;
                        delay_count <= 32'd0;
                        state <= ST_ADDR2_WAIT;
                    end
                end

                ST_ADDR2_WAIT: begin
                    if (delay_count < CMD_DELAY_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        delay_count <= 32'd0;
                        char_index <= 5'd0;
                        state <= ST_LINE2_SEND;
                    end
                end

                ST_LINE2_SEND: begin
                    lcd_rs   <= 1'b1;
                    lcd_data <= line2_char(class_in, char_index);
                    lcd_en   <= 1'b1;
                    delay_count <= 32'd0;
                    state <= ST_LINE2_PULSE;
                end

                ST_LINE2_PULSE: begin
                    if (delay_count < EN_PULSE_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        lcd_en <= 1'b0;
                        delay_count <= 32'd0;
                        state <= ST_LINE2_WAIT;
                    end
                end

                ST_LINE2_WAIT: begin
                    if (delay_count < CMD_DELAY_CYCLES-1) begin
                        delay_count <= delay_count + 1'b1;
                    end
                    else begin
                        delay_count <= 32'd0;
                        if (char_index < 5'd15) begin
                            char_index <= char_index + 1'b1;
                            state <= ST_LINE2_SEND;
                        end
                        else begin
                            displayed_class <= class_in;
                            state <= ST_IDLE;
                        end
                    end
                end

                ST_IDLE: begin
                    lcd_en <= 1'b0;
                    if (class_changed) begin
                        state <= ST_ADDR1_SEND;
                    end
                end

                default: begin
                    state <= ST_RESET_WAIT;
                    delay_count <= 32'd0;
                    lcd_en <= 1'b0;
                end
            endcase
        end
    end

endmodule
