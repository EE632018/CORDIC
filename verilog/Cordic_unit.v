`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 01:35:09 PM
// Design Name: 
// Module Name: Cordic_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// x[i+1] = (x[i] +- (y[i]*tan(angle_i))) -- this multiplication is aproximated with right shift
// y[i+1] = (y[i] +- (x[i]*tan(angle_i))) -- this multiplication is aproximated with right shift 
// z[i+1] = (z[i] +- tan_table[i]) -- tan_table represent angles : 45, 26.565, 14.036 etc


module Cordic_unit
    #(parameter WIDTH = 24)
    (  
    input                            clk,
    input                            reset,
    input signed  [WIDTH - 1:0]      x_i,
    input signed  [WIDTH - 1:0]      y_i,
    input signed  [WIDTH - 1:0]      z_i, 
    input wire    [4:0]              shift_i,
    input signed  [WIDTH - 1:0]      tan_table,
    output signed [WIDTH - 1:0]      x_o,
    output signed [WIDTH - 1:0]      y_o,
    output signed [WIDTH - 1:0]      z_o
    );
    
    reg signed [WIDTH - 1 : 0] x_n;
    reg signed [WIDTH - 1 : 0] y_n;
    reg signed [WIDTH - 1 : 0] z_n;
    reg signed [WIDTH - 1 : 0] quadrant_n;
    
    always @(posedge clk or negedge reset)
    begin
        if (reset != 1) begin
            x_n <= 0;
            y_n <= 0;
            z_n <= 0;
        end
        else begin 
            x_n <= x_i; 
            y_n <= y_i; 
            z_n <= z_i; 
        end
    end
    
    assign x_o = z_n[WIDTH - 1] ? x_n + (y_n >>> shift_i)   : x_n - (y_n >>> shift_i);
    assign y_o = z_n[WIDTH - 1] ? y_n - (x_n >>> shift_i)   : y_n + (x_n >>> shift_i);
    assign z_o = z_n[WIDTH - 1] ? z_n + tan_table           : z_n - tan_table;
    
endmodule
