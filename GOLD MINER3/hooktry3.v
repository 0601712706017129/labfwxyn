`timescale 1ns / 1ps
module hooktry3(clk,rst,vsync,site_x1,site_y1,defen,ball_x1,ball_y1);
   //还需要改写成顶层模块的形式(寄存器的位数未定****************************）
 input clk;
 input rst;
 input vsync;
 output defen;
 output reg[9:0]ball_x1=450;
 output reg[9:0]ball_y1=350;

 reg [31:0]clk_cnt;
 reg an_last;//??????????????????????????????
 reg anxia=1;
 reg defen=0;
 reg  RORL=1;
output reg [9:0]site_x1=450;
output reg [9:0]site_y1=120;
reg xlength=4;//位数*************************
reg ylength=4;
reg xlength1;
reg ylength1;
reg pengdao=0;
reg cha;//?????????????????????????????????????
reg [2:0] pengnum;
reg [9:0]site_x1pre=450;
reg [9:0]site_y1pre=119;
reg [2:0] data;
reg clk_50M;
reg clk_25M;
integer i;
integer k;
parameter site_x0=450;
parameter site_y0=50;
parameter hook_r=10;
reg [1:0] type[5:0];
    initial begin
    type[0]=2'b11;//碰到边界处，类型设为2'b11
    type[1]=2'b01;//黄金，石头，钻石的分类
    type[2]=2'b01;
    type[3]=2'b01;
    type[4]=2'b00;
    type[5]=2'b00;
    type[6]=2'b10;
    end
 reg [9:0] ball_x_pos[6:0];
        initial begin
        ball_x_pos[1]=450;//500
        ball_x_pos[2]=200;
        ball_x_pos[3]=600;
        ball_x_pos[4]=400;
        ball_x_pos[5]=700;
        ball_x_pos[6]=600;
        end
   reg [9:0] ball_y_pos[6:0];
        initial begin
        ball_y_pos[1]=350;//500
        ball_y_pos[2]=300;
        ball_y_pos[3]=300;
        ball_y_pos[4]=400;
        ball_y_pos[5]=400;
        ball_y_pos[6]=200;
        end
   reg [5:0] ball_r [6:0];
        initial begin
        ball_r[1]=10;
        ball_r[2]=30;
        ball_r[3]=30;
        ball_r[4]=20;
        ball_r[5]=20;
        ball_r[6]=20;
        end
/*	always@(posedge clk or negedge rst) begin
            if(!rst) begin
                clk_cnt <= 0;
                anxia<=0;
                an_last<=0;                
            end    
            else begin
            if(clk_cnt == 5_0000) begin
                    clk_cnt <= 0;
                    an_last<=an;
                    if(an_last == 0 && an == 1) 
                    begin
                    anxia<=1;
                    end
                    end                        
                else begin
                    clk_cnt <= clk_cnt + 1;
                    
                end
            end    
        end    */
always @(posedge clk)
begin
clk_50M = ~clk_50M;
end


//always@(posedge vsync) begin

//end

always@(posedge vsync ) begin
//按键检测模块，只要检测到一次按键，anxia就变为1，一直存着，到下个VS上升沿到来时检测到anxia=1，进入相应模块，直到最后钩子返回原位才将anxia置为0，下一次VS到来时重新进入初始摆动模块，一直执行，直到再一次有按键按下，将anxiaz置为1
//钩子初始摆动

 //检测到按键按下，anxia=1;
 //对碰到的值为0或者1的处理
 if( !anxia ) begin 
if (RORL) begin//钩子向右摆动
            site_x1<= site_x1+1;
            if (site_x1>500) 
            begin
			RORL=0;
			end
          end//钩子向右摆动处理完毕
else if(!RORL) 
begin//钩子向左摆动
			site_x1<= site_x1-1;
			if (site_x1<400) begin
				RORL=1;
			end
			
end
end

 if(site_x1>150&&site_x1<750&&site_y1<400&&(site_y1>site_y1pre)) begin//未碰到边界
   for(i=1;i<=6;i=i+1)
  if(((site_x1-ball_x_pos[i])*(site_x1-ball_x_pos[i])+(site_y1-ball_y_pos[i])*(site_y1-ball_y_pos[i]))<((hook_r+ball_r[i])*(hook_r+ball_r[i])))//检测有没有碰到石块，金子，钻石
  begin
  pengdao<=1;pengnum<=i;
  end
  else
  pengdao<=0;
  end
  else if(site_x1<=150|site_x1>=750|site_y1>=400|(site_y1<site_y1pre))begin//碰到边界
  pengdao<=1;
  pengnum<=0;//此时不对矿物做处理
  end//检测有没有碰到矿物完毕
 if(anxia&&!pengdao)//出钩
  begin
  //xlength<=site_x1-site_x1pre;
 // site_x1pre<=site_x1;
  //site_x1<= site_x1+xlength;
  site_y1pre<=site_y1;
  site_y1<=site_y1+1;
  end//对pengdao的值为0处理完毕
  else if(anxia&&pengdao)  //pengdao=1;
  begin
  
  //对pengdao值为1处理完毕
  //对pengdao值整体处理完毕
  //开始处理回钩
  if(site_y1>120)
  begin
  //site_x1<= site_x1-xlength1;
  site_y1pre<=site_y1;
  site_y1<=site_y1-1; 
  //y1-ylength     //到320时不再减，钩子返回原处，还要写一个跳回初始状态的函数     
  //ball_x_pos[pengnum]<= ball_x_pos[pengnum]-xlength1;
  ball_y_pos[pengnum]<= ball_y_pos[pengnum]-1;//ylength1;
  
 case(pengnum) 
   1: ball_y1<=ball_y_pos[1];
  //2:ball_y2<=ball_y_pos[pengnum];
  //3:ball_y3<=ball_y_pos[pengnum];
  //4:ball_y4<=ball_y_pos[pengnum];
  //5:ball_y5<=ball_y_pos[pengnum];
  //6:ball_y6<=ball_y_pos[pengnum];
 endcase
  end//回钩处理
  else
  begin  
  site_y1=120;
  anxia<=0;
  pengdao=0;
  end//返回原处
  /*if ((Hcnt - ball_x_pos[pengnum])*(Hcnt - ball_x_pos[pengnum]) + (Vcnt - ball_y_pos[pengnum])*(Vcnt - ball_y_pos[pengnum]) <= (ball_r[pengnum] * ball_r[pengnum])) 
  begin
  //让矿物消失
  end
  end//矿物消失处理*/
// end//对整个回钩处理完毕        
  
  //对整个anxia处理完毕
  //对anxia和！anxia处理完毕
  end//对游戏主体模块处理完毕
  end

endmodule