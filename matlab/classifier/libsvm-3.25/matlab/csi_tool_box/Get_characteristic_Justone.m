file_index = ['C:\Users\xjc\Desktop\���ݼ�\test',num2str(1),'.dat']
%a=['xxx',num2str(n)]

csi_trace = read_bf_file(file_index);

for i = 1:600%������ȡ�����ݰ��ĸ���
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry); %��ȡcsi����    
        csi = csi(1,:,:);

	csi_j = (squeeze(csi).');  %����λ��Ϣ
        csi1 = abs(squeeze(csi).');          %��ȡ��ֵ(��ά+ת��)
        
        %ֻȡһ�����ߵ�����
	first_ant_csi_j(:,i) = csi_j(:,1);  
        first_ant_csi(:,i) = csi1(:,1);           %ֱ��ȡ��һ������(����Ҫforѭ��ȡ)
        second_ant_csi(:,i) = csi1(:,2);
        third_ant_csi(:,i) = csi1(:,3);
                     
%         for j=1:30
%             csi15_end(i,:)=csi1(j,:);           %3���ŵ���j�����ز�
%         end
end
 
first_ant_csi_1 = first_ant_csi(1,:);
%��ȡ����,51~550
first_ant_csi_1 = first_ant_csi_1(1,51:550);
n = length(first_ant_csi_1);        %������������
%��ֵ
Charac_mean = mean(first_ant_csi_1(:));                                                                 %��
%��׼��
charac_std = std(first_ant_csi_1);                                                                      %��
%���ֵ
charac_max = max(first_ant_csi_1);                                                                      %��
%��Сֵ
charac_min = min(first_ant_csi_1);                                                                      %��
%��Χ
charac_scope = charac_max-charac_min;                                                                   %��
%����ֵ����

n_num_beyond_mean =0;
for j=1:n
    if (first_ant_csi_1(1,j)>Charac_mean)
        n_num_beyond_mean = n_num_beyond_mean + 1;
    end
end

charac_beyondmean = n_num_beyond_mean;                                                                   %��


%1/4��λ��
charac_onefour = quantile(first_ant_csi_1,0.25,2);                                                       %��

%3/4��λ��

charac_threefour = quantile(first_ant_csi_1,0.75,2);                                                      %��

%�ķ�λ����Χ
charac_Quantile_scope = charac_threefour - charac_onefour;                                                %��

%����Ҷ�任
fs=100;         
fft_amp =abs(fft(first_ant_csi_1,n));        %��ɢ����Ҷ�任
fft_f = (0:n-1)*(fs/n);        %��ɢ����Ҷ�任Ƶ����


%******************************************Ƶ��������ȡ************************************************************
    fft_amp_apx=fft_amp;            % fft_amp�ı���
    [fft_amp_sort,index]=sort(fft_amp_apx,'descend');     %��������fft_amp_sortΪ�������������У�indexΪ������ֵ��Ӧ��ԭ������������
    fft_amp_second=fft_amp_sort(1,2);                   %�ڶ���FFT                                           %��
    fft_amp_second_index=fft_f(1,index(1,2));           %�ڶ���FFT��Ӧ��Ƶ��                                 %�٢�
    fft_amp_third=fft_amp_sort(1,3);                  %������FFT                                           %�٢�
    fft_amp_third_index=fft_f(1,index(1,3));          %������FFT��Ӧ��Ƶ��                                  %�٢�
    fft_amp_fifth=fft_amp_sort(1,5);                   %�����FFT                                           %�٢�
    fft_amp_fifth_index=fft_f(1,index(1,5));           %�����FFT��Ӧ��Ƶ��                                  %�٢�
 
   %*********����ͳ������***************************
    average_fft_amp=mean(fft_amp(:));                       %Ƶ��ƽ��ֵ                                       %�٢�
    stade_fft_amp=std(fft_amp(:));                          %Ƶ���׼��                                       %�٢�
    n_fft=length(fft_amp);                                  %��ȡƵ�򳤶�                                      
    
    %************************************�ķ�λ�����䷶Χ******************************************
    charac_fft_amp_onefour = quantile(fft_amp,0.25,2);                                                        %�٢�     
    charac_fft_amp_threefour = quantile(fft_amp,0.75,2);                                                      %�٢�      
   charac_fft_amp_Quantile_scope = charac_fft_amp_threefour - charac_fft_amp_onefour;                         %�ک�
    
    
    
    %*********����ͳ������״ͳ�ƣ�����������ʼ��*******************************************************
    skew=0;
    kurt=0;
    average_amp_shape=0;
    skew_fft_amp_shape=0;
    stade_fft_amp_shape=0;
    kurt_fft_amp_shape=0;
    %*************************************************************************************************
    
    
    S=sum(fft_amp);                                         %S��һ�������������ź�Ƶ����ȵĺ�
    for i_fft=1:n_fft
        skew=skew+((fft_amp(1,i_fft)-average_fft_amp)/stade_fft_amp)^3;
        kurt=kurt+((fft_amp(1,i_fft)-average_fft_amp)/stade_fft_amp)^4;
        average_amp_shape=average_amp_shape+i_fft*fft_amp(1,i_fft);
 
    end
    skew=skew/n_fft;                                        %ƫ��                                                 %�ڢ�
    kurt=kurt/n_fft-3;                                      %���                                                 %�ڢ�
    average_amp_shape=average_amp_shape/n_fft;              %��״ͳ�ƾ�ֵ                                          %�ڢ�
    
    
     %*****************��״ͳ�Ʊ�׼��**********************************************************************
    for j_fft=1:n_fft
    stade_fft_amp_shape=stade_fft_amp_shape+(j_fft-average_amp_shape)^2*fft_amp(j_fft);
    end
    stade_fft_amp_shape=sqrt(stade_fft_amp_shape/S);                                                               %�ڢ�
    %********************************************************************************************************
    
    %*****************��״ͳ��ƫ�ȣ����****************************
    
    for k_fft=1:n_fft
    skew_fft_amp_shape=skew_fft_amp_shape+((k_fft-average_amp_shape)/stade_fft_amp_shape)^3*fft_amp(1,k_fft);
    kurt_fft_amp_shape=kurt_fft_amp_shape+((k_fft-average_amp_shape)/stade_fft_amp_shape)^4*fft_amp(1,k_fft);
    end
    skew_fft_amp_shape=skew_fft_amp_shape/S;                                                                       %�ڢ� 
    kurt_fft_amp_shape=(kurt_fft_amp_shape-3)/S;                                                                   %�ڢ�
    
    


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

 