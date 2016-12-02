
function hp = explot_AHP(ind,ax,varargin)
global mypath AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    for b=1:length(idx)
        z=idx(b);
        m = isnan([DetailedData.SpikeData(z).Spikes(:).AHP]);
        AHPMean(b) = mean([DetailedData.SpikeData(z).Spikes(~m).AHP]);
        AHPSTD(b) = std([DetailedData.SpikeData(z).Spikes(~m).AHP]);
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['AHP Amplitude (' DetailedData.AxoClampData.VoltageUnits ')'];
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = AHPMean;
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

idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
for b=1:length(idx)
    z=idx(b);
    m = isnan([DetailedData.SpikeData(z).Spikes(:).AHP]);
    AHPMean(b) = mean([DetailedData.SpikeData(z).Spikes(~m).AHP]);
    AHPSTD(b) = std([DetailedData.SpikeData(z).Spikes(~m).AHP]);
end
hp = errorbar(ax,DetailedData.AxoClampData.Currents(idx),AHPMean,AHPSTD,'Color',col,'Marker','.');

xlabel(['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(['AHP Amplitude (' DetailedData.AxoClampData.VoltageUnits ')'])
end
