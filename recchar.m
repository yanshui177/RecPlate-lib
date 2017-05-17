function resultc=recchar(Ipchar, param_char)
% 此函数是对字符的二值图像进行识别
% --------------------------------------------------------
% 参数  [resultc, Ic]=recchar(Ichar);
% @输入 Ichar     二值化的数字或者字母图像
% @输出 resultc   识别结果
%       Ic        识别的原图
% --------------------------------------------------------
%                                    作者： 李波 @2017 ,05
% /////////////////////////////////////////////////////



%% 识别汉字
image=Ipchar; % 识别第i个图片
% 预处理
image=imresize(image,param_char.img_size);
image=double(reshape(image, param_char.img_size(1)*param_char.img_size(2), 1)'); % 行拉直，下一步PCA（主成分分析）
image=bsxfun(@times,image,1./sum(image,2));% 归一化，全部值映射到0-1
image = image*param_char.coef(:,1:param_char.dim);% 降维

image=bsxfun(@rdivide, image, sqrt(param_char.latent(1:param_char.dim)+1e-6));% 白化
imgage = image'; % 最终要使用列向量

% 仿真
val=sim(param_char.net, imgage);
[~ , temp] = max(val);
resultc=param_char.cate(temp);

% 结果显示
hold on
subplot(1,8,1)
imshow(Ipchar)
title(resultc);
end

