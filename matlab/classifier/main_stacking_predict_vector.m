%%
tic;
clc;
clear;
close all;
p = 0.7;                                    %Select 70% of the data as the training set
%%
%LOAD AND RANDOM 
load data_after_phase_PCA.mat;
raw_data_phase = Feature_phase;
[m_phase,n_phase] = size(raw_data_phase);                     %Get the number of rows m and columns n of the original data;
r_phase = randperm(m_phase);                            %Randomly generate a row vector with m elements, the elements are integers from 1 to row number m
                                            %Each integer appears once
raw_data_phase = raw_data_phase(r_phase,:);                   %The original data is randomly disrupted according to the number of rows, and the disrupted order is the row vector r
%% LOAD AND RANDOM
load data_after_PCA.mat;
raw_data = Feature;
[m,n] = size(raw_data);                     %Get the number of rows m and columns n of the original data;
% r = randperm(m);                            %Randomly generate a row vector with m elements, the elements are integers from 1 to row number m
%                                             %Each integer occurs once
r = r_phase;
raw_data = raw_data(r,:);                   %The original data is randomly disrupted according to the number of rows, and the disrupted order is the row vector r
%% Split the training set and validation set and test set (phase)
Characteristic_phase = raw_data_phase(:,1:end-1);               %Columns 1 through (end-1) of the original data are sample eigenvalues
lable_phase = raw_data_phase(:,end);                            %The last column of the raw data is the categorization label
x_phase = int32(m_phase*p);                                     %Take p of the original sample as the training set and (1-p) as the test set (here p=0.7)
SVM_train_phase = Characteristic_phase( 1:x_phase , :);               %Feature matrix of the training set
SVM_train_lable_phase = lable_phase(1:x_phase);                       %Labeling matrix of the training set

x_train_phase = int32(x_phase*p); 
SVM_train_train_phase = SVM_train_phase(1:x_train_phase, :);
SVM_train_train_lable_phase = SVM_train_lable_phase(1:x_train_phase);

SVM_train_val_phase = SVM_train_phase( ((x_train_phase+1) : end) , :);
SVM_train_val_lable_phase = SVM_train_lable_phase((x_train_phase)+1 : end);

SVM_test_phase = Characteristic_phase( ((x_phase+1) : end) , :);      %Characterization matrix of the test set
SVM_test_lable_phase = lable_phase( (x_phase)+1 : end);               %Labeling matrix for the test set
%% Split the training set and validation set and test set(amplitude)
Characteristic = raw_data(:,1:end-1);               %Columns 1 through (end-1) of the original data are sample eigenvalues
lable = raw_data(:,end);                            %The last column of the raw data is the categorization label
x = int32(m*p);                                     %Take p of the original sample as the training set and (1-p) as the test set (here p=0.7)
SVM_train = Characteristic( 1:x , :);               %Feature matrix of the training set
SVM_train_lable = lable(1:x);                       %Labeling matrix of the training set

x_train = int32(x*p); 
SVM_train_train = SVM_train(1:x_train, :);
SVM_train_train_lable = SVM_train_lable(1:x_train);

SVM_train_val = SVM_train( ((x_train+1) : end) , :);
SVM_train_val_lable = SVM_train_lable((x_train)+1 : end);

SVM_test = Characteristic( ((x+1) : end) , :);      %Characterization matrix of the test set
SVM_test_lable = lable( (x)+1 : end);               %Labeling matrix for the test set
%%
%Training the SVM model
%phase

[bestacc_phase,bestc_phase,bestg_phase] = SVMcg(SVM_train_train_lable_phase,SVM_train_train_phase,0,5,0,5);  %Find the optimal hyperparameters c, g using a grid search algorithm and plot the contour map
train_option_phase=['-c',' ',num2str(bestc_phase),' ','-g',' ',num2str(bestg_phase),' ','-b 1'];%Convert hyperparameters to a specific format as input to the svmtrain() function


model_phase = svmtrain(SVM_train_train_lable_phase,SVM_train_train_phase,train_option_phase);          
%Call svmtrain function (SVM model training function), input training set, output training model model

[Predictlable_phase, accuracy_phase, dec_values_phase] = svmpredict(SVM_train_val_lable_phase,SVM_train_val_phase,model_phase,'-b 1');
%Call svmpredict function (SVM prediction function), input training model model and test set, output prediction label, accuracy
 
%amplitude

[bestacc,bestc,bestg] = SVMcg(SVM_train_train_lable,SVM_train_train,0,5,0,5);  %Find the optimal hyperparameters c, g using a grid search algorithm and plot the contour map
train_option=['-c',' ',num2str(bestc),' ','-g',' ',num2str(bestg),' ','-b 1'];%Convert hyperparameters to a specific format as input to the svmtrain() function


model = svmtrain(SVM_train_train_lable,SVM_train_train,train_option);          
%Call svmtrain function (SVM model training function), input training set, output training model model

[Predictlable, accuracy, dec_values] = svmpredict(SVM_train_val_lable,SVM_train_val,model,'-b 1');
%Call svmpredict function (SVM prediction function), input training model model and test set, output prediction label, accuracy

%% combine
SVM_train_and = (dec_values+dec_values_phase)/2;
SVM_train_label_and = SVM_train_val_lable;
[bestacc_and,bestc_and,bestg_and] = SVMcg(SVM_train_label_and,SVM_train_and,-5,5,-5,5);
train_option_and=['-c',' ',num2str(bestc_and),' ','-g',' ',num2str(bestg_and),' ','-b 1'];


model_and = svmtrain(SVM_train_label_and,SVM_train_and,train_option_and);          
%% test 
%phase_test
[Predictlable_phase_test, accuracy_phase_test, dec_values_phase_test] = svmpredict(SVM_test_lable_phase,SVM_test_phase,model_phase,'-b 1');
%amplitude_test
[Predictlable_test, accuracy_test, dec_values_test] = svmpredict(SVM_test_lable,SVM_test,model,'-b 1');


SVM_test_and = (dec_values_test+dec_values_phase_test)/2;
SVM_test_label_and = SVM_test_lable;
[Predictlable_and, accuracy_and, dec_values_and] = svmpredict(SVM_test_label_and,SVM_test_and,model_and,'-b 1');
 [label,rOrder] = sort(model_and.Label);
predict_scoresR = dec_values_and(:,rOrder);
toc;