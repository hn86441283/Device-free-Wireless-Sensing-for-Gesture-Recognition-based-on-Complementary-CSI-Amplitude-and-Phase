
clear;
clc;
close all;
% %% 读取数据
% fall_sample=270;        %跌倒样本数
% not_fall_sample=270;        %非跌倒样本数
% p=0.75;       %选取％75的样本作为训练集
% 
% % 首先载入数据
% % load('heart_scale');
data=readmatrix(data);           %使用readmatrix函数读取EXCEL中对应范围的数据即可
Characteristic=data(:,1:end-1);                          %特征矩阵
lable=data(:,end);                                       %属性标签
[m,n]=size(data);
% 
% %交叉验证法
% %000x，x为测试集
% train1=(1:floor(fall_sample*p));                          %训练集1索引
% test1=(floor(fall_sample*p)+1:fall_sample);                         %测试集1索引
% train2=(fall_sample+1:fall_sample+1+floor(not_fall_sample*p));                    %训练集2索引
% test2=(fall_sample+1+floor(not_fall_sample*p)+1:fall_sample+not_fall_sample);                   %测试集2索引
%%
%%初始化参数
fall_sample=330;                            %跌倒样本数
not_fall_sample=400;                        %非跌倒样本数
 k=4;                                        %交叉验证份数
one_fall = floor(fall_sample / k);          %跌倒，一份交叉验证的大小
one_not_fall = floor(not_fall_sample / k);  %非跌倒，一份交叉验证的大小


a = ( 1 : one_fall);                                  %跌倒样本区间1
b = ( one_fall * 1 + 1 : one_fall * 2);               %跌倒样本区间2
c = ( one_fall * 2 + 1 : one_fall * 3);               %跌倒样本区间3
d = ( one_fall * 3 + 1 : fall_sample);                %跌倒样本区间4
e = ( fall_sample +1 :  fall_sample+ one_not_fall);                             %非跌倒样本区间1
f = ( fall_sample + (one_not_fall * 1) +1 : fall_sample + (one_not_fall * 2));  %非跌倒样本区间2
g = ( fall_sample + (one_not_fall * 2) +1 : fall_sample + (one_not_fall * 3));  %非跌倒样本区间3
h = ( fall_sample + (one_not_fall * 3) +1 : fall_sample + not_fall_sample);     %非跌倒样本区间4

test1=a;
train1=([b,c,d]);
test2=e;
train2=([f,g,h]);
train=([train1,train2]);
test=([test1,test2]);

SVM_train=Characteristic(train,:);    %训练集
SVM_train_lable=lable(train);         %训练集标签
SVM_test=Characteristic(test,:);       %测试集
SVM_test_lable=lable(test);            %测试集标签

%%
%最佳参数c,g算法
[bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train);
% disp(bestc);
% [bestacc,bestc,bestg] = SVMcgForClass(SVM_train_lable,SVM_train,-2,4,-4,4,3,0.5,0.5,0.9);

% 训练模型
% model = svmtrain(SVM_train_lable,SVM_train,'-c 16 -g 0.0625');
%测试模型
% [Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);






