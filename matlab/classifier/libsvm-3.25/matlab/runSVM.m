function [Predictlable, accuracy, dec_values] = runSVM(train,test)
%SVM����
%   �˴���ʾ��ϸ˵��
SVM_train=Characteristic(train,:);    %ѵ����
SVM_train_lable=lable(train);         %ѵ������ǩ
SVM_test=Characteristic(test,:);       %���Լ�
SVM_test_lable=lable(test);            %���Լ���ǩ


%��Ѳ���c,g�㷨
 [bestacc,bestc,bestg] = SVMcg(SVM_train_lable,SVM_train,-5,5,-5,5,4,1,1,1.5);
% [bestacc,bestc,bestg] = SVMcgForClass(SVM_train_lable,SVM_train,-2,4,-4,4,3,0.5,0.5,0.9);

% ѵ��ģ��
model = svmtrain(SVM_train_lable,SVM_train,'-c bestc -g bestg');
%����ģ��
[Predictlable, accuracy, dec_values] = svmpredict(SVM_test_lable,SVM_test,model);

end

