function [result, Ipcrop]=recplate(Ipcrop, param_num)
% 此函数是对数字字母的二值图像进行识别
% --------------------------------------------------------
% 参数  [result, Ipcrop]=recplate(Ipcrop, param_num)
% @输入 Ipcrop     二值化的数字或者字母图像
%       Ipchar     二值化的汉字
% %       param      结构体，包含以下内容：
%                  [    param.net       训练好的BP神经网络]
%                  [    param.coef      PCA参数          ]
%                  [    param.latent    PCA参数          ]
%                  [    param.dim       降维维数         ]
% @输出 result     识别结果
%       Icrop      识别的原图
% --------------------------------------------------------
%                                    作者： 李波 @2017 ,04
% clear
% clc
% load test

%% 读取预训练参数
% coef=param.coef;
% dim=param.dim;
% latent=param.latent;
% net=param.net;
% cate=param.cate;
% img_size=param.img_size;

%% 识别
result=''; % 识别结果存储在result中
j=1;
%% 识别字母 
for i=length(Ipcrop):-1:1
    %     i=2
    image=Ipcrop{i}; % 识别第i个图片
    
    % 预处理
    image=imresize(image, param_num.img_size);
    image2=double(reshape(image, param_num.img_size(1)*param_num.img_size(2), 1)'); % 行拉直，下一步PCA（主成分分析）
    image2=bsxfun(@times,image2,1./sum(image2,2));% 归一化，全部值映射到0-1
    image2 = image2*param_num.coef(:,1:param_num.dim);% 降维
    
    image2=bsxfun(@rdivide, image2, sqrt(param_num.latent(1:param_num.dim)+1e-6));% 白化
    image2 = image2'; % 最终要使用列向量
    
    % 仿真
    val=sim(param_num.net,image2);
    [~ , temp] = max(val);
    ch=param_num.cate(temp);
    
    % 结果显示
    result=[result;ch];
    subplot(1,8,j+1)
    j=j+1;
    imshow(image)
    title(ch);
end
hold off
end