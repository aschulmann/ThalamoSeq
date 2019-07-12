%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
areaGroupFile = 'anatomyGroupInfo.mat';

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% Load area info.
load(fullfile(mainFolder,'..','..','Data','Output',areaGroupFile),'anGroupInfo');

%% PCA data.
pcaScore = cat(1,neuronInfo.pca);

%% get mediolateral position.
mlPos = cat(1,neuronInfo.position);
mlPos = abs(5695 - mlPos(:,1))/1000;

%% Scatter plot names.
hFig = figure;
hAx = axes;
hAx.XLim = [-6,7];
hAx.YLim = [0,2];
hold on
%plot by group identity.
for iGroup = 1:numel(anGroupInfo)
    indGroup = find(ismember({neuronInfo.loc},anGroupInfo(iGroup).areas));
    % plot neurons in group.
    for iNeuron = 1:numel(indGroup)
        cNeuron = indGroup(iNeuron);
        hT = text(pcaScore(cNeuron,1), mlPos(cNeuron),...
            neuronInfo(cNeuron).loc,...
            'VerticalAlignment','middle',...
            'HorizontalAlignment','center',...
            'Color', anGroupInfo(iGroup).color,...
            'FontSize',12);
    end
end
% linear fit.
[fObj, gof,output] = fit( pcaScore(:,1), mlPos ,  'poly1' );
regInfo = regstats(pcaScore(:,1),  mlPos ,'linear');
hF = plot(fObj);
hF.LineStyle = '--';
hF.Color = [0,0,0];
hAx.PlotBoxAspectRatio = [1,0.85,1];
text(0.05,0.95,sprintf('\nR^2 = %.2f\n\tp = %.2e\nt = %.3f\ndfe = %i',regInfo.rsquare,regInfo.tstat.pval(2),regInfo.tstat.t(2),regInfo.tstat.dfe),'Units','normalized',...
    'HorizontalAlignment','left')
legend off
%format.
hFig.Color = [1,1,1];
xlabel('PC1 Score');
ylabel(sprintf('Mediolateral Position (mm)'));
hAx.TickDir = 'out';
