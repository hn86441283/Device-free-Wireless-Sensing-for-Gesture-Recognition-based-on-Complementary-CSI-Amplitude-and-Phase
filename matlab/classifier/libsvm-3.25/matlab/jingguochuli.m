clc,clear,close all;
load model_C;                               %����SVMģ�ͣ�
raw_data = readmatrix('1.xlsx');            %����ԭʼ���ݣ�m��n�У���
[m,n] = size(raw_data);                     %���ԭʼ���ݵ�����m������n��
r = randperm(m);                            %�������һ��Ԫ�ظ���Ϊm������������Ԫ��Ϊ1~����m��������
                                            %ÿ����������һ�Σ�
raw_data = raw_data(r,:);                   %��ԭʼ���ݰ�������������ң����ҵ�˳��Ϊ������r��
Characteristic = raw_data(:,(1:end-1));     %ԭʼ���ݵ�1����end-1����Ϊ����ֵ
lable = raw_data(:,end);                    %ԭʼ���ݵ����һ��Ϊ�����ǩ
                                       %lable matrix
[Predictlable, accuracy, dec_values] = svmpredict(lable,Characteristic,model);
