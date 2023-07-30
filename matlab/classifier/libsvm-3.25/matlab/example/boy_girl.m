% 使用Libsvm进行分类的小例子
% 训练数据和标签
train_data = [176 70;
        180 80;
        161 45;
        163 47];
train_label = [1;1;-1;-1];

% 建立模型
model = svmtrain(train_label,train_data);

% 测试数据和标签
test_data = [103 55];
test_label = 1;

% 预测
[predict_label,accuracy,dec_value] = svmpredict(test_label,test_data,model);
predict_label
if 1 == predict_label
    disp('该生为男生');
end
if -1 == predict_label
    disp('该生为女生');
end
