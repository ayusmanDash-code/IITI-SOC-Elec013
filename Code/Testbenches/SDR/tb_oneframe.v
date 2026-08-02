`timescale 1ns/1ps
`include "params.vh"

module tb_oneframe ();
    reg clk=0;
    wire hysnq,vsynq;
    reg [7:0] red,green,blue;

    block1 uut(
        .clk(clk),
        .hysnq(hsynq),
        .vysnq(vsynq),
        .red(red),
        .blue(blue),
        .green(green)
    );

    initial begin
        $monitor($time,"clk=%b,hsynq=%b,vsynq=%b",clk,hsynq,vsynq);
        always clk = ~clk;
        #4950000
        $finish
    end


//WRONG DELAY MISSING
    
endmodule