%%
clc,clear,close all;
p = 0.7;
%%
%LOAD AND RANDOM 
raw_data = readmatrix('1.xlsx');            %载入原始数据（m行n列）；
[m,n] = size(raw_data);                     %获得原始数据的行数m，列数n；
r = randperm(m);                            %随机产生一个元素个数为m个的行向量，元素为1~行数m的整数，
                                            %每个整数出现一次；
raw_data = raw_data(r,:);                   %将原始数据按照行数随机打乱，打乱的顺序为行向量r；



%%
%训练SVM模型
Characteristic = raw_data(:,1:end-1);               %原始数据的1至（end-1）列为样本特征值
lable = raw_data(:,end);                            %原始数据的最后一列为分类标签
x = int32(m*p);                                     %取原始样本的p作为训练集，（1-p）为测试集（此处p=0.7）
SVM_train = Characteristic( 1:x , :);               %训练集的特征矩阵
SVM_train_lable = lable(1:x);                       %训练集的标签矩阵

SVM_test = Characteristic( ((x+1) : end) , :);      %测试集的特征矩阵
SVM_test_lable = lable( (x)+1 : end);               %测试集的标签矩阵

[bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train,0,5,0,5);  %使用网格搜索算法寻找最优超参数c，g
train_option=['-c',' ',num2str(bestc),' ','-g',' ',num2str(bestg)];%将超参数转换为特定格式作为svmtrain()函数的输入


model = svmtrain(SVM_train_lable,SVM_train,train_option);          
%SVM模型训练函数，输入训练集，输出训练模型model

[Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);
%SVM模型训练函数，输入训练模型model和测试集，输出预测标签、准确率
 

