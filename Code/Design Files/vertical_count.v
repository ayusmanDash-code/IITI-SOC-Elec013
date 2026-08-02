`timescale 1ns/1ps
`include "params.vh"
module v_count(
    input enable,
    input clk,
    output reg [15:0] vcount = 0,
    output reg frame = 1'b0
    );
    always @(posedge clk) begin
        if(enable == 1'b1) begin
            if(vcount < (`vtotal + 1)) begin   //fix hend replace with htotal()
                vcount <= vcount + 1;
                frame <= 1'b0;
            end
            else begin
               vcount <= 0;
               frame <=1'b1;
            end
        end
    end
endmodule