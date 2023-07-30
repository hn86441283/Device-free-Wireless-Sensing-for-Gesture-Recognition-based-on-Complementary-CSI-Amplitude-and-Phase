function [bestacc,bestc,bestg,cg] = SVMcgPP(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
%本作者不提供技术支持，不对代码负责，免费，随意改。
%并行部分author@https://blog.csdn.net/u013249853/article/list/1
%
% 使用说明.如下:
% [bestacc,bestc,bestg,cg] = SVMcgPP(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
%
% train_label:训练 集标签.要求与libsvm工具箱中要求一致.
% train:训练集.要求与libsvm工具箱中要求一致.
% cmin:惩罚参数c的变化范围的最小值(取以2为底的对数后),即 c_min = 2^(cmin).默认为 -5
% cmax:惩罚参数c的变化范围的最大值(取以2为底的对数后),即 c_max = 2^(cmax).默认为 5
% gmin:参数g的变化范围的最小值(取以2为底的对数后),即 g_min = 2^(gmin).默认为 -5
% gmax:参数g的变化范围的最小值(取以2为底的对数后),即 g_min = 2^(gmax).默认为 5
%
% v:cross validation的参数,即给测试集分为几部分进行cross validation.默认为 3
% cstep:参数c步进的大小.默认为 1
% gstep:参数g步进的大小.默认为 1
% accstep:最后显示准确率图时的步进大小. 默认为 1.5
 
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