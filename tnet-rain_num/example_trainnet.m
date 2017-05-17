% 训练matlab神经网络用 num
% 归一化大小为25*15

clear all
close all
clc

% rootpath='charSamples/*';
% [labels, images ,flag] = readimg(rootpath);
load plateData;
param_num.dim=35;
param_num.one_hot=34;

%% 生成标准数据格式（类似于mnist）
[train , test] = cdata(labels, images);
clear images labels

%% 预处理
[img_train, label_train, img_test, label_test, param_num]=...
    process(train, test, flag, param_num);
clear test train dim flag
% savevari('D:', img_train, label_train, img_test, label_test) % 存储数据集到txt

%% 神经网络
param_num = ANN(img_train, label_train, img_test, label_test, param_num); % 训练神经网络并得到识别率
save param_num