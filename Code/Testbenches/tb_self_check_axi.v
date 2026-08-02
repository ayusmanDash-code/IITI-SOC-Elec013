`timescale 1ns / 1ps

module tb_myip_axi_direct ();

    // --- Clock and Reset ---
    reg S_AXI_ACLK;
    reg S_AXI_ARESETN;

    // --- AXI-Lite Write Channels ---
    reg [3:0]  S_AXI_AWADDR;
    reg        S_AXI_AWVALID;
    wire       S_AXI_AWREADY;

    reg [31:0] S_AXI_WDATA;
    reg [3:0]  S_AXI_WSTRB;
    reg        S_AXI_WVALID;
    wire       S_AXI_WREADY;

    wire [1:0] S_AXI_BRESP;
    wire       S_AXI_BVALID;
    reg        S_AXI_BREADY;

    // --- AXI-Lite Read Channels (Tied off for this write-only test) ---
    reg [3:0]  S_AXI_ARADDR = 0;
    reg        S_AXI_ARVALID = 0;
    wire       S_AXI_ARREADY;
    wire [31:0] S_AXI_RDATA;
    wire [1:0] S_AXI_RRESP;
    wire       S_AXI_RVALID;
    reg        S_AXI_RREADY = 0;

    // --- Output Wires from IP ---
    wire [3:0] ddr_blue_out;
    wire [3:0] ddr_green_out;
    wire       ddr_hsynq_out;
    wire [3:0] ddr_red_out;
    wire       ddr_vsynq_out;

    // --- Self-Checking Variables ---
    reg check_size_pass = 1'b1;
    reg check_speed_pass = 1'b1;
    reg check_state_pass = 1'b1;
    reg all_tests_passed = 1'b1;

    // --- Clock Generation ---
    initial begin
        S_AXI_ACLK = 0;
        forever #5 S_AXI_ACLK = ~S_AXI_ACLK; // 100 MHz
    end

    // --- Instantiate the Custom AXI IP directly ---
    // Make sure the module name matches your generated IP
    myip1_v1_0_S00_AXI # (
        .C_S_AXI_DATA_WIDTH(32),
        .C_S_AXI_ADDR_WIDTH(4) // 4 bits for 4 registers
    ) uut (
        .S_AXI_ACLK(S_AXI_ACLK),
        .S_AXI_ARESETN(S_AXI_ARESETN),
        
        .S_AXI_AWADDR(S_AXI_AWADDR),
        .S_AXI_AWPROT(3'b000),
        .S_AXI_AWVALID(S_AXI_AWVALID),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        
        .S_AXI_WDATA(S_AXI_WDATA),
        .S_AXI_WSTRB(S_AXI_WSTRB),
        .S_AXI_WVALID(S_AXI_WVALID),
        .S_AXI_WREADY(S_AXI_WREADY),
        
        .S_AXI_BRESP(S_AXI_BRESP),
        .S_AXI_BVALID(S_AXI_BVALID),
        .S_AXI_BREADY(S_AXI_BREADY),
        
        .S_AXI_ARADDR(S_AXI_ARADDR),
        .S_AXI_ARPROT(3'b000),
        .S_AXI_ARVALID(S_AXI_ARVALID),
        .S_AXI_ARREADY(S_AXI_ARREADY),
        
        .S_AXI_RDATA(S_AXI_RDATA),
        .S_AXI_RRESP(S_AXI_RRESP),
        .S_AXI_RVALID(S_AXI_RVALID),
        .S_AXI_RREADY(S_AXI_RREADY),
        
        // Custom Ports
        .ddr_hsynq_out(ddr_hsynq_out),
        .ddr_vsynq_out(ddr_vsynq_out),
        .ddr_red_out(ddr_red_out),
        .ddr_blue_out(ddr_blue_out),
        .ddr_green_out(ddr_green_out)
    );

    // reg [15:0] i_box_size = 16'd50;
    // reg [15:0] i_box_speed = 16'd3;
    // reg [1:0] state = 2'b00;
    // ddr_display dut (
    //     .clk_half(S_AXI_ACLK),
    //     .i_box_size(i_box_size),
    //     .i_box_speed(i_box_speed),
    //     .state(state),
    //     .ddr_hsynq(ddr_hsynq_out),
    //     .ddr_vsynq(ddr_vsynq_out),
    //     .ddr_red(ddr_red_out),
    //     .ddr_blue(ddr_blue_out),
    //     .ddr_green(ddr_green_out)
    // );

    // --- AXI Write Task ---
    // Simulates the processor writing data to a memory-mapped register
    
    task axi_write;
        input [3:0]  addr;
        input [31:0] data;
        begin
            @(posedge S_AXI_ACLK);
            // Initiate Write Address and Data
            S_AXI_AWADDR  <= addr;
            S_AXI_AWVALID <= 1'b1;
            S_AXI_WDATA   <= data;
            S_AXI_WSTRB   <= 4'hF; // Write all 4 bytes
            S_AXI_WVALID  <= 1'b1;

            // Wait for Slave to assert READY signals
            wait(S_AXI_AWREADY && S_AXI_WREADY);
            @(posedge S_AXI_ACLK);
            
            // Deassert VALID signals
            S_AXI_AWVALID <= 1'b0;
            S_AXI_WVALID  <= 1'b0;

            // Wait for Write Response (B-Channel)
            S_AXI_BREADY  <= 1'b1;
            wait(S_AXI_BVALID);
            @(posedge S_AXI_ACLK);
            S_AXI_BREADY  <= 1'b0;
            
            // Small delay between transactions
            #20; 
        end
    endtask

    // --- Main Simulation Block ---
    initial begin
        // 1. Initialize Signals
        S_AXI_ARESETN = 0;
        S_AXI_AWADDR  = 0;
        S_AXI_AWVALID = 0;
        S_AXI_WDATA   = 0;
        S_AXI_WSTRB   = 0;
        S_AXI_WVALID  = 0;
        S_AXI_BREADY  = 0;

        // 2. Apply Reset
        #10;
        S_AXI_ARESETN = 1;
        #10;
        
        $display("=====================================================");
        $display("[%0t] Starting AXI Direct Simulation...", $time);
        
        // Note: index 3 (slv_reg3) shifted by 2 bytes (ADDR_LSB) = address offset 0x0C
        
        // 3. Send 'W' (Increase Speed) -> ASCII 8'h57
        $display("[%0t] Writing 'W' to slv_reg3 (Offset 0x0C)...", $time);
        axi_write(4'hC, 32'h00000057);

        // 4. Send '+' (Increase Size) -> ASCII 8'h2B
        $display("[%0t] Writing '+' to slv_reg3 (Offset 0x0C)...", $time);
        axi_write(4'hC, 32'h0000002B);

        // 5. Send 'B' (Blue Color) -> ASCII 8'h42 (Testing state change to 1)
        $display("[%0t] Writing 'B' to slv_reg3 (Offset 0x0C)...", $time);
        axi_write(4'hC, 32'h00000042);
        
        #50;

        $display("========================================");
        $display("   STARTING SELF-CHECK VERIFICATION     ");
        $display("========================================");

        // 6. Verification Checks (Directly access uut.xxx)
        // Check Speed (Default was 5, should now be 6)
        if (uut.internal_box_speed == 16'd6) begin
            $display("[PASS] Speed updated successfully.");
            check_speed_pass = 1'b1;
        end else begin
            $display("[FAIL] Speed mismatch! Expected: 6, Got: %0d", uut.internal_box_speed);
            check_speed_pass = 1'b0;
        end

        // Check Size (Default was 50, +10 should be 60)
        if (uut.internal_box_size == 16'd60) begin
            $display("[PASS] Size updated successfully.");
            check_size_pass = 1'b1;
        end else begin
            $display("[FAIL] Size mismatch! Expected: 60, Got: %0d", uut.internal_box_size);
            check_size_pass = 1'b0;
        end

        // Check State/Color (Should be 1 for Blue)
        if (uut.internal_box_color == 2'b01) begin
            $display("[PASS] State/Color updated successfully.");
            check_state_pass = 1'b1;
        end else begin
            $display("[FAIL] State mismatch! Expected: 1, Got: %0d", uut.internal_box_color);
            check_state_pass = 1'b0;
        end

        // 7. Final Verdict
        all_tests_passed = check_size_pass & check_speed_pass & check_state_pass;
        
        $display("========================================");
        if (all_tests_passed)
            $display("   SIMULATION VERDICT: ALL PASS         ");
        else
            $display("   SIMULATION VERDICT: FAILED           ");
        $display("========================================");

        $finish;
    end
endmodule