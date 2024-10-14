`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: EEE
// Engineer: Milos Strizak
// 
// Create Date: 05/17/2024 10:54:23 AM
// Design Name: 
// Module Name: cordic
// Project Name: 
// Target Devices: Nexus Video
// Tool Versions: 
// Description: 
// This module implements calculation od sine and cosine
// using CORDIC algorithm. As input it has angle, and on
// output we generate sine and cosine of that angle. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic
    #(  parameter ITERATIONS = 24,
        parameter WIDTH      = 24   
    )
    (
        input wire                  clk,
        input wire                  reset_n,             
        input signed [WIDTH - 1 : 0]  angle_i,
        output signed [WIDTH - 1 : 0] sine_o,
        output signed [WIDTH - 1 : 0] cosine_o
    );
    
    // This table represents tan(angle_i) representation 
    // The starting point is 45 degrees, each aftert that 
    // is devided by 2 
    wire  signed [WIDTH - 1 : 0] tan_table [0 : ITERATIONS - 1];
    // values of LUT tan_table
    assign tan_table[00] = 24'b001000000000000000000000; // 45.000000 degrees
    assign tan_table[01] = 24'b000100101110010000000010; // 26.565000 degrees
    assign tan_table[02] = 24'b000010011111101100101101; // 14.036000 degrees
    assign tan_table[03] = 24'b000001010001000100010001; // 7.125000 degrees
    assign tan_table[04] = 24'b000000101000101011111101; // 3.576000 degrees
    assign tan_table[05] = 24'b000000010100011000111001; // 1.789000 degrees
    assign tan_table[06] = 24'b000000001010001011101110; // 0.895000 degrees
    assign tan_table[07] = 24'b000000000101000110001110; // 0.448000 degrees
    assign tan_table[08] = 24'b000000000010100011000111; // 0.224000 degrees
    assign tan_table[09] = 24'b000000000001010001100011; // 0.112000 degrees
    assign tan_table[10] = 24'b000000000000101000110001; // 0.056000 degrees
    assign tan_table[11] = 24'b000000000000010100011000; // 0.028000 degrees
    assign tan_table[12] = 24'b000000000000001010001100; // 0.014000 degrees
    assign tan_table[13] = 24'b000000000000000101000110; // 0.007000 degrees
    assign tan_table[14] = 24'b000000000000000010100011; // 0.003500 degrees
    assign tan_table[15] = 24'b000000000000000001010011; // 0.001750 degrees
    assign tan_table[16] = 24'b000000000000000000101001; // 0.000875 degrees
    assign tan_table[17] = 24'b000000000000000000010010; // 0.000438 degrees
    assign tan_table[18] = 24'b000000000000000000001001; // 0.000219 degrees
    assign tan_table[19] = 24'b000000000000000000000100; // 0.000109 degrees
    assign tan_table[20] = 24'b000000000000000000000100; // 0.000055 degrees
    assign tan_table[21] = 24'b000000000000000000000010; // 0.000027 degrees
    assign tan_table[22] = 24'b000000000000000000000000; // 0.000014 degrees
    assign tan_table[23] = 24'b000000000000000000000000; // 0.000007 degrees
    
    wire signed [WIDTH - 1 : 0] x_s, y_s;
    
    assign x_s = 24'b110011011011001000101100;
    assign y_s = 24'b100000000000000000000000;

    // register x,y,z    
    wire signed [WIDTH - 1 : 0] x_w [0 : ITERATIONS - 1];
    wire signed [WIDTH - 1 : 0] y_w [0 : ITERATIONS - 1];
    wire signed [WIDTH - 1 : 0] z_w [0 : ITERATIONS - 1];
    wire [1:0] quadrant;
    reg  [WIDTH - 1 : 0] x_r, y_r, z_r;
    
    assign quadrant = angle_i[23:22];
    
    always @(posedge clk)
      begin // make sure the rotation angle is in the -pi/2 to pi/2 range
        case(quadrant)
          2'b00:
          begin
            x_r <= x_s;
            y_r <= y_s;
            z_r <= angle_i;
          end
          2'b11: // no changes needed for these quadrants
          begin
            x_r <= x_s;
            y_r <= y_s;
            z_r <= angle_i;
          end
    
          2'b01:
          begin
            x_r <= -y_s;
            y_r <= x_s;
            z_r <= {2'b00,angle_i[21:0]}; // subtract pi/2 for angle in this quadrant
          end
    
          2'b10:
          begin
            x_r <= y_s;
            y_r <= -x_s;
            z_r <= {2'b11,angle_i[21:0]}; // add pi/2 to angles in this quadrant
          end
        endcase
      end
                      
    
    Cordic_unit inst0(
        .clk(clk),
        .reset(reset_n),
        .x_i(x_r),
        .y_i(y_r),
        .z_i(z_r),
        .shift_i(5'b00000),
        .tan_table(tan_table[0]),
        .x_o(x_w[0]),
        .y_o(y_w[0]),
        .z_o(z_w[0])
    );
    genvar i;
    generate
        for (i = 1; i < ITERATIONS; i = i + 1) begin
            Cordic_unit inst_i(
                .clk(clk),
                .reset(reset_n),
                .x_i(x_w[i-1]),
                .y_i(y_w[i-1]),
                .z_i(z_w[i-1]),
                .shift_i(i),
                .tan_table(tan_table[i]),
                .x_o(x_w[i]),
                .y_o(y_w[i]),
                .z_o(z_w[i])
            );
        end 
    endgenerate
    
    assign sine_o  = y_w[ITERATIONS - 1] - 24'b100000000000000000000000;
    assign cosine_o  = x_w[ITERATIONS - 1] - 24'b100000000000000000000000;


endmodule


