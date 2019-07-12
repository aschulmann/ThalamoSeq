%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
areaGroupFile = 'anatomyGroupInfo.mat';
%analysis
allenName = 'CP';
hemi = 'bi';
prop = 'totalLength';

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% Load area info.
load(fullfile(mainFolder,'..','..','Data','Output',areaGroupFile),'anGroupInfo');

%% PCa data.
pcaScore = cat(1,neuronInfo.pca);

%% Region info.
[allenInfo] = getAllenAnatomyInfo(allenName,'Property','acronym');

%% Go through neurons.
data = NaN(nNeurons,1);
for iNeuron = 1:nNeurons
   cNeuron = neuronInfo(iNeuron).id;
   fprintf('\nNeuron %s [%i\\%i]',cNeuron,iNeuron,nNeurons);
   [info] = neuronInfoAllenRegion(neuronInfo(iNeuron).morphology.axon,allenInfo.structure_id_path );
   data(iNeuron) = info.(hemi).(prop)/1000;
end

%% Scatter plot names.
hFig = figure;
hAx = axes;
hAx.XLim = [-6,7];
hAx.YLim = [0,110];
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
xlabel('PC1 Score');
ylabel(sprintf('Axonal length\nCaudoputamen(mm)'));
hAx.TickDir = 'out';
