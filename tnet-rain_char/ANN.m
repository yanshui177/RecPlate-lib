function param_char=ANN(img_train, label_train, img_test,label_test, param_char)
% 生成训练测试数据集   char
% --------------------------------------------------
% 参数：ANN(img_train, label_train, img_test, label_test)
% @输入 img_train      输入的训练图像
%       label_train    输入的训练图像标签
%       img_test       输入的测试图像
%       label_test     输入的测试图像标签
% ---------------------------------------------------
%                               作者 ：李波 @2017

one_hot = param_char.one_hot;

%% 建立并训练神经网络
% 建立神经网络
net=newff(minmax(img_train),[60,one_hot],{'logsig','purelin'},'trainscg');
net.trainParam.epochs=5000;
net.trainParam.goal=1e-4;
net.trainParam.lr=0.1;
net.trainParam.mc=0.9;
% 训练神经网络
tic;
net=train(net,img_train,label_train);
toc
param_char.net=net;

%% 测试神经网络（仿真）
sim1=sim(net,img_train);[~ ,Y1] = max(sim1);
[~ ,trainl] = max(label_train);
ratio1 = mean(Y1==double(trainl));
fprintf('Train ratio： %0.4g \n',ratio1);

sim2=sim(net,img_test);[~ , Y2] = max(sim2);
[~ ,testl] = max(label_test);
ratio2 = mean(Y2==double(testl));
fprintf('Test ratio： %0.4g \n',ratio2);

end

