`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2019 06:40:43 PM
// Design Name: 
// Module Name: vga_game
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


module vga_game(
    input pause,
    input [19:0] x2,
    input [19:0] y1,
    input [19:0] y2,
    input [19:0] x1,
    input clk_65M,
    input clear,
    input vid_on,
    input game_on,
    input game_startd,
    input [16:0] H_count,
    input [16:0] V_count,
    output reg [3:0] VGA_red,
    output reg [3:0] VGA_green,
    output reg [3:0] VGA_blue
    );
    
    parameter HPIXELS=1344; //PIXELS IN HORIZONTAL LINE
    parameter VLINES=806; //PIXELS IN VERTICAL LINE
    parameter HBP=296; //AT WHICH BACK PORCH ENDS
    parameter HFP=1320; //AT WHICH DISPLAY ENDS AND FRONT PORCH STARTS
    parameter VBP=35;
    parameter VFP=803;
    parameter HSP=136;
    parameter VSP=6;
    parameter HSCREEN=1024;
    parameter VSCREEN=768;
    
    
    wire [20:0] delta_x,delta_y;
    wire signed [20:0]p1;
    
    reg signed [60:0] p_reg;
    reg signed [60:0] p_next;
    reg [60:0] x_reg,x_next,
    y_reg,y_next,count,count_next;
    
    assign delta_x=x2-x1;
    assign delta_y=y2-y1;
    assign p1 = 2*delta_y - delta_x;  
    
    reg [2:0] ps; 
    reg [2:0] ns;
    parameter reset=3'b000;
    parameter start=3'b001;
    parameter check=3'b010;
    parameter c1=3'b011;
    parameter c2=3'b100;
    //////////////////////////////////////////////////////////////////////////
    reg line_on;
    
    
    always @(*)
    begin
        if(((H_count<= x_reg + 2 + HBP)&&(H_count>= x_reg - 2 + HBP)) && ((V_count<= y_reg + 2 + VBP) &&(V_count >= y_reg - 2 + VBP)))
        line_on=1;
        else
        line_on=0;
    end
  
  ///////////////////////////////////////////////////////////////////////////  
   
    always @ (posedge clk_65M)
    begin
    if (clear)
    ps <= reset;
    else
    ps <= ns;
    end
    
    always @(*)
    begin
    ns=ps;
    case (ps)
  
    reset: 
    
    if (game_startd)
    ns<=start;
    else 
    ns<=reset;
    
    start :
    
    if (count==5'd31)
    ns<= check;
    else
    ns<=start;
    
    check:
    
    if (x_reg > x2)
    ns<=start;
    else if ((p_reg <0) && (x_reg <=x2))
    ns <= c1;
    else if ((p_reg >=0) && (x_reg <=x2))
    ns<= c2;
    else 
    ns<= check;
    
    
    c1:
    ns<=check;
    
    
    c2:
    ns<= check;
    
    default:
    ns<=reset;
    
    endcase
    end

    ///////////////////////////////////////////////////////////////////
    
    always @ (posedge clk_65M)
    begin
    count <=count_next;
    end
    
    always @(*)
    begin
    count_next=count;
    if (clear)
    count_next<=0;
    else if (count == 5'd31)
    count_next <= 0;
    else
    count_next <=count+ 1;
    end
    
  
    always @(posedge clk_65M)
    begin
    if (clear )
    begin
    x_reg <= x1;
    y_reg <= y1;
    end
   
    else 
    begin
    x_reg <= x_next;
    y_reg <= y_next;
    end
    
    end
    
    always @(*)
    begin
    
     if (ps == (reset || start))
     begin
     x_next <= x1;
     y_next <=  y1;
     end
     
     else if (ps == check)
     begin
     x_next <= x_reg ;
     y_next <= y_reg ;
     end
     
     else if (ps == c1)
     begin
     x_next <= x_reg + 20'd1;
     y_next <= y_reg ;
     end
     
     else if (ps == c2 )
     begin
     x_next <= x_reg + 20'd1;
     y_next <= y_reg + 20'd1 ;
     end
     
     end
     ////////////////////////////////////////////////////////////////////////////
     
     always @ (posedge clk_65M)
     begin
     if (clear)
     p_reg <=p1;
     else
     p_reg <= p_next;
     end
     
     
     always @(*)
     begin
 
    if (ps == (reset || start))
    p_next<=p1;
    
    else if (ps==c1)
    p_next <= p_reg + 20'd2*delta_y;
     
     else if (ps==c2)
    p_next <= p_reg + 20'd2*delta_y - 20'd2*delta_x ;
    
    
    else if (ps== check)
    p_next <= p_reg ;
    
    end
    
  
 //////color////

always @(*)
    begin
        VGA_red=4'b0000;
        VGA_green=4'b0000;
        VGA_blue=4'b0000;
         
    if(vid_on==1 && game_on==1 && line_on && game_startd)
        begin
            VGA_red=4'b1111;
            VGA_green=4'b1111;
            VGA_blue=4'b1111;
        end
       
         
       else if (vid_on==1 && game_on==1)
        begin
            VGA_red=4'b0000;
            VGA_green=4'b0000;
            VGA_blue=4'b0000;
        end
         
     
  end
        
endmodule
