%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
%analysis
binSize = 15;
resolutionUm = 1;
minLength = 150;

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% load cortex mask.
load(fullfile(mainFolder,'..','..','Data','Output','ctxMask.mat'),'ctxMask');
ctxMask = imresize3(uint8(ctxMask),0.5)>0;

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

%% Plot Histogram.
hFig = figure;
hAx = axes;
h = histogram(density,0:binSize:150,...
    'Normalization','probability');
%format bars.
h.FaceColor = [0.2,0.2,0.2];
%format axis.
hAx.YLim = [0,0.6];
hAx.XLim = [0,150];
hAx.Box = 'off';
hAx.PlotBoxAspectRatio = [1,0.85,1];
hAx.TickDir = 'out';
%labels
xlabel(sprintf('Axonal Density Cortex (mm/mm^3)'));
ylabel('Occurence (%)')
hFig.Renderer = 'painter';
