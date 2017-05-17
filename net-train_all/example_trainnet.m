% 训练matlab神经网络用

clear all
close all
clc

% rootpath='samples/*';
% [labels, images ,flag] = readimg(rootpath);
load plate_data
param_.dim=30;
param_.one_hot=length(flag);

%% 生成标准数据格式（类似于mnist）
[train , test] = cdata(labels, images);clear images labels

%% 预处理
[img_train, label_train, img_test, label_test, param_]=...
    process(train, test, flag, param_);
clear test train dim flag
% savevari('D:', img_train, label_train, img_test, label_test) % 存储数据集到txt

%% 神经网络
param_ = ANN(img_train, label_train, img_test, label_test, param_); % 训练神经网络并得到识别率
save param_