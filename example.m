%% 车牌处理程序
%
%
clear
close all
clc

%% 读取车牌图像
% [fn,pn,~]=uigetfile('ChePaiKu\*.jpg','选择图片');
% Is=imread([pn fn]);%输入原始图像
% clear fn pn
Is='img/3.jpg';% 输入原始图像
% figure
% imshow(Is)
load param_char
load param_num

%% 找到车牌位置
Iplate=findplate(Is);
[Iplate,angle]=rotateimg(Iplate);
% plate=finetune(sbw);
figure
imshow(Iplate)

%% 车牌字符分割
[Ipcrop, Ipchar] = cropplate(Iplate);  clear Iplate;
% save Iplate Iplate

%% 车牌字符识别
figure
resultc = recchar(Ipchar, param_char);
[resultp,~] = recplate(Ipcrop, param_num)
res=strcat(resultc,resultp(1), ' ',resultp(2), resultp(3), resultp(4), resultp(5), resultp(6));
% fprintf('识别结果：%s %s  %s %s %s %s %s \n',resultc, resultp);
figure
imshow(imread(Is));
title(res)
