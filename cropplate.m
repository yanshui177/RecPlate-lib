function [Ipcrop, Ipchar] = cropplate(Iplate)
% 车牌字符裁剪，将二值车牌图像中所有字符
% 裁剪成单个字符图像
% -----------------------------------
% 参数   
% [Ipcrop, Ipchar] = cropplate(Iplate)
% @输入 Iplate 输入的车牌图像
% @输出 Icrop  输出裁剪后的图像序列
% @输出 Ipchar 裁剪后第一个图像，汉字
% -----------------------------------
%                  作者：李波 @2017
% clear
% clc
% load test
%%
% 预处理
% subplot(1,2,1),plot(Iplate),title('车牌图像');
Ipf=bwareaopen(Iplate,20);% 形态学滤波（车牌图像是二值图像%）
Ippcrop=double(Ipf);

[h,w]=size(Ippcrop); 
X3=zeros(1,w);%产生1行q列全零数组
for j=1:w
    for i=1:h
       if(Ippcrop(i,j)==1) 
           X3(1,j)=X3(1,j)+1;
       end
    end
end
% subplot(1,2,2),plot(0:w-1,X3),title('列方向像素点灰度值累计和'),xlabel('列值'),ylabel('累计像素量');

% 字符分割 h高w宽，倒序分割
Px0=w;%字符右侧限
Px1=w;%字符左侧限
for i=1:6
    while((X3(1,Px0)<3)&&(Px0>0))
       Px0=Px0-1;
    end
    Px1=Px0;
    while(((X3(1,Px1)>=3))&&(Px1>0)||((Px0-Px1)<15))
        Px1=Px1-1;
    end
    Ipcrop{i}=Ipf(:,Px1:Px0,:);
    Px0=Px1;
end
% 对第一个进行处理
img=Ipcrop{1};%字符1右侧限
PX3=round(size(img,2)/2);
sum1=sum(img);
while((sum1(1,PX3-2)+sum1(1,PX3-1)+sum1(1,PX3)~=0) && ( PX3<length(sum1)-2) )
       PX3=PX3+1;
end
Ipcrop{1}=img(:,1:PX3);
% imshow(Ipcrop{end})
% 对最后一个进行处理
img=Ipcrop{end};%字符1右侧限
PX3=round(size(img,2)/2);
sum1=sum(img);
while((sum1(1,PX3-2)+sum1(1,PX3-1)+sum1(1,PX3)~=0) && ( PX3<length(sum1)-2) )
       PX3=PX3+1;
end
Ipcrop{end}=img(:,1:PX3);
% imshow(Ipcrop{end})


% 对第一个字符进行特别处理
PX3=Px1;%字符1右侧限
while((X3(1,PX3)<3)&&(PX3>0))
       PX3=PX3-1;
end
PX2=PX3; % 字符1左侧限制
while( X3(1, PX2+1)+ X3(1,PX2-1)+ X3(1,PX2) > 1 && PX2 > 2)
       PX2=PX2-1;       
end
Ipchar=Ippcrop(:,PX2:PX3,:);

end
% 
