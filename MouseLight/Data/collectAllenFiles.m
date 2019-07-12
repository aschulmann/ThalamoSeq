%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
urlLoc = 'http://download.alleninstitute.org/informatics-archive/current-release/mouse_ccf/cortical_coordinates/ccf_2017/laplacian_10.nrrd';

% %% Download.
% fprintf('\nDownloading Allen laplacian volume...');
% lapFile = fullfile(tempdir,'laplacian.nrrd');
% websave(lapFile,urlLoc);
% 
% %% read and save.
% fprintf('\nReading Allen laplacian volume...');
% ILap = nrrdreadAllen(lapFile);
% ILap = permute(ILap,[3,1,2]);
% fprintf('\nSaving...');
% save(fullfile(mainFolder,'Output','Laplacian.mat'),'ILap','-v7.3');
% delete(lapFile);
% fprintf('\nDone!');

%% cortex mask
urlLoc = 'http://download.alleninstitute.org/informatics-archive/current-release/mouse_ccf/annotation/ccf_2017/structure_masks/structure_masks_100/structure_315.nrrd';
%% Download.
fprintf('\nDownloading Allen Cortex Mask');
maskFile = fullfile(tempdir,'cortexMask.nrrd');
websave(maskFile,urlLoc);

%% read and save.
fprintf('\nReading Allen cortexMask volume...');
ctxMask = nrrdreadAllen(maskFile);
ctxMask = ctxMask>0;
ctxMask = permute(ctxMask,[3,1,2]);
fprintf('\nSaving...');
save(fullfile(mainFolder,'Output','ctxMask.mat'),'ctxMask','-v7.3');
delete(maskFile);
fprintf('\nDone!');
