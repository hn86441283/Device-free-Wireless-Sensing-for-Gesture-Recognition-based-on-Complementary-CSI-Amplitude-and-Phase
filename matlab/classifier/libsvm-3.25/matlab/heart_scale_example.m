clear,clc,close all;
load('heart_scale.mat');
p=0.7;                                  %选取70%为训练集
[m,n]=size(heart_scale_inst);           %[m,n]=size（A），返回数组A的行数m和列数n
train=heart_scale_inst((1:m*p),:);
train_lable=heart_scale_label(1:m*p);
test=heart_scale_inst((((m*p)+1):end),:);
test_label=heart_scale_label(m*p+1:end);
[bestacc,bestc,bestg] = SVMcg(train_lable,train);
 model=svmtrain(train_lable,train,'-c 2 -g 0.1258');
 [predict_label,accurate,t]=svmpredict(test_label,test,model);

