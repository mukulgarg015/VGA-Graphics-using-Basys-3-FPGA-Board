`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2019 16:50:46
// Design Name: 
// Module Name: top_VGA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


    module main(
    input clk_100M,
    input clear,

    input game_on,
    input game_start,
    output  H_sync,
    output  V_sync,
    output  [3:0] VGA_r,
    output  [3:0] VGA_g,
    output  [3:0] VGA_b

    //output game_startd
    );
    wire clk_65M;
     clk_wiz_0 clean_clk
   (
    // Clock out ports
    .clk_65M(clk_65M),     // output clk_65M
   // Clock in ports
    .clk_100M(clk_100M)); 
    
    wire clk_250H;
    
    clk_div #(.COUNT_DIV(50)) clk1(.clear(clear),.clk_in(clk_100M),.clk_div(clk_250H));
   

    wire game_startd;

    wire [16:0] H_cnt,V_cnt;
    wire Vid_on;
  vga_ctrl v1(.clk_65M(clk_65M),.clear(clear),.H_sync(H_sync),.V_sync(V_sync),.H_cnt(H_cnt),.V_cnt(V_cnt),.Vid_on(Vid_on)); 
 
wire [19:0] x1,x2,y1,y2;
assign x1=20'd200;
assign x2=20'd800;
assign y1=20'd200;
assign y2=20'd400;

    vga_game v2(.x1(x1),.x2(x2),.y1(y1),.y2(y2),.clk_65M(clk_65M),.clear(clear),.game_on(game_on),.game_startd(game_start),
    .vid_on(Vid_on),.H_count(H_cnt),.V_count(V_cnt),.VGA_red(VGA_r),.VGA_blue(VGA_b),.VGA_green(VGA_g));
    

endmodule
