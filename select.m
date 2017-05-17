function [y,y1]=select(ImageData,h,w)

thr=0.5;delta=0.05;
%
y=(ImageData>=thr*mean(max(ImageData)));
BW2=bwareaopen(y,10);SE=strel('square',15);
IM2=imdilate(BW2,SE);
IM3=imerode(IM2,SE);
%
average=sum(sum(IM3))/(h*w);
while(average<0.03||average>0.08)%参数可能需要自己调整
   % if(average<=0.005||average>=1)
    %    break;
    %end
    if(average<0.03)
        thr=thr-delta;
    else
        thr=thr+delta;
    end
    y=(ImageData>=thr*mean(max(ImageData)));
    BW2=bwareaopen(y,10);
    IM2=imdilate(BW2,SE);
    IM3=imerode(IM2,SE);
    average=sum(sum(IM3))/(h*w);
end
y1=y;
y=IM3;

