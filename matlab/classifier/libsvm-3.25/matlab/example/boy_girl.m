% ʹ��Libsvm���з����С����
% ѵ�����ݺͱ�ǩ
train_data = [176 70;
        180 80;
        161 45;
        163 47];
train_label = [1;1;-1;-1];

% ����ģ��
model = svmtrain(train_label,train_data);

% �������ݺͱ�ǩ
test_data = [103 55];
test_label = 1;

% Ԥ��
[predict_label,accuracy,dec_value] = svmpredict(test_label,test_data,model);
predict_label
if 1 == predict_label
    disp('����Ϊ����');
end
if -1 == predict_label
    disp('����ΪŮ��');
end
