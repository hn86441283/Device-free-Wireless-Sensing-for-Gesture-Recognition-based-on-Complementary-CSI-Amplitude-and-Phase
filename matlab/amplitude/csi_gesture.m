clear;
clc;
close all;
Sample_set = zeros(600,541);
Samples=zeros(1,540);
numrot = -1;
for gesture = 1:6
numrot = numrot + 1;
for num_file = 1:100
file_index = ['C:\Users\Cai\Desktop\Dataset\zz_',num2str(gesture),'_',num2str(num_file),'.dat']
csi_trace = read_bf_file(file_index);
database_length = size(csi_trace,1);
first_ant_csi = zeros(30,database_length);
second_ant_csi = zeros(30,database_length);
third_ant_csi = zeros(30,database_length);
%% amplitude extraction
for i = 1:database_length% length of csi data
    csi_entry = csi_trace{i};
    csi = get_scaled_csi(csi_entry); %Extract csi matrix    
    csi_j = (squeeze(csi(1,:,:)).');  %Contains phase information
    csi_amplitude = abs(csi_j);          %Extract magnitude (dimensionality reduction + transposition)
    %% Extract phase or amplitude
    first_ant_csi(:,i) = csi_amplitude(:,1);           %Fetch the first column of data directly (no need to for loop to fetch)
    second_ant_csi(:,i) = csi_amplitude(:,2);
    third_ant_csi(:,i) = csi_amplitude(:,3);
end
%% Anomaly removal 3¦Ò
for kk = 1:30
    %The first transceiver antenna pair
    first_ant_csi(kk,:) = hampel(first_ant_csi(kk,:));
    %Second transceiver antenna pair
    second_ant_csi(kk,:) = hampel(second_ant_csi(kk,:));
    %Third transceiver antenna pair
    third_ant_csi(kk,:) = hampel(third_ant_csi(kk,:));
end
%% filter
for kk = 1:30
    %The first transceiver antenna pair
    first_ant_csi(kk,:) = wden(first_ant_csi(kk,:),'sqtwolog','h','one',3,'db4');  %Hard thresholding noise reduction based on wavelet decomposition
    %Second transceiver antenna pair
    second_ant_csi(kk,:) = wden(second_ant_csi(kk,:),'sqtwolog','h','one',3,'db4');
    %Third transceiver antenna pair
    third_ant_csi(kk,:) = wden(third_ant_csi(kk,:),'sqtwolog','h','one',3,'db4');
end
%% feature extraction
%The first transceiver antenna pair
for kk = 1:30
    mean_subcarrier_first(1,kk) = mean(first_ant_csi(kk,:));
    var_subcarrier_first(1,kk) = var(first_ant_csi(kk,:));
    std_subcarrier_first(1,kk) = std(first_ant_csi(kk,:));
    iqr_subcarrier_first(1,kk) = prctile(first_ant_csi(kk,:),75)-prctile(first_ant_csi(kk,:),25);
    power_subcarrier_first(1,kk) = genFeatureEn(first_ant_csi(kk,:),{'eE'});
    gong_subcarrier_first(1,kk) = genFeatureEn(first_ant_csi(kk,:),{'psdE'});
end
 %Second transceiver antenna pair
for kk = 1:30
    mean_subcarrier_second(1,kk) = mean(second_ant_csi(kk,:));
    var_subcarrier_second(1,kk) = var(second_ant_csi(kk,:));
    std_subcarrier_second(1,kk) = std(second_ant_csi(kk,:));
    iqr_subcarrier_second(1,kk) = prctile(second_ant_csi(kk,:),75)-prctile(second_ant_csi(kk,:),25);
    power_subcarrier_second(1,kk) = genFeatureEn(second_ant_csi(kk,:),{'eE'});
    gong_subcarrier_second(1,kk) = genFeatureEn(second_ant_csi(kk,:),{'psdE'});    
end
%Third transceiver antenna pair
for kk = 1:30
    mean_subcarrier_third(1,kk) = mean(third_ant_csi(kk,:));
    var_subcarrier_third(1,kk) = var(third_ant_csi(kk,:));
    std_subcarrier_third(1,kk) = std(third_ant_csi(kk,:));
    iqr_subcarrier_third(1,kk) = prctile(third_ant_csi(kk,:),75)-prctile(third_ant_csi(kk,:),25);
    power_subcarrier_third(1,kk) = genFeatureEn(third_ant_csi(kk,:),{'eE'});
    gong_subcarrier_third(1,kk) = genFeatureEn(third_ant_csi(kk,:),{'psdE'});       
end
Samples = [mean_subcarrier_first,var_subcarrier_first,std_subcarrier_first,iqr_subcarrier_first,power_subcarrier_first,...
    gong_subcarrier_first,mean_subcarrier_second,var_subcarrier_second,std_subcarrier_second,iqr_subcarrier_second,...
    power_subcarrier_second,gong_subcarrier_second,mean_subcarrier_third,var_subcarrier_third,std_subcarrier_third,...
    iqr_subcarrier_third,power_subcarrier_third,gong_subcarrier_third];
Sample_set(numrot*100+num_file,1:end-1) = Samples;
Sample_set(numrot*100+num_file,end) = gesture;
end
end