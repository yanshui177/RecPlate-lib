function [labels, images ,flag] = readimg(rootpath)
%  格式化图像
%  读入大小归一化后的车牌单字符图像
%   
%%
dirs = dir(rootpath); % 设定根目录，并读取根目录下的文件夹
l = length(dirs);   % 文件夹个数
labels=[]; % 初始化
images(25,15,1)=0; % 初始化
num=1;
flag=[];

%% 循环读取每一个目录下的png图像
for i=1:l    
    % 生成当前目录下的路径
    path=strcat('charSamples/ ',dirs(i).name, '/');
    files = dir(strcat(path,'*.png')); % 获取第i个路径下所有文件名称    
    n=length(files); % 得到的文件数量
    % 能进入循环说明当前路径有png文件
    if n~=0 % 当前目录下存在png文件（个数不是0）
    %读取图像并防缩到25*15
    label=[];
    flag=[flag dirs(i).name ];
    for j=1:n
        img=imresize(imread(strcat(path, files(j).name)),[25,15]); %放缩图像
        images(:,:,num)=img(:,:);
        label=[label dirs(i).name];
        num=num+1;
    end
    % 存储当前标签
    labels=[labels label];
    end
end

% % 展示B每个元素的第五个图像
% figure(1)
% j=1;
% for i=500:515
%     subplot(3,6,j)
%     j=j+1;
%     imshow(uint8(images(:,:,i)));
% end

end



