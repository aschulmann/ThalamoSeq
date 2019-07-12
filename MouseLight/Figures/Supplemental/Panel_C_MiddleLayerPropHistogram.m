%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
%analysis.
binSize = 0.10;
lapRange = [0.4, 0.78];

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% Load FlatMap.
fprintf('\nLoading Laplacian');
if ~exist('ILap','var')
    load(fullfile(mainFolder,'..','..','Data','Output','Laplacian.mat'),'ILap');
end
fprintf('\nDone!\n');

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

%% Plot Histogram.
hFig = figure;
hAx = axes;
h = histogram(data,0:binSize:1,...
    'Normalization','probability');
%format bars.
h.FaceColor = [0.2,0.2,0.2];
%format axis.
hAx.YLim = [0,0.2];
hAx.XLim = [0,1];
hAx.Box = 'off';
hAx.PlotBoxAspectRatio = [1,0.85,1];
hAx.TickDir = 'out';
%labels
xlabel('Middle Layer Innervation (% Length)');
ylabel('Occurence (%)')
hFig.Renderer = 'painter';