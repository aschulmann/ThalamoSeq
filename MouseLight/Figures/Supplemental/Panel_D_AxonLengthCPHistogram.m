%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'neuronGeneInfo-07-23.mat';
%analysis
binSize = 10;
allenName = 'CP';
hemi = 'bi';
prop = 'totalLength';

%% Load neuron Info.
fprintf('\nLoading Neuron Info');
load(fullfile(mainFolder,'..','..','Data','Output',infoFile),'neuronInfo');
nNeurons = size(neuronInfo,2);
fprintf('\nDone!\n');

%% Allen area
allenInfo = getAllenAnatomyInfo(allenName,'Property','acronym');

%% Go through neurons.
data = NaN(nNeurons,1);
for iNeuron = 1:nNeurons
   cNeuron = neuronInfo(iNeuron).id;
   fprintf('\nNeuron %s [%i\\%i]',cNeuron,iNeuron,nNeurons);
   [info] = neuronInfoAllenRegion(neuronInfo(iNeuron).morphology.axon,allenInfo.structure_id_path );
   data(iNeuron) = info.(hemi).(prop)/1000; % to mm.
end

%% Plot Histogram.
hFig = figure;
hAx = axes;
h = histogram(data,0:binSize:100,...
    'Normalization','probability');
%format bars.
h.FaceColor = [0.2,0.2,0.2];
%format axis.
hAx.YLim = [0,0.8];
hAx.XLim = [0,100];
hAx.Box = 'off';
hAx.PlotBoxAspectRatio = [1,0.85,1];
hAx.TickDir = 'out';
%labels
xlabel(sprintf('Axonal Length\nCaudoputamen (mm)'));
ylabel('Occurence (%)')
hFig.Renderer = 'painter';
