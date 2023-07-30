function [Predictlable, accuracy, dec_values] = runSVM(train,test)
%SVM函数
%   此处显示详细说明
SVM_train=Characteristic(train,:);    %训练集
SVM_train_lable=lable(train);         %训练集标签
SVM_test=Characteristic(test,:);       %测试集
SVM_test_lable=lable(test);            %测试集标签


%最佳参数c,g算法
 [bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train,-5,5,-5,5,4,1,1,1.5);
% [bestacc,bestc,bestg] = SVMcgForClass(SVM_train_lable,SVM_train,-2,4,-4,4,3,0.5,0.5,0.9);

% 训练模型
model = svmtrain(SVM_train_lable,SVM_train,'-c bestc -g bestg');
%测试模型
[Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);

end

