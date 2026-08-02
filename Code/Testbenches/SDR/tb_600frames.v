`timescale 1ns / 1ps

module tb_video_out2;
    reg clk;
    wire hsynq, vsynq;
    wire [3:0] red, green, blue;

    // Instantiate your block1 module
    block1 uut (
        .clk(clk),
        .hsynq(hsynq),
        .vsynq(vsynq),
        .red(red),
        .blue(blue),
        .green(green)
    );

    // Generate a 74.25 MHz clock (approx 13.46 ns period)
    initial begin
        clk = 0;
        forever #6.73 clk = ~clk;
    end

    integer file_id = 0;
    integer frame_count = 0;
    
    // Create a register array large enough to hold the file name string (e.g., 30 characters * 8 bits)
    reg [8*30:1] filename;
    
    // Initialize the very first frame file
    initial begin
        // Verilog-2001 way to format strings
        $sformat(filename, "frame_%0d.ppm", frame_count);
        file_id = $fopen(filename, "w");
        
        // Write the PPM header: Format P3, Width 1920, Height 1080, Max Color Value 15
        $fwrite(file_id, "P3\n1920 1080\n15\n"); 
    end

    // Use your 'frame' signal to detect when a screen finishes drawing
    always @(posedge uut.frame) begin
        if (file_id) $fclose(file_id); // Close the finished frame
        
        frame_count = frame_count + 1;
        
        // 600 frames = 10 seconds at 60 FPS
        if (frame_count >= 600) begin
            $display("10 seconds of video generated! Stopping simulation.");
            $finish;
        end else begin
            // Verilog-2001 way to format strings for the next frame
            $sformat(filename, "frame_%0d.ppm", frame_count);
            file_id = $fopen(filename, "w");
            
            $fwrite(file_id, "P3\n1920 1080\n15\n");
            
            // Print progress to the Vivado Tcl Console so you know it's working
            if (frame_count % 10 == 0) begin
                $display("Rendering frame %0d / 600...", frame_count);
            end
        end
    end

    // Write pixel data during the Active Video Area
    always @(posedge clk) begin
        // Based on your counters, the active 1920x1080 area is within these bounds
        if (uut.hcount >= 192 && uut.hcount < 2112 && uut.vcount >= 41 && uut.vcount < 1121) begin
            if (file_id) begin
                // Write the 4-bit red, green, and blue values separated by spaces
                $fwrite(file_id, "%0d %0d %0d\n", red, green, blue);
            end
        end
    end

endmodule






// A X I






`timescale 1ns / 1ps

module tb_video_out2;
    reg clk;
    wire hsynq, vsynq;
    wire [7:0] red, green, blue;
    reg [15:0]i_box_size = 16'd50;
    reg [15:0]i_box_speed = 16'd1;
    reg [1:0]state = 2'b00;

    // Instantiate your block1 module
    ddr_display uut (
        .state(state),
        .i_box_size(i_box_size),
        .i_box_speed(i_box_speed),
        .clk(clk),
        .hsynq(ddr_hsynq),
        .vsynq(ddr_vsynq),
        .red(ddr_red),
        .blue(ddr_blue),
        .green(ddr_green)
    );

    // Clock Generation
    // 640x480 @ 60Hz uses a 25.175 MHz pixel clock.
    // Since this is a half-clock design (DDR), clk_half is ~12.5 MHz (80ns period).
    initial begin
        clk = 0;
        forever #40 clk = ~clk;
    end

    integer file_id = 0;
    integer frame_count = 0;
    
    // Create a register array large enough to hold the file name string (e.g., 30 characters * 8 bits)
    reg [8*30:1] filename;
    
    // Initialize the very first frame file
    initial begin
        // Verilog-2001 way to format strings
        $sformat(filename, "frame_new_%0d.ppm", frame_count);
        file_id = $fopen(filename, "w");
        
        // Write the PPM header: Format P3, Width 1920, Height 1080, Max Color Value 15
        // $fwrite(file_id, "P3\n1920 1080\n15\n"); 
        $fwrite(file_id, "P3\n640 480\n255\n");
    end

    // Use your 'frame' signal to detect when a screen finishes drawing
    always @(posedge uut.frame) begin
        if (file_id) $fclose(file_id); // Close the finished frame
        
        frame_count = frame_count + 1;
        
        // 600 frames = 10 seconds at 60 FPS
        if (frame_count == 150) begin
            state <= 2'b01;       // Change to Green
            i_box_speed <= 16'd4; // Speed up
        end
        else if (frame_count == 300) begin
            state <= 2'b10;       // Change to Blue
            i_box_size <= 16'd100;// Increase size to 100x100
        end
        else if (frame_count == 450) begin
            state <= 2'b11;       // Change to Black
            i_box_speed <= 16'd1; // Slow down
            i_box_size <= 16'd20; // Shrink to 20x20
        end
        else if (frame_count == 500) begin
            state <= 2'b00;
            i_box_size <= 16'd40;
            i_box_speed <= 16'd5;
        end


        if (frame_count >= 600) begin
            $display("10 seconds of video generated! Stopping simulation.");
            $finish;
        end else begin
            // Verilog-2001 way to format strings for the next frame
            $sformat(filename, "frame_new_%0d.ppm", frame_count);
            file_id = $fopen(filename, "w");
            
            // $fwrite(file_id, "P3\n1920 1080\n15\n");
            $fwrite(file_id, "P3\n640 480\n255\n");
            
            // Print progress to the Vivado Tcl Console so you know it's working
            if (frame_count % 10 == 0) begin
                $display("Rendering frame %0d / 600...", frame_count);
            end
        end
    end

    // Write pixel data during the Active Video Area
    always @(posedge clk) begin
        // Based on your counters, the active 1920x1080 area is within these bounds
        if (uut.hcount >= 192 && uut.hcount < 2112 && uut.vcount >= 41 && uut.vcount < 1121) begin
            if (file_id) begin
                // Write the 4-bit red, green, and blue values separated by spaces
                $fwrite(file_id, "%0d %0d %0d\n", red, green, blue);
            end
        end
    end

endmodule