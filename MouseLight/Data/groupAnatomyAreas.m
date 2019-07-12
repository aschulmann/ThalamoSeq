%% Parameters.
[mainFolder,~,~] = fileparts(mfilename('fullpath'));
areaFile = 'AreaColors.xlsx';
outputFile = 'anatomyGroupInfo.mat';

%% Load area info.
[~,~,areaInfo] = xlsread(fullfile(mainFolder,'Excels',areaFile));
[~,ind] = unique(areaInfo(:,3));
groupsNames = areaInfo(sort(ind),3);
groupColor = areaInfo(sort(ind),2);

%% Store.
anGroupInfo = [];
for iGroup = 1:numel(groupsNames)
    anGroupInfo(iGroup).name = groupsNames{iGroup};
    anGroupInfo(iGroup).color = hex2rgb(groupColor{iGroup});
    %areas in group.
    ind = ismember(areaInfo(:,3),groupsNames(iGroup));   
    anGroupInfo(iGroup).areas =  areaInfo(ind,1);
end

%% sanity checks.
%number of areas matches number of rows.
totnum = 0;
for iGroup = 1:numel(groupsNames)
    totnum=totnum+numel(anGroupInfo(iGroup).areas);
end
if totnum~=size(areaInfo,1), error('resulting group numbers dont match'); end

%% store.
save(fullfile(mainFolder,'Output',outputFile),'anGroupInfo');
