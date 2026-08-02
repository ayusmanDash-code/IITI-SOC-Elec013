`timescale 1ns / 1ps
// Include params to ensure testbench knows the 1080p resolution configurations
`include "params.vh"

module tb_video_gen;
    // System Clock
    reg clk_half;
    
    // File I/O and Trackers
    integer file_handle;
    integer frame_count = 0;

    // Design Inputs
    reg [15:0] i_box_size;
    reg [15:0] i_box_speed;
    reg [1:0]  state;

    // Design Outputs
    wire ddr_hsynq, ddr_vsynq;
    wire [3:0] ddr_red, ddr_blue, ddr_green;

    // Instantiate your design as the top module
    ddr_display uut (
        .clk_half(clk_half),
        .i_box_size(i_box_size),
        .i_box_speed(i_box_speed),
        .state(state),
        .ddr_hsynq(ddr_hsynq),
        .ddr_vsynq(ddr_vsynq),
        .ddr_red(ddr_red),
        .ddr_blue(ddr_blue),
        .ddr_green(ddr_green)
    );

    // Clock generation (Generic 10ns period, adjustable as needed)
    initial clk_half = 0;
    always #5 clk_half = ~clk_half;

    // Stimulus Initialization
    initial begin
        // Open file to write 1080p hex data
        file_handle = $fopen("video3_data_1080p.hex", "w");
        
        // Initial parameters
        i_box_size  = 16'd50;
        state       = 2'b00;
        i_box_speed = 16'd3;

        $display("Starting 1080p Video Simulation...");
        $display("Initial State: Size=50, Speed=3, Color=00 (Red)");
    end

    // --- UPDATED: Edge detection register ---
    reg prev_frame_val = 1'b0;

    // Frame Counting and Dynamic Parameter Updates
    always @(posedge clk_half) begin
        // Store the previous value of the frame signal
        prev_frame_val <= uut.inst1.frame;
        
        // ONLY trigger when frame transitions from 0 to 1 (Rising Edge)
        if (uut.inst1.frame == 1'b1 && prev_frame_val == 1'b0) begin
            frame_count = frame_count + 1;
            
            // Log progress periodically to the Vivado Tcl Console
            if (frame_count % 10 == 0) begin
                $display("Captured Frame: %0d / 600", frame_count);
            end
            
            // Flush file buffer to disk to prevent memory overflow
            $fflush(file_handle); 

            // State Machine for Parameter Changes
            if (frame_count == 150) begin
                i_box_size  = 16'd30;
                state       = 2'b01; // Green
                i_box_speed = 16'd5;
                $display("--- Frame 150 Reached: Updated to Size=30, Speed=5, Color=01 (Green)");
            end
            else if (frame_count == 300) begin
                i_box_size  = 16'd40;
                state       = 2'b10; // Blue
                i_box_speed = 16'd4;
                $display("--- Frame 300 Reached: Updated to Size=40, Speed=4, Color=10 (Blue)");
            end
            else if (frame_count == 450) begin
                i_box_size  = 16'd60;
                state       = 2'b11; // Black
                i_box_speed = 16'd2;
                $display("--- Frame 450 Reached: Updated to Size=60, Speed=2, Color=11 (Black)");
            end
            else if (frame_count == 600) begin
                $fclose(file_handle);
                $display("Hex file generation complete! 600 frames recorded.");
                $finish;
            end
        end
    end
    // ---------------------------------------------------------
    // DDR Sampling Logic (Testing the ODDR outputs directly)
    // ---------------------------------------------------------
    
    // Sample Pixel 1 (D1 from ODDR) on Positive Edge
    always @(posedge clk_half) begin
        #1; // 1ns delay allows ODDR outputs to settle in simulation
        if (uut.inst1.video_active) begin
            // {ddr_red, ddr_red} scales 4-bit color (0xF) to 8-bit color (0xFF) for easier image rendering
            $fwrite(file_handle, "%02x%02x%02x\n", {ddr_red, ddr_red}, {ddr_green, ddr_green}, {ddr_blue, ddr_blue});
        end
    end

    // Sample Pixel 2 (D2 from ODDR) on Negative Edge
    always @(negedge clk_half) begin
        #1; // 1ns delay allows ODDR outputs to settle in simulation
        if (uut.inst1.video_active) begin
            $fwrite(file_handle, "%02x%02x%02x\n", {ddr_red, ddr_red}, {ddr_green, ddr_green}, {ddr_blue, ddr_blue});
        end
    end

endmodule