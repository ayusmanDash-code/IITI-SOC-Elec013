`timescale 1ns / 1ps
`include "params.vh"

//module block1(
//    input clk,
//    input [15:0]i_box_size,
//    input [15:0]i_box_speed,
//    input [1:0]state,
//    output reg hsynq1 = 1'b0,
//    output reg vsynq1 = 1'b0,
//    output reg hsynq2 = 1'b0,
//    output reg vsynq2 = 1'b0,
//    output [7:0]red1,
//    output [7:0]blue1,
//    output [7:0]green1,
//    output [7:0]red2,
//    output [7:0]blue2,
//    output [7:0]green2
//    );
    
//    wire enable;
//    wire [15:0]hcount;
//    wire [15:0]vcount;
    
//    reg [7:0]ored1 = 8'd0;
//    reg [7:0]oblue1 = 8'd0;
//    reg [7:0]ogreen1 = 8'd0;

//    reg [7:0]ored2 = 8'd0;
//    reg [7:0]oblue2 = 8'd0;
//    reg [7:0]ogreen2 = 8'd0;

//    reg [15:0]boxx = `hstart;
//    reg [15:0]boxy = `vstart;
//    reg xdir = 1'b1;
//    reg ydir = 1'b1;
    
//    // reg [15:0]xfix;
//    // reg [15:0]yfix;
    
//    wire [15:0]hcount1 = hcount;
//    wire [15:0]hcount2 = hcount+1;
    
//    // THE FIX: Changed from 'reg' to 'wire'
//    wire frame; 

//    h_count inst1 (.clk(clk), .enable(enable), .hcount(hcount));
//    v_count inst2 (.clk(clk), .enable(enable), .vcount(vcount), .frame(frame));
    

//    // 0 2 4 6 ------- 2112 ----- 2200
//    //**hstart = 191(hcount = 190, 192) use hcount1 and hcount2 both individually**
//    wire video_active = (hcount >= `hstart && hcount < `hend) &&  (vcount >= `vstart && vcount < `vend);


//    // Synchronous position update: triggers exactly once at the end of the frame
//    always @(posedge clk) begin
//        hsynq1 <= (hcount1 < `hsync_val) ? 1'b1:1'b0;
//        vsynq1 <= (vcount < `vsync_val) ? 1'b1:1'b0;
//        hsynq2 <= (hcount2 < `hsync_val) ? 1'b1:1'b0;
//        vsynq2 <= (vcount < `vsync_val) ? 1'b1:1'b0;

//        //change check equality for htotal and htotal -1 
//        if ( ((hcount == (`htotal - 1) ) || (hcount == `htotal ))   && vcount == (`vtotal - 1)) begin
//            //(using next-state predictions) 
//            // X Movement
//            // if ((boxx + i_box_size + i_box_speed > `hend) && xdir == 1'b1) begin
//            //     xfix <= i_box_speed - (boxx + i_box_size + i_box_speed - `hend);
//            //     boxx <= boxx + xfix;
//            // end
//            // else if ((boxx + i_box_size + i_box_speed <= `hend) && xdir == 1'b1) begin
//            //     boxx <= boxx + i_box_speed;
//            // end 
//            // if ((boxx - i_box_speed < `hstart) && xdir == 1'b0) begin
//            //     xfix <= i_box_speed - (`hstart - (boxx - i_box_speed));
//            //     boxx <= boxx - xfix;
//            // end
//            // else if ((boxx - i_box_speed >= `hstart) && xdir == 1'b0) begin
//            //     boxx <= boxx - i_box_speed;
//            // end


//            // // Y Movement
//            // if ((boxy + i_box_size + i_box_speed > `vend) && ydir == 1'b1) begin
//            //     yfix <= i_box_speed - (boxy + i_box_size + i_box_speed - `vend);
//            //     boxy <= boxy + yfix;
//            // end
//            // else if ((boxy + i_box_size + i_box_speed <= `vend) && ydir == 1'b1) begin
//            //     boxy <= boxy + i_box_speed;
//            // end

//            // if ((boxy - i_box_speed < `vstart) && ydir == 1'b0) begin
//            //     yfix <= i_box_speed - (`vstart - (boxy - i_box_speed));
//            //     boxy <= boxy - yfix;
//            // end
//            // else if ((boxy - i_box_speed >= `vstart) && ydir == 1'b0) begin
//            //     boxy <= boxy - i_box_speed;
//            // end



//            //**EASIER METHOD**
//            if (xdir == 1'b1) begin
//                if ((boxx + i_box_size + i_box_speed) > `hend) begin
//                    boxx <= `hend - i_box_size; 
//                end else begin
//                    boxx <= boxx + i_box_speed;
//                end
//            end 
//            else begin
//                if ((boxx - i_box_speed) < `hstart) begin
//                    boxx <= `hstart;    
//                end else begin
//                    boxx <= boxx - i_box_speed;
//                end
//            end

//            // Y Movement
//            if (ydir == 1'b1) begin
//                if ((boxy + i_box_size + i_box_speed) > `vend) begin
//                    boxy <= `vend - i_box_size; 
//                end else begin
//                    boxy <= boxy + i_box_speed;
//                end
//            end 
//            else begin
//                if ((boxy - i_box_speed) < `vstart) begin
//                    boxy <= `vstart;    
//                end else begin
//                    boxy <= boxy - i_box_speed;
//                end
//            end

//            //PREVIOUS LOGIC
//            // if (ydir == 1'b1) 
//            //     boxy <= boxy + i_box_speed;
//            // else 
//            //     boxy <= boxy - i_box_speed;
//            // Bouncing Logic 
//            if ((boxy + i_box_size) >= `vend) 
//                ydir <= 1'b0;
//            else if (boxy <= `vstart) 
//                ydir <= 1'b1;
//            if ((boxx + i_box_size) >= `hend) 
//                xdir <= 1'b0;
//            else if (boxx <= `hstart) 
//                xdir <= 1'b1;
//        end
//    end
    
//    // Color implementation
//    always @(posedge clk) begin
//        //hcount1
//        if (!video_active) begin
//            oblue1 <= 8'd0;
//            ored1 <= 8'd0;
//            ogreen1 <= 8'd0;
//        end
//        else if(hcount1>=boxx && hcount1<=(boxx+i_box_size) && vcount>=boxy && vcount<=(boxy+i_box_size)) begin
//            case (state)
//                2'b00: begin
//                    //red
//                    oblue1 <= 8'd0;
//                    ogreen1 <= 8'd0;
//                    ored1 <= 8'd255;
//                end
//                2'b01: begin
//                    //green
//                    oblue1 <= 8'd0;
//                    ogreen1 <= 8'd255;
//                    ored1 <= 8'd0;
//                end 
//                2'b10: begin
//                    //blue
//                    oblue1 <= 8'd255;
//                    ogreen1 <= 8'd0;
//                    ored1 <= 8'd0;
//                end
//                2'b11: begin
//                    //black
//                    oblue1 <= 8'd0;
//                    ogreen1 <= 8'd0;
//                    ored1 <= 8'd0;
//                end 
//            endcase
//        end
//        else begin
//            oblue1 <= 8'd255;
//            ored1 <= 8'd255;
//            ogreen1 <= 8'd255;
//        end

//        //hcount2
//        if (!video_active) begin
//            oblue2 <= 8'd0;
//            ored2 <= 8'd0;
//            ogreen2 <= 8'd0;
//        end
//        else if(hcount2>=boxx && hcount2<=(boxx+i_box_size) && vcount>=boxy && vcount<=(boxy+i_box_size)) begin
//            case (state)
//                2'b00: begin
//                    //red
//                    oblue2 <= 8'd0;
//                    ogreen2 <= 8'd0;
//                    ored2 <= 8'd255;
//                end
//                2'b01: begin
//                    //green
//                    oblue2 <= 8'd0;
//                    ogreen2 <= 8'd255;
//                    ored2 <= 8'd0;
//                end 
//                2'b10: begin
//                    //blue
//                    oblue2 <= 8'd255;
//                    ogreen2 <= 8'd0;
//                    ored2 <= 8'd0;
//                end
//                2'b11: begin
//                    //black
//                    oblue2 <= 8'd0;
//                    ogreen2 <= 8'd0;
//                    ored2 <= 8'd0;
//                end 
//            endcase
//        end
//        else begin
//            oblue2 <= 8'd255;
//            ored2 <= 8'd255;
//            ogreen2 <= 8'd255;
//        end
//    end
//    assign red1 = ored1;
//    assign blue1 = oblue1;
//    assign green1 = ogreen1;

//    assign red2 = ored2;
//    assign blue2 = oblue2;
//    assign green2 = ogreen2;
    
//endmodule

module block1(
    input clk,
    input [15:0]i_box_size,
    input [15:0]i_box_speed,
    input [1:0]state,
    output reg hsynq1 = 1'b0,
    output reg vsynq1 = 1'b0,
    output reg hsynq2 = 1'b0,
    output reg vsynq2 = 1'b0,
    output [3:0]red1,
    output [3:0]blue1,
    output [3:0]green1,
    output [3:0]red2,
    output [3:0]blue2,
    output [3:0]green2
    );
    
    wire enable;
    wire [15:0]hcount;
    wire [15:0]vcount;
    
    reg [3:0]ored1;
    reg [3:0]oblue1;
    reg [3:0]ogreen1;

    reg [3:0]ored2;
    reg [3:0]oblue2;
    reg [3:0]ogreen2;

    reg [15:0]boxx = `hstart;
    reg [15:0]boxy = `vstart;
    reg xdir = 1'b1;
    reg ydir = 1'b1;
    
    // reg [15:0]xfix;
    // reg [15:0]yfix;
    
    wire [15:0]hcount1 = hcount;
    wire [15:0]hcount2 = hcount+1;
    
    // THE FIX: Changed from 'reg' to 'wire'
    wire frame; 

    h_count inst1 (.clk(clk), .enable(enable), .hcount(hcount));
    v_count inst2 (.clk(clk), .enable(enable), .vcount(vcount), .frame(frame));
    

    // 0 2 4 6 ------- 2112 ----- 2200
    //**hstart = 191(hcount = 190, 192) use hcount1 and hcount2 both individually**
    wire video_active = (hcount >= `hstart && hcount < `hend) &&  (vcount >= `vstart && vcount < `vend);


    // Synchronous position update: triggers exactly once at the end of the frame
    always @(posedge clk) begin
        hsynq1 <= (hcount1 < `hsync_val) ? 1'b1:1'b0;
        vsynq1 <= (vcount < `vsync_val) ? 1'b1:1'b0;
        hsynq2 <= (hcount2 < `hsync_val) ? 1'b1:1'b0;
        vsynq2 <= (vcount < `vsync_val) ? 1'b1:1'b0;

        //change check equality for htotal and htotal -1 
        if ( ((hcount == (`htotal - 1) ) || (hcount == `htotal ))   && vcount == (`vtotal - 1)) begin
           
            //**EASIER METHOD**
            if (xdir == 1'b1) begin
                if ((boxx + i_box_size + i_box_speed) > `hend) begin
                    boxx <= `hend - i_box_size; 
                end else begin
                    boxx <= boxx + i_box_speed;
                end
            end
            else begin
                if ((boxx - i_box_speed) < `hstart) begin
                    boxx <= `hstart;    
                end else begin
                    boxx <= boxx - i_box_speed;
                end
            end

            // Y Movement
            if (ydir == 1'b1) begin
                if ((boxy + i_box_size + i_box_speed) > `vend) begin
                    boxy <= `vend - i_box_size; 
                end else begin
                    boxy <= boxy + i_box_speed;
                end
            end 
            else begin
                if ((boxy - i_box_speed) < `vstart) begin
                    boxy <= `vstart;    
                end else begin
                    boxy <= boxy - i_box_speed;
                end
            end

            //PREVIOUS LOGIC
            // if (ydir == 1'b1) 
            //     boxy <= boxy + i_box_speed;
            // else 
            //     boxy <= boxy - i_box_speed;
            // Bouncing Logic 
            if ((boxy + i_box_size) >= `vend) 
                ydir <= 1'b0;
            else if (boxy <= `vstart) 
                ydir <= 1'b1;
            if ((boxx + i_box_size) >= `hend) 
                xdir <= 1'b0;
            else if (boxx <= `hstart) 
                xdir <= 1'b1;
        end
    end
    
    // Color implementation
    always @(posedge clk) begin
        //hcount1
        if (!video_active) begin
            oblue1 <= 4'd0;
            ored1 <= 4'd0;
            ogreen1 <= 4'd0;
        end
        else if(hcount1>=boxx && hcount1<=(boxx+i_box_size) && vcount>=boxy && vcount<=(boxy+i_box_size)) begin
            case (state)
                2'b00: begin
                    //red
                    oblue1 <= 4'd0;
                    ogreen1 <= 4'd0;
                    ored1 <= 4'd15;
                end
                2'b01: begin
                    //green
                    oblue1 <= 4'd0;
                    ogreen1 <= 4'd15;
                    ored1 <= 4'd0;
                end 
                2'b10: begin
                    //blue
                    oblue1 <= 4'd15;
                    ogreen1 <= 4'd0;
                    ored1 <= 4'd0;
                end
                2'b11: begin
                    //black
                    oblue1 <= 4'd0;
                    ogreen1 <= 4'd0;
                    ored1 <= 4'd0;
                end 
            endcase
        end
        else begin
            oblue1 <= 4'd15;
            ored1 <= 4'd15;
            ogreen1 <= 4'd15;
        end

        //hcount2
        if (!video_active) begin
            oblue2 <= 4'd0;
            ored2 <= 4'd0;
            ogreen2 <= 4'd0;
        end
        else if(hcount2>=boxx && hcount2<=(boxx+i_box_size) && vcount>=boxy && vcount<=(boxy+i_box_size)) begin
            case (state)
                2'b00: begin
                    //red
                    oblue2 <= 4'd0;
                    ogreen2 <= 4'd0;
                    ored2 <= 4'd15;
                end
                2'b01: begin
                    //green
                    oblue2 <= 4'd0;
                    ogreen2 <= 4'd15;
                    ored2 <= 4'd0;
                end 
                2'b10: begin
                    //blue
                    oblue2 <= 4'd15;
                    ogreen2 <= 4'd0;
                    ored2 <= 4'd0;
                end
                2'b11: begin
                    //black
                    oblue2 <= 4'd0;
                    ogreen2 <= 4'd0;
                    ored2 <= 4'd0;
                end 
            endcase
        end
        else begin
            oblue2 <= 4'd15;
            ored2 <= 4'd15;
            ogreen2 <= 4'd15;
        end
    end
    assign red1 = ored1;
    assign blue1 = oblue1;
    assign green1 = ogreen1;

    assign red2 = ored2;
    assign blue2 = oblue2;
    assign green2 = ogreen2;
    
endmodule
