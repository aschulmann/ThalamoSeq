%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
areaGroupFile = 'anatomyGroupInfo.mat';

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% Load area info.
load(fullfile(mainFolder,'..','Data','Output',areaGroupFile),'anGroupInfo');

for iGroup = 1:numel(anGroupInfo)
    % select neurons in group.
    ind = ismember({neuronInfo.loc},anGroupInfo(iGroup).areas);
    groupInfo = neuronInfo(ind);
    nNeurons = numel(groupInfo);
    fprintf('\nGroup: %s, n: %i',anGroupInfo(iGroup).name,nNeurons);
end