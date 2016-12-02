
function hp = explot_SpikeAmps(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    for b=1:length(idx)
        z=idx(b);
        AmpMean(b) = mean([DetailedData.SpikeData(z).Spikes(:).Amplitude]);
        AmpSTD(b) = mean([DetailedData.SpikeData(z).Spikes(:).Amplitude]);
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Average Spike Amplitude (mV)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = AmpMean;
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
    AmpMean(b) = mean([DetailedData.SpikeData(z).Spikes(:).Amplitude]);
    AmpSTD(b) = mean([DetailedData.SpikeData(z).Spikes(:).Amplitude]);
end
hp = errorbar(ax,DetailedData.AxoClampData.Currents(idx),AmpMean,AmpSTD,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['Average Spike Amplitude (mV)'])
end
