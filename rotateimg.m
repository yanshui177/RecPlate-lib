function [sbw,angle]=rotateimg(sbw1)
%%
%Step6 计算车牌水平投影，并对水平投影进行峰谷分析
histcol1=sum(sbw1);      %计算垂直投影
histrow=sum(sbw1');      %计算水平投影
% figure,subplot(2,1,1),bar(histcol1);title('垂直投影（含边框）');%输出垂直投影
% subplot(2,1,2),bar(histrow);     title('水平投影（含边框）');%输出水平投影
% figure,subplot(2,1,1),bar(histrow);     title('水平投影（含边框）');%输出水平投影
% subplot(2,1,2),imshow(sbw1);title('车牌二值子图');%输出二值图
%对水平投影进行峰谷分析
meanrow=mean(histrow);%求水平投影的平均值
minrow=min(histrow);%求水平投影的最小值
levelrow=(meanrow+minrow)/2;%求水平投影的平均值
count1=0;
l=1;
hight=size(sbw1,1);
for k=1:hight
    if histrow(k)<=levelrow                             
        count1=count1+1;                                
    else 
        if count1>=1
            markrow(l)=k;%上升点
            markrow1(l)=count1;%谷宽度（下降点至下一个上升点）
            l=l+1;
        end
        count1=0;
    end
end
markrow2=diff(markrow);%峰距离（上升点至下一个上升点）
[~,n1]=size(markrow2);
n1=n1+1;
markrow(l)=hight;
markrow1(l)=count1;
markrow2(n1)=markrow(l)-markrow(l-1);
% l=0;
for k=1:n1
    markrow3(k)=markrow(k+1)-markrow1(k+1);%下降点
    markrow4(k)=markrow3(k)-markrow(k);%峰宽度（上升点至下降点）
    markrow5(k)=markrow3(k)-double(uint16(markrow4(k)/2));%峰中心位置
end 
%%
%Step7 计算车牌旋转角度
%(1)在上升点至下降点找第一个为1的点
[m2,n2]=size(sbw1);%sbw1的图像大小
[m1,n1]=size(markrow4);%markrow4的大小
maxw=max(markrow4);%最大宽度为字符
if markrow4(1) ~= maxw%检测上边
    ysite=1;
    k1=1;
    for l=1:n2
    for k=1:markrow3(ysite)%从顶边至第一个峰下降点扫描
        if sbw1(k,l)==1
            xdata(k1)=l;
            ydata(k1)=k;
            k1=k1+1;
            break;
        end
    end
    end
else  %检测下边
    ysite=n1;
    if markrow4(n1) ==0
        if markrow4(n1-1) ==maxw
           ysite= 0; %无下边
       else
           ysite= n1-1;
       end
    end
    if ysite ~=0
        k1=1;
        for l=1:n2
            k=m2;
            while k>=markrow(ysite) %从底边至最后一个峰的上升点扫描
                if sbw1(k,l)==1
                    xdata(k1)=l;
                    ydata(k1)=k;
                    k1=k1+1;
                    break;
                end
                k=k-1;
            end
        end
    end
end       
%(2)线性拟合，计算与x夹角
fresult = fit(xdata',ydata','poly1');   %poly1    Y = p1*x+p2
p1=fresult.p1;
angle=atan(fresult.p1)*180/pi; %弧度换为度，360/2pi,  pi=3.14
%(3)旋转车牌图象
subcol = imrotate(sbw1,angle,'bilinear','crop'); %旋转车牌图象
sbw = imrotate(sbw1,angle,'bilinear','crop');%旋转图像
% figure,subplot(2,1,1),imshow(subcol);title('车牌灰度子图');%输出车牌旋转后的灰度图像标题显示车牌灰度子图
% subplot(2,1,2),imshow(sbw);title('');%输出车牌旋转后的灰度图像
% title(['车牌旋转角: ',num2str(angle),'度'] ,'Color','r');%显示车牌的旋转角度