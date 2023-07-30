
clear;
clc;
close all;
% %% ��ȡ����
% fall_sample=270;        %����������
% not_fall_sample=270;        %�ǵ���������
% p=0.75;       %ѡȡ��75��������Ϊѵ����
% 
% % ������������
% % load('heart_scale');
data=readmatrix(data);           %ʹ��readmatrix������ȡEXCEL�ж�Ӧ��Χ�����ݼ���
Characteristic=data(:,1:end-1);                          %��������
lable=data(:,end);                                       %���Ա�ǩ
[m,n]=size(data);
% 
% %������֤��
% %000x��xΪ���Լ�
% train1=(1:floor(fall_sample*p));                          %ѵ����1����
% test1=(floor(fall_sample*p)+1:fall_sample);                         %���Լ�1����
% train2=(fall_sample+1:fall_sample+1+floor(not_fall_sample*p));                    %ѵ����2����
% test2=(fall_sample+1+floor(not_fall_sample*p)+1:fall_sample+not_fall_sample);                   %���Լ�2����
%%
%%��ʼ������
fall_sample=330;                            %����������
not_fall_sample=400;                        %�ǵ���������
 k=4;                                        %������֤����
one_fall = floor(fall_sample / k);          %������һ�ݽ�����֤�Ĵ�С
one_not_fall = floor(not_fall_sample / k);  %�ǵ�����һ�ݽ�����֤�Ĵ�С


a = ( 1 : one_fall);                                  %������������1
b = ( one_fall * 1 + 1 : one_fall * 2);               %������������2
c = ( one_fall * 2 + 1 : one_fall * 3);               %������������3
d = ( one_fall * 3 + 1 : fall_sample);                %������������4
e = ( fall_sample +1 :  fall_sample+ one_not_fall);                             %�ǵ�����������1
f = ( fall_sample + (one_not_fall * 1) +1 : fall_sample + (one_not_fall * 2));  %�ǵ�����������2
g = ( fall_sample + (one_not_fall * 2) +1 : fall_sample + (one_not_fall * 3));  %�ǵ�����������3
h = ( fall_sample + (one_not_fall * 3) +1 : fall_sample + not_fall_sample);     %�ǵ�����������4

test1=a;
train1=([b,c,d]);
test2=e;
train2=([f,g,h]);
train=([train1,train2]);
test=([test1,test2]);

SVM_train=Characteristic(train,:);    %ѵ����
SVM_train_lable=lable(train);         %ѵ������ǩ
SVM_test=Characteristic(test,:);       %���Լ�
SVM_test_lable=lable(test);            %���Լ���ǩ

%%
%��Ѳ���c,g�㷨
[bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train);
% disp(bestc);
% [bestacc,bestc,bestg] = SVMcgForClass(SVM_train_lable,SVM_train,-2,4,-4,4,3,0.5,0.5,0.9);

% ѵ��ģ��
% model = svmtrain(SVM_train_lable,SVM_train,'-c 16 -g 0.0625');
%����ģ��
% [Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);






