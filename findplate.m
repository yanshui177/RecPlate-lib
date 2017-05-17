function Iplate = findplate(Is)
% 此函数通过一张包含车牌的图像找到车牌位置，
% 并返回二值车牌图像
% ----------------------------------------
% 参数  Iplate = findplate(Is)
% @输入 Is     原始图像
% @输出 Iplate 车牌图像
% ----------------------------------------
%                        作者： 李波 @2017
% Is=imread('3.jpg');%输入原始图像
% figure
% imshow(Is)

%% 图像预处理
Is=imread(Is);
Igray=rgb2gray(Is);%转化为灰度图像
Iedge=edge(Igray,'canny',0.5);%Canny算子边缘检测

se1=[1;1;1]; %线型结构元素 
Ierode=imerode(Iedge,se1);    %腐蚀图像
se2=strel('rectangle',[25,25]); %矩形结构元素
Ifill=imclose(Ierode,se2);%图像聚类、填充图像

If=bwareaopen(Ifill,2000);%从对象中移除面积小于2000的小对象

%% 车牌粗定位 
[y,x]=size(If);%size函数将数组的行数返回到第一个输出变量，将数组的列数返回到第二个输出变量
Idouble=double(If);

% 车牌粗定位 确定行的起始位置和终止位置
Y1=zeros(y,1);%产生y行1列全零数组
for i=1:y
    for j=1:x
        if(Idouble(i,j)==1)
            Y1(i,1)= Y1(i,1)+1;%白色像素点统计
        end
    end
end

[temp,MaxY]=max(Y1);%Y方向车牌区域确定。返回行向量temp和MaxY，temp向量记录Y1的每列的最大值，MaxY向量记录Y1每列最大值的行号
PY1=MaxY;
while ((Y1(PY1,1)>=50)&&(PY1>1))
        PY1=PY1-1;
end
PY2=MaxY;
while ((Y1(PY2,1)>=50)&&(PY2<y))
        PY2=PY2+1;
end
IY=Is(PY1:PY2,:,:);

% 车牌粗定位 确定列的起始位置和终止位置
X1=zeros(1,x);%产生1行x列全零数组
for j=1:x
    for i=PY1:PY2
        if(Idouble(i,j,1)==1)
                X1(1,j)= X1(1,j)+1;               
         end  
    end       
end
PX1=1;
while ((X1(1,PX1)<3)&&(PX1<x))
       PX1=PX1+1;
end    
PX3=x;
while ((X1(1,PX3)<3)&&(PX3>PX1))
        PX3=PX3-1;
end
Ip=Is(PY1:PY2,PX1:PX3,:);

%% 车牌精细定位 
% 预处理`
Ipgray=rgb2gray(Ip); %将RGB图像转化为灰度图像
c_max=double(max(max(Ipgray)));
c_min=double(min(min(Ipgray)));
T=round(c_max-(c_max-c_min)/3); %T为二值化的阈值
Ipbw=im2bw(Ipgray,T/256);

% 去除边框干扰
[r,s]=size(Ipbw);%size函数将数组的行数返回到第一个输出变量，将数组的列数返回到第二个输出变量
Iplate=double(Ipbw);
X2=zeros(1,s);%产生1行s列全零数组
for i=1:r
    for j=1:s
        if(Iplate(i,j)==1)
            X2(1,j)= X2(1,j)+1;%白色像素点统计
        end
    end
end
[temp,MaxX]=max(X2);
% subplot(2,2,2),plot(0:s-1,X2),title('粗定位车牌图像列方向像素点值累计和'),xlabel('列值'),ylabel('像素');

% 去除左侧边框干扰 
[g,h]=size(Iplate);
leftwidth=0;rightwidth=0;widthThreshold=5;
while sum(Iplate(:,leftwidth+1))~=0
    leftwidth=leftwidth+1;
end
if leftwidth<widthThreshold   % 认为是左侧干扰
    Iplate(:,1:leftwidth)=0;%给图像d中1到KuanDu宽度间的点赋值为零
    Iplate=QieGe(Iplate); %值为零的点会被切割
end
% subplot(2,2,3),imshow(Ipd),title('去除左侧边框的二值车牌图像')

 % 去除右侧边框干扰
[~,f]=size(Iplate);%上一步裁剪了一次，所以需要再次获取图像大小
d=f;
while sum(Iplate(:,d-1))~=0
    rightwidth=rightwidth+1;
    d=d-1;
end
if rightwidth < widthThreshold   % 认为是右侧干扰
    Iplate(:,(f-rightwidth):f)=0;%
    Iplate=QieGe(Iplate); %值为零的点会被切割
end
% subplot(2,2,4),imshow(Ipd),title('精确定位的车牌二值图像')

end