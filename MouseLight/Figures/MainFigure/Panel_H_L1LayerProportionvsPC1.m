%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
areaGroupFile = 'anatomyGroupInfo.mat';
%analysis.
binSize = 0.05;
lapRange = [0.92, 1];
% lapRange = [0.78, 1];

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
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

%% Go through neurons.
data = NaN(nNeurons,1);
for iNeuron = 1:nNeurons
    fprintf('\nNeuron %s %i\\%i',neuronInfo(iNeuron).id,iNeuron,nNeurons);
    % get laplacian depth values.
    cNeuron = neuronInfo(iNeuron).morphology.axon;
    lapVal = getLaplacianValues(cNeuron,ILap,1);
    %ratio
    ind = lapVal>lapRange(1) & lapVal<lapRange(2);
    area1 = sum(ind); area2 = sum(~ind);
    data(iNeuron) = area1/(area1+area2);
end
% remove NaN( true for one neuron outside Laplacian)
ind = find(isnan(data));
neuronInfo(ind) = [];
data(ind) = [];
pcaScore(ind,:) = [];

%% Scatter plot names.
hFig = figure;
hAx = axes;
hAx.XLim = [-6,7];
hAx.YLim = [0,1];
hold on
%plot by group identity.
for iGroup = 1:numel(anGroupInfo)
    indGroup = find(ismember({neuronInfo.loc},anGroupInfo(iGroup).areas));
    % plot neurons in group.
    for iNeuron = 1:numel(indGroup)
        cNeuron = indGroup(iNeuron);
        hT = text(pcaScore(cNeuron,1), data(cNeuron),...
            neuronInfo(cNeuron).loc,...
            'VerticalAlignment','middle',...
            'HorizontalAlignment','center',...
            'Color', anGroupInfo(iGroup).color,...
            'FontSize',12);
    end
end
% linear fit.
[fObj, gof,output] = fit( pcaScore(:,1), data ,  'poly1' );
regInfo = regstats(pcaScore(:,1), data,'linear');
hF = plot(fObj);
hF.LineStyle = '--';
hF.Color = [0,0,0];
hAx.PlotBoxAspectRatio = [1,0.85,1];
text(0.05,0.95,sprintf('\nR^2 = %.2f\n\tp = %.2e\nt = %.3f\ndfe = %i',regInfo.rsquare,regInfo.tstat.pval(2),regInfo.tstat.t(2),regInfo.tstat.dfe),'Units','normalized',...
    'HorizontalAlignment','left')
legend off
%format.
hFig.Color = [1,1,1];
xlabel('Gene PC1');
ylabel(sprintf('Top Layers Proportion (norm. %%)'));
hAx.TickDir = 'out';
