%%
%%��ʼ������
fall_sample=330;                            %����������
not_fall_sample=400;                        %�ǵ���������
k=4;                                        %������֤����
one_fall = floor(fall_sample / k);          %������һ�ݽ�����֤�Ĵ�С
one_not_fall = floor(not_fall_sample / k);  %�ǵ�����һ�ݽ�����֤�Ĵ�С


a = ( 1 : one_fall);                                  %������������1
b = ( one_fall * 1 + 1 : one_fall * 2);               %������������2
c = ( one_fall * 2 + 1 : one_fall * 3);               %������������3
d = ( one_fall * 3 + 1 : fall_sample);                %������������4
e = ( fall_sample +1 :  fall_sample+ one_not_fall);                             %�ǵ�����������1
f = ( fall_sample + (one_not_fall * 1) +1 : fall_sample + (one_not_fall * 2));  %�ǵ�����������2
g = ( fall_sample + (one_not_fall * 2) +1 : fall_sample + (one_not_fall * 3));  %�ǵ�����������3
h = ( fall_sample + (one_not_fall * 3) +1 : fall_sample + not_fall_sample);     %�ǵ�����������4

%%
%%������֤
 for i=1:k
    switch i
        case 1
            test1=a;
            train1=([b,c,d]);
            test2=e;
            train2=([f,g,h]);
            train=([train1,train2]);
            test=([test1,test2]);
        case 2
            test1=b;
            train1=([a,c,d]);
            test2=f;
            train2=([e,g,h]);
            train=([train1,train2]);
            test=([test1,test2]);
        case 3
            test1=c;
            train1=([a,b,d]);
            test2=g;
            train2=([e,f,h]);
            train=([train1,train2]);
            test=([test1,test2]);
        case 4
            test1=d;
            train1=([a,b,c]);
            test2=h;
            train2=([e,f,g]);
            train=([train1,train2]);
            test=([test1,test2]);
        otherwise
        disp('������֤����');
    end
	
 end