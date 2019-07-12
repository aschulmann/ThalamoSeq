%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
%input.
neuronFile =    'neuronInfo-06-04.mat';
geneFile =      'geneInfo-07-23.mat';
%output.
outputFile =    'neuronGeneInfo-07-23.mat';
voxelSize =     [200,200,200]; % in um

%% Load neuron info
fprintf('\nLoading Neuron data...');
load(fullfile(mainFolder,'Output',neuronFile));
nNeurons = size(neuronInfo,2);

%% Load gene info
fprintf('\nLoading Gene data...');
load(fullfile(mainFolder,'Output',geneFile));
nGenes = size(geneInfo,2);

%% Go through neurons.
for iNeuron = 1:nNeurons
    fprintf('\nNeuron %s [%i\\%i]',neuronInfo(iNeuron).id,iNeuron,nNeurons);
    %% lookup pixel.
    pos = neuronInfo(iNeuron).position;
    pixPos = ceil(pos./voxelSize);
    neuronInfo(iNeuron).geneScore = NaN(nGenes,1);
    for iGene = 1:nGenes
    
%         %% show image.
%         hFig = figure;
%         hAx = axes;
%         imshow(geneInfo(iGene).I(:,:,pixPos(3)),[]);  
%         hold on
%         scatter(pixPos(1),pixPos(2));

        %% Energy value.
        neuronInfo(iNeuron).geneScore(iGene) = geneInfo(iGene).I(pixPos(2),pixPos(1),pixPos(3));
    end
    neuronInfo(iNeuron).genes = {geneInfo.name};
end

%% Gather data
data = cat(2,neuronInfo.geneScore)';
zScores = zscore(data);

%% Pca.
[coeff,score,latent,tsquared,explained,mu]  = pca(zScores);
% store.
pcaInfo = [];
pcaInfo.coeff = coeff; pcaInfo.latent = latent;
pcaInfo.tsquared = tsquared; pcaInfo.explained = explained;
pcaInfo.mu = mu;

%% plot
hFig = figure;
hAx = axes;
scatter(score(:,1),score(:,2));

%% plot pca medial alteral position.
hFig = figure;
hAx = axes;
pos = cat(1,neuronInfo.position);
scatter(pos(:,1),score(:,1));
xlabel('Left-Right Position')
ylabel(sprintf('First PC (%.2f %% of variance)',explained(1)));

%% Store score.
for iNeuron=1:size(neuronInfo,2)
    neuronInfo(iNeuron).pca = score(iNeuron,:);
end

%% Save 
fprintf('\nSaving...');
save(fullfile(mainFolder,'Output',outputFile),'neuronInfo','geneInfo','pcaInfo');
fprintf('\nDone!\n');
