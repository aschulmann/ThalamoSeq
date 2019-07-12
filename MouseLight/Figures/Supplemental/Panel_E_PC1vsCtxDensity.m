%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
areaGroupFile = 'anatomyGroupInfo.mat';
%analysis
resolutionUm = 1;
minLength = 150;

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% Load area info.
load(fullfile(mainFolder,'..','..','Data','Output',areaGroupFile),'anGroupInfo');

%% load cortex mask.
load(fullfile(mainFolder,'..','..','Data','Output','ctxMask.mat'),'ctxMask');
ctxMask = imresize3(uint8(ctxMask),0.5)>0;

%% PCA data.
pcaScore = cat(1,neuronInfo.pca);

%% get cortex density.
density = NaN(nNeurons,1);
for iNeuron = 1:nNeurons
    fprintf('\nNeuron %s %i\\%i',neuronInfo(iNeuron).id,iNeuron,nNeurons);
    neuron = neuronInfo(iNeuron).morphology.axon;    
    %convert to SWC. 
    swcData = [[neuron.sampleNumber]',[neuron.structureIdValue]',...
    [neuron.x]',[neuron.y]',[neuron.z]',...
    ones(size([neuron.y]',1),1), [neuron.parentNumber]'];
    %upsample.
    [pnts] = upsampleSWC(swcData,resolutionUm);
    pnts(isnan(pnts(:,1)),:) = [];
    %to voxels.
    voxels = round(pnts/200);    
    % find
    ind = sub2ind(size(ctxMask),voxels(:,1),voxels(:,2),voxels(:,3));
    % get voxels in cortex.
    ind = ind(ctxMask(ind));
    % get length in each voxel.
    [N,edges] = histcounts(ind,0:max(ind));
    % sum voxels above threshold.
    totLength = sum(N(N>=minLength))/1000; % to mm.    
    % number of positive voxels.
    nVoxels = sum(N>=minLength);
    coveredArea = (nVoxels*200^3)*1e-9; %% mm3
    % get density.
    density(iNeuron) =  totLength/coveredArea; 
end

%% Scatter plot names.
hFig = figure;
hAx = axes;
hAx.XLim = [-6,7];
hAx.YLim = [0,150];
hold on
%plot by group identity.
for iGroup = 1:numel(anGroupInfo)
    indGroup = find(ismember({neuronInfo.loc},anGroupInfo(iGroup).areas));
    % plot neurons in group.
    for iNeuron = 1:numel(indGroup)
        cNeuron = indGroup(iNeuron);
        hT = text(pcaScore(cNeuron,1), density(cNeuron),...
            neuronInfo(cNeuron).loc,...
            'VerticalAlignment','middle',...
            'HorizontalAlignment','center',...
            'Color', anGroupInfo(iGroup).color,...
            'FontSize',12);
    end
end
% linear fit.
[fObj, gof,output] = fit( pcaScore(:,1), density ,  'poly1' );
regInfo = regstats(pcaScore(:,1),  density ,'linear');
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
ylabel(sprintf('Axon Density Cortex (mm/mm^3)'));
hAx.TickDir = 'out';
