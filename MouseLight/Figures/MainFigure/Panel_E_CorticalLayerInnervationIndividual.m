%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
% display.
binSize = 0.05;
colorRange = [-5,4];

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = numel(neuronInfo);
fprintf('\nDone!\n');

%% Load FlatMap.
fprintf('\nLoading Laplacian');
load(fullfile(mainFolder,'..','..','Data','Output','Laplacian.mat'),'ILap');
fprintf('\nDone!\n');

%% PCA data.
pcaScore = cat(1,neuronInfo.pca);

%% Go through neurons.
data = struct();
for iNeuron = 1:nNeurons
    fprintf('\nNeuron %s %i\\%i',neuronInfo(iNeuron).id,iNeuron,nNeurons);
    % get laplacian values.
    cNeuron = neuronInfo(iNeuron).morphology.axon;
    lapVal = getLaplacianValues(cNeuron,ILap,1);
    % Histogram
    [N,edges] = histcounts(lapVal,0:binSize:1);
    % Stats.
    data(iNeuron).values = lapVal;
    data(iNeuron).N = N;
end

%% Collect data.
histData = cat(1,data.N);
histData = histData./repmat(sum(histData,2),1,size(histData,2)); % normalize to total.
% order.
[~,sortInd] = sort(pcaScore(:,1));
score = pcaScore(sortInd,1);
histData = histData(sortInd,:);       
% organize data for area3 function.
xData = repmat(binSize/2:binSize:1,nNeurons,1);     % nNeurons-by-binPositions
yData = [1:nNeurons];                               % nNeurons-by-1
zData = histData;                                   % nNeurons-by-binScores

%% Color code.
colorInd = uint8((score(:,1)-colorRange(1)) / (colorRange(2)-colorRange(1))*254)+1;
cMap = flipud(jet(255));
cMap = cMap(colorInd,:);

%% Plot.
options = struct(...
    'Edgecolor',[0.2,0.2,0.2],...
    'Color',flipud(cMap),...
    'barwidth',0.1);
alphaVal = 0.5;
options.TScaling=[alphaVal  alphaVal ;
                  alphaVal  alphaVal ; 
                  alphaVal  alphaVal];
hFig = figure;
hAx = axes;
hA = area3(flipud(xData),yData,flipud(zData),options);hold on
xlabel('Normalized Depth'); 
ylabel('PCA Score order (Low-High)');
zlabel('Normalized Axon Length');
hAx.PlotBoxAspectRatio = [1,1.4,1];
view(0,65)
