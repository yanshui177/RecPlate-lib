% function [labels, images ,flag] = readimg(rootpath)
%  格式化图像
%  读入大小归一化后的车牌单字符图像
%   
clear
clc
rootpath='samples/*';
%%

dirs = dir(rootpath); % 设定根目录，并读取根目录下的文件夹
l = length(dirs)  % 文件夹个数
labels=[]; % 初始化
images(16,32,1)=0; % 初始化
num=1;
flag=[];

%% 循环读取每一个目录下的png图像
for i=1:l    
    fprintf('.');
    % 生成当前目录下的路径
    path=strcat('samples/ ',dirs(i).name, '/');
    files = dir(strcat(path,'*.bmp')); % 获取第i个路径下所有文件名称 
    n=length(files); % 得到的文件数量
    % 能进入循环说明当前路径有png文件
    if n~=0 % 当前目录下存在png文件（个数不是0）
    %读取图像并防缩到25*15
    label=[];
    flag=[flag dirs(i).name ];
    for j=1:200
        img=imresize(imread(strcat(path, files(j).name)),[16, 32]); %放缩图像
        images(:,:,num)=img(:,:);
        label=[label dirs(i).name];
        num=num+1;
    end
    % 存储当前标签
    labels=[labels label];
    end
end

% 展示B每个元素的第五个图像
% figure(1)
% j=0;
% for i=1:200:6800
%     j=j+1
%     subplot(6,6,j)
%     imshow(uint8(images(:,:,i)));
% end
% save variables flag images labels
% end



