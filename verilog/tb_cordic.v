`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 09:34:12 AM
// Design Name: 
// Module Name: tb_cordic
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


module tb_cordic();

    localparam WIDTH = 24;
    
    reg [WIDTH-1:0] angle_s;
    reg clk;
    reg reset;
    wire [WIDTH-1:0] sine;
    wire [WIDTH-1:0] cosine;
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
    
        $monitor($time, reset, angle_s, sine, cosine);
        angle_s = 24'b0;
        for(i = 0; i < 1000; i = i + 1)begin
            angle_s = angle_s + 24'b000000001000000000000000;
            #100;
        end
//        angle_s = 24'b000000000000000000000000;
//        #100
//        angle_s = 24'b000000000000000000000000; // 0.00 
//        #100
//        angle_s =24'b010000000000000000000000; // 90
//        #100
//        angle_s =24'b100000000000000000000000; // 180
//        #100 
//        angle_s =24'b110000000000000000000000; // 270
//        #100
        angle_s = 24'b000101010101010101010101; // 30.00 
        #100
        angle_s =24'b001010101010101010101010; // 60 
        #100
        angle_s =24'b010101010101010101010101; // 120
        #100
        angle_s =24'b011010101010101010101010; // 150 
        #100
        angle_s =24'b000000000000000000000000; 
        
        #100000
        $stop;
        
    end

    cordic test(.clk(clk),.reset_n(reset), .angle_i(angle_s), .sine_o(sine), .cosine_o(cosine));

endmodule
