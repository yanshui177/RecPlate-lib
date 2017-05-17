function  [img_train, label_train, img_test, label_test, param_]=process(train, test, flag, param_)
% 预处理训练测试数据集, 生成完整可用训练数据和测试数据 all
% --------------------------------------------------
% 参数：[img_train, label_train, img_test, label_test, param_]=process(train, test, flag, param_)
% @输入 train    训练图像元胞，包含训练图像和标签
%       test     测试图像元胞，包含测试图像和标签
% @输出 img_train     经过处理后的训练图像
%       img_test      经过处理后的测试图像
%       label_train   经过处理后的训练标签
%       label_test    经过处理后的训练标签
% ---------------------------------------------------
%                               作者 ：李波 @2017

%% 参数检查
if nargin < 4
    dim = 50;
    if nargin < 3        
        warning('MATLAB:ParamAmbiguous','not enough parameters given')
    end
end

%% 提取数据
train_images=train{1};
train_labels=train{2};
test_images=test{1};
test_labels=test{2};

train_num=size(train_images,3);
test_num=size(test_images,3);

%% 标签向量化
one_hot=param_.one_hot;
label_train=zeros(one_hot,train_num); % 训练标签
for i=1:train_num
    for j=1:one_hot
        if(strcmp(flag(j), train_labels(i)))      
            label_train(j,i)=1;
            break;
        end
    end
end

label_test=zeros(one_hot,test_num); % 测试标签
for i=1:test_num
    for j=1:one_hot
        if(strcmp(flag(j), test_labels(i)))      
            label_test(j,i)=1;
            break;
        end
    end
end

%% 图像预处理1
% 二值化
train_images2=double(train_images)/256;
for i=1:train_num
    c_max=double(max(max(train_images(:,:,i))));
    c_min=double(min(min(train_images(:,:,i))));
    T=round(c_max-(c_max-c_min)/3); %T为二值化的阈值
    train_images(:,:,i)=im2bw(train_images2(:,:,i),T/256);
end
test_images2=double(test_images)/256;
for i=1:test_num
    c_max=double(max(max(test_images(:,:,i))));
    c_min=double(min(min(test_images(:,:,i))));
    T=round(c_max-(c_max-c_min)/3); %T为二值化的阈值
    test_images(:,:,i)=im2bw(test_images2(:,:,i),T/256);
end
% 提取训练测试数据属性
train_row=size(train_images,1);
train_col=size(train_images,2);
train_page=size(train_images,3);

test_row=size(test_images,1);
test_col=size(test_images,2);
test_page=size(test_images,3);

% 行拉直，为下一步PCA（主成分分析）做准备
train_images=double(reshape( train_images, train_row*train_col, train_page)');
test_images=double(reshape( test_images, test_row*test_col, test_page)');

% 归一化，全部值映射到0-1
train_images=bsxfun(@times,train_images,1./sum(train_images,2));
test_images=bsxfun(@times,test_images,1./sum(test_images,2));

% PCA（主成分分析—）
[coef,~,latent]=princomp(train_images);
% lat=cumsum(latent)./sum(latent); % 为百分比能量使用

%% 图像预处理2：降维
dim=param_.dim;
if(dim==0)
   dim= size(coef,2);
end;
img_train = train_images*coef(:,1:dim);
img_test = test_images*coef(:,1:dim);
latent=latent';

img_train=bsxfun(@rdivide,img_train, sqrt(latent(1:dim)+1e-6));
img_test=bsxfun(@rdivide,img_test, sqrt(latent(1:dim)+1e-6));

img_train = img_train'; 
img_test = img_test';

param_.cate=flag;
param_.latent=latent;
param_.img_size=size(train_images(:,:,1));
param_.coef=coef;
end

