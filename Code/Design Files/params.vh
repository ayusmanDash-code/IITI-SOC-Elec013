`ifndef paramsvh
`define paramsvh

// horizontal data 
`define hsync_val 44
`define hback 148
`define hactive 1920
`define hfront 88
`define htotal 2200
// addressable video horizontal
`define hstart 192
`define hend 2112

// vertical data
`define vsync_val 5
`define vback 36
`define vactive 1080
`define vfront 4
// addressable video vertical
`define vstart 41
`define vend 1121
`define vtotal 1125
//speed
`define speed 5

`endif




// `ifndef paramsvh
// `define paramsvh

// // horizontal data 
// `define hsync_val 96
// `define hback 48
// `define hactive 640
// `define hfront 16
// `define htotal 800

// // addressable video horizontal
// // hstart = hsync_val + hback (96 + 48 = 144)
// `define hstart 144
// // hend = hstart + hactive (144 + 640 = 784)
// `define hend 784


// // vertical data
// `define vsync_val 2
// `define vback 33
// `define vactive 480
// `define vfront 10
// `define vtotal 525

// // addressable video vertical
// // vstart = vsync_val + vback (2 + 33 = 35)
// `define vstart 35
// // vend = vstart + vactive (35 + 480 = 515)
// `define vend 515

// //speed (5 is fine, but the box will move faster across the smaller screen)
// `define speed 5
// `endif