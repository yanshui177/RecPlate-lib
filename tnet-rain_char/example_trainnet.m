% 训练matlab神经网络用 char
% 图片大小是归一化为 16 * 32
clear all
close all
clc

% rootpath='samples/*';
% [labels, images ,flag] = readimg(rootpath);
load variables
param_char.dim=10;
param_char.one_hot=length(flag);

%% 生成标准数据格式（类似于mnist）
[train , test] = cdata(labels, images);
clear images labels

%% 预处理
[img_train, label_train, img_test, label_test, param_char]=...
    process(train, test, flag, param_char);
clear test train dim flag
% savevari('D:', img_train, label_train, img_test, label_test) % 存储数据集到txt

%% 神经网络
param_char = ANN(img_train, label_train, img_test, label_test, param_char); % 训练神经网络并得到识别率
save param_char