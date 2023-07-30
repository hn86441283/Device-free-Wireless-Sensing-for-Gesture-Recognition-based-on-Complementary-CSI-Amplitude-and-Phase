%%
clc,clear,close all;
p = 0.7;
%%
%LOAD AND RANDOM 
raw_data = readmatrix('1.xlsx');            %����ԭʼ���ݣ�m��n�У���
[m,n] = size(raw_data);                     %���ԭʼ���ݵ�����m������n��
r = randperm(m);                            %�������һ��Ԫ�ظ���Ϊm������������Ԫ��Ϊ1~����m��������
                                            %ÿ����������һ�Σ�
raw_data = raw_data(r,:);                   %��ԭʼ���ݰ�������������ң����ҵ�˳��Ϊ������r��



%%
%ѵ��SVMģ��
Characteristic = raw_data(:,1:end-1);               %ԭʼ���ݵ�1����end-1����Ϊ��������ֵ
lable = raw_data(:,end);                            %ԭʼ���ݵ����һ��Ϊ�����ǩ
x = int32(m*p);                                     %ȡԭʼ������p��Ϊѵ��������1-p��Ϊ���Լ����˴�p=0.7��
SVM_train = Characteristic( 1:x , :);               %ѵ��������������
SVM_train_lable = lable(1:x);                       %ѵ�����ı�ǩ����

SVM_test = Characteristic( ((x+1) : end) , :);      %���Լ�����������
SVM_test_lable = lable( (x)+1 : end);               %���Լ��ı�ǩ����

[bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train,0,5,0,5);  %ʹ�����������㷨Ѱ�����ų�����c��g
train_option=['-c',' ',num2str(bestc),' ','-g',' ',num2str(bestg)];%��������ת��Ϊ�ض���ʽ��Ϊsvmtrain()����������


model = svmtrain(SVM_train_lable,SVM_train,train_option);          
%SVMģ��ѵ������������ѵ���������ѵ��ģ��model

[Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);
%SVMģ��ѵ������������ѵ��ģ��model�Ͳ��Լ������Ԥ���ǩ��׼ȷ��
 

