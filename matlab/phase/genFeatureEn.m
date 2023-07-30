function fea = genFeatureEn(data,featureNamesCell)
%input:
%data: input data
%featureNamesCell: feature name
%output:
%fea: Feature value corresponding to feature name
rng('default')
data = data';
[len,num] = size(data); %Get data size, data length/number of data groups
if len == 1  %One-dimensional data rows and columns are oriented incorrectly if
    data = data';
    [len,num] = size(data); %Get data size, data length/number of data groups
end
allFeaNames = {'psdE','eE'}; %All feature names

%% information entropy
% power spectral entropy
psdE=zeros(1,num);%initialization
if sum(contains(featureNamesCell,{'psdE'}))
    psdE = kPowerSpectrumEntropy(data);
end
% energy entropy
eE = zeros(1,num);%initialization
if sum(contains(featureNamesCell,{'eE'}))
    eE = kEnergyEntropy(data);
end
allFea = [psdE;eE];
%% end. Assignment of value to output variable fea
fea = [];
for i = 1:length(featureNamesCell)
    %featureNamesCell{i} == allFeaNames;
    try
    if find(contains(allFeaNames,featureNamesCell{i})) %If the current feature is in the feature list
        fea = [fea;allFea(find(strcmp(allFeaNames,featureNamesCell{i})),:)];
    end
    catch ME 
    end
end

fea = fea';
end

function ie = kInformationEntopy(sig,SegmentNum)
% Calculate the information entropy of the signal
% input£º
% sig£ºinput signal
% SegmentNum£ºThe number of proposed groups, if not entered, is automatically calculated using the Sturges empirical formula.
% output£º
% ie£ºInformation entropy solving result
[len,num] = size(sig);
if num >= 2
    SigLen = len;  %Input signal length
    if nargin == 1
        SegmentNum = round(1.87*(SigLen-1)^(2/5));  %Sturges' empirical formula for finding the optimal number of groupings
    end
    CutLen = SigLen/SegmentNum; %Signal length per group
    Ent = [];
    for i = 1:SegmentNum
        Ent = [Ent;sum(sig(round(CutLen*(i-1)+1):round(CutLen*i),:),1)];  %Find the total energy of each set of signals
    end
    pk = Ent./sum(Ent,2); %Size of kth energy as a fraction of total energy
    ie = -sum(pk.*log(pk)); %information entropy equation
end 
if num == 1
    
    [SigLen,~] = size(sig);  %Input signal length
    if nargin == 1
        SegmentNum = round(1.87*(SigLen-1)^(2/5));  %Sturges' empirical formula for finding the optimal number of groupings
    end
    CutLen = SigLen/SegmentNum; %Signal length per group
    for i = 1:SegmentNum
        Ent(i) = sum(sig(round(CutLen*(i-1)+1):round(CutLen*i)));  %Find the total energy of each set of signals
    end
    pk = Ent/sum(Ent); %Size of kth energy as a fraction of total energy
    ie = -sum(pk.*log(pk)); %information entropy equation
end
end

function psdE = kPowerSpectrumEntropy(data)
% Find the power spectral entropy of the signal
% The power spectrum is calculated using the periodogram method to obtain
% input£º
% data£ºSignal to be analyzed
% ouput£º
% psdE£ºPower spectrum entropy
[len,num] = size(data);
psdE = []; 
for j = 1:num
    [pxx] = periodogram(data(:,j)); %Periodogram method for finding power spectrum
    [len,~] = size(pxx);
    psdE(j) = kInformationEntopy( pxx,len);
end


end
function eE = kEnergyEntropy(data)
% Finding the energy entropy of a signal based on the emd decomposition algorithm
% input£º
% data£ºSignal to be analyzed
% ouput£º
% eE£ºEnergy entropy

% MATLAB 2018a and newer required
[len,num] = size(data);
for i = 1:num
    imf = emd(data(:,i),'Display',1);
    imfE = sum(imf.^2,2);
    eE(i) = kInformationEntopy(imfE,length(imfE)); 
end
end
