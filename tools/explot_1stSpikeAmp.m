
function hp = explot_1stSpikeAmp(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    for b=1:length(idx)
        NS(b) = DetailedData.SpikeData(idx(b)).Spikes(1).Amplitude;
    end    
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = '1st Spike Amplitude (mV)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = NS;
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
    NS(b) = DetailedData.SpikeData(idx(b)).Spikes(1).Amplitude;
end
hp = plot(ax,DetailedData.AxoClampData.Currents(idx),NS,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['1st Spike Amplitude (mV)'])
end
