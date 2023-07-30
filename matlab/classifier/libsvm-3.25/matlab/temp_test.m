%%
clc,clear,close all;
p = 0.7;
%%
%LOAD AND RANDOM 
raw_data = readmatrix('2700(1).xlsx');            %Load raw data;
[m,n] = size(raw_data);                        % m*n array(m rows n colums)
r = randperm(m);   %Generates a sequence of randomly arranged rows about the number of rows             

%*randperm(n):Generate n random numbers(Each number is a uniqe integer from 1 to n;
%size(A,):Assume that A is a n demention array; 
%Size(A,n) can count the dimension             
%and return the length of nth dimension;
raw_data = raw_data(r,:);       

%%
Characteristic = raw_data(:,1:end-1);                          %Characteristic matrix
lable = raw_data(:,end);                                       %lable matrix
x = int32(m*p);
SVM_train = Characteristic( 1:x , :);
SVM_train_lable = lable(1:x);

SVM_test = Characteristic( ((x+1) : end) , :);
SVM_test_lable = lable( (x)+1 : end);

[bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train,0,5,0,5);

% option_c = num2str(bestc);
% option_g = num2str(bestg);
train_option=['-c',' ',num2str(bestc),' ','-g',' ',num2str(bestg)];

model = svmtrain(SVM_train_lable,SVM_train,train_option);

%%
%  SVM_test = readmatrix('2161_2700(1).xlsx'); 
%  SVM_test_lable = SVM_test(:,end);
%  SVM_test = SVM_test(:,(1:end-1));
[Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);
 

