%将指定的图象文件转化为灰度图象
%filename:图象文件名
%作者:重庆大学  田建国
%时间:2007年7月9日
function I=im2gray(filename)

colortype=imfinfo(filename);
colortype=colortype.ColorType;%获取图象颜色类型

%类型判断
switch(colortype)
    case 'truecolor'
        I=rgb2gray(imread(filename));
    case  'indexed'
        [I,map]=imread(filename);
        I=ind2gray(I,map);
    otherwise
        I=imread(filename);
end
clear filename;clear colortype;