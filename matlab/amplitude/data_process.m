clear;
clc;
close all;
data = zeros(3000,541);
after_data = zeros(3000,541);
load data_kq.mat
data(1:600,:) = Sample_set;
clear Sample_set


load data_mj.mat
data(601:1200,:) = Sample_set;
clear Sample_set


load data_zh.mat
data(1201:1800,:) = Sample_set;
clear Sample_set


load data_zj.mat
data(1801:2400,:) = Sample_set;
clear Sample_set


load data_zz.mat
data(2401:3000,:) = Sample_set;

length = size(data,2)-1;
for ii = 1:length
    max_rot = max(data(:,ii));
    min_rot = min(data(:,ii));
    after_data(:,ii) = (data(:,ii)-min_rot)./(max_rot-min_rot);
end
after_data(:,end) = data(:,end);
