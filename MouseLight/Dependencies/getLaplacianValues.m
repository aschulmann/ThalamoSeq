function [lapVal] = getLaplacianValues(neuron,ILap,resolutionUm)
%convert to SWC. 
swcData = [[neuron.sampleNumber]',[neuron.structureIdValue]',...
[neuron.x]',[neuron.y]',[neuron.z]',...
ones(size([neuron.y]',1),1), [neuron.parentNumber]'];
%upsample.
[pnts] = upsampleSWC(swcData,resolutionUm);
%to pixels.
pixs = floor(pnts/10);
% remove outliers.
ind = find(isnan(pixs(:,1)));
pixs(ind,:) = [];
for iDim = 1:3
    indRemove = pixs(:,iDim)<1 | pixs(:,iDim)>size(ILap,iDim);
    pixs(indRemove,:) = [];
end
% Lookup laplacian values.
ind = sub2ind(size(ILap),pixs(:,1),pixs(:,2),pixs(:,3));
lapVal = ILap(ind);
lapVal(lapVal==0)=[];
lapVal = 1-lapVal;

% % visual check.
% cPix = 67461;
% ZFrame = pixs(cPix,3)
% figure();
% imshow(ILap(:,:,ZFrame)',[]); hold on
% ind = find(pixs(:,3)==ZFrame);
% scatter(pixs(ind,1),pixs(ind,2));
% scatter(pixs(cPix,1),pixs(cPix,2));
% fprintf('\npixel value should be %.6f',1-lapVal(cPix));
% fprintf('\nZ pos in allen coordinates: %i',ZFrame*10);
% % check maping.
% tempNeuron =[];
% tempNeuron.axon = neuron;
% tempNeuron.dendrite =[];
% reconstructionViewer(tempNeuron);

end

