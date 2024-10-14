`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 11:24:48 AM
// Design Name: 
// Module Name: top_tb
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


module top_tb();
    localparam WIDTH = 24;
    localparam HARMONIC = 16;

    reg [WIDTH-1:0] angle_s0;
   
    reg [WIDTH-1:0] amp_s0;
    reg [WIDTH-1:0] amp_s1;
    reg [WIDTH-1:0] amp_s2;
    reg [WIDTH-1:0] amp_s3;
    reg [WIDTH-1:0] amp_s4;
    reg [WIDTH-1:0] amp_s5;
    reg [WIDTH-1:0] amp_s6;
    reg [WIDTH-1:0] amp_s7;
    reg [WIDTH-1:0] amp_s8;
    reg [WIDTH-1:0] amp_s9;
    reg [WIDTH-1:0] amp_s10;
    reg [WIDTH-1:0] amp_s11;
    reg [WIDTH-1:0] amp_s12;
    reg [WIDTH-1:0] amp_s13;
    reg [WIDTH-1:0] amp_s14;
    reg [WIDTH-1:0] amp_s15;
    wire [HARMONIC * WIDTH - 1: 0] amp_s;
    assign amp_s = {amp_s15, amp_s14, amp_s13, amp_s12, amp_s11, amp_s10, amp_s9, amp_s8, amp_s7, amp_s6,
                      amp_s5, amp_s4, amp_s3, amp_s2, amp_s1, amp_s0};
    
    //reg [WIDTH-1:0] amp_s;
    reg clk;
    reg reset;
    reg send;
    wire [WIDTH-1:0] sound;
    top dut_test(.clk(clk),.reset_n(reset), .send_i(send), .angle_i(angle_s0), .harmo_amp(amp_s), .sound_dac_o(sound));
    integer i;
    initial begin
        clk = 'b1;
        forever
            #50 clk = ~clk;
    end         
     
    initial begin
        reset = 'b0;
        #100
        reset = 'b1;
    end  
     initial begin    
    
        send = 1;
        angle_s0 = 0;
        amp_s0 = 24'b100000000000000000000000;
        amp_s1 = 24'b100000000000000000000000;
        amp_s2 = 24'b100000000000000000000000;
        amp_s3 = 24'b100000000000000000000000;
        amp_s4 = 24'b100000000000000000000000;
        amp_s5 = 24'b100000000000000000000000;
        amp_s6 = 24'b100000000000000000000000;
        amp_s7 = 24'b100000000000000000000000;
        amp_s8 = 24'b100000000000000000000000;
        amp_s9 = 24'b100000000000000000000000;
        amp_s10 = 24'b100000000000000000000000;
        amp_s11 = 24'b100000000000000000000000;
        amp_s12 = 24'b100000000000000000000000;
        amp_s13 = 24'b100000000000000000000000;
        amp_s14 = 24'b100000000000000000000000;
        amp_s15 = 24'b100000000000000000000000;
        $monitor($time, reset, angle_s0, amp_s, sound);
        for(i = 0; i < 1000; i = i + 1)begin
            angle_s0 = angle_s0 + 24'b000000001000000000000000;
            #100;
        end
        
        $stop;
      end  
endmodule
