// `timescale 1ns/1ps
// `include "params.vh"

// // ============================================================
// //  tb_blogic_fixed.v  —  Vivado-compatible bounce testbench
// //
// //  Fix: removed 'automatic' task keyword.
// //       force/release now use module-level regs (t_boxx etc.)
// //       so Vivado's procedural-continuous-assignment restriction
// //       is satisfied.
// // ============================================================


// module tb_blogic_fixed;

//     // ----------------------------------------------------------
//     // Mirror params.vh as localparams
//     // ----------------------------------------------------------
//     localparam HTOTAL   = `htotal;   
//     localparam VTOTAL   = `vtotal;   
//     localparam HSTART   = `hstart;   
//     localparam HEND     = `hend;     
//     localparam VSTART   = `vstart;   
//     localparam VEND     = `vend;     
//     localparam BOXSIZE  = 50;

//     // Cycles to guarantee one full frame trigger fires
//     localparam integer FRAME_CYCLES = (HTOTAL + 1) * (VTOTAL + 1);

//     // ----------------------------------------------------------
//     // DUT signals
//     // ----------------------------------------------------------
//     reg  clk = 0;
//     wire hsynq, vsynq;
//     wire [7:0] red, green, blue;

//     block1 uut (
//         .clk   (clk),
//         .hsynq (hsynq),
//         .vsynq (vsynq),
//         .red   (red),
//         .green (green),
//         .blue  (blue)
//     );

//     // ----------------------------------------------------------
//     // Free-running clock (4 ns period)
//     // ----------------------------------------------------------
//     always #2 clk = ~clk;

//     // ----------------------------------------------------------
//     // Module-level staging regs used by force/release
//     // (Vivado requires force targets to be module-level signals)
//     // ----------------------------------------------------------
//     reg [15:0] t_boxx, t_boxy;
//     reg        t_xdir, t_ydir;

//     // Saved init values for pass/fail checks after task returns
//     reg [15:0] s_boxx, s_boxy;
//     reg        s_xdir, s_ydir;
    
//     // ----------------------------------------------------------
//     // Task — NO 'automatic', inputs copied to module-level regs
//     // ----------------------------------------------------------
//     task test_edge;
//         input [15:0] init_boxx;
//         input [15:0] init_boxy;
//         input        init_xdir;
//         input        init_ydir;
//         input [8*20-1:0] label;   // up to 20-char string
//         begin
//             // Copy inputs to module-level regs so force can use them
//             t_boxx = init_boxx;
//             t_boxy = init_boxy;
//             t_xdir = init_xdir;
//             t_ydir = init_ydir;

//             // Save for pass/fail check later
//             s_boxx = init_boxx;
//             s_boxy = init_boxy;
//             s_xdir = init_xdir;
//             s_ydir = init_ydir;

//             // Apply forced values
//             force uut.boxx = t_boxx;
//             force uut.boxy = t_boxy;
//             force uut.xdir = t_xdir;
//             force uut.ydir = t_ydir;

//             // One posedge to latch them in
//             @(posedge clk); #1;

//             // Hand control back to DUT
//             release uut.boxx;
//             release uut.boxy;
//             release uut.xdir;
//             release uut.ydir;

//             $display("\n====  %0s  ====", label);
//             $display("  BEFORE : boxx=%0d  boxy=%0d  xdir=%b  ydir=%b",
//                      uut.boxx, uut.boxy, uut.xdir, uut.ydir);

//             // Wait one full frame so the htotal-1/vtotal-1 trigger fires
//             repeat (FRAME_CYCLES) @(posedge clk);
//             #1;

//             $display("  AFTER  : boxx=%0d  boxy=%0d  xdir=%b  ydir=%b",
//                      uut.boxx, uut.boxy, uut.xdir, uut.ydir);

//             // ---- Pass/Fail checks ----
//             if (s_xdir == 1 && (s_boxx + BOXSIZE) >= HEND) begin
//                 if (uut.xdir !== 1'b0)
//                     $display("  [FAIL] RIGHT edge: xdir did NOT flip to 0");
//                 else
//                     $display("  [PASS] RIGHT edge: xdir flipped to 0 correctly");
//             end

//             if (s_xdir == 0 && s_boxx <= HSTART) begin
//                 if (uut.xdir !== 1'b1)
//                     $display("  [FAIL] LEFT edge: xdir did NOT flip to 1");
//                 else
//                     $display("  [PASS] LEFT edge: xdir flipped to 1 correctly");
//             end

//             if (s_ydir == 1 && (s_boxy + BOXSIZE) >= VEND) begin
//                 if (uut.ydir !== 1'b0)
//                     $display("  [FAIL] BOTTOM edge: ydir did NOT flip to 0");
//                 else
//                     $display("  [PASS] BOTTOM edge: ydir flipped to 0 correctly");
//             end

//             if (s_ydir == 0 && s_boxy <= VSTART) begin
//                 if (uut.ydir !== 1'b1)
//                     $display("  [FAIL] TOP edge: ydir did NOT flip to 1");
//                 else
//                     $display("  [PASS] TOP edge: ydir flipped to 1 correctly");
//             end
//         end
//     endtask

//     // ----------------------------------------------------------
//     // Simulation driver
//     // ----------------------------------------------------------
//     initial begin
//         $dumpfile("tb_blogic_fixed.vcd");
//         $dumpvars(0, tb_blogic_fixed);

//         // Allow DUT to initialise
//         repeat(10) @(posedge clk);

//         // Test 1 — RIGHT edge (xdir=1 → should flip to 0)
//         test_edge(HEND-BOXSIZE, VSTART+100, 1'b1, 1'b1, "RIGHT EDGE");

//         // Test 2 — LEFT edge (xdir=0 → should flip to 1)
//         test_edge(HSTART, VSTART+100, 1'b0, 1'b1, "LEFT EDGE");

//         // Test 3 — BOTTOM edge (ydir=1 → should flip to 0)
//         test_edge(HSTART+100, VEND-BOXSIZE, 1'b1, 1'b1, "BOTTOM EDGE");

//         // Test 4 — TOP edge (ydir=0 → should flip to 1)
//         test_edge(HSTART+100, VSTART, 1'b1, 1'b0, "TOP EDGE");

//         // Test 5 — BOTTOM-RIGHT corner (both flip)
//         test_edge(HEND-BOXSIZE, VEND-BOXSIZE, 1'b1, 1'b1, "BOTTOM-RIGHT CORNER");

//         // Test 6 — TOP-LEFT corner (both flip)
//         test_edge(HSTART, VSTART, 1'b0, 1'b0, "TOP-LEFT CORNER");

//         $display("\n=== All bounce tests complete ===\n");
//         $finish;
//     end

// endmodule






`timescale 1ns/1ps
`include "params.vh"


module tb_bounce_fast;

    // -------------------------------------------------------
    //  Mirror params.vh as localparams
    // -------------------------------------------------------
    localparam HTOTAL  = `htotal;      // 2200
    localparam VTOTAL  = `vtotal;      // 1125
    localparam HSTART  = `hstart;      // 192
    localparam HEND    = `hend;        // 2112
    localparam VSTART  = `vstart;      // 41
    localparam VEND    = `vend;        // 1121
    localparam SPEED   = `speed;       // 5
    localparam BOXSIZE = 50;

    // -------------------------------------------------------
    //  DUT
    // -------------------------------------------------------
    reg  clk = 0;
    wire hsynq, vsynq;
    wire [7:0] red, green, blue;

    block1 uut (
        .clk   (clk),
        .hsynq (hsynq),
        .vsynq (vsynq),
        .red   (red),
        .green (green),
        .blue  (blue)
    );

    // 4 ns period clock
    always #2 clk = ~clk;

    // -------------------------------------------------------
    //  Module-level staging regs
    //  (Vivado requires force targets to be module-level)
    // -------------------------------------------------------
    reg [15:0] t_boxx, t_boxy;
    reg        t_xdir, t_ydir;

    integer pass_count = 0;
    integer fail_count = 0;

    // -------------------------------------------------------
    //  Trigger one frame-end event without simulating full frame
    //
    //  Works by:
    //   step 1 - force hcount/vcount to (htotal-1)/(vtotal-1)
    //   step 2 - one posedge fires the bounce always block
    //   step 3 - release so DUT counters are free again
    // -------------------------------------------------------
    task trigger_frame_end;
        begin
            force uut.inst1.hcount = HTOTAL - 1;
            force uut.inst2.vcount = VTOTAL - 1;
            // Also force enable so v_count sees its enable=1
            force uut.enable       = 1'b1;

            @(posedge clk); #1;   // bounce logic fires here

            release uut.inst1.hcount;
            release uut.inst2.vcount;
            release uut.enable;

            // let DUT settle one more cycle before we read outputs
            @(posedge clk); #1;
        end
    endtask

    // -------------------------------------------------------
    //  Core test task
    //  Sets DUT internal state, fires one frame-end, checks result
    // -------------------------------------------------------
    task test_bounce;
        input [15:0] init_boxx;
        input [15:0] init_boxy;
        input        init_xdir;
        input        init_ydir;
        input [8*30-1:0] label;   // up to 30-char string
        // expected direction after bounce
        input exp_xdir;
        input exp_ydir;

        reg [15:0] pre_boxx, pre_boxy;
        reg        pre_xdir, pre_ydir;
        begin
            // ---- 1. Inject state ----
            force uut.boxx = init_boxx;
            force uut.boxy = init_boxy;
            force uut.xdir = init_xdir;
            force uut.ydir = init_ydir;
            @(posedge clk); #1;
            release uut.boxx;
            release uut.boxy;
            release uut.xdir;
            release uut.ydir;

            // ---- 2. Capture pre state ----
            pre_boxx = uut.boxx;
            pre_boxy = uut.boxy;
            pre_xdir = uut.xdir;
            pre_ydir = uut.ydir;

            // ---- 3. Trigger the bounce logic ----
            trigger_frame_end;

            // ---- 4. Display & check ----
            $display("\n==== %0s ====", label);
            $display("  PRE  : boxx=%4d  boxy=%4d  xdir=%b  ydir=%b",
                      pre_boxx, pre_boxy, pre_xdir, pre_ydir);
            $display("  POST : boxx=%4d  boxy=%4d  xdir=%b  ydir=%b",
                      uut.boxx, uut.boxy, uut.xdir, uut.ydir);

            // xdir check
            if (uut.xdir === exp_xdir) begin
                $display("  [PASS] xdir = %b (expected %b)", uut.xdir, exp_xdir);
                pass_count = pass_count + 1;
            end else begin
                $display("  [FAIL] xdir = %b  but expected %b", uut.xdir, exp_xdir);
                fail_count = fail_count + 1;
            end

            // ydir check
            if (uut.ydir === exp_ydir) begin
                $display("  [PASS] ydir = %b (expected %b)", uut.ydir, exp_ydir);
                pass_count = pass_count + 1;
            end else begin
                $display("  [FAIL] ydir = %b  but expected %b", uut.ydir, exp_ydir);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // -------------------------------------------------------
    //  Continuous waveform monitoring (visible in waveform viewer)
    // -------------------------------------------------------
    // These are wires so the waveform shows live DUT internals
    
    wire [15:0] mon_boxx = uut.boxx;
    wire [15:0] mon_boxy = uut.boxy;
    wire        mon_xdir = uut.xdir;
    wire        mon_ydir = uut.ydir;
    wire [15:0] mon_hcount = uut.inst1.hcount;
    wire [15:0] mon_vcount = uut.inst2.vcount;

    // -------------------------------------------------------
    //  Simulation driver
    // -------------------------------------------------------
    initial begin
        $dumpfile("tb_bounce_fast.vcd");
        $dumpvars(0, tb_bounce_fast);

        $display("=========================================");
        $display("  Fast Bounce Testbench");
        $display("  HTOTAL=%0d VTOTAL=%0d", HTOTAL, VTOTAL);
        $display("  HSTART=%0d HEND=%0d BOXSIZE=%0d SPEED=%0d",
                  HSTART, HEND, BOXSIZE, SPEED);
        $display("  VSTART=%0d VEND=%0d", VSTART, VEND);
        $display("=========================================");

        // Let DUT reset / initialise
        repeat(5) @(posedge clk);

        // ==================================================
        //  TEST 1 - RIGHT edge
        //  Block at right wall, moving right → xdir must flip to 0
        // ==================================================
        test_bounce(
            HEND - BOXSIZE,     // boxx: right edge, box just touching hend
            VSTART + 200,       // boxy: mid-screen vertically
            1'b1,               // xdir: moving right
            1'b1,               // ydir: moving down
            "TEST 1: RIGHT EDGE (xdir 1->0)",
            1'b0,               // expected xdir after bounce
            1'b1                // ydir unchanged
        );

        // ==================================================
        //  TEST 2 - LEFT edge
        //  Block at left wall, moving left → xdir must flip to 1
        // ==================================================
        test_bounce(
            HSTART,             // boxx: at left wall
            VSTART + 200,
            1'b0,               // xdir: moving left
            1'b1,
            "TEST 2: LEFT EDGE  (xdir 0->1)",
            1'b1,               // expected xdir after bounce
            1'b1
        );

        // ==================================================
        //  TEST 3 - BOTTOM edge
        //  Block at bottom wall, moving down → ydir must flip to 0
        // ==================================================
        test_bounce(
            HSTART + 300,
            VEND - BOXSIZE,     // boxy: bottom wall
            1'b1,
            1'b1,               // ydir: moving down
            "TEST 3: BOTTOM EDGE (ydir 1->0)",
            1'b1,
            1'b0                // expected ydir after bounce
        );

        // ==================================================
        //  TEST 4 - TOP edge
        //  Block at top wall, moving up → ydir must flip to 1
        // ==================================================
        test_bounce(
            HSTART + 300,
            VSTART,             // boxy: at top wall
            1'b1,
            1'b0,               // ydir: moving up
            "TEST 4: TOP EDGE   (ydir 0->1)",
            1'b1,
            1'b1                // expected ydir after bounce
        );

        // ==================================================
        //  TEST 5 - BOTTOM-RIGHT corner
        //  Both axes hit simultaneously → both dirs flip
        // ==================================================
        test_bounce(
            HEND - BOXSIZE,
            VEND - BOXSIZE,
            1'b1,
            1'b1,
            "TEST 5: BOTTOM-RIGHT CORNER (x:1->0, y:1->0)",
            1'b0,
            1'b0
        );

        // ==================================================
        //  TEST 6 - TOP-LEFT corner
        //  Both axes hit simultaneously → both dirs flip
        // ==================================================
        test_bounce(
            HSTART,
            VSTART,
            1'b0,
            1'b0,
            "TEST 6: TOP-LEFT CORNER   (x:0->1, y:0->1)",
            1'b1,
            1'b1
        );

        // ==================================================
        //  TEST 7 - TOP-RIGHT corner
        // ==================================================
        test_bounce(
            HEND - BOXSIZE,
            VSTART,
            1'b1,
            1'b0,
            "TEST 7: TOP-RIGHT CORNER  (x:1->0, y:0->1)",
            1'b0,
            1'b1
        );

        // ==================================================
        //  TEST 8 - BOTTOM-LEFT corner
        // ==================================================
        test_bounce(
            HSTART,
            VEND - BOXSIZE,
            1'b0,
            1'b1,
            "TEST 8: BOTTOM-LEFT CORNER (x:0->1, y:1->0)",
            1'b1,
            1'b0
        );

        // ==================================================
        //  TEST 9 - Mid-screen: no bounce should happen
        //  Directions must remain unchanged
        // ==================================================
        test_bounce(
            HSTART + 500,
            VSTART + 300,
            1'b1,
            1'b1,
            "TEST 9: MID-SCREEN  (no bounce, dirs unchanged)",
            1'b1,               // xdir stays 1
            1'b1                // ydir stays 1
        );

        // -------------------------------------------------------
        $display("\n=========================================");
        $display("  RESULTS:  PASS=%0d   FAIL=%0d", pass_count, fail_count);
        if (fail_count == 0)
            $display("  >>> ALL TESTS PASSED <<<");
        else
            $display("  >>> %0d TEST(S) FAILED - check bounce logic <<<", fail_count);
        $display("=========================================\n");

        $finish;
    end