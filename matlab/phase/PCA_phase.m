clc;
clear;
close all;
load data_after_phase_fisher.mat;
[m,n] = size(after_fisher_phase_data);
[coeff, score, latent, tsquared, explained, mu]=pca(after_fisher_phase_data(:,1:n-1));
a=cumsum(latent)./sum(latent);   % Calculate the cumulative contribution of the feature
% Both explained and latent can be used to calculate how many dimensions can be taken after 
% dimensionality reduction to achieve the accuracy you need, and the effects are equivalent.
% explained=100*latent./sum(latent); 
idx=find(a>0.95);    % The number of dimensions in which the cumulative contribution of features is not 
% less than 0.95 is used as the number of features after PCA dimensionality reduction
k=idx(1);
Feature=score(:,1:k);   % Take the first k columns of the transformed matrix score as PCA reduced features
Feature = [Feature,after_fisher_phase_data(:,end)];