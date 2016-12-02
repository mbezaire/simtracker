
function hp = explot_Adaptation(ind,ax,varargin) % Spike frequency Adaptation: http://www.scholarpedia.org/article/Spike_frequency_adaptation
% but see also http://en.wikipedia.org/wiki/Accommodation_index
global AllCells DetailedData

if ax==-1 
    idx = find([DetailedData.SpikeData(:).NumISIs]>1);
    for b=1:length(idx)
        z=idx(b);
        ISIRatio(b) = DetailedData.SpikeData(z).ISIs(end).ISI/DetailedData.SpikeData(z).ISIs(1).ISI;
    end
    hp.xheader = ['Current (' DetailedData.AxoClampData.CurrentUnits ')'];
    hp.yheader = 'ISI Ratio (Last/First)';
    hp.x = DetailedData.AxoClampData.Currents(idx);
    hp.y = ISIRatio;
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

idx = find([DetailedData.SpikeData(:).NumISIs]>1);
for b=1:length(idx)
    z=idx(b);
    ISIRatio(b) = DetailedData.SpikeData(z).ISIs(end).ISI/DetailedData.SpikeData(z).ISIs(1).ISI;
end
hp = plot(ax,DetailedData.AxoClampData.Currents(idx),ISIRatio,'Color',col,'Marker','.');

xlabel(ax,['Current (' DetailedData.AxoClampData.CurrentUnits ')'])
ylabel(ax,['ISI Ratio (Last/First)'])
end

