`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 12:15:19 PM
// Design Name: 
// Module Name: top
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


module harmonic_multiplication
    #(
        parameter WIDTH      = 24
    )
    (
        input wire                    clk,
        input wire                    reset_n,
        input wire                    send_i,             
        input signed [WIDTH - 1 : 0]  angle_i,
        input signed [WIDTH - 1 : 0]  harmo_amp,
        output signed [WIDTH - 1 : 0] multiplication_o
    );
    
    reg signed [WIDTH -1 : 0] d_reg;
    wire signed [WIDTH - 1 : 0] sine_w, cosine_w;
    wire signed [2 * WIDTH - 2 : 0] multiplication_w;
    wire signed [WIDTH - 2 : 0] sine_inv;
    
    
    always @(posedge clk or negedge reset_n)
    begin
        if (reset_n != 1)
            d_reg <= 0;
        else  
            if (send_i == 1)
                d_reg <= angle_i; 
    end
    
    cordic inst(
        .clk(clk),
        .reset_n(reset_n),             
        .angle_i(d_reg),
        .sine_o(sine_w),
        .cosine_o(cosine_w)
    );
    
    assign sine_inv = sine_w[23] ? sine_w[22:0] : ~sine_w[22:0];
    assign multiplication_w = sine_inv * harmo_amp;
    assign multiplication_o = sine_w[23] ? {sine_w[23], ~multiplication_w[45:23]} : {sine_w[23], multiplication_w[45:23]};
   // assign multiplication_o = {sine_w[23], multiplication_w[46:24]};
    
//    always @(posedge clk or negedge reset_n)
//    begin
//        if (reset_n == 0)
//            multiplication_w = 0;
//        else     
//        case (harmo_amp[23:20])
//            4'b0000 :   multiplication_w = 0;
//            4'b0001 :   multiplication_w = sine_w >>> 4; // 1/16
//            4'b0010 :   multiplication_w = sine_w >>> 3; // 1/8
//            4'b0011 :   multiplication_w = (((sine_w <<< 1) + sine_w) >>> 4); // 3/16
//            4'b0100 :   multiplication_w = sine_w >>> 2; // 1/4
//            4'b0101 :   multiplication_w = (((sine_w <<< 2) + sine_w) >>> 4); // 5/16
//            4'b0110 :   multiplication_w = (((sine_w <<< 1) + sine_w) >>> 3); // 3/8
//            4'b0111 :   multiplication_w = (((sine_w <<< 3) - sine_w) >>> 4); // 7/16
//            4'b1000 :   multiplication_w = sine_w >>> 1; // 1/2
//            4'b1001 :   multiplication_w = (((sine_w <<< 3) + sine_w) >>> 4); // 9/16
//            4'b1010 :   multiplication_w = (((sine_w <<< 2) + sine_w) >>> 3); // 5/8
//            4'b1011 :   multiplication_w = (( (sine_w <<< 3) + (sine_w <<< 1) + sine_w) >>> 4);
//            4'b1100 :   multiplication_w = (((sine_w <<< 1) + sine_w) >>> 2); // 3/4
//            4'b1101 :   multiplication_w = (( (sine_w <<< 3) + (sine_w <<< 2) + sine_w) >>> 4); // 13/16
//            4'b1110 :   multiplication_w = (((sine_w <<< 3) - sine_w) >>> 3);
//            4'b1111 :   multiplication_w = sine_w;
//            default :   multiplication_w = sine_w;
//        endcase
//    end 
    
//    assign multiplication_o = multiplication_w;
endmodule
