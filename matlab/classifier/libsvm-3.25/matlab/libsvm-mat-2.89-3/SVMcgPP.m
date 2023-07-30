function [bestacc,bestc,bestg,cg] = SVMcgPP(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
%�����߲��ṩ����֧�֣����Դ��븺����ѣ�����ġ�
%���в���author@https://blog.csdn.net/u013249853/article/list/1
%
% ʹ��˵��.����:
% [bestacc,bestc,bestg,cg] = SVMcgPP(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
%
% train_label:ѵ�� ����ǩ.Ҫ����libsvm��������Ҫ��һ��.
% train:ѵ����.Ҫ����libsvm��������Ҫ��һ��.
% cmin:�ͷ�����c�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� c_min = 2^(cmin).Ĭ��Ϊ -5
% cmax:�ͷ�����c�ı仯��Χ�����ֵ(ȡ��2Ϊ�׵Ķ�����),�� c_max = 2^(cmax).Ĭ��Ϊ 5
% gmin:����g�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� g_min = 2^(gmin).Ĭ��Ϊ -5
% gmax:����g�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� g_min = 2^(gmax).Ĭ��Ϊ 5
%
% v:cross validation�Ĳ���,�������Լ���Ϊ�����ֽ���cross validation.Ĭ��Ϊ 3
% cstep:����c�����Ĵ�С.Ĭ��Ϊ 1
% gstep:����g�����Ĵ�С.Ĭ��Ϊ 1
% accstep:�����ʾ׼ȷ��ͼʱ�Ĳ�����С. Ĭ��Ϊ 1.5
 
%% about the parameters of SVMcg
if nargin < 10
    accstep = 1.5;
end
if nargin < 8
    accstep = 1.5;
    cstep = 1;
    gstep = 1;
end
if nargin < 7
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
end
if nargin < 6
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
end
if nargin < 5
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
end
if nargin < 4
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
    cmax = 5;
end
if nargin < 3
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
    cmax = 5;
    cmin = -5;
end
%% X:c Y:g cg:acc
x = length(cmin:cstep:cmax);
y = length(gmin:gstep:gmax);
A = [];
C = [cmin:cstep:cmax];
G = [gmin:gstep:gmax];
o=1;
for i = 1:x
    for j = 1:y
        A(o,1) = C(i);
        A(o,2) = G(j);
        o=o+1;
    end
end
% [m,n] = size(X);
cg =[];
%% record acc with different c & g,and find the bestacc with the smallest c
bestc = 0;
bestg = 0;
bestacc = 0;
basenum = 2;
parfor i=1:o-1
    cmd = ['-v ',num2str(v),' -c ',num2str( basenum^A(i,1) ),' -g ',num2str( basenum^A(i,2) )];
    cg(i) = svmtrain(train_label, train, cmd);
end
% parfor i = 1:m
%     for j = 1:n
%         cmd = ['-v ',num2str(v),' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) )];
%         cg(i,j) = svmtrain(train_label, train, cmd);
%     end
% end
%         if cg(i,j) > bestacc
%             bestacc = cg(i,j);
%             bestc = basenum^X(i,j);
%             bestg = basenum^Y(i,j);
%         end
%         if ( cg(i,j) == bestacc && bestc > basenum^X(i,j) )
%             bestacc = cg(i,j);
%             bestc = basenum^X(i,j);
%             bestg = basenum^Y(i,j);
%         end
[bestacc,I] = max(max(cg));
bestc = basenum^A(I,1);
bestg = basenum^A(I,2);
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
cg1 = reshape(cg,[y,x]);
%% to draw the acc with different c & g
[C,h] = contour(X,Y,cg1,60:accstep:100);
clabel(C,h,'FontSize',10,'Color','r');
xlabel('log2c','FontSize',10);
ylabel('log2g','FontSize',10);
grid on;