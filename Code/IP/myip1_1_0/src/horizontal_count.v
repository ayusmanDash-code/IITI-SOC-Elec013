`timescale 1ns / 1ps
`include "params.vh"

module h_count(
    input clk,
    output reg enable = 1'b0,
    output reg [15:0]hcount=0
    );
    always @(posedge clk) begin
        if(hcount < (`htotal + 1)) begin
            hcount <= hcount + 2;
            enable<=1'b0;
        end
        else begin
            enable <= 1'b1;
            hcount <= 0;
        end
    end
endmodule