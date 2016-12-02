function spikerast = addtype2raster(cells,spikerast,idx,varargin)
% addtype2raster(NumCellTypes,cells,spikeraster,idx)
% addtype2raster takes an existing spikeraster matrix (for the current run) and
% adds another column to it, containing the cell type index corresponding
% to the cell that produced the spike in each row.

if isempty(varargin)
    idx2id=2;
else
    idx2id=varargin{1};
end

for r=1:length(cells) % number of real cell types // but I think we should include the artificial ones as well
    outind=find(spikerast(:,idx2id)>=cells(r).range_st & spikerast(:,idx2id)<=cells(r).range_en);
    spikerast(outind,idx)=r-1; % make the third column of the spikeraster contain the cell type
end