`timescale 1ns / 1ps
module dingcen(clk,rst,switch,an,vsync,hsync,disp_RGB);
input clk;
input rst;
input [1:0] switch;
input an;
output vsync;
output hsync;
output [2:0] disp_RGB;
wire vsync;
wire [9:0]site_x1;
wire [9:0]site_y1;
wire [9:0]ball_x1;
wire [9:0]ball_y1;
//wire anxia;
vga U0(.clk(clk),.switch(switch),.disp_RGB(disp_RGB),.hsync(hsync),.vsync(vsync),.site_x1(site_x1),.site_y1(site_y1),.ball_x1(ball_x1),.ball_y1(ball_y1));
hooktry3 U1(.clk(clk),.rst(rst),.vsync(vsync),.site_x1(site_x1),.site_y1(site_y1),.ball_x1(ball_x1),.ball_y1(ball_y1));
endmodule
