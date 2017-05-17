% function plate=finetune(sbw)
% 
% 
clear
close all
clc
load sbw
figure
imshow(sbw)
%%
sum_row=sum(sbw);
i=1:length(sum_row);
plot(i, sum_row, '-');

sum_col=sum(sbw,2);