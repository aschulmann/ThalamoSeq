%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
infoFile = 'GeneList-07-23.xlsx';
outputFile = 'geneInfo-07-23.mat';

%% Read info.
[~,~,info]=xlsread(fullfile(mainFolder,'Excels',infoFile));

%% Collect ISH experiments
nGenes = size(info,1);
geneInfo = struct();
for iGene = 1:nGenes
   cGene = info{iGene,1};
   fprintf('\nGene %s [%i\\%i]',cGene,iGene,nGenes);
   % store zip.
   zipFile = fullfile(tempdir,sprintf('%s.zip',cGene));
   websave(zipFile,...
       sprintf('http://api.brain-map.org/grid_data/download/%i?include=energy',info{iGene,3}));
   % unzip.
   unzip(zipFile,fullfile(tempdir,'MatlabData'));
   delete(zipFile);
   % 200 micron volume size
   sizeGrid = [67 41 58];
   % ENERGY = 3-D matrix of expression energy grid volume
   fid = fopen(fullfile(tempdir,'MatlabData','energy.raw'), 'r', 'l' );
   I = fread( fid, prod(sizeGrid), 'float' );
   fclose( fid );
   I = reshape(I,sizeGrid);
   I = permute(I,[2,3,1]);
%    figure;imagesc(squeeze(I(:,:,34)));colormap(gray);
   
   %% store.
   geneInfo(iGene).name = cGene;
   geneInfo(iGene).exp = info{iGene,3};
   geneInfo(iGene).area = info{iGene,2};
   geneInfo(iGene).I = I;
end

%% Saving,
fprintf('\nSaving..');
save(fullfile(mainFolder,'Output',outputFile),'geneInfo');
fprintf('\nDone!\n');
