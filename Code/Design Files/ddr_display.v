`timescale 1ns/1ps
`include "params.vh"

//module ddr_display (
//    input clk_half,
//    input [15:0] i_box_size,
//    input [15:0] i_box_speed,
//    input [1:0] state,
//    output ddr_hsynq,
//    output ddr_vsynq,
//    output [7:0] ddr_red,
//    output [7:0] ddr_blue,
//    output [7:0] ddr_green
//);

//    wire hsynq1, hsynq2, vsynq1, vsynq2;
//    wire [7:0] red1, red2, blue1, blue2, green1, green2;

//    block1 inst1 (
//        .clk(clk_half),
//        .i_box_size(i_box_size),
//        .i_box_speed(i_box_speed),
//        .state(state),
//        .hsynq1(hsynq1),
//        .vsynq1(vsynq1),
//        .hsynq2(hsynq2),
//        .vsynq2(vsynq2),
//        .red1(red1),
//        .blue1(blue1),
//        .green1(green1),
//        .red2(red2),
//        .green2(green2),
//        .blue2(blue2)
//    );

//    genvar i;

//    generate
//        for(i=0; i<8; i=i+1) begin : oddrimplement

//            ODDR #(
//                .DDR_CLK_EDGE("SAME_EDGE"),
//                .INIT(1'b0),
//                .SRTYPE("SYNC")
//            ) oddr_red (
//                .Q(ddr_red[i]),
//                .C(clk_half),
//                .CE(1'b1),
//                .D1(red1[i]),
//                .D2(red2[i]),
//                .R(1'b0),
//                .S(1'b0)
//            );

//            ODDR #(
//                .DDR_CLK_EDGE("SAME_EDGE"),
//                .INIT(1'b0),
//                .SRTYPE("SYNC")
//            ) oddr_blue (
//                .Q(ddr_blue[i]),
//                .C(clk_half),
//                .CE(1'b1),
//                .D1(blue1[i]),
//                .D2(blue2[i]),
//                .R(1'b0),
//                .S(1'b0)
//            );

//            ODDR #(
//                .DDR_CLK_EDGE("SAME_EDGE"),
//                .INIT(1'b0),
//                .SRTYPE("SYNC")
//            ) oddr_green (
//                .Q(ddr_green[i]),
//                .C(clk_half),
//                .CE(1'b1),
//                .D1(green1[i]),
//                .D2(green2[i]),
//                .R(1'b0),
//                .S(1'b0)
//            );

//        end
//    endgenerate

//    // ODDR for HSYNC
//    ODDR #(
//        .DDR_CLK_EDGE("SAME_EDGE"),
//        .INIT(1'b0),
//        .SRTYPE("SYNC")
//    ) oddr_hsynq (
//        .Q(ddr_hsynq),
//        .C(clk_half),
//        .CE(1'b1),
//        .D1(hsynq1),
//        .D2(hsynq2),
//        .R(1'b0),
//        .S(1'b0)
//    );

//    // ODDR for VSYNC
//    ODDR #(
//        .DDR_CLK_EDGE("SAME_EDGE"),
//        .INIT(1'b0),
//        .SRTYPE("SYNC")
//    ) oddr_vsynq (
//        .Q(ddr_vsynq),
//        .C(clk_half),
//        .CE(1'b1),
//        .D1(vsynq1),
//        .D2(vsynq2),
//        .R(1'b0),
//        .S(1'b0)
//    );

//endmodule


module ddr_display (
    input clk_half,
    input [15:0] i_box_size,
    input [15:0] i_box_speed,
    input [1:0] state,
    output ddr_hsynq,
    output ddr_vsynq,
    output [3:0] ddr_red,
    output [3:0] ddr_blue,
    output [3:0] ddr_green
);

    wire hsynq1, hsynq2, vsynq1, vsynq2;
    wire [3:0] red1, red2, blue1, blue2, green1, green2;

    block1 inst1 (
        .clk(clk_half),
        .i_box_size(i_box_size),
        .i_box_speed(i_box_speed),
        .state(state),
        .hsynq1(hsynq1),
        .vsynq1(vsynq1),
        .hsynq2(hsynq2),
        .vsynq2(vsynq2),
        .red1(red1),
        .blue1(blue1),
        .green1(green1),
        .red2(red2),
        .green2(green2),
        .blue2(blue2)
    );

    genvar i;

    generate
        for(i=0; i<4; i=i+1) begin : oddrimplement

            ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"),
                .INIT(1'b0),
                .SRTYPE("SYNC")
            ) oddr_red (
                .Q(ddr_red[i]),
                .C(clk_half),
                .CE(1'b1),
                .D1(red1[i]),
                .D2(red2[i]),
                .R(1'b0),
                .S(1'b0)
            );

            ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"),
                .INIT(1'b0),
                .SRTYPE("SYNC")
            ) oddr_blue (
                .Q(ddr_blue[i]),
                .C(clk_half),
                .CE(1'b1),
                .D1(blue1[i]),
                .D2(blue2[i]),
                .R(1'b0),
                .S(1'b0)
            );

            ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"),
                .INIT(1'b0),
                .SRTYPE("SYNC")
            ) oddr_green (
                .Q(ddr_green[i]),
                .C(clk_half),
                .CE(1'b1),
                .D1(green1[i]),
                .D2(green2[i]),
                .R(1'b0),
                .S(1'b0)
            );

        end
    endgenerate

    // ODDR for HSYNC
    ODDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),
        .INIT(1'b0),
        .SRTYPE("SYNC")
    ) oddr_hsynq (
        .Q(ddr_hsynq),
        .C(clk_half),
        .CE(1'b1),
        .D1(hsynq1),
        .D2(hsynq2),
        .R(1'b0),
        .S(1'b0)
    );

    // ODDR for VSYNC
    ODDR #(
        .DDR_CLK_EDGE("SAME_EDGE"),
        .INIT(1'b0),
        .SRTYPE("SYNC")
    ) oddr_vsynq (
        .Q(ddr_vsynq),
        .C(clk_half),
        .CE(1'b1),
        .D1(vsynq1),
        .D2(vsynq2),
        .R(1'b0),
        .S(1'b0)
    );

endmodule