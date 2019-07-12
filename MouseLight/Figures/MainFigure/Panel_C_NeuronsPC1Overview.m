%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
colorRange = [-5,4];

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = numel(neuronInfo);
fprintf('\nDone!\n');

%% PCA data.
pcaScore = cat(1,neuronInfo.pca);
score = pcaScore(:,1);

%% Get colors.
cMap = flipud(jet(255));
indScore = round(((score-colorRange(1))/(colorRange(2)-colorRange(1)))*255);
indScore(indScore>255) = 255;
indScore(indScore<1) = 1;
colors = cMap(indScore,:);

%% names.
names = {neuronInfo.id};

%% Load.
reconstructionViewer([neuronInfo.morphology],colors,'Names',names);