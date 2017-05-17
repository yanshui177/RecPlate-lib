function savevari(rootp, img_train, label_train, img_test, label_test)
% 保存变量到txt

%% 保存训练文件
fid=fopen(strcat(rootp, '\img_train.txt'),'wt'); %写入的文件，各函数后面有说明
[m,n]=size(img_train);
 for i=1:m
	for j=1:n
        fprintf(fid,'%g ',img_train(i,j));
	end
 	fprintf(fid,'\n');
end
fclose(fid);

fid=fopen(strcat(rootp, '\label_train.txt'),'wt'); %写入的文件，各函数后面有说明
[m,n]=size(label_train);
 for i=1:m
	for j=1:n
        fprintf(fid,'%g ',label_train(i,j));
	end
 	fprintf(fid,'\n');
end
fclose(fid);

%% 保存测试文件
fid=fopen(strcat(rootp, '\img_test.txt'),'wt'); %写入的文件，各函数后面有说明
[m,n]=size(img_test);
 for i=1:m
	for j=1:n
        fprintf(fid,'%g ',img_test(i,j));
	end
 	fprintf(fid,'\n');
end
fclose(fid);

fid=fopen(strcat(rootp, '\label_test.txt'),'wt'); %写入的文件，各函数后面有说明
[m,n]=size(label_test);
 for i=1:m
	for j=1:n
        fprintf(fid,'%g ',label_test(i,j));
	end
 	fprintf(fid,'\n');
end
fclose(fid);

end