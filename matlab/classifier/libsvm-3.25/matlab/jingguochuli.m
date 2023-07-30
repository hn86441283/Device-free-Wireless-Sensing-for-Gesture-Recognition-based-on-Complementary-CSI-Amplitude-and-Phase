clc,clear,close all;
load model_C;                               %载入SVM模型；
raw_data = readmatrix('1.xlsx');            %载入原始数据（m行n列）；
[m,n] = size(raw_data);                     %获得原始数据的行数m，列数n；
r = randperm(m);                            %随机产生一个元素个数为m个的行向量，元素为1~行数m的整数，
                                            %每个整数出现一次；
raw_data = raw_data(r,:);                   %将原始数据按照行数随机打乱，打乱的顺序为行向量r；
Characteristic = raw_data(:,(1:end-1));     %原始数据的1至（end-1）列为特征值
lable = raw_data(:,end);                    %原始数据的最后一列为分类标签
                                       %lable matrix
[Predictlable, accuracy, dec_values] = svmpredict(lable,Characteristic,model);
