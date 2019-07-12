%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo','pcaInfo');
nNeurons = numel(neuronInfo);
fprintf('\nDone!\n');

%% PCA data.
pcaScore = cat(1,neuronInfo.pca);           %% pca score.

%% Gather gene scores.
values = cat(2,neuronInfo.geneScore)';      %% 'raw' gene score.

%% Sort by neurons.
[~,sortNeurons] = sort(pcaScore(:,1));
values = values(sortNeurons,:)';

%% Sort by genes.
[~,sortGenes] = sort(pcaInfo.coeff(:,1));
values = values(sortGenes,:);
genes = neuronInfo(1).genes(sortGenes);

%% Plot.
yBin = 25;
Y = 0:yBin:100;
X = genes;
hFig = figure;
hAx =axes;
hAx.XLim =[0.5,size(values,1)+0.5];
hAx.YLim =[0.5,size(values,2)+0.5];
hAx.CLim = [0,15];
hAx.YDir = 'reverse';
hAx.XAxisLocation = 'top';
hAx.YTick = Y;
hAx.XTick = [1:hAx.XLim(2)];
hAx.XTickLabel = X;
hAx.TickDir = 'out';
hAx.DataAspectRatio = [1,1,1];
hFig.Color = [1,1,1];
xtickangle(45);
hold on
colormap(hAx,'parula')
imagesc(values');
ylabel('Neurons'); 
c = colorbar;
c.Label.String = 'Inferred Gene Expression';
hAx.DataAspectRatio = [0.06,1,1];
hAx.YDir = 'normal';
c.Position(4) = 0.3;
c.Position(1) = 0.85;
hFig.Color = [1,1,1];
c.TickDirection = 'out';
hAx.Color = [1,1,1];
c.Visible = 'off';