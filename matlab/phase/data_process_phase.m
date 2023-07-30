clear;
clc;
close all;
data_phase = zeros(3000,541);
after_data_phase = zeros(3000,541);
load data_kq_phase.mat
data_phase(1:600,:) = Sample_set;
clear Sample_set


load data_mj_phase.mat
data_phase(601:1200,:) = Sample_set;
clear Sample_set


load data_zh_phase.mat
data_phase(1201:1800,:) = Sample_set;
clear Sample_set


load data_zj_phase.mat
data_phase(1801:2400,:) = Sample_set;
clear Sample_set


load data_zz_phase.mat
data_phase(2401:3000,:) = Sample_set;

length = size(data_phase,2)-1;
for ii = 1:length
    max_rot = max(data_phase(:,ii));
    min_rot = min(data_phase(:,ii));
    after_data_phase(:,ii) = (data_phase(:,ii)-min_rot)./(max_rot-min_rot);
end
after_data_phase(:,end) = data_phase(:,end);
