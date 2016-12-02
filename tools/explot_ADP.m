
function hp = explot_ADP(ind,ax,varargin)
global AllCells DetailedData
if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumSpikes]>0);
    for b=1:length(idx)
        z=idx(b);
        m = isnan([DetailedData.SpikeData(z).Spikes(:).ADP]);
        ADPMean(b) = mean([DetailedData.SpikeData(z).Spikes(~m).ADP]);
        ADPSTD(b) = std([DetailedData.SpikeData(z).Spikes(~m).ADP]);
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = ['ADP Amplitude (' DetailedData.AxoClampData.VoltageUnits ')'];
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = ADPMean;
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
    m = isnan([DetailedData.SpikeData(z).Spikes(:).ADP]);
    ADPMean(b) = mean([DetailedData.SpikeData(z).Spikes(~m).ADP]);
    ADPSTD(b) = mean([DetailedData.SpikeData(z).Spikes(~m).ADP]);
end
hp = errorbar(ax,DetailedData.AxoClampData.Currents(idx),ADPMean,ADPSTD,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['ADP Amplitude (' DetailedData.AxoClampData.VoltageUnits ')'])
end
