`timescale 1ns/1ps

module tb_self_check ();
    //AXi + uart + ddr
    reg reset;
    // reg sys_clock;
    reg usb_uart_rxd;

    wire [3:0] ddr_blue_out_0;
    wire [3:0] ddr_green_out_0;
    wire ddr_hsynq_out_0;
    wire [3:0] ddr_red_out_0;
    wire ddr_vsynq_out_0;
    wire usb_uart_txd;
    reg [15:0]i_box_size=16'd50;
    reg [15:0]i_box_speed=16'd3;
    reg [1:0]state=2'b00;
    wire hsynq1 = 1'b0;
    wire vsynq1 = 1'b0;
    wire hsynq2 = 1'b0;
    wire vsynq2 = 1'b0;
    wire [3:0]red1;
    wire [3:0]blue1;
    wire [3:0]green1;
    wire [3:0]red2;
    wire [3:0]blue2;
    wire [3:0]green2;
    
    reg passred = 1'b1;
    reg passblue = 1'b1;
    reg passgreen = 1'b1;
    reg passhsynq = 1'b1;
    reg passvsynq = 1'b1;

    reg clk_74_25 = 0;
    initial forever #6.734 clk_74_25 = ~clk_74_25;

    // design_1_wrapper uut (
    //     .ddr_blue_out_0(ddr_blue_out_0),
    //     .ddr_green_out_0(ddr_green_out_0),
    //     .ddr_hsynq_out_0(ddr_hsynq_out_0),
    //     .ddr_red_out_0(ddr_red_out_0),
    //     .ddr_vsynq_out_0(ddr_vsynq_out_0),
    //     .reset(reset),
    //     .sys_clock(sys_clock),
    //     .usb_uart_rxd(usb_uart_rxd),
    //     .usb_uart_txd(usb_uart_txd)
    // );

    ddr_display uut (
        .clk_half(clk_74_25),
        .i_box_size(i_box_size),
        .i_box_speed(i_box_speed),
        .state(state),
        .ddr_hsynq(ddr_hsynq),
        .ddr_vsynq(ddr_vsynq),
        .ddr_red(ddr_red),
        .ddr_blue(ddr_blue),
        .ddr_green(ddr_green)
    );


    block1 inst (
        .clk(clk_74_25),
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
        .blue2(blue2),
        .green2(green2)
    );

    // initial begin
    //     sys_clock=0;
    //     forever #5 begin
    //         sys_clock = ~sys_clock;
    //     end
    // end
    real QUARTER_CYCLE = 3.367;

    always @(posedge clk_74_25) begin
        #QUARTER_CYCLE;        
        if(ddr_red_out_0!=red1)
        passred<=0;
        else
        passred<=1;
        
        if(ddr_blue_out_0!=blue1)
        passblue<=0;
        else
        passblue<=1;
        if(ddr_green_out_0!=green1)
        passgreen<=0;
        else
        passgreen<=1;

        if(ddr_hsynq_out_0!=hsynq1)
        passhsynq<=0;
        else
        passhsynq<=1;
        
        if(ddr_vsynq_out_0!=vsynq1)
        passvsynq<=0;
        else
        passvsynq<=1;
    end

    always @(negedge clk_74_25) begin
        #QUARTER_CYCLE;
        if(ddr_red_out_0!=red2)
        passred<=0;
        else
        passred<=1;
        
        if(ddr_blue_out_0!=blue2)
        passblue<=0;
        else
        passblue<=1;
        
        if(ddr_green_out_0!=green2)
        passgreen<=0;
        else
        passgreen<=1;
        
        if(ddr_hsynq_out_0!=hsynq2)
        passhsynq<=0;
        else
        passhsynq<=1;
        
        if(ddr_vsynq_out_0!=vsynq2)
        passvsynq<=0;
        else
        passvsynq<=1;
    end

    initial begin
        #20000000;
        $finish;
    end
endmodule