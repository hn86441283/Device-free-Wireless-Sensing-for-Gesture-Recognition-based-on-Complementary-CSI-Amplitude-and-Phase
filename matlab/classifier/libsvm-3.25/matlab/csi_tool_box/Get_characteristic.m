


Sample_set = zeros(30,27);
for num_file=1:30
    if num_file < 271
        category = 0;
    else
        category = 1;
    end
    
file_index = ['C:\Users\123\Desktop\test',num2str(num_file)]
%a=['xxx',num2str(n)]

csi_trace = read_bf_file(file_index);

for i = 1:600%这里是取的数据包的个数
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry); %提取csi矩阵    
        csi = csi(1,:,:);

	csi_j = (squeeze(csi).');  %含相位信息
        csi1 = abs(squeeze(csi).');          %提取幅值(降维+转置)
        
        %只取一根天线的数据
	first_ant_csi_j(:,i) = csi_j(:,1);  
        first_ant_csi(:,i) = csi1(:,1);           %直接取第一列数据(不需要for循环取)
        second_ant_csi(:,i) = csi1(:,2);
        third_ant_csi(:,i) = csi1(:,3);
                     
%         for j=1:30
%             csi15_end(i,:)=csi1(j,:);           %3个信道第j个子载波
%         end
end
 
first_ant_csi_1 = first_ant_csi(1,:);
%截取部分,51~550
first_ant_csi_1 = first_ant_csi_1(1,51:550);
n = length(first_ant_csi_1);        %单样本包长度
%均值
Charac_mean = mean(first_ant_csi_1(:));                                                                 %①
%标准差
charac_std = std(first_ant_csi_1);                                                                      %②
%最大值
charac_max = max(first_ant_csi_1);                                                                      %③
%最小值
charac_min = min(first_ant_csi_1);                                                                      %④
%范围
charac_scope = charac_max-charac_min;                                                                   %⑤
%过均值点数

n_num_beyond_mean =0;
for j=1:n
    if (first_ant_csi_1(1,j)>Charac_mean)
        n_num_beyond_mean = n_num_beyond_mean + 1;
    end
end

charac_beyondmean = n_num_beyond_mean;                                                                   %⑥


%1/4分位数
charac_onefour = quantile(first_ant_csi_1,0.25,2);                                                       %⑦

%3/4分位数

charac_threefour = quantile(first_ant_csi_1,0.75,2);                                                      %⑧

%四分位数范围
charac_Quantile_scope = charac_threefour - charac_onefour;                                                %⑨

%傅里叶变换
fs=100;         
fft_amp =abs(fft(first_ant_csi_1,n));        %离散傅里叶变换
fft_f = (0:n-1)*(fs/n);        %离散傅里叶变换频域间隔


%******************************************频域特征提取************************************************************
    fft_amp_apx=fft_amp;            % fft_amp的备份
    [fft_amp_sort,index]=sort(fft_amp_apx,'descend');     %降序排序，fft_amp_sort为降序排序后的序列，index为降序后的值对应的原来的数组索引
    fft_amp_second=fft_amp_sort(1,2);                   %第二大FFT                                           %⑩
    fft_amp_second_index=fft_f(1,index(1,2));           %第二大FFT对应的频率                                 %①①
    fft_amp_third=fft_amp_sort(1,3);                  %第三大FFT                                           %①②
    fft_amp_third_index=fft_f(1,index(1,3));          %第三大FFT对应的频率                                  %①③
    fft_amp_fifth=fft_amp_sort(1,5);                   %第五大FFT                                           %①④
    fft_amp_fifth_index=fft_f(1,index(1,5));           %第五大FFT对应的频率                                  %①⑤
 
   %*********幅度统计特征***************************
    average_fft_amp=mean(fft_amp(:));                       %频域平均值                                       %①⑥
    stade_fft_amp=std(fft_amp(:));                          %频域标准差                                       %①⑦
    n_fft=length(fft_amp);                                  %获取频域长度                                      
    
    %************************************四分位数及其范围******************************************
    charac_fft_amp_onefour = quantile(fft_amp,0.25,2);                                                        %①⑧     
    charac_fft_amp_threefour = quantile(fft_amp,0.75,2);                                                      %①⑨      
   charac_fft_amp_Quantile_scope = charac_fft_amp_threefour - charac_fft_amp_onefour;                         %②〇
    
    
    
    %*********幅度统计与形状统计，特征变量初始化*******************************************************
    skew=0;
    kurt=0;
    average_amp_shape=0;
    skew_fft_amp_shape=0;
    stade_fft_amp_shape=0;
    kurt_fft_amp_shape=0;
    %*************************************************************************************************
    
    
    S=sum(fft_amp);                                         %S，一个窗口内所有信号频域幅度的和
    for i_fft=1:n_fft
        skew=skew+((fft_amp(1,i_fft)-average_fft_amp)/stade_fft_amp)^3;
        kurt=kurt+((fft_amp(1,i_fft)-average_fft_amp)/stade_fft_amp)^4;
        average_amp_shape=average_amp_shape+i_fft*fft_amp(1,i_fft);
 
    end
    skew=skew/n_fft;                                        %偏度                                                 %②①
    kurt=kurt/n_fft-3;                                      %峰度                                                 %②②
    average_amp_shape=average_amp_shape/n_fft;              %形状统计均值                                          %②③
    
    
     %*****************形状统计标准差**********************************************************************
    for j_fft=1:n_fft
    stade_fft_amp_shape=stade_fft_amp_shape+(j_fft-average_amp_shape)^2*fft_amp(j_fft);
    end
    stade_fft_amp_shape=sqrt(stade_fft_amp_shape/S);                                                               %②④
    %********************************************************************************************************
    
    %*****************形状统计偏度，峰度****************************
    
    for k_fft=1:n_fft
    skew_fft_amp_shape=skew_fft_amp_shape+((k_fft-average_amp_shape)/stade_fft_amp_shape)^3*fft_amp(1,k_fft);
    kurt_fft_amp_shape=kurt_fft_amp_shape+((k_fft-average_amp_shape)/stade_fft_amp_shape)^4*fft_amp(1,k_fft);
    end
    skew_fft_amp_shape=skew_fft_amp_shape/S;                                                                       %②⑤ 
    kurt_fft_amp_shape=(kurt_fft_amp_shape-3)/S;                                                                   %②⑥
    
    


  characteristic_headers = {'mean','std','max','min'...
        ,'scope','beyondmean','characonefour','characthreefour', 'charac_Quantilescope'...
        ,'fft_amspecond','fft_amp_secondindex','fft_ampthird','fft_amp_thirdindex','fft_ampfifth'...
        ,'fft_amp_fifthindex','average_fftamp','stade_fftamp'...
        ,'charac_fft_amponefour','charac_fft_ampthreefour'...
        ,'charac_fft_amp_Quantilescope','skew_','kurt_','average_ampshape'...
        ,'stade_fft_ampshape','skew_fft_ampshape','kurt_fft_ampshape','Category'};
    
 
 Sample = [Charac_mean,charac_std,charac_max,charac_min,charac_scope,...
     charac_beyondmean,charac_onefour,charac_threefour,charac_Quantile_scope,...
     fft_amp_second,fft_amp_second_index,fft_amp_third,fft_amp_third_index,...
     fft_amp_fifth,fft_amp_fifth_index,average_fft_amp,stade_fft_amp,...
     charac_fft_amp_onefour,charac_fft_amp_threefour,charac_fft_amp_Quantile_scope,...
     skew,kurt,average_amp_shape,stade_fft_amp_shape,skew_fft_amp_shape,kurt_fft_amp_shape];

 
%***************************************************特征值归一化*************************************
Sample_Max = max(Sample);
Sample_Min = min(Sample);
for lie_i = 1:26 
    Sample(1,lie_i) = (Sample(1,lie_i) - Sample_Min )/(Sample_Max + Sample_Min);
end

Sample =[Sample,category];  %为特征值加上动作种类
Sample_set(num_file,:)=Sample;    %写入0矩阵中
end

Sample_set_670 = num2cell(Sample_set);
xlswrite('a.xlsx',[characteristic_headers;Sample_set_670]);