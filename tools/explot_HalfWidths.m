
function hp = explot_HalfWidths(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    for b=1:length(idx)
        z=idx(b);
        HWMean(b) = mean([DetailedData.SpikeData(z).Spikes(:).HalfWidth].*1000);
        HWSTD(b) = mean([DetailedData.SpikeData(z).Spikes(:).HalfWidth].*1000);
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Average Spike Half Width (ms)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = HWMean;
else
if isempty(varargin)
    col='b';
    cla(ax)
    cla(ax,'reset')
else
    col=varargin{1};
    if length(varargin)>1
        cla(ax)
        cla(ax,'reset')
    end
end
% DetailedData.SpikeData(z).Spikes(s).HalfWidth
idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
for b=1:length(idx)
    z=idx(b);
    HWMean(b) = mean([DetailedData.SpikeData(z).Spikes(:).HalfWidth].*1000);
    HWSTD(b) = mean([DetailedData.SpikeData(z).Spikes(:).HalfWidth].*1000);
end
hp = errorbar(ax,DetailedData.AxoClampData.Currents(idx),HWMean,HWSTD,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Average Spike Half Width (ms)'])
end
