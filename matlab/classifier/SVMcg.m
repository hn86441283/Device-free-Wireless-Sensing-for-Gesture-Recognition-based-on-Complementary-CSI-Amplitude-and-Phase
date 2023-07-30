function [bestacc,bestc,bestg] = SVMcg(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
% train_label:Training set labels
% train:Training set
% cmin:Minimum value of the range of variation of the penalty parameter c (after taking the logarithm of the base 2), i.e. c_min = 2^(cmin). The default is -5
% cmax:The maximum value of the range of variation of the penalty parameter c (after taking the logarithm of the base 2), i.e. c_max = 2^(cmax). The default is 5
% gmin:The minimum value of the range of variation of the parameter g (after taking the logarithm of the base 2), i.e. g_min = 2^(gmin). The default is -5.
% gmax:The minimum value of the range of variation of the parameter g (after taking the logarithm of the base 2), i.e. g_min = 2^(gmax). Defaults to 5.
%
% v:cross validation parameter, i.e., divide the test set into several parts for cross validation. default is 3.
% cstep:The parameter c is the size of the step. The default is 1
% gstep:The parameter g is the size of the step. The default is 1
% accstep:The step size for the final display of the accuracy plot. The default is 1.5
%% Regarding the starting parameter of the SVM, the number of variable inputs to the nargin read function
if nargin < 10  %0£¬1£¬2£¬3£¬4£¬5£¬6£¬7£¬8£¬9
    accstep = 1.5;
end
if nargin < 8  %0£¬1£¬2£¬3£¬4£¬5£¬6£¬7
    accstep = 1.5;
    cstep = 1;
    gstep = 1;
end
if nargin < 7  %0£¬1£¬2£¬3£¬4£¬5£¬6
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
end
if nargin < 6  %0£¬1£¬2£¬3£¬4£¬5
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
end
if nargin < 5  %0£¬1£¬2£¬3£¬4
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
end
if nargin < 4  %0£¬1£¬2£¬3
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
    cmax = 5;
end
if nargin < 3  %0£¬1£¬2
    accstep = 1.5;
    v = 3;
    cstep = 1;
    gstep = 1;
    gmax = 5;
    gmin = -5;
    cmax = 5;
    cmin = -5;
end
%% X corresponds to the broadcast matrix for the c parameter and Y corresponds to the broadcast matrix for the g parameter, with cg being used to hold the highest acc values
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
[m,n] = size(X);
cg = zeros(m,n);
%% Calculate the correctness rate corresponding to each step, obtain the maximum correctness rate bestacc and the minimum penalty parameter bestc
bestc = 0;
bestg = 0;
bestacc = 0;
basenum = 2;
for i = 1:m
    for j = 1:n
        cmd = ['-v ',num2str(v),' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) )];
        cg(i,j) = svmtrain(train_label, train, cmd);
        
        if cg(i,j) > bestacc
            bestacc = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        if ( cg(i,j) == bestacc && bestc > basenum^X(i,j) )   %The smaller c is, the better the generalization ability, but it is prone to underfitting problems
            bestacc = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        
    end
end
%% Draw the values of acc corresponding to different values of the parameters c, g
[C,h] = contour(X,Y,cg,60:accstep:100);
clabel(C,h,'FontSize',10,'Color','r');
xlabel('log2c','FontSize',10);
ylabel('log2g','FontSize',10);
grid on;