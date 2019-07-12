%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
areaGroupFile = 'anatomyGroupInfo.mat';
%analysis.
binSize = 0.05;

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
fprintf('\nDone!\n');

%% Load area info.
load(fullfile(mainFolder,'..','..','Data','Output',areaGroupFile),'anGroupInfo');

%% Load FlatMap.
fprintf('\nLoading Laplacian');
if ~exist('ILap','var')
    load(fullfile(mainFolder,'..','..','Data','Output','Laplacian.mat'),'ILap');
end
fprintf('\nDone!\n');

%% PCA data.
pcaScore = cat(1,neuronInfo.pca);

%% Plot.
hFig = figure;
hFig.Color = [1,1,1];
hAx = axes;
hold on
%
depthData = [];
binEdges = 0:binSize:1;
for iGroup = 1:3
    % select neurons in group.
    ind = ismember({neuronInfo.loc},anGroupInfo(iGroup).areas);
    groupInfo = neuronInfo(ind);
    nNeurons = numel(groupInfo);
    fprintf('\nGroup %s n:%i [%i\\%i]',anGroupInfo(iGroup).name,...
        nNeurons,iGroup,numel(anGroupInfo(iGroup).areas));
    %% Go through neurons.
    data = NaN(numel(binEdges)-1,nNeurons);
    for iNeuron = 1:nNeurons
        % get laplacian depth values.
        cNeuron = groupInfo(iNeuron).morphology.axon;
        lapVal = getLaplacianValues(cNeuron,ILap,1);
        % Histogram
        [N,edges] = histcounts(lapVal,binEdges);
        % Store.
        data(:,iNeuron) = ((N./sum(N))*100)'; % normalized.
    end
    % collect.
    mData = nanmean(data,2);
    stdData = nanstd(data,[],2);    
    semData = stdData/sqrt(nNeurons);
    % plot.
    hE = errorbar(mData,(binSize/2:binSize:1).*100,[],[],semData,semData);
    hE.Marker = 'o';
    hE.MarkerEdgeColor = anGroupInfo(iGroup).color;
    hE.MarkerFaceColor = hE.MarkerEdgeColor;
    hE.Color = hE.MarkerEdgeColor;
    hE.CapSize = 12;    hE.MarkerSize = 8;
    hE.LineWidth = 0.5; hE.MarkerSize = 6;
end
%format.
hAx.YDir = 'normal';
hAx.YLim = [0,100];
hAx.XLim = [0,25];
box off
hAx.TickDir = 'out';
xlabel('Axon Length (% total length)');
ylabel('Cortical Depth (%)');
hAx.Clipping = 'on';
hAx.PlotBoxAspectRatio = [1,1.5,1];

