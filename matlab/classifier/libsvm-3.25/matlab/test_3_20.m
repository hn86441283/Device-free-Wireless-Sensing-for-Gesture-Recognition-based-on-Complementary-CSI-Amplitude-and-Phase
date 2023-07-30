load model_90;

data_filename ='database_2700.xlsx';
data = xlsread(data_filename); 
function read_excel_quiet()
ap1_mp1=zeros(1,600);%����һ��ȫ��������600�����ز���Ϣ
panduan=zeros(1,50);%����һ��ȫ����������ڴ�����ز������еڶ��ٵ���������������ڽ��з�ֵ�ж�
% xvhao=0;
[y,Fs]=audioread('/home/diana/quiet_min.mp3');
while 1

    port = 8090;
    t = tcpip('0.0.0.0', port, 'NetworkRole', 'server');
    t.InputBufferSize = 1024;
    t.Timeout = 15;
    fprintf('Waiting for connection on port %d\n',port);
    fopen(t);
    fprintf('Accept connection from %s\n',t.RemoteHost);

                                                                                                    
    clf;
    axis([1,30,-10,30]);
    t1=0;
    m1=zeros(30,1);


    [~,DATESTR] = version();
    if datenum(DATESTR) > datenum('February 11, 2014')
        p = plot(t1,m1,'MarkerSize',5);
    else
        p = plot(t1,m1,'EraseMode','Xor','MarkerSize',5);
    end

    xlabel('Time');
    ylabel('Subcarrier amplitude');

    csi_entry = [];
    index = -1;
    broken_perm = 0;
    triangle = [1 3 6];

    while 1 %һ����ѭ����ȷ������������һֱ����
     if(max(panduan)-min(panduan)>7)&&(min(panduan)~=0)%���ж������е����ֵ����Сֵ��ֵ���������ǽ�������������㷨�ж�
        if 2>1%���������㷨
            first_ant_csi_1=ap1_mp1(51,550)
         
            
n = length(first_ant_csi_1);        %������������
%***************************************DWTС������******************************************************
xinhao_csi = first_ant_csi_1;  

[c,l] = wavedec(xinhao_csi,3,'db7');              %���źŽ���С���ֽ� �õ�ƽ��ϵ��C��С��ϵ��l
c(l(4):end) = 0;                                  %ѡ���˲�Ƶ��
y=waverec(c,l,'db7');                             %�˲�

first_ant_csi_1 = y;                              %�˲�����ź�    

%step = 12;
%for time = 1:20

   %new_first_ant_csi =  first_ant_csi_1(1,1+time*step:256+time*step);%ȡ��256�����ݰ�;

%********************************************ʱ��������ȡ*************************************************
%��ֵ
Charac_mean = mean(first_ant_csi_1);                                                                 %��
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
for j=1:256  %n=500
    if (first_ant_csi_1(1,j)>Charac_mean)
        n_num_beyond_mean = n_num_beyond_mean + 1;
    end
end

charac_beyondmean = n_num_beyond_mean;     %��ù���ֵ�����                                                              %��


%1/4��λ��
charac_onefour = quantile(first_ant_csi_1,0.25,2);                                                       %��

%3/4��λ��

charac_threefour = quantile(first_ant_csi_1,0.75,2);                                                      %��

%�ķ�λ����Χ
charac_Quantile_scope = charac_threefour - charac_onefour;                                                %��

%����Ҷ�任
fs=100;   %����Ƶ��      
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
    
    


 
 Sample = [Charac_mean,charac_std,charac_max,charac_min,charac_scope,...
     charac_beyondmean,charac_onefour,charac_threefour,charac_Quantile_scope,...
     fft_amp_second,fft_amp_second_index,fft_amp_third,fft_amp_third_index,...
     fft_amp_fifth,fft_amp_fifth_index,average_fft_amp,stade_fft_amp,...
     charac_fft_amp_onefour,charac_fft_amp_threefour,charac_fft_amp_Quantile_scope,...
     skew,kurt,average_amp_shape,stade_fft_amp_shape,skew_fft_amp_shape,kurt_fft_amp_shape];

%***************************************************����ֵ��һ��*********************************
Sample_set(1,:)=Sample;    %д��0������
motion_sample =zeros(1,26);
for n_n=1:26
    chara_max=max( data(:,n_n ));
    chara_min=min( data(:,n_n ));
    x=(Sample_set(1,n_n) - chara_min )/(chara_max - chara_min);
    motion_sample(1,n_n) = x;
end

%***************************************************������********************************************
 b=[1];
 [Predictlable, accuracy, dec_values] = svmpredict(b,motion_sample,model);
 if(Predictlable == 0)
     fprintf('����');
 else
     fprintf('�ǵ���');


%****************************************************�������*******************************************         


            sound(y,Fs);
            
            ap1_mp1=zeros(1,600);%���Ѿ����й������������㣬����ȫ�����鲻�����ж����������ܽ���else��������
%              xvhao=xvhao+1;
%              fid = fopen(['/home/diana/data/test' num2str(xvhao) '.xlsx'],'a+');
%              fprintf(fid,'%c',ap1_mp1(350));
%             fclose(fid);
            panduan=zeros(1,50);
        end       
         
     else  %������������if���ж�ʱ��������������
          s = warning('error', 'instrument:fread:unsuccessfulRead');
        try
            field_len = fread(t, 1, 'uint16');
        catch
            warning(s);
            disp('Timeout, please restart the client and connect again.');
            break;
        end

        code = fread(t,1);    
        if (code == 187) 
            bytes = fread(t, field_len-1, 'uint8');
            bytes = uint8(bytes);
            if (length(bytes) ~= field_len-1)
                fclose(t);
                return;
            end
        else if field_len <= t.InputBufferSize  
            fread(t, field_len-1, 'uint8');
            continue;
            else
                continue;
            end
        end

        if (code == 187) 
            csi_entry = read_bfee(bytes);
        
            perm = csi_entry.perm;
            Nrx = csi_entry.Nrx;
            if Nrx > 1
                if sum(perm) ~= triangle(Nrx) 
                    if broken_perm == 0
                        broken_perm = 1;
                        fprintf('WARN ONCE: Found CSI (%s) with Nrx=%d and invalid perm=[%s]\n', filename, Nrx, int2str(perm));
                    end
                else
                    csi_entry.csi(:,perm(1:Nrx),:) = csi_entry.csi(:,1:Nrx,:);
                end
            end
        end
    
        index = mod(index+1, 10);
        
        csi = get_scaled_csi(csi_entry);
        for i=1:599 %�������ٸ����ز�����
            ap1_mp1(i)=ap1_mp1(i+1);
        end
        for m=1:49
            panduan(m)=panduan(m+1);
        end
        ap1_mp1(600)=abs(squeeze(csi(1,1,1)).');%�����ز���Ϣ����ap1_mp1��������һ����
        
        panduan(50)=ap1_mp1(250);
        csi_entry = [];       
     end
    end
    fclose(t);
    delete(t);
end
end
