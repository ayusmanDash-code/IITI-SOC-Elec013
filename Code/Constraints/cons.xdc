## Clock and Reset
#set_property PACKAGE_PIN W5 [get_ports sys_clock]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
## Let Vivado know the physical pin is exactly 100 MHz
#create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports sys_clock]

#set_property PACKAGE_PIN U18 [get_ports reset]
#set_property IOSTANDARD LVCMOS33 [get_ports reset]

## HSYNC and VSYNC
#set_property PACKAGE_PIN P19 [get_ports ddr_hsynq_out_0]
#set_property IOSTANDARD LVCMOS33 [get_ports ddr_hsynq_out_0]
#set_property PACKAGE_PIN R19 [get_ports ddr_vsynq_out_0]
#set_property IOSTANDARD LVCMOS33 [get_ports ddr_vsynq_out_0]

## VGA Red (Mapping top 4 bits: 7, 6, 5, 4)
#set_property PACKAGE_PIN N19 [get_ports {ddr_red_out_0[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[7]}]
#set_property PACKAGE_PIN J19 [get_ports {ddr_red_out_0[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[6]}]
#set_property PACKAGE_PIN H19 [get_ports {ddr_red_out_0[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[5]}]
#set_property PACKAGE_PIN G19 [get_ports {ddr_red_out_0[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[4]}]

## VGA Blue (Mapping top 4 bits)
#set_property PACKAGE_PIN J18 [get_ports {ddr_blue_out_0[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[7]}]
#set_property PACKAGE_PIN K18 [get_ports {ddr_blue_out_0[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[6]}]
#set_property PACKAGE_PIN L18 [get_ports {ddr_blue_out_0[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[5]}]
#set_property PACKAGE_PIN N18 [get_ports {ddr_blue_out_0[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[4]}]

## VGA Green (Mapping top 4 bits)
#set_property PACKAGE_PIN D17 [get_ports {ddr_green_out_0[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[7]}]
#set_property PACKAGE_PIN G17 [get_ports {ddr_green_out_0[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[6]}]
#set_property PACKAGE_PIN H17 [get_ports {ddr_green_out_0[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[5]}]
#set_property PACKAGE_PIN J17 [get_ports {ddr_green_out_0[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[4]}]




# Clock and Reset
set_property PACKAGE_PIN W5 [get_ports sys_clock]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
# Let Vivado know the physical pin is exactly 100 MHz

set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# HSYNC and VSYNC
set_property PACKAGE_PIN P19 [get_ports ddr_hsynq_out_0]
set_property IOSTANDARD LVCMOS33 [get_ports ddr_hsynq_out_0]
set_property PACKAGE_PIN R19 [get_ports ddr_vsynq_out_0]
set_property IOSTANDARD LVCMOS33 [get_ports ddr_vsynq_out_0]

# VGA Red (Mapping top 4 bits: 7, 6, 5, 4)
set_property PACKAGE_PIN N19 [get_ports {ddr_red_out_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[3]}]
set_property PACKAGE_PIN J19 [get_ports {ddr_red_out_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[2]}]
set_property PACKAGE_PIN H19 [get_ports {ddr_red_out_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[1]}]
set_property PACKAGE_PIN G19 [get_ports {ddr_red_out_0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_red_out_0[0]}]

# VGA Blue (Mapping top 4 bits)
set_property PACKAGE_PIN J18 [get_ports {ddr_blue_out_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[3]}]
set_property PACKAGE_PIN K18 [get_ports {ddr_blue_out_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[2]}]
set_property PACKAGE_PIN L18 [get_ports {ddr_blue_out_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[1]}]
set_property PACKAGE_PIN N18 [get_ports {ddr_blue_out_0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_blue_out_0[0]}]

# VGA Green (Mapping top 4 bits)
set_property PACKAGE_PIN D17 [get_ports {ddr_green_out_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[3]}]
set_property PACKAGE_PIN G17 [get_ports {ddr_green_out_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[2]}]
set_property PACKAGE_PIN H17 [get_ports {ddr_green_out_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[1]}]
set_property PACKAGE_PIN J17 [get_ports {ddr_green_out_0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ddr_green_out_0[0]}]

