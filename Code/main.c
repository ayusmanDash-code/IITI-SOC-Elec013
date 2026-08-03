#include "xparameters.h"
#include "xuartlite.h"
#include "xil_io.h"
#include "xil_printf.h"

// Set to 1 for Software Simulation (QEMU/PC). Set to 0 for Physical FPGA Hardware.
#define RUN_SIMULATION 

// Define Base Addresses for Vitis 2023.2 Unified IDE (SDT flow)
#define MYIP_BASE_ADDR     XPAR_MYIP1_0_BASEADDR
#define UARTLITE_BASE_ADDR XPAR_AXI_UARTLITE_0_BASEADDR

// Register Offset for slv_reg3 (controls video parameters via raw ASCII)
#define SLV_REG3_OFFSET    0x0C

// Global array to simulate the 4-byte aligned registers of your custom IP block
#if RUN_SIMULATION
static u32 mock_hardware_registers[4] = {0}; 
#endif

int main(void) {
    volatile int delay;
    while (1) {
        // Send 'W' (0x57) - Speed Up 
        Xil_Out32(MYIP_BASE_ADDR + SLV_REG3_OFFSET, 0x57);
        
        // Tiny delay loop (takes a few microseconds in simulation)
        for(delay = 0; delay < 100; delay++); 
        
        // Send '+' (0x2B) - Size Up
        Xil_Out32(MYIP_BASE_ADDR + SLV_REG3_OFFSET, 0x2B);
        
        for(delay = 0; delay < 100; delay++);
    }

    XUartLite UartLite;
    int Status;
    u8 ReceivedChar;

    // xil_printf("--- FPGA Keyboard Command System Initialized ---\r\n");

    // 1. Initialize the AXI UART Lite driver
    #if RUN_SIMULATION
        Status = XST_SUCCESS; // Force success in simulation
        // xil_printf("[SIM] Mock UART Driver Initialized.\r\n");
    #else
        Status = XUartLite_Initialize(&UartLite, UARTLITE_BASE_ADDR);
    #endif

    if (Status != XST_SUCCESS) {
        // xil_printf("ERROR: UART Lite Initialization Failed!\r\n");
        return XST_FAILURE;
    }

    // 2. Perform hardware self-test on UART Lite
    #if RUN_SIMULATION
        Status = XST_SUCCESS; // Force success in simulation
        // xil_printf("[SIM] Mock UART Self-Test Passed.\r\n");
    #else
        Status = XUartLite_SelfTest(&UartLite);
    #endif

    if (Status != XST_SUCCESS) {
        // xil_printf("ERROR: UART Lite Self Test Failed!\r\n");
        return XST_FAILURE;
    }

    // xil_printf("UART Initialized Successfully. Ready for Keyboard Inputs.\r\n");
    // xil_printf("Controls: \r\n");
    // xil_printf("  [W / S] Speed Up / Down\r\n");
    // xil_printf("  [+ / -] Size Increase / Decrease\r\n");
    // xil_printf("  [R / G / B] Color Selection\r\n");

    // Counter to feed different keys across simulation clock cycles
    u32 simulation_ticks = 0;

    while (1) {
        u32 bytes_received = 0;

        #if RUN_SIMULATION
            // Simulate receiving a keypress sequentially every few loop iterations
            if (simulation_ticks == 100000) {
                ReceivedChar = 'W'; // Speed up command
                bytes_received = 1;
            } else if (simulation_ticks == 200000) {
                ReceivedChar = '+'; // Size up command
                bytes_received = 1;
            } else if (simulation_ticks == 300000) {
                ReceivedChar = 'R'; // Select Red color
                bytes_received = 1;
            } else if (simulation_ticks > 400000) {
                // Terminate simulation or loop silently once verification is done
                // xil_printf("[SIM] Verification Complete. Stopping loop.\r\n");
                while(1); 
            }
            simulation_ticks++;
        #else
            // Real physical hardware non-blocking poll
            bytes_received = XUartLite_Recv(&UartLite, &ReceivedChar, 1);
        #endif
        
        if (bytes_received > 0) {
            // xil_printf("Key Received: %c (0x%02X)\r\n", ReceivedChar, ReceivedChar);

            #if RUN_SIMULATION
                // Safely route the data to our virtual register array block
                int reg_index = SLV_REG3_OFFSET / 4; // 0x0C / 4 = index 3
                mock_hardware_registers[reg_index] = (u32)ReceivedChar;
                
                // Read back the value to double-check software logic integrity
                u32 read_back = mock_hardware_registers[reg_index];
                // xil_printf("[SIM] Mock slv_reg3 memory updated to: 0x%02X\r\n\n", read_back);
            #else
                // Physical hardware out-of-order execution write
                Xil_Out32(MYIP_BASE_ADDR + SLV_REG3_OFFSET, (u32)ReceivedChar);
            #endif
        }
    }

    return XST_SUCCESS;
}