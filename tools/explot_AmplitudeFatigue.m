
function hp = explot_AmplitudeFatigue(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>1);
    for b=1:length(idx)
        z=idx(b);
        SpikeRatio(b) = DetailedData.SpikeData(z).Spikes(end).Amplitude/DetailedData.SpikeData(z).Spikes(1).Amplitude;
    end   
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'Spike Amplitude Ratio (Last/First)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = SpikeRatio;
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

idx = find([DetailedData.SpikeData(:).NumSpikes]>1);
for b=1:length(idx)
    z=idx(b);
    SpikeRatio(b) = DetailedData.SpikeData(z).Spikes(end).Amplitude/DetailedData.SpikeData(z).Spikes(1).Amplitude;
end
hp = plot(ax,DetailedData.AxoClampData.Currents(idx),SpikeRatio,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,'Spike Amplitude Ratio (Last/First)')
end
