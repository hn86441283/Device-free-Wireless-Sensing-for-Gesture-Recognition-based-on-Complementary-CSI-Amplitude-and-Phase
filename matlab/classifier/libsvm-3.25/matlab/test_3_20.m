load model_90;

data_filename ='database_2700.xlsx';
data = xlsread(data_filename); 
function read_excel_quiet()
ap1_mp1=zeros(1,600);%设置一个全零数组存放600个子载波信息
panduan=zeros(1,50);%设置一个全零的数组用于存放子载波数组中第二百到二百五的数，便于进行幅值判断
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

    while 1 %一个死循环，确保后续操作能一直进行
     if(max(panduan)-min(panduan)>7)&&(min(panduan)~=0)%当判断数组中的最大值与最小值幅值满足条件是将数组送入跌倒算法判断
        if 2>1%跌倒检测的算法
            first_ant_csi_1=ap1_mp1(51,550)
         
            
n = length(first_ant_csi_1);        %单样本包长度
%***************************************DWT小波除噪******************************************************
xinhao_csi = first_ant_csi_1;  

[c,l] = wavedec(xinhao_csi,3,'db7');              %对信号进行小波分解 得到平滑系数C与小波系数l
c(l(4):end) = 0;                                  %选择滤波频率
y=waverec(c,l,'db7');                             %滤波

first_ant_csi_1 = y;                              %滤波后的信号    

%step = 12;
%for time = 1:20

   %new_first_ant_csi =  first_ant_csi_1(1,1+time*step:256+time*step);%取得256个数据包;

%********************************************时域特征提取*************************************************
%均值
Charac_mean = mean(first_ant_csi_1);                                                                 %①
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
for j=1:256  %n=500
    if (first_ant_csi_1(1,j)>Charac_mean)
        n_num_beyond_mean = n_num_beyond_mean + 1;
    end
end

charac_beyondmean = n_num_beyond_mean;     %求得过均值点个数                                                              %⑥


%1/4分位数
charac_onefour = quantile(first_ant_csi_1,0.25,2);                                                       %⑦

%3/4分位数

charac_threefour = quantile(first_ant_csi_1,0.75,2);                                                      %⑧

%四分位数范围
charac_Quantile_scope = charac_threefour - charac_onefour;                                                %⑨

%傅里叶变换
fs=100;   %采样频率      
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
    
    


 
 Sample = [Charac_mean,charac_std,charac_max,charac_min,charac_scope,...
     charac_beyondmean,charac_onefour,charac_threefour,charac_Quantile_scope,...
     fft_amp_second,fft_amp_second_index,fft_amp_third,fft_amp_third_index,...
     fft_amp_fifth,fft_amp_fifth_index,average_fft_amp,stade_fft_amp,...
     charac_fft_amp_onefour,charac_fft_amp_threefour,charac_fft_amp_Quantile_scope,...
     skew,kurt,average_amp_shape,stade_fft_amp_shape,skew_fft_amp_shape,kurt_fft_amp_shape];

%***************************************************特征值归一化*********************************
Sample_set(1,:)=Sample;    %写入0矩阵中
motion_sample =zeros(1,26);
for n_n=1:26
    chara_max=max( data(:,n_n ));
    chara_min=min( data(:,n_n ));
    x=(Sample_set(1,n_n) - chara_min )/(chara_max - chara_min);
    motion_sample(1,n_n) = x;
end

%***************************************************输出结果********************************************
 b=[1];
 [Predictlable, accuracy, dec_values] = svmpredict(b,motion_sample,model);
 if(Predictlable == 0)
     fprintf('跌倒');
 else
     fprintf('非跌倒');


%****************************************************跌倒检测*******************************************         


            sound(y,Fs);
            
            ap1_mp1=zeros(1,600);%将已经进行过检测的数组置零，由于全零数组不满足判断条件，顾能进入else进行收数
%              xvhao=xvhao+1;
%              fid = fopen(['/home/diana/data/test' num2str(xvhao) '.xlsx'],'a+');
%              fprintf(fid,'%c',ap1_mp1(350));
%             fclose(fid);
            panduan=zeros(1,50);
        end       
         
     else  %当不满足上述if的判定时，持续进行收数
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
        for i=1:599 %传递六百个子载波数组
            ap1_mp1(i)=ap1_mp1(i+1);
        end
        for m=1:49
            panduan(m)=panduan(m+1);
        end
        ap1_mp1(600)=abs(squeeze(csi(1,1,1)).');%将子载波信息赋给ap1_mp1数组的最后一个数
        
        panduan(50)=ap1_mp1(250);
        csi_entry = [];       
     end
    end
    fclose(t);
    delete(t);
end
end
