%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
neuronFile = 'NeuronList-06-04.xlsx';
% out.
outputName = 'neuronInfo-06-04.mat';

%% collect info.
[~,~,info] = xlsread(fullfile(mainFolder,'Excels',neuronFile));
nNeurons = size(info,1);

%% get area colors.
[~,~,colorInfo] = xlsread(fullfile(mainFolder,'Excels','AreaColors.xlsx'));
areaNames = colorInfo(:,1);
areaColors = colorInfo(:,2);

%% go through neurons
neuronInfo = struct();
for iNeuron = 1:nNeurons
    cNeuron = info{iNeuron,1};
    fprintf('\nNeuron %s [%i\\%i]',cNeuron,iNeuron,nNeurons);
    %% get neuron.
    neuron = getNeuronfromIdString(cNeuron,'ForceHemi','Right');
    %% store info.
    neuronInfo(iNeuron).id = cNeuron;
    neuronInfo(iNeuron).position = [neuron.axon(1).x,neuron.axon(1).y,neuron.axon(1).z];
    neuronInfo(iNeuron).loc = info{iNeuron,3};
    neuronInfo(iNeuron).morphology = neuron;
    
    %% Lookup anatomy color.
    ind = find(strcmpi(areaNames,neuronInfo(iNeuron).loc));
    if isempty(ind), error('\nCould not find color info for %s',neuronInfo(iNeuron).loc); end
    neuronInfo(iNeuron).areaColor = hex2rgb(areaColors{ind});
   
end

%% Store.
save(fullfile(mainFolder,'Output',outputName),'neuronInfo');
