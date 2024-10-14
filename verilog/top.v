`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 12:44:31 PM
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


module top
    #(
        parameter WIDTH      = 24,
        parameter HARMONIC   = 16
    )
    (
        input wire                                     clk,
        input wire                                     reset_n,  
        input wire                                     send_i,           
        input signed [WIDTH - 1 : 0]                   angle_i,
        input signed [HARMONIC -1 : 0] [WIDTH - 1 : 0] harmo_amp,
        output signed [WIDTH - 1 : 0]                  sound_dac_o
    );


    reg [WIDTH -1: 0] angle_har [0: HARMONIC -1];
    reg [27 : 0] addition_w;
    wire [WIDTH - 1 : 0] multiplication_w [0 : HARMONIC - 1];
    
    integer k;
    always @(*)
    begin
        for(k = 0; k < HARMONIC; k = k +1)begin
            if (send_i == 1)
                if (k == 0)
                    angle_har[k] = angle_i;
                else
                    angle_har[k] = (k + 1) * angle_i;
            else 
                angle_har[k] = 0;            
        end
    end
    
    genvar i;
    generate
        for (i = 0; i < HARMONIC; i = i + 1) begin
            harmonic_multiplication inst(
                .clk(clk),
                .reset_n(reset_n),
                .send_i(send_i),
                .angle_i(angle_har[i]),
                .harmo_amp(harmo_amp[i]),
                .multiplication_o(multiplication_w[i])
            );
        end 
    endgenerate

    integer j;
    always @(*)
    begin 
        addition_w = 0;  
        for (j = 0; j < HARMONIC; j = j + 1) begin
            addition_w = addition_w + multiplication_w[j];    
        end
    end

//    assign addition_w = (((multiplication_w[0] + multiplication_w[1]) + (multiplication_w[2]+ multiplication_w[3])) + 
//                        ((multiplication_w[4] + multiplication_w[5])+ (multiplication_w[6] + multiplication_w[7]))) +
//                        (((multiplication_w[8]+ multiplication_w[9]) + (multiplication_w[10] + multiplication_w[11])) +
//                        ((multiplication_w[12] + multiplication_w[13]) + (multiplication_w[14]+ multiplication_w[15])));

    assign sound_dac_o = addition_w[27:4];

endmodule
